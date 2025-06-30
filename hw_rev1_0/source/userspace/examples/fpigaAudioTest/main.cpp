#include <iostream>
//#include "SSM2603.h"
#include "fpiga_audio.h"
#include <unistd.h>

int main()
{
    std::cout << "Setting Up Audio Codec" << std::endl;
    RCT_FPiGA_Audio fpiga;

    std::cout << "Audio Codec initialized" << std::endl;
    bool running = true;
    std::string choice;
    uint32_t freq;
    uint32_t volume;
    uint16_t osc;
    uint16_t waveform;

    while(running){
        std::cout << "\nFPiGA Menu:" << std::endl;
        std::cout << "ENDSP - enable DSP" << std::endl;
        std::cout << "ENPASS - enable passthrough" << std::endl;
        std::cout << "ENTEST - enable test signals" << std::endl;
        std::cout << "Enter your choice: ";
        std::cin >> choice;

        if(choice == "ENDSP"){
            fpiga.enableDSP();
        }

        else if(choice == "ENPASS"){
            fpiga.enablePassthrough();
        }
        else if(choice == "ENDSPPASS"){
            fpiga.enableDSPPassthrough();
        }

        else if(choice == "ENTEST"){
            fpiga.enableTestSigs();
        }

        else if(choice == "CLOSE"){
            running = false;
        }

        else if(choice == "INCVOL"){
            fpiga.changeVolume(true);
        }
        else if(choice == "DECVOL"){
            fpiga.changeVolume(false);
        }
        else if(choice == "SYNTH"){
            fpiga.enableSynthMode();
        }
        else if(choice == "NOTE"){
            std::cout << "Enter osc num: ";
            std::cin >> osc;
            std::cout << "Enter your frequency value: ";
            std::cin >> freq;
            fpiga.setFreq(freq,osc);
        }
        else if(choice == "MOD"){
            freq = 15000;
            for(int i = 0; i < 200; i++){
                freq  += 50*i;
                fpiga.setFreq(freq,0);
               // usleep(10);
            }
            for(int i = 0; i < 200; i++){
                freq  -= 50*i;

                fpiga.setFreq(freq,0);
                //usleep(10);
            }

        }
        else if(choice == "MIX"){

                fpiga.enableMixer();


        }
        else if(choice == "LVOL"){
            std::cout << "Enter left vol  value: ";
            std::cin >> volume;
            fpiga.setLVol(volume);


        }
        else if(choice == "RVOL"){
            std::cout << "Enter r vol  value: ";
            std::cin >> volume;
            fpiga.setRVol(volume);


        }
        else if(choice == "SETOSCVOL"){
            std::cout << "Enter osc num: ";
            std::cin >> osc;
            std::cout << "Enter osc vol  value: ";
            std::cin >> volume;
            fpiga.setOscVol(osc,volume);


        }
        else if(choice == "SETOSCWFM"){
            std::cout << "Enter osc num: ";
            std::cin >> osc;
            std::cout << "Enter waveform  value: ";
            std::cin >> waveform;
            fpiga.setWav(osc,waveform);


        }
    }

    return 0;
}
