#ifndef RCT_FPIGA_H
#define RCT_FPIGA_H
#include <stdio.h>
#include <stdlib.h>
#include <cstdlib>
#include <cstdio>
#include <stdint.h>
#include <iostream>


class RCT_FPiGA
{
public:


    RCT_FPiGA(std::string devFile);
    ~RCT_FPiGA();

    //void regread8(uint8_t addr, uint16_t *buf);
    // void regwrite8(uint8_t reg, uint16_t val);
    //void setslvaddr(uint16_t addr);
    //void i2c_read_reg( uint8_t reg, uint8_t *buf);
    //void i2c_write_reg(uint8_t reg, uint8_t value);
    //void i2c_read(uint8_t *buf, size_t buf_len);
    //void i2c_write(uint8_t *buf, size_t buf_len);
    // void i2c_readn_reg( uint8_t reg, uint8_t *buf, size_t buf_len);
    // void i2c_writen_reg( uint8_t reg, uint8_t *buf, size_t buf_len);

private:

protected:
    static int fd;
    static uint16_t fpgaaddr;
    // bool setslvaddr(uint16_t addr);
    // int i2c_write_reg(uint8_t reg, uint8_t value);
    // uint8_t i2c_read_reg( uint8_t reg);
    // bool i2c_readn_reg(uint8_t reg, uint8_t *buf, size_t buf_len);
    // bool regwrite8( uint8_t reg, uint16_t val, bool rshift = true);
    // bool i2c_writen_reg( uint8_t reg, uint8_t *buf, size_t buf_len);
    // int i2c_read(uint8_t *buf, size_t buf_len);
    // int i2c_write( uint8_t *buf, size_t buf_len);

    static inline void i2c_wr32( uint16_t addr, uint16_t reg, uint32_t val);
    static inline uint32_t i2c_rd32( uint16_t addr, uint16_t reg);
    static void i2c_wr16_and_or(uint16_t addr, uint16_t reg, uint16_t mask, uint16_t val);
    static inline void i2c_wr16(uint16_t addr, uint16_t reg, uint16_t val);
    static inline uint16_t i2c_rd16( uint16_t addr, uint16_t reg);
    static inline void i2c_wr8_and_or(  uint16_t addr, uint16_t reg,
                                      uint8_t mask, uint8_t val);
    static inline void i2c_wr8( uint16_t addr, uint16_t reg, uint8_t val);
    static inline uint8_t i2c_rd8(uint16_t addr, uint16_t reg);
    static void i2c_wr( uint16_t addr, uint16_t reg, uint8_t *values, uint32_t n);
    static void i2c_rd( uint16_t addr,  uint16_t reg, uint8_t *values, uint32_t n);

    void Fpiga_i2c_wr(uint8_t reg, uint8_t val);
    uint8_t Fpiga_i2c_rd(uint8_t reg);
    void Fpiga_bitset(uint8_t reg, uint8_t bit);
    void Fpiga_bitclear(uint8_t reg, uint8_t bit);


};



#endif // RCT_FPIGA_H
