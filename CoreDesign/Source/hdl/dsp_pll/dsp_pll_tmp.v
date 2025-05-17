//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11
//Part Number: GW5A-LV25MG121NC1/I0
//Device: GW5A-25
//Device Version: B
//Created Time: Fri Mar 28 02:56:12 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    dsp_pll your_instance_name(
        .lock(lock), //output lock
        .clkout0(clkout0), //output clkout0
        .clkout1(clkout1), //output clkout1
        .clkin(clkin) //input clkin
    );

//--------Copy end-------------------
