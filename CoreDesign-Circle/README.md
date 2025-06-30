# FPiGA Audio Hat Core Design Circle

The FPiGA hat is fully open, so there's no need for using a prebuilt design, but to act as a starting point or example, a core design project has been 
designed using the FPiGA Core Lib which can be found at its own repo here:
https://github.com/Radical-Computer-Technologies/FPiGA-CoreLib

A system overview diagram of this design is below:

![Core Design](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/blob/main/photos/FPiGA-Audio-1.0-FPGA-CoreDesign.png "Core Design")

## Core Design Features
* I2S clocks generated from the SSM2603 codec using the on board crystal oscillator to ensure low jitter system.
* 200MHz FPGA system clock generation from Gowin PLL
* I2C Core Debug hub to aid in real time system debug between the Pi and FPGA. (a UI for Real time Integrated Logic Analyzer comms via I2C is Planned)
* CDC between I2S interface to DSP core to move from BCLK domains to 200MHz FPGA System clock
* Raspberry Pi ALSA Linux Kernel Driver w/ IOCTL interface. Interfaces to both the SSM2603 and the FPGA via I2C
* FPGA I2C Register bank implementation for control from the Raspberry Pi
* DSP Core which enables <1 sample latency processing of Audio samples

# FPGA Design

## DSP Core Overview

### Implemented Features
* Passthrough of audio from Raspberry Pi -> Audio Codec and Audio Codec -> Raspberry Pi
* Parallel biquad filter bank + Mixer
* Programmable Wavetable DDS generators 

### Planned/In Development Features (Ordered by Priority)
* Programmable signal path generation via rudimentary instruction set (Similar to SPIN FV-1)
* Delay effect
* Oversampling filters
* Bitcrushing

## I2C Core Overview
TBA

## Debug Hub Overview
TBA

# Circle Driver Library
TBA