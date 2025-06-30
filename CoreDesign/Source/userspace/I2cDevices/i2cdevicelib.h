#ifndef I2CDEVICELIB_H
#define I2CDEVICELIB_H

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
class I2cDevice : public QObject
{
    Q_OBJECT
public:
    explicit I2cDevice(std::string devpath);
    ~I2cDevice();
    bool fd_ok = false;
public slots:
    bool regwrite8(uint8_t reg, uint16_t val);
    bool setslvaddr(uint16_t addr);
    uint8_t i2c_read_reg( uint8_t reg);
    int i2c_write_reg(uint8_t reg, uint8_t value);
    int i2c_read(uint8_t *buf, size_t buf_len);
    int i2c_write(uint8_t *buf, size_t buf_len);
    bool i2c_readn_reg( uint8_t reg, uint8_t *buf, size_t buf_len);
    bool i2c_writen_reg( uint8_t reg, uint8_t *buf, size_t buf_len);

private:
    int fd;


signals:
};

#endif // I2CDEVICELIB_H
