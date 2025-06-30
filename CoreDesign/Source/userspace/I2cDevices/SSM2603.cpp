 #include "SSM2603.h"
#include <iostream>
#include <unistd.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <cstdlib>
#include <cstdio>
#include <stdint.h>
#include <iostream>

bool regwrite8(uint8_t reg, uint16_t val){

    bool success = true;
    int retval;

    uint8_t wrbuf = val;
    uint8_t regshft = reg<<1;
    retval = i2c_writen_reg(regshft,&wrbuf,1);

    if(retval <= 0){
        std::cout << "\t\tWriting value: 0X" << std::hex << (uint)val
                  << " at address: 0X" << (uint)reg << " failed \r\n";

        success = false;
    }

    return success;

}

uint8_t i2c_read_reg( uint8_t reg){
    uint8_t value = 0;
    i2c_readn_reg(reg, &value, 1);
    return value;
}

int i2c_write_reg(uint8_t reg, uint8_t value){
    return i2c_writen_reg(reg, &value, 1);

}
int i2c_read(uint8_t *buf, size_t buf_len){
    int i = read(fd, buf, buf_len);
    //std::cout << "Bytes read " << i << std::endl;
    return i;

}

int i2c_write(uint8_t *buf, size_t buf_len){
    int i = write(fd, buf, buf_len);
    //std::cout << "bytes writted:" << i << "\r\n";
    return i;

}

bool setslvaddr(uint16_t addr){
    bool success = true;
    if ((ioctl(fd, I2C_SLAVE, (uint8_t)addr)) < 0) {
        success = false;
    }

    return success;
}

bool i2c_readn_reg( uint8_t reg, uint8_t *buf, size_t buf_len){

    int ret;
    /*
     * Write the I2C register address.
     */
    ret = i2c_write(&reg, 1);
    if(ret <= 0){
        std::cout << " failed to write i2c register address: 0X"<< std::hex << reg <<"\r\n" << std::dec
                  << "Returned: " << ret << "\n";
        return false;
    }

    /*
     * Read the I2C register data.
     */
    ret = i2c_read(buf, buf_len);
    if (ret <= 0) {
        std::cout << "failed to read i2c register data\r\n"
                  << "returned" << ret;
        return false;
    }

    return true;
}
bool i2c_writen_reg( uint8_t reg, uint8_t *buf, size_t buf_len){
    bool success = true;
    uint8_t *full_buf;
    int full_buf_len;
    int rc;
    int i;

    full_buf_len = buf_len + 1;
    full_buf = (uint8_t*)malloc(sizeof(uint8_t) * full_buf_len);

    full_buf[0] = reg;
    for (i = 0; i < buf_len; i++) {
        full_buf[i + 1] = buf[i];
    }

    rc = i2c_write(full_buf, full_buf_len);
    if (rc <= 0) {
        std::cout << " failed to write i2c register address and data\r\n";
        success = false;
    }

    free(full_buf);
    return success;
}


SSM2603::SSM2603(std::string filename, uint16_t address)
 : QObject{parent}
{
    addr = address;
    volume = 105;

}
SSM2603::~SSM2603(){

}

bool SSM2603::configure(SSM2603_Conf_t config){
    bool success = true;

    if(config.srate == SampRate::r_48000){
        //https://www.analog.com/media/en/technical-documentation/data-sheets/SSM2603.pdf
        // 1 - Set active bit to 0
        std::cout << "Setting codec!\r\n";
        //emit setslvaddr(addr);
        //emit regwrite8(ACTIVE, 0x0000);

         setslvaddr(addr);
         regwrite8(15, 0x0000);
        usleep(10000);
        // 2 - Enable all necessary power management bits of R6 (except out bit)
         setslvaddr(addr);
         regwrite8(PWR_MANAG,0x70);


        // 3 - Set all registers except for active bit (R9 Bit 0)
            //Set dac Volumes
         setslvaddr(addr);
         regwrite8(L_DAC_VOL,256+volume);

         setslvaddr(addr);
         regwrite8(R_DAC_VOL,256+volume);

            //Set dac analog path to be mixed at output
         setslvaddr(addr);
         regwrite8(ANA_AUD_PATH, 0x0000);


            //Set DAC Mute disabled
         setslvaddr(addr);
         regwrite8(DIG_AUD_PATH, 0x0004);

         setslvaddr(addr);
         regwrite8(DIG_AUD_IF, 0x8E); //Changed so Word length is 24
            // 3 wait for VMID Decoupling cap before setting active
            //set sample rate
         setslvaddr(addr);
         regwrite8(SAMP_RATE,0x0020);
        usleep(10000);
         setslvaddr(addr);
         regwrite8(ACTIVE, 0x0001);
        usleep(10000);


            // 4 - Enable DAC output by setting out bit of register R6 to 0
         setslvaddr(addr);
         regwrite8(PWR_MANAG,0x20);
        //emit regwrite8(SAMP_RATE,0x0040);
        usleep(10000);
         setslvaddr(addr);
        emit regwrite8(ANA_AUD_PATH,22);
    }
    else{
        std::cout << "Invalid codec sample rate setting!" << std::endl;
    }

    return success;
}

void SSM2603::mute(bool muteen){

     setslvaddr(addr);
    if(muteen){
        emit regwrite8(DIG_AUD_PATH, 0x000C);
    }
    else{
        emit regwrite8(DIG_AUD_PATH, 0x0004);
    }
}

void SSM2603::changeVolume(bool inc){
     setslvaddr(addr);
    if(inc && volume < 127){
        if(volume+3 <=127){
            volume = volume +3;

        }
        else{
            volume = 127;
        }
    }
    else if(volume > 48){
        if(volume-3 >=48){
            volume = volume-3;
        }
        else{
            volume = 48;
        }
    }
     regwrite8(L_DAC_VOL,256+volume);
     regwrite8(R_DAC_VOL,256+volume);

}
