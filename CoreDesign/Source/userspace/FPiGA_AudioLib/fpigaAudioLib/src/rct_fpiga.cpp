#include "rct_fpiga.h"
#include <iostream>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/i2c.h>
#include <linux/i2c-dev.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <cstdlib>
#include <cstdio>
#include <stdint.h>
#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>

int RCT_FPiGA::fd = 0;
uint16_t RCT_FPiGA::fpgaaddr = 0;



void RCT_FPiGA::i2c_rd(uint16_t addr,  uint16_t reg, uint8_t *values, uint32_t n)
{
    int err;
    uint8_t buf[1] = { uint8_t(reg & 0xff) };
    struct i2c_rdwr_ioctl_data msgset;
    struct i2c_msg msgs[2] = {
        {
            .addr = addr,
            .flags = 0,
            .len = 1,
            .buf = buf,
        },
        {
            .addr = addr,
            .flags = I2C_M_RD,
            .len = uint16_t(n),
            .buf = values,
        },
    };

    msgset.msgs = msgs;
    msgset.nmsgs = 2;

    err = ioctl(fd, I2C_RDWR, &msgset);
    if(err != msgset.nmsgs)
        std::cout << "%s: reading register 0x%x from 0x%x failed, err %d\n";
}

void RCT_FPiGA::i2c_wr(uint16_t addr, uint16_t reg, uint8_t *values, uint32_t n)
{
    uint8_t data[1024];
    int err, i;
    struct i2c_msg msg;
    struct i2c_rdwr_ioctl_data msgset;

    if ((1 + n) > sizeof(data))
        std::cout << "i2c wr reg=%04x: len=%d is too big!\n";


    msg.addr = addr;
    msg.buf = data;
    msg.len = 1 + n;
    msg.flags = 0;

    //data[0] = reg >> 8;
    data[0] = reg & 0xff;

    for (i = 0; i < n; i++)
        data[1 + i] = values[i];

    msgset.msgs = &msg;
    msgset.nmsgs = 1;

    err = ioctl(fd, I2C_RDWR, &msgset);
    if (err != 1) {
        std::cout <<"%s: writing register " << reg << " from " <<  addr << "failed\n";
        return;
    }
}

inline uint8_t RCT_FPiGA::i2c_rd8(uint16_t addr, uint16_t reg)
{
    uint8_t val;

    i2c_rd(addr,reg, &val, 1);

    return val;
}

inline void RCT_FPiGA::i2c_wr8(uint16_t addr, uint16_t reg, uint8_t val)
{
    i2c_wr(addr, reg, &val, 1);
}

inline uint16_t RCT_FPiGA::i2c_rd16(uint16_t addr, uint16_t reg)
{
    uint16_t val;

    i2c_rd( addr, reg, (uint8_t *)&val, 2);

    return val;
}

inline void RCT_FPiGA::i2c_wr16(uint16_t addr, uint16_t reg, uint16_t val)
{
    i2c_wr( addr, reg, (uint8_t *)&val, 2);
}

void RCT_FPiGA::i2c_wr16_and_or(uint16_t addr, uint16_t reg, uint16_t mask, uint16_t val)
{
    i2c_wr16(addr, reg, (i2c_rd16(addr, reg) & mask) | val);
}

inline uint32_t RCT_FPiGA::i2c_rd32(uint16_t addr, uint16_t reg)
{
    uint32_t val;

    i2c_rd(addr, reg, (uint8_t *)&val, 4);

    return val;
}

inline void RCT_FPiGA::i2c_wr32(uint16_t addr, uint16_t reg, uint32_t val)
{
    i2c_wr(addr, reg, (uint8_t *)&val, 4);
}





RCT_FPiGA::RCT_FPiGA(std::string filename)

{

    fd = open(filename.c_str(), O_RDWR);
    if(fd > 0){
        std::cout << "Opened i2c device\r\n";
        fpgaaddr = 0x12;


    }

}



RCT_FPiGA::~RCT_FPiGA(){

}

void RCT_FPiGA::Fpiga_i2c_wr(uint8_t reg, uint8_t val){
    i2c_wr8(fpgaaddr,reg,val);

}
uint8_t RCT_FPiGA::Fpiga_i2c_rd(uint8_t reg){
    return i2c_rd8(fpgaaddr,reg);
}


void RCT_FPiGA::Fpiga_bitset(uint8_t reg, uint8_t bit){
    uint8_t rval = Fpiga_i2c_rd(reg);
    rval = rval | (0x01<<bit);
    Fpiga_i2c_wr(reg,rval);
}

void RCT_FPiGA::Fpiga_bitclear(uint8_t reg, uint8_t bit){
    uint8_t rval = Fpiga_i2c_rd(reg);
    rval = rval & ~(0x01<<bit);
    Fpiga_i2c_wr(reg,rval);

}
