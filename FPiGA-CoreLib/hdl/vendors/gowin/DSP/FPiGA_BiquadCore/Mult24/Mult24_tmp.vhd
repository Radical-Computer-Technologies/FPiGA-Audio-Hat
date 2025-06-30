--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.11
--Part Number: GW5A-LV25MG121NC1/I0
--Device: GW5A-25
--Device Version: B
--Created Time: Fri May 16 21:37:51 2025

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component Mult24
    port (
        dout: out std_logic_vector(47 downto 0);
        a: in std_logic_vector(23 downto 0);
        b: in std_logic_vector(23 downto 0);
        clk: in std_logic;
        ce: in std_logic;
        reset: in std_logic
    );
end component;

your_instance_name: Mult24
    port map (
        dout => dout,
        a => a,
        b => b,
        clk => clk,
        ce => ce,
        reset => reset
    );

----------Copy end-------------------
