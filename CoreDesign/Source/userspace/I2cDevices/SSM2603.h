#ifndef SSM2603_H
#define SSM2603_H

enum class SampRate {
    r_44100,
    r_48000,
    r_192000
};

struct SSM2603_Conf_t {
    SampRate srate;
};

class SSM2603 : public QObject
{
    Q_OBJECT
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

    explicit SSM2603(std::string filename, uint16_t address);
    ~SSM2603();

    bool configure(SSM2603_Conf_t config);
    void regread8(uint8_t addr, uint16_t *buf);
    void regwrite8(uint8_t reg, uint16_t val);
    void setslvaddr(uint16_t addr);
    void i2c_read_reg( uint8_t reg, uint8_t *buf);
    void i2c_write_reg(uint8_t reg, uint8_t value);
    void i2c_read(uint8_t *buf, size_t buf_len);
    void i2c_write(uint8_t *buf, size_t buf_len);
    void i2c_readn_reg( uint8_t reg, uint8_t *buf, size_t buf_len);
    void i2c_writen_reg( uint8_t reg, uint8_t *buf, size_t buf_len);
    void mute(bool);
    void changeVolume(bool);
private:
    uint8_t volume;
    int fd;
    uint16_t addr;
    SSM2603_Conf_t conf;


};

#endif
