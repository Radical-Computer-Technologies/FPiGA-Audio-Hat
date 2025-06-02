#include "fpiga_audio.h"
#include <unistd.h>
#include <vector>
#include <cmath>
#include <iomanip>

RCT_FPiGA_Audio::RCT_FPiGA_Audio() :  RCT_FPiGA("/dev/i2c-1")
{

    codecvolume = 118;
    codecaddr = 0x1b;
    conf.srate =SampRate::r_48000;
    configureSSM2603(conf);
    initWaveTables();
}
RCT_FPiGA_Audio::~RCT_FPiGA_Audio() {

}

void RCT_FPiGA_Audio::enableTestSigs(){
    Fpiga_i2c_wr(FPiGA_CONF_REG,0x02);

}
void RCT_FPiGA_Audio::enableDSPPassthrough(){
    Fpiga_i2c_wr(FPiGA_DSPMODE_REG,0x00);
    Fpiga_i2c_wr(FPiGA_CONF_REG,0x03);

}

void RCT_FPiGA_Audio::enableMixer(){
    dspctl = dspctl | 4;
    Fpiga_i2c_wr(FPiGA_DSPCTL_REG,dspctl);


}
void RCT_FPiGA_Audio::setLVol(uint32_t vol){
    uint8_t shigh = uint8_t(vol>>16 & 0xFF);
    uint8_t smid = uint8_t(vol>>8 & 0xFF);
    uint8_t slow = uint8_t(vol & 0xFF);
    Fpiga_i2c_wr(FPiGA_LVOL_REG,slow);
    Fpiga_i2c_wr(FPiGA_LVOL_REG+1,smid);
    Fpiga_i2c_wr(FPiGA_LVOL_REG+2,shigh);

}

void RCT_FPiGA_Audio::setRVol(uint32_t vol){
    uint8_t shigh = uint8_t(vol>>16 & 0xFF);
    uint8_t smid = uint8_t(vol>>8 & 0xFF);
    uint8_t slow = uint8_t(vol & 0xFF);
    Fpiga_i2c_wr(FPiGA_RVOL_REG,slow);
    Fpiga_i2c_wr(FPiGA_RVOL_REG+1,smid);
    Fpiga_i2c_wr(FPiGA_RVOL_REG+2,shigh);
}

void RCT_FPiGA_Audio::enablePassthrough(){
    Fpiga_bitset(FPiGA_CONF_REG,1);
}
void RCT_FPiGA_Audio::setFreq(uint32_t freq,uint8_t osc){
    uint8_t shigh = uint8_t(freq>>16 & 0xFF);
    uint8_t smid = uint8_t(freq>>8 & 0xFF);
    uint8_t slow = uint8_t(freq & 0xFF);
    uint8_t reg;

    if(osc == 0){
        reg = FPiGA_FREQ0_REG;
    }
    else if(osc == 1){
        reg = FPiGA_FREQ1_REG;
    }
    else if(osc == 2){
        reg = FPiGA_FREQ2_REG;
    }
    else{
        reg = FPiGA_FREQ3_REG;

    }
    Fpiga_i2c_wr(reg,slow);
    Fpiga_i2c_wr(reg+1,smid);
    Fpiga_i2c_wr(reg+2,shigh);

}

void RCT_FPiGA_Audio::setOscVol(uint8_t osc,uint32_t volume){
    uint8_t shigh = uint8_t(volume>>16 & 0xFF);
    uint8_t smid = uint8_t(volume>>8 & 0xFF);
    uint8_t slow = uint8_t(volume & 0xFF);
    uint8_t reg;
    std::cout << "Setting Volume to: ";

    if(osc == 0){
        reg = FPiGA_OSC0VOL_REG;
    }
    else if(osc == 1){
        reg = FPiGA_OSC1VOL_REG;
    }
    else if(osc == 2){
        reg = FPiGA_OSC2VOL_REG;
    }
    else{
        reg = FPiGA_OSC3VOL_REG;

    }
    Fpiga_i2c_wr(reg,slow);
    Fpiga_i2c_wr(reg+1,smid);
    Fpiga_i2c_wr(reg+2,shigh);


}

