--###############################
--# Project Name : FPiGA_CoreLib
--# File         : fpigai2c_top.vhd
--# Project      : Radical Computer Technologies FPiGA Core Lib
--# Engineer     : Joseph Vincent (jvincent@radcomp.tech)
--# Version      : 1.0.0
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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

        -- DEBUG CORE BUS
        DBG_DATA0 : in std_logic_vector(63 downto 0);
        DBG_DATA1 : in std_logic_vector(63 downto 0);
        DBG_DATA2 : in std_logic_vector(63 downto 0);
        DBG_DATA3 : in std_logic_vector(63 downto 0);
        DBG_RDY : out std_logic_vector(3 downto 0);
        DBG_ADDR : out std_logic_vector(3 downto 0);
        DBG_VALID : in std_logic(3 downto 0)
	);
end FPiGA_I2C;

architecture rtl of FPiGA_I2C is


    component FPiGA_I2C_REGBANK is
        generic(
            ID_REGISTER : std_logic_vector(7 downto 0) := x"00";
            NCORES : integer range 0 to 4 := 0
        );
        port(
            --
            address		: in	std_logic_vector(7 downto 0);
            clock		: in	std_logic;
            data		: in	std_logic_vector(7 downto 0);
            wren		: in	std_logic;
            dataout		: out	std_logic_vector(7 downto 0);
            rden        : in std_logic;
            --General Control Registers
            SOFT_RST   : out std_logic_vector(7 downto 0);
            SOFT_EN  : out std_logic_vector(7 downto 0);
            --Debug Core
            DBG_DATA0 : in std_logic_vector(63 downto 0);
            DBG_DATA1 : in std_logic_vector(63 downto 0);
            DBG_DATA2 : in std_logic_vector(63 downto 0);
            DBG_DATA3 : in std_logic_vector(63 downto 0);
            DBG_RDY : out std_logic_vector(3 downto 0);
            DBG_ADDR : out std_logic_vector(3 downto 0);
            DBG_VALID : in std_logic(3 downto 0)
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

    signal i2cdatain_i : std_logic;
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

    I2C_RAM : FPiGA_I2C_REGBANK 
    	generic map(
    		ID_REGISTER => ID_REGISTER,
            NCORES => NCORES
    	);
    	port map(
    	    --
    		address	=>	ramaddr,
    		clock	=>	SYSCLK,
    		data	=>	ramdin,
    		wren	=>	ramwren,
    		dataout	=>	ramdout,
            rden    =>  ramrden, 
            --General Control Registers
            SOFT_RST   => SOFT_RST,
            SOFT_EN  => SOFT_EN,
            --Debug Core
            DBG_DATA0 => DBG_DATA0,
            DBG_DATA1 => DBG_DATA1,
            DBG_DATA2 => DBG_DATA2,
            DBG_DATA3 =>  DBG_DATA3,
            DBG_RDY  =>  DBG_RDY,
            DBG_ADDR =>  DBG_ADDR,
            DBG_VALID =>  DBG_VALID
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

	B8 : process(dspclk_i,rstn_i)
	begin
		if (rstn_i = '0') then
			buff8 <= (others => '0');
		elsif rising_edge(dspclk_i) then
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