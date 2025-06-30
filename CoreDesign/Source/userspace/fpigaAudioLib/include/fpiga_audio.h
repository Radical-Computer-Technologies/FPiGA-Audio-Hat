#ifndef FPIGA_AUDIO_H
#define FPIGA_AUDIO_H
#include "rct_fpiga.h"

enum class SampRate {
    r_44100,
    r_48000,
    r_192000
};

struct SSM2603_Conf_t {
    SampRate srate;
};

class RCT_FPiGA_Audio : public RCT_FPiGA
{
public:
    enum REG {
        L_ADC_VOL = 0x00,
        R_ADC_VOL = 0x01,
        L_DAC_VOL = 0x02,
        R_DAC_VOL = 0x03,
        ANA_AUD_PATH = 0x04,
        DIG_AUD_PATH = 0x05,
        PWR_MANAG = 0x06,
        DIG_AUD_IF = 0x07,
        SAMP_RATE = 0x08,
        ACTIVE = 0x09,
        SOFT_RST = 0x0F,
        ALC_CTRL1 = 0x10,
        ALC_CTRL2 = 0x11,
        NOISE_GATE = 0x12
    };

    enum FPGA_REG {
        FPiGA_ID_REG = 0x00,
        FPiGA_ENABLE_REG = 0x02,
        FPiGA_SRST_REG = 0x01,
        FPiGA_CONF_REG = 0x03,
        FPiGA_DSPMODE_REG = 0x04,
        FPiGA_WAVSEL_REG = 17,

        FPiGA_WAVCTL_REG = 20,
        FPiGA_WAVDATA_REG = 21,
        FPiGA_FREQ0_REG = 5,
        FPiGA_FREQ1_REG = 8,
        FPiGA_FREQ2_REG = 11,
        FPiGA_FREQ3_REG = 14,

        FPiGA_DSPCTL_REG = 24,
        FPiGA_LVOL_REG = 25,
        FPiGA_RVOL_REG = 28,
        FPiGA_OSC0VOL_REG = 31,
        FPiGA_OSC1VOL_REG = 34,
        FPiGA_OSC2VOL_REG = 37,
        FPiGA_OSC3VOL_REG = 40,

    };

    enum DSP_MODES {
        DSP_MODE_PASS = 0x00,
        DSP_MODE_SYNTH = 0x01,
        DSP_MODE_LOADWAVE = 0x02,

    };


    RCT_FPiGA_Audio();
    ~RCT_FPiGA_Audio();

    void muteCodec(bool);
    void changeVolume(bool);
    void enableDSP();
    void enableTestSigs();
    void enablePassthrough();
    void enableDSPPassthrough();
    void enableMixer();

    void enableSynthMode();
    void initWaveTables();
    void setFreq(uint32_t freq,uint8_t osc);
    void setWav(uint8_t osc,uint8_t wav);
    void setOscVol(uint8_t osc,uint32_t volume);

    void setLVol(uint32_t vol);
    void setRVol(uint32_t vol);

    void writeWaveSample(int32_t samp, uint8_t waveSel);

    void setWaveTable(int32_t* table, uint8_t waveSel);
private:
    uint8_t codecvolume;
    bool configureSSM2603(SSM2603_Conf_t config);
    uint16_t codecaddr;
    uint8_t waves = 0;
    SSM2603_Conf_t conf;
    uint8_t dspctl = 0;
    void Codec_i2c_wr(uint8_t reg, uint8_t val);

};

#endif // FPIGA_AUDIO_H