void RCT_FPiGA_Audio::setWav(uint8_t osc, uint8_t wav){
    waves = waves & ~(3<<(2*osc));
    waves = waves | (wav<<(2*osc));
    Fpiga_i2c_wr(FPiGA_WAVSEL_REG,waves);

}

void RCT_FPiGA_Audio::writeWaveSample(int32_t samp, uint8_t waveSel){
    int8_t shigh = samp>>24 & 0xFF;
    int8_t smid = int8_t(samp>>16 & 0xFF);
    int8_t slow = int8_t(samp>>8 & 0xFF);

    uint8_t* dat;
    dat = (uint8_t*)&slow;
    Fpiga_i2c_wr(FPiGA_WAVDATA_REG,*dat);

    dat = (uint8_t*)&smid;
    Fpiga_i2c_wr(FPiGA_WAVDATA_REG+1,*dat);

    dat = (uint8_t*)&shigh;
    Fpiga_i2c_wr(FPiGA_WAVDATA_REG+2,*dat);
    uint8_t shWaveSel = waveSel<<1;
    Fpiga_i2c_wr(FPiGA_WAVCTL_REG,(0 | shWaveSel));
    Fpiga_i2c_wr(FPiGA_WAVCTL_REG,(1 | shWaveSel));
    Fpiga_i2c_wr(FPiGA_WAVCTL_REG,(0 | shWaveSel));


}

void RCT_FPiGA_Audio::setWaveTable(int32_t* table, uint8_t waveSel){
    Fpiga_i2c_wr(FPiGA_DSPMODE_REG,DSP_MODE_LOADWAVE);


    for(int i = 0; i < 1024; i++){
        writeWaveSample(table[i],waveSel);
    }
    Fpiga_i2c_wr(FPiGA_DSPMODE_REG,DSP_MODE_PASS);


}

void RCT_FPiGA_Audio::initWaveTables(){
    const int numSamples = 1024;
    const double amplitude = 1.0;
    const double frequency = 1.0; // Frequency in cycles per sample
    double sineWave[1024];
    int32_t wavtab[1024];

    //sinewave
    for (int i = 0; i < numSamples; ++i) {
        double time = static_cast<double>(i) / numSamples;
        sineWave[i] = 1.00 * std::sin(2 * M_PI * frequency * time);
        wavtab[i] = sineWave[i]*2147483647;
    }
    Fpiga_i2c_wr(FPiGA_CONF_REG,0x03);

    setWaveTable(wavtab,0);

    //square wave
    for (int i = 0; i < numSamples; ++i) {
        if(i < numSamples/2){
            wavtab[i] = -2147483647;
        }
        else{
            wavtab[i] = 2147483647;

        }
    }
    setWaveTable(wavtab,1);

    //triangle wave
    int tri = 0;
    int inc = 2147483647/(numSamples/4);
    for (int i = 0; i < numSamples; ++i) {
        if(i < numSamples/4){
            wavtab[i] = tri;
            tri = tri +inc;
        }
        else if(i < (numSamples*3)/4){
            wavtab[i] = tri;
            tri = tri - inc;

        }
        else{
            wavtab[i] = tri;
            tri = tri +inc;

        }

    }
    setWaveTable(wavtab,2);

    setFreq(65536,0);
    setWav(0,1);
    setWav(1,1);
    setWav(2,2);
    setWav(3,0);
    setOscVol(1,0);
    setOscVol(2,0);
    setOscVol(3,0);

    Fpiga_i2c_wr(FPiGA_CONF_REG,0x01);


}


void RCT_FPiGA_Audio::enableSynthMode(){
    //ensure passthrough mode
    Fpiga_i2c_wr(FPiGA_DSPMODE_REG,DSP_MODE_SYNTH);


}

