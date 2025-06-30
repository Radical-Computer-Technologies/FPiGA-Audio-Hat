#include "i2cdevicelib.h"

I2cDevice::I2cDevice(std::string devpath, QObject *parent)
    : QObject{parent}
{
    fd = open(devpath.c_str(), O_RDWR);
    if(fd > 0){
        fd_ok = true;
    }

}

I2cDevice::~I2cDevice(){
    close(fd);
}

bool I2cDevice::regwrite8(uint8_t reg, uint16_t val){

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

uint8_t I2cDevice::i2c_read_reg( uint8_t reg){
    uint8_t value = 0;
    i2c_readn_reg(reg, &value, 1);
    return value;
}

int I2cDevice::i2c_write_reg(uint8_t reg, uint8_t value){
    return i2c_writen_reg(reg, &value, 1);

}
int I2cDevice::i2c_read(uint8_t *buf, size_t buf_len){
    int i = read(fd, buf, buf_len);
    //std::cout << "Bytes read " << i << std::endl;
    return i;

}

int I2cDevice::i2c_write(uint8_t *buf, size_t buf_len){
    int i = write(fd, buf, buf_len);
    //std::cout << "bytes writted:" << i << "\r\n";
    return i;

}

bool I2cDevice::setslvaddr(uint16_t addr){
    bool success = true;
    if ((ioctl(fd, I2C_SLAVE, (uint8_t)addr)) < 0) {
        success = false;
    }

    return success;
}

bool I2cDevice::i2c_readn_reg( uint8_t reg, uint8_t *buf, size_t buf_len){

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
bool I2cDevice::i2c_writen_reg( uint8_t reg, uint8_t *buf, size_t buf_len){
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

