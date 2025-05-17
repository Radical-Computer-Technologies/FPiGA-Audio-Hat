--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.11
--Part Number: GW5A-LV25MG121NC1/I0
--Device: GW5A-25
--Device Version: B
--Created Time: Fri Mar 28 02:56:43 2025

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component dsp_pll
    port (
        lock: out std_logic;
        clkout0: out std_logic;
        clkout1: out std_logic;
        clkin: in std_logic
    );
end component;

your_instance_name: dsp_pll
    port map (
        lock => lock,
        clkout0 => clkout0,
        clkout1 => clkout1,
        clkin => clkin
    );

----------Copy end-------------------