void RCT_FPiGA_Audio::enableDSP(){
    //Configure for 48K I2S Passthrough Mode
    Fpiga_i2c_wr(FPiGA_CONF_REG,0x03);

}
void RCT_FPiGA_Audio::Codec_i2c_wr(uint8_t reg, uint8_t val){
    uint8_t rshift = reg<<1;
    i2c_wr8(codecaddr,rshift,val);

}

bool RCT_FPiGA_Audio::configureSSM2603(SSM2603_Conf_t config){
    bool success = true;
    //set mute enable
    Fpiga_i2c_wr(FPiGA_ENABLE_REG,0x00);
    Fpiga_i2c_wr(FPiGA_SRST_REG,0x03);

    //regwrite8(fd,FPiGA_SRST_REG,0x01,false);

    codecvolume = 102;

    if(config.srate == SampRate::r_48000){
        //https://www.analog.com/media/en/technical-documentation/data-sheets/SSM2603.pdf
        // 1 - Set active bit to 0
        std::cout << "Setting codec!\r\n";
        //emit setslvaddr(addr);
        //emit regwrite8(ACTIVE, 0x0000);
        usleep(10000);
        Codec_i2c_wr(15,0x0000);
        usleep(10000);
        // 2 - Enable all necessary power management bits of R6 (except out bit)
        Codec_i2c_wr(PWR_MANAG,0x95);

        // 3 - Set all registers except for active bit (R9 Bit 0)
        //Set dac Volumes
        Codec_i2c_wr(L_DAC_VOL,256+codecvolume);
        Codec_i2c_wr(R_DAC_VOL,256+codecvolume);

        //Set dac analog path to be mixed at output
        Codec_i2c_wr(ANA_AUD_PATH,0x0000);

        //Set DAC Mute disabled
        Codec_i2c_wr(DIG_AUD_PATH,0x0004);
        Codec_i2c_wr(DIG_AUD_IF,0x4E);//Changed so Word length is 24
            // 3 wait for VMID Decoupling cap before setting active
            //set sample rate
        Codec_i2c_wr(SAMP_RATE,0x0000);

        usleep(10000);
        Codec_i2c_wr(ACTIVE,0x0001);
        usleep(10000);
        // 4 - Enable DAC output by setting out bit of register R6 to 0
        Codec_i2c_wr(PWR_MANAG,0x20);
        //emit regwrite8(SAMP_RATE,0x0040);
        usleep(10000);
        Codec_i2c_wr(ANA_AUD_PATH,22);

        //Configure for 48K I2S Passthrough Mode
        Fpiga_i2c_wr(FPiGA_CONF_REG,0x01);

        //Disable mute enable
        Fpiga_i2c_wr(FPiGA_ENABLE_REG,0x01);

        //Release soft reset
        Fpiga_i2c_wr(FPiGA_SRST_REG,0x01);

        //ensure passthrough mode
        Fpiga_i2c_wr(FPiGA_DSPMODE_REG,0x00);


    }
    else{
        std::cout << "Invalid codec sample rate setting!" << std::endl;
    }

    return success;
}

void RCT_FPiGA_Audio::muteCodec(bool muteen){

    if(muteen){
        Codec_i2c_wr(DIG_AUD_PATH, 0x000C);
    }
    else{
        Codec_i2c_wr(DIG_AUD_PATH, 0x0004);
    }
}

void RCT_FPiGA_Audio::changeVolume(bool inc){
    if(inc && codecvolume < 127){
        if(codecvolume+3 <=127){
            codecvolume = codecvolume +3;

        }
        else{
            codecvolume = 127;
        }
    }
    else if(codecvolume > 48){
        if(codecvolume-3 >=48){
            codecvolume = codecvolume-3;
        }
        else{
            codecvolume = 48;
        }
    }
    Codec_i2c_wr(L_DAC_VOL,256+codecvolume);
    Codec_i2c_wr(R_DAC_VOL,256+codecvolume);

}
