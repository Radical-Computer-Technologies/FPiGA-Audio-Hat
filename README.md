# FPiGA-Audio-Hat
This repository contains software source, driver source, FPGA designs, hardware resources, and other supporting resources for the RCT FPiGA Audio Hat platform.

![Front Facing Tilt](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/blob/main/FPiGA_Audio-fwdtilt.jpg "Front Facing Tile")
![Overhead](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/blob/main/FPiGA_Audio-overhead.png "Overhead")

## Features
* Multiple Audio Pathways offering Real time, single sample latency processing via FPGA Module
* MIDI Input/Output
* Flashing FPGA bitfile from IO Pins using OpenFPGALoader
* Real time, 10 band equalizer via FPGA
* FOSS FPGA Toolchain Integration
* SSM2603 Hifidelity Audio Codec
* Audio Line Input, Line Output, and Headphones Output
* SSM2603 Userspace Driver Library/Control via I2C
* FPGA control Via I2C interface and Userspace Driver
* Long pins through 40 Pin header as well as 8 pin breakout from FPGA IO (To support expansion via hat stacking)
* UART In and Thru Out MIDI Driver Integration
* USB Midi Integration
* Custom (tuned) Pi OS Image for Audio Use

## FPGA Info
The FPiGA Audio Hat utilized a Sipeed Tang Primer 25k module in conjunction with a Raspberry Pi style platform. 

## Supported Platforms
* Raspberry Pi 3, 4, 5, CM4, CM5, Zero, Zero 2 W,
* Rock Pi 3C, Rock Pi CM3, and Rock Pi 5.
* Orange Pi Platforms (Possibly)
