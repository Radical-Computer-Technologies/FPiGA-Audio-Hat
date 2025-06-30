--###############################
--# Project Name : FPiGA_CoreLib
--# File         : fpigai2c_top.vhd
--# Project      : Radical Computer Technologies FPiGA Core Lib
--# Engineer     : Joseph Vincent
--# Version      : 1.0.0
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.FPiGA_Audio_Pkg.all;
entity FPiGA_I2C is
	generic(
		ID_REGISTER : std_logic_vector(7 downto 0) := x"00";
		DEVADDR 		: std_logic_vector(7 downto 0) := x"38";
        NCORES : integer range 0 to 4 := 0
	);
	port(
        -- I2C Lines (to pins and expecting external pull up resistor)
        SCL			: inout	std_logic;
        SDA			: inout	std_logic;
        -- Clocking/Reset/Enable
        SYSCLK      : in std_logic;
        RSTN        : in std_logic;
        SOFT_RST   : out std_logic_vector(7 downto 0);
        SOFT_EN  : out std_logic_vector(7 downto 0);
        CONFREG0 : out std_logic_vector(7 downto 0);
        CONFREG1 : out std_logic_vector(7 downto 0);
        --WaveTable Registers
        FREQ : out PhaseArr; -- Phase Increment
    OscWave : out OscWaves;
    Osc0Vol : out std_logic_vector(23 downto 0);
    Osc1Vol : out std_logic_vector(23 downto 0);
    Osc2Vol : out std_logic_vector(23 downto 0);
    Osc3Vol : out std_logic_vector(23 downto 0);
        VOICE_GATE : out std_logic_vector(15 downto 0);
        WAVEWR_EN : out std_logic;
        WAVEWR_WAVESEL : out integer range 0 to 3;
        WAVEWR_DATA : out std_logic_vector(23 downto 0);
        WAVEWR_RDY : in std_logic;
        DSP_CTL : out std_logic_vector(7 downto 0);
        LVOL    : out std_logic_vector(23 downto 0);
        RVOL    : out std_logic_vector(23 downto 0)

	);
end FPiGA_I2C;

architecture rtl of FPiGA_I2C is


    component FPiGA_I2C_REGBANK is
        generic(
            ID_REGISTER : std_logic_vector(7 downto 0) := x"00";
            NCORES : integer range 0 to 4 := 0
        );
        port(
            RSTN: in	std_logic;
            address		: in	std_logic_vector(7 downto 0);
            clock		: in	std_logic;
            data		: in	std_logic_vector(7 downto 0);
            wren		: in	std_logic;
            dataout		: out	std_logic_vector(7 downto 0);
            rden        : in std_logic;
            --General Control Registers
            SOFT_RST   : out std_logic_vector(7 downto 0);
            SOFT_EN  : out std_logic_vector(7 downto 0);
            CONFREG0 : out std_logic_vector(7 downto 0);
            CONFREG1 : out std_logic_vector(7 downto 0);
            --WaveTable Registers
            FREQ : out PhaseArr; -- Phase Increment
    OscWave : out OscWaves;
    Osc0Vol : out std_logic_vector(23 downto 0);
    Osc1Vol : out std_logic_vector(23 downto 0);
    Osc2Vol : out std_logic_vector(23 downto 0);
    Osc3Vol : out std_logic_vector(23 downto 0);




            VOICE_GATE : out std_logic_vector(15 downto 0);
            WAVEWR_EN : out std_logic;
            WAVEWR_WAVESEL : out integer range 0 to 3;
            WAVEWR_DATA : out std_logic_vector(23 downto 0);
            WAVEWR_RDY : in std_logic;
        DSP_CTL : out std_logic_vector(7 downto 0);
        LVOL    : out std_logic_vector(23 downto 0);
        RVOL    : out std_logic_vector(23 downto 0)



        );
    end component;

    component I2CSLAVE
        generic( DEVICE: std_logic_vector(7 downto 0));
        port(
            MCLK		: in	std_logic;
            nRST		: in	std_logic;
            SDA_IN		: in	std_logic;
            SCL_IN		: in	std_logic;
            SDA_OUT		: out	std_logic;
            SCL_OUT		: out	std_logic;
            ADDRESS		: out	std_logic_vector(7 downto 0);
            DATA_OUT	: out	std_logic_vector(7 downto 0);
            DATA_IN		: in	std_logic_vector(7 downto 0);
            WR			: out	std_logic;
            RD			: out	std_logic
        );
    end component;

    signal i2cdatain_i : std_logic_vector(7 downto 0);
    signal sdain_i : std_logic;
    signal sdaout_i : std_logic;
    signal sclin_i : std_logic;
    signal sclout_i : std_logic;
    signal ramaddr : std_logic_vector(7 downto 0);
    signal ramdin : std_logic_vector(7 downto 0);
    signal ramdout : std_logic_vector(7 downto 0);
    signal ramrden : std_logic;
	signal buff8		: std_logic_vector(7 downto 0);
    signal ramwren : std_logic;
