library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FPiGA_Audio_Top is
	generic(
		DEVICE 		: std_logic_vector(7 downto 0) := x"38"
	);
	port(
        CLK_50M     : in    std_logic;
		SDA_IN		: in	std_logic;
		SCL_IN		: in	std_logic;

        --RPi I2S Signals
        I2S_SDA_IN_RPI : in std_logic;
        I2S_SDA_OUT_RPI : out std_logic;
        I2S_BCK_RPI : out std_logic;
        I2S_LRCK_RPI : out std_logic;
        -- From Codec/Crystal
        I2S_MCLK : in std_logic;
        I2S_BCK_DAC : in std_logic;
        I2S_LRCK_DAC : in std_logic;
        I2S_BCK_ADC : in std_logic;
        I2S_LRCK_ADC : in std_logic;
        I2S_SDA_DAC : out std_logic
        I2S_SDA_ADC : in std_logic

	);
end FPiGA_Audio_Top;

architecture RTL of FPiGA_Audio_Top is

component FPiGA_I2C is
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
end component;

component FPiGA_I2S is
  port (
    SYSCLK : in STD_LOGIC;
    SYS_RSTN : in STD_LOGIC;

    --Control Bus
    I2S_EN : in std_logic;

    --RPi I2S Signals
    I2S_SDA_IN_RPI : in std_logic;
    I2S_SDA_OUT_RPI : out std_logic;
    I2S_BCK_RPI : out std_logic;
    I2S_LRCK_RPI : out std_logic;
    -- From Codec/Crystal
    I2S_MCLK : in std_logic;
    I2S_BCK_DAC : in std_logic;
    I2S_LRCK_DAC : in std_logic;
    I2S_BCK_ADC : in std_logic;
    I2S_LRCK_ADC : in std_logic;
    I2S_SDA_DAC : out std_logic
    I2S_SDA_ADC : in std_logic;

    --Output data on SYSCLK Domain
    DSP_DAC_DAT : in std_logic_vector(47 downto 0);
    DSP_DAC_DVALID : in std_logic;
    DSP_DAC_RDY : out std_logic;

    --Returning data on SYSCLK domain
    DSP_ADC_DAT : out std_logic_vector(47 downto 0);
    DSP_ADC_VALID : out std_logic;
    DSP_ADC_RDY : in std_logic;

    --Returning data on SYSCLK domain
    DSP_PI_DIN : in std_logic_vector(47 downto 0);
    DSP_PI_DINVALID : in std_logic;
    DSP_PI_DINRDY : out std_logic;

    --Returning data on SYSCLK domain
    DSP_PI_DOUT : out std_logic_vector(47 downto 0);
    DSP_PI_DOUTVALID : out std_logic;
    DSP_PI_DOUTRDY : in std_logic 
  );
end component;

signal sysclk_i             :  std_logic;
signal rstn_i               :  std_logic;
signal softrst_i            :  std_logic_vector(7 downto 0);
signal soften_i             :  std_logic_vector(7 downto 0);

signal dbgdat_0             :  std_logic_vector(63 downto 0);
signal dbgdat_1             :  std_logic_vector(63 downto 0);
signal dbgdat_2             :  std_logic_vector(63 downto 0);
signal dbgdat_3             :  std_logic_vector(63 downto 0);
signal dbgrdy               :  std_logic_vector(3 downto 0);
signal dbgaddr              :  std_logic_vector(3 downto 0);
signal dbgvalid             :  std_logic_vector(3 downto 0);
signal dspdacdata_i         :   std_logic_vector(47 downto 0);
signal dspadcdata_i         :   std_logic_vector(47 downto 0);
signal pidindata_i          :   std_logic_vector(47 downto 0);
signal pidoutdata_i         :   std_logic_vector(47 downto 0);
signal dspdacvalid_i        :  std_logic;
signal dspadcvalid_i        :  std_logic;
signal pidinvalid_i         :  std_logic;
signal pidoutvalid_i        :  std_logic;
signal dspdacrdy_i        :  std_logic;
signal dspadcrdy_i        :  std_logic;
signal pidinrdy_i         :  std_logic;
signal pidoutrdy_i        :  std_logic;

begin
i2ccore : FPiGA_I2C 
	generic map(
		ID_REGISTER => x"01";
		DEVADDR  => x"38";
        NCORES => 0
	)
	port map(
        -- I2C Lines (to pins and expecting external pull up resistor)
        SCL	=> SCL,
        SDA	=> SCL,
        -- Clocking/Reset/Enable
        SYSCLK  => sysclk_i,
        RSTN  => rstn_i,
        SOFT_RST  => softrst_i,
        SOFT_EN  => soften_i,

        -- DEBUG CORE BUS
        DBG_DATA0 => dbgdat_0,
        DBG_DATA1=> dbgdat_1,
        DBG_DATA2 => dbgdat_2,
        DBG_DATA3 => dbgdat_3,
        DBG_RDY => dbgrdy,
        DBG_ADDR => dbgaddr,
        DBG_VALID => dbgvalid
	);

i2score : FPiGA_I2S 
	port map(

        -- Clocking/Reset/Enable
        SYSCLK  => sysclk_i,
        RSTN  => rstn_i,
        I2S_EN  => soften_i(0),
        SOFT_EN  => soften_i,
        --RPi I2S Signals
        I2S_SDA_IN_RPI  => I2S_SDA_IN_RPI ,
        I2S_SDA_OUT_RPI => I2S_SDA_OUT_RPI,
        I2S_BCK_RPI     => I2S_BCK_RPI    ,
        I2S_LRCK_RPI    => I2S_LRCK_RPI   ,
        -- From Codec/Crystal
        I2S_MCLK     => I2S_MCLK    ,
        I2S_BCK_DAC  => I2S_BCK_DAC ,
        I2S_LRCK_DAC => I2S_LRCK_DAC,
        I2S_BCK_ADC  => I2S_BCK_ADC ,
        I2S_LRCK_ADC => I2S_LRCK_ADC,
        I2S_SDA_DAC  => I2S_SDA_DAC ,
        I2S_SDA_ADC  => I2S_SDA_ADC ,

        --Output data on SYSCLK Domain
        DSP_DAC_DAT     => dspdacdata_i,
        DSP_DAC_DVALID  => dspdacvalid_i,
        DSP_DAC_RDY     => dspdacrdy_i,

        --Returning data on SYSCLK domain
        DSP_ADC_DAT     => dspadcdata_i,
        DSP_ADC_VALID   => dspadcvalid_i,
        DSP_ADC_RDY     => dspadcrdy_i,

        --Returning data on SYSCLK domain
        DSP_PI_DIN      => pidindata_i,
        DSP_PI_DINVALID => pidinvalid_i,
        DSP_PI_DINRDY   => pidinrdy_i,

        --Returning data on SYSCLK domain
        DSP_PI_DOUT      => pidoutdata_i,
        DSP_PI_DOUTVALID => pidoutvalid_i,
        DSP_PI_DOUTRDY   =>pidoutrdy_i

	);



end RTL;
