# FPiGA-Audio-Hat
This repository contains software source, driver source, FPGA designs, hardware resources, and other supporting resources for Radical Computer Technologies's FPiGA Audio Hat platform.

![Overhead](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/blob/main/photos/FPiGA_Audio-overhead.png "Overhead")
![Front Facing Tilt](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/blob/main/photos/FPiGA_Audio-fwdtilt.jpg "Front Facing Tile")

## Features

 Upon release these features will be available/incrementally added:

* Multiple Audio Pathways offering Real time, single sample latency processing via FPGA Module
* MIDI Input/Output
* Flashing FPGA bitfile from IO Pins using OpenFPGALoader
* Real time, 10 band equalizer via provided FPGA design
* Configurable filter chain via provided FPGA design
* Simple panning/Mixer via FPGA Design
* Programmable Wavetable for signal generation via FPGA Design
* Downsampling/Upsampling and filters in FPGA design
* FOSS FPGA Toolchain Integration
* SSM2603 Hi-Fi Audio Codec w/ programmable gain amplifiers and up to 96kSample rate
* Ability to generate I2S clocking from ADC+Crystal, generate from Pi, generate from FPGA, or hybridize clock generation based on use case
* Audio Line Input, Line Output, and Headphones Output
* SSM2603+FPGA combined I2C/Alsa Kernel Driver + Userspace C/C++ API Library
* FPGA control Via I2C interface and Userspace Driver
* Expanded 40 Pin header as well as 8 pin breakout from FPGA IO (To support expansion via hat stacking)
* UART In and Thru Out MIDI Driver Integration
* USB Midi Integration
* Custom (tuned) Pi OS Image for Audio Use w/ supporting software/drivers for hat board
* FPGA reference designs for HDL developers

There are multiple signal path options, including:

* Pi I2S Out -> FPGA -> Codec I2S DAC & Codec ADC Input -> FPGA -> Pi I2S Input
* Codec ADC Input -> FPGA -> Codec I2S DAC
* Codec ADC Input -> FPGA Input -> Pi I2S Input & FPGA generated output -> Codec I2S DAC
* FPGA generated sound -> Pi I2S Input & Pi I2s output -> FPGA -> Codec I2S DAC

## FPGA Info
The FPiGA Audio Hat utilizes a Sipeed Tang Primer 25k module in conjunction with a Raspberry Pi style platform. 

## Supported Platforms
* Raspberry Pi 3, 4, 5, CM4, CM5, Zero, Zero 2 W,
* Rock Pi 3C, Rock Pi Zero 3W, Rock Pi CM3, and Rock Pi 5. (Planned)
* Orange Pi Platforms (Planned)


## Provided Designs
* [FPiGA Audio Core Design](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/)

## Guides
* [FPiGA Audio Core Design](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/)




