--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.11
--Part Number: GW5A-LV25MG121NC1/I0
--Device: GW5A-25
--Device Version: B
--Created Time: Fri May 16 18:46:11 2025

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component i2s_cdc_fifo
	port (
		Data: in std_logic_vector(47 downto 0);
		Reset: in std_logic;
		WrClk: in std_logic;
		RdClk: in std_logic;
		WrEn: in std_logic;
		RdEn: in std_logic;
		Rnum: out std_logic_vector(6 downto 0);
		Q: out std_logic_vector(47 downto 0);
		Empty: out std_logic;
		Full: out std_logic
	);
end component;

your_instance_name: i2s_cdc_fifo
	port map (
		Data => Data,
		Reset => Reset,
		WrClk => WrClk,
		RdClk => RdClk,
		WrEn => WrEn,
		RdEn => RdEn,
		Rnum => Rnum,
		Q => Q,
		Empty => Empty,
		Full => Full
	);

----------Copy end-------------------