begin

--	I2C_RAM : sp256x8
--		port map (
--		    DEVICE_ID => idreg_i,
--			address	=> ramaddr,
--			clock		=> SYSCLK,
--			data		=> ramdin,
--			wren		=> ramwren,
--			q			=> ramdout,
--            I2S_RST => SOFTRST,
--            I2S_EN  => open
--		);

I2C_RAM : FPiGA_I2C_REGBANK 
	generic MAP(
		ID_REGISTER => ID_REGISTER,
        NCORES => NCORES
	)
	port MAP(
	    --
		address	=>	ramaddr,
		clock	=>	SYSCLK,
		data	=>	ramdin,
		wren	=>	ramwren,
		dataout	=>	ramdout,
        rden    =>  ramrden, 
        --General Control Registers
        RSTN => RSTN,

        SOFT_RST => SOFT_RST,
        SOFT_EN  => SOFT_EN,
        CONFREG0 => CONFREG0,
        CONFREG1 => CONFREG1,
        --WaveTable Registers
        FREQ       => FREQ,
        OscWave    => OscWave,
Osc0Vol =>Osc0Vol,
Osc1Vol =>Osc1Vol,
Osc2Vol =>Osc2Vol,
Osc3Vol =>Osc3Vol,

        VOICE_GATE  => VOICE_GATE,
        WAVEWR_EN => WAVEWR_EN,
        WAVEWR_WAVESEL => WAVEWR_WAVESEL,
        WAVEWR_DATA => WAVEWR_DATA,
        WAVEWR_RDY => WAVEWR_RDY,
        DSP_CTL => DSP_CTL,
        LVOL  =>    LVOL,
        RVOL  =>   RVOL


	);



	I_I2CITF : I2CSLAVE
		generic map (DEVICE => DEVADDR)
		port map (
			MCLK		=> SYSCLK,
			nRST		=> RSTN,
			SDA_IN		=> sdain_i,
			SCL_IN		=> sclin_i,
			SDA_OUT		=> sdaout_i,
			SCL_OUT		=> sclout_i,
			ADDRESS		=> ramaddr,
			DATA_OUT	=> ramdin,
			DATA_IN		=> i2cdatain_i,
			WR			=> ramwren,
			RD			=> ramrden
		);

	B8 : process(SYSCLK,RSTN)
	begin
		if (RSTN = '0') then
			buff8 <= (others => '0');
		elsif rising_edge(SYSCLK) then
			if (ramrden = '1') then
				buff8 <= ramdout;
			end if;
		end if;
	end process B8;

    i2cdatain_i <= buff8;
	--  open drain PAD pull up 1.5K needed
	SCL <= 'Z' when sclout_i='1' else '0';
	sclin_i <= to_UX01(SCL);
	SDA <= 'Z' when sdaout_i='1' else '0';
	sdain_i <= to_UX01(SDA);

end rtl;