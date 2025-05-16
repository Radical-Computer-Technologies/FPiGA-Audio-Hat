# FPiGA Audio Hat - User Guide

# Software Requirements
* Gowin IDE

# FPiGA Raspberry Pi OS Image
TBA

# Getting Started Guide
## Data Flow
![Data Flow](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/blob/main/photos/FPiGA-Audio-1.0-DataFlow.png "Data Flow")

### Codec Data Flow Overview
Starting at the analog inputs, there are a stereo headphones output, a stereo line output, a stereo line input, and mono mic input. Users can set both the
headphones output and stereo line outputs as active, but only either the stereo line input or mono mic input can be active at a single time. The SSM2603 is 
paired with a 12.888 MHz crystal to generate clean I2S clocks with minimal jitter. The Raspberry Pi drives the codec via I2C, which allows for real time 
programming of the gain amplifiers, software muting, enabling the oversampling filters, and setting the noise gate, amongst other options. 

### FPGA Data Flow
The FPiGA Audio hat sits the FPGA between the Audio Codec and the Raspberry Pi. This is advantageous as it allows for the FPGA to act as 
a subprocessor on both incoming audio streams as well as outgoing audio streams. The FPGA is able to be programmed via either using the Raspberry Pi's
GPIO as a JTAG interface or by using an external JTAG programmer. The [core design](https://github.com/Radical-Computer-Technologies/FPiGA-Audio-Hat/) 
offers a good starting point for integration, but ultimately the user is not limited to this design. 

### Raspberry Pi
Made available from the aforementioned Core Design design is a Raspberry Pi OS Alsa driver/I2C. Additionally there is a bare metal implementation of the same driver using the Raspberry Pi Circle framework for those who like to work without an OS. Two of the audio jacks function as physical MIDI interfaces. Furthermore,
there is USB support for MIDI via the Pi's USB hub. Unexplored as of yet is the USB OTG functionality of the Pi, but with 480kbits/s of throughput, this should be
able to allow the Pi to function as a USB device, which could be interesting for those who wish to develop an Audio Interface to a typical computer using the system.

# Hardware User Guide
TBA