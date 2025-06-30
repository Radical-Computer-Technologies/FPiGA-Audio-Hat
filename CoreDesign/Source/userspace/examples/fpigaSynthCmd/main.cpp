#include <iostream>
#include "RtMidi.h"
#include "fpiga_audio.h"

#define MAXNOTES 64
uint32_t notes[128];
uint8_t notesActive[MAXNOTES];
uint8_t numActive = 0;
uint32_t velocities[128];

int main()
{
    uint32_t freq = uint32_t(27.5*350);
    uint32_t freqhz;
    uint32_t velstep = 8000000/128;
    for(int i = 0; i < 128; i++){

        notes[i] = freq;
        freqhz = freq/350;
        freqhz = (uint32_t)(1.059463*(float)freqhz);
        freq = freqhz*350;
        std::cout << "Freq is " << freq;
        velocities[i] =velstep*i;
    }
    RtMidiIn *midiin = 0;
    try {
        midiin = new RtMidiIn();
    } catch (RtMidiError &error) {
        error.printMessage();
        return 1;
    }

    unsigned int nPorts = midiin->getPortCount();
    if (nPorts == 0) {
        std::cout << "No MIDI input ports found!\n";
        delete midiin;
        return 0;
    }

    std::cout << "Available MIDI input ports:\n";
    for (unsigned int i = 0; i < nPorts; i++) {
        std::cout << "  " << i << ": " << midiin->getPortName(i) << "\n";
    }

    unsigned int port = 0; // Choose the desired MIDI port (e.g., 0 for the first one)
    std::cout << "Which port should we use: ";
    std::cin >> port;
    std::cout << "Opening port " << port << "\n";
    midiin->openPort(port);

    std::vector<unsigned char> message;
    int nBytes;
    double stamp;
    RCT_FPiGA_Audio fpiga;
    fpiga.enableDSP();
    fpiga.enableSynthMode();
    fpiga.setWav(0,0);
    fpiga.setWav(1,0);
    fpiga.changeVolume(true);
    fpiga.changeVolume(true);
    fpiga.changeVolume(true);
    fpiga.changeVolume(true);



    std::cout << "Listening for MIDI messages...\n";
    while (true) {
        stamp = midiin->getMessage(&message);
        nBytes = message.size();

        if (nBytes > 0) {
            std::cout << "Message received: ";
            for (int i = 0; i < nBytes; i++) {
                std::cout << "0x" << std::hex << (int)message[i] << " ";
            }
            std::cout << std::dec << "\n";
            // Example: Check if it's a note-on message (status byte 0x90-0x9F)
            if ((message[0] & 0xF0) == 0x90) {
                int note = message[1];
                int velocity = message[2];
                //freqhz = notes[note]/350;
                //freqhz = uint32_t(1.059463*(float)freqhz*4);
                fpiga.setFreq(notes[note],0);
                fpiga.setFreq(notes[note+5],1);

                fpiga.setOscVol(0,velocities[velocity]);
                fpiga.setOscVol(1,velocities[velocity]);
                if(numActive < MAXNOTES){
                    notesActive[numActive] = note;
                    numActive++;


                }
                else{
                    for(int i = 0; i < MAXNOTES-1; i++){
                        notesActive[i] = notesActive[i+1];
                    }
                    notesActive[7] = note;

                }
                std::cout << "Note On: " << note << " Velocity: " << velocity << "\n";
            }
            // Example: Check if it's a control change message (status byte 0xB0-0xBF)
            if ((message[0] & 0xF0) == 0xB0) {
                int controller = message[1];
                int value = message[2];
                std::cout << "Control Change: " << controller << " Value: " << value << "\n";
            }
            if((message[0] & 0xF0) == 0x80){
                int rmv = message[1];
                if(numActive > 1){
                    uint8_t rmvidx = 0;
                    for(int i = 0; i < MAXNOTES; i++){
                        if(rmv == notesActive[i]) rmvidx = i;

                    }
                    if(rmvidx < numActive-1){
                        for(int i = rmvidx; i < numActive; i++){
                            notesActive[i] = notesActive[i+1];
                        }
                    }

                    numActive--;
                    int note = notesActive[numActive-1];
                    fpiga.setFreq(notes[note],0);
                    fpiga.setFreq(notes[note+5],1);
                }
                else{
                    if(numActive > 0)numActive--;
                    fpiga.setOscVol(0,0);
                    fpiga.setOscVol(1,0);
                }


            }
        }
    }
    delete midiin;
    return 0;

}
