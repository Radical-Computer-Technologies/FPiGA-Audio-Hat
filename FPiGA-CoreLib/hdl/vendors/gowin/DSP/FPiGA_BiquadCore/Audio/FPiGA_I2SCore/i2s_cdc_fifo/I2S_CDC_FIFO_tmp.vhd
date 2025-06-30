--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.11
--Part Number: GW5A-LV25MG121NC1/I0
--Device: GW5A-25
--Device Version: B
--Created Time: Thu Mar 27 21:34:00 2025

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component i2s_cdc_fifo
	port (
		Data: in std_logic_vector(1 downto 0);
		WrClk: in std_logic;
		RdClk: in std_logic;
		WrEn: in std_logic;
		RdEn: in std_logic;
		Almost_Empty: out std_logic;
		Almost_Full: out std_logic;
		Q: out std_logic_vector(1 downto 0);
		Empty: out std_logic;
		Full: out std_logic
	);
end component;

your_instance_name: i2s_cdc_fifo
	port map (
		Data => Data,
		WrClk => WrClk,
		RdClk => RdClk,
		WrEn => WrEn,
		RdEn => RdEn,
		Almost_Empty => Almost_Empty,
		Almost_Full => Almost_Full,
		Q => Q,
		Empty => Empty,
		Full => Full
	);

----------Copy end-------------------
