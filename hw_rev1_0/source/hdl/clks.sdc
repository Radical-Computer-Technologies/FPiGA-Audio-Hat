//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11 
//Created Time: 2025-05-25 22:20:16
create_clock -name CODEC_BCK -period 310.366 -waveform {0 155.183} [get_nets {I2S_BCK}]
//create_clock -name RPI_BCK -period 310.366 -waveform {0 155.183} [get_nets {I2S_BCK_RPI}]
//create_clock -name I2S_MCLK -period 81.38 -waveform {0 40.69} [get_nets {MCLKXCO_OUT}]
