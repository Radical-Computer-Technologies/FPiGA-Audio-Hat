library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library gw5a;
use gw5a.components.all;
library work;
use work.FPiGA_Audio_Pkg.all;

entity FPiGA_Audio is
	generic(
		DEVICE 		: std_logic_vector(7 downto 0) := x"38"
	);
	port(
        CLK_50M     : in    std_logic;
		SDA_IN		: inout	std_logic;
		SCL_IN		: inout	std_logic;
        --BCKO : out std_logic
--        RPi I2S Signals
        I2S_SDA_IN_RPI : in std_logic;
        --I2S_SDA_OUT_RPI : out std_logic;
        I2S_BCK_RPI : out std_logic;
        I2S_LRCK_RPI : out std_logic;
  --       From Codec/Crystal
       -- MCLKXCO_IN : in std_logic;
        MCLKXCO_OUT: out std_logic;
        I2S_BCK : in std_logic;
        I2S_LRCK_DAC : in std_logic;
        I2S_LRCK_ADC : in std_logic;
        I2S_SDA_DAC : out std_logic;
        I2S_SDA_ADC : in std_logic;
        MUTEEN : out  std_logic;
        FPGA67 : out  std_logic;        --B2
        FPGA75 : out  std_logic;         --E1
        FPGA77 : out  std_logic;         --D1
        FPGA71 : out  std_logic


	);
end FPiGA_Audio;

architecture RTL of FPiGA_Audio is


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


component fpiga_clks
    port (
        lock: out std_logic;
        clkout0: out std_logic;
        clkout1: out std_logic;
        clkout2: out std_logic;
        clkin: in std_logic
    );
end component;

component FPiGA_I2S is
  Port ( 

-- On I2S BCK Domain
    --  clocking/resets
    MCLK : in std_logic;
    BCK : in std_logic;
    DAC_LRCK : in std_logic;
    ADC_LRCK : in std_logic;
    I2S_RSTN : in std_logic;
    RPI_BCK : out std_logic := '0';
    RPI_LRCK : out std_logic := '0';
    -- data
    RPI_DIN : in std_logic;
    RPI_DOUT : out std_logic := '0';
    I2S_ADC_DAT : in std_logic;
    I2S_DAC_DATA : out std_logic := '0';
    DSP_DOUT   : out std_logic_vector(47 downto 0);
    DSP_DVALID : out std_logic;
-- On System Clock Domain
    --Configuration
    I2S_MODE : in std_logic_vector(7 downto 0);
    I2S_CTL : in std_logic_vector(7 downto 0);
    --Data
    DAC_DIN : in std_logic_vector(47 downto 0);
    DAC_DINVALID : in std_logic;
    DAC_DIN_RDY : out std_logic

  
  );
end component;
component FPiGA_Audio_DSP is
  Port ( 
    BCK : in std_logic;
    I2S_RESETN : in std_logic;
    SYSCLK : in std_logic;
    SYS_RSTN : in std_logic;
    DSP_DIN : in std_logic_vector(47 downto 0);
    DSP_DINVALID : in std_logic;
    DSP_DOUT : out std_logic_vector(47 downto 0);
    DSP_DOUTVALID : out std_logic;
    DAC_DIN_RDY : in std_logic;

    DSP_MODE : in std_logic_vector(7 downto 0);
    WAVEWR_EN : in std_logic;
    WAVEWR_WAVESEL : in integer range 0 to 3;
    WAVEWR_DATA : in std_logic_vector(23 downto 0);
    WAVEWR_RDY : out std_logic;
    --Wavetable bus
    FREQ : in PhaseArr; -- Phase Increment
    OscWave : in OscWaves;
    Osc0Vol : in std_logic_vector(23 downto 0);
    Osc1Vol : in std_logic_vector(23 downto 0);
    Osc2Vol : in std_logic_vector(23 downto 0);
    Osc3Vol : in std_logic_vector(23 downto 0);
    VOICE_GATE : in std_logic_vector(15 downto 0);
    DB_OUT : out std_logic;
    DSP_CTL : in std_logic_vector(7 downto 0);
    LVOL    : in std_logic_vector(23 downto 0);
    RVOL    : in std_logic_vector(23 downto 0)
  );
end component;


signal sysclk_i             :  std_logic;
signal rstn_i               :  std_logic;
signal i2srst : std_logic;
signal i2srstcnt        :  integer range 0 to 100 :=0;
signal sysrstcnt        :  integer range 0 to 100 :=0;
signal clocks_locked        :  std_logic :='0';
signal mclk : std_logic;
signal i2s_softrst_i            :  std_logic :='0';
signal i2s_softrst_r            :  std_logic :='0';
signal i2s_softrst_rr            :  std_logic :='0';

signal dspdout_i : std_logic_vector(47 downto 0);
signal dspsample_i : std_logic_vector(47 downto 0);
signal dacsample_i : std_logic_vector(47 downto 0);

signal dspwren_r        :  std_logic :='0';
signal dspwren_i        :  std_logic :='0';
signal dsprden_i        :  std_logic :='0';
signal dspoutwren_i        :  std_logic :='0';
signal dspoutwren_r        :  std_logic :='0';
signal dspoutwren_rr        :  std_logic :='0';

signal dspoutrden_i        :  std_logic :='0';
signal dspoutrdnum_i        :  std_logic_vector(5 downto 0);
signal dspdacsample_i : std_logic_vector(47 downto 0);
signal dspdacsample_r : std_logic_vector(47 downto 0);
signal dspdacsample_rr : std_logic_vector(47 downto 0);
signal dspdacsample_rrr : std_logic_vector(47 downto 0);

signal dacdout_i : std_logic_vector(47 downto 0);
signal dacdvalid_i : std_logic;

signal dsprdnum_i        :  std_logic_vector(5 downto 0);
signal datarcvd_i : std_logic := '0';
signal datarcvd_r : std_logic := '0';
signal dacdsprdy_i : std_logic := '0';
--I2C Reg Signals
signal softrst_i            :  std_logic_vector(7 downto 0);
signal soften_i             :  std_logic_vector(7 downto 0);
signal i2smode_i            :  std_logic_vector(7 downto 0);
signal dbgdat_0             :  std_logic_vector(63 downto 0);
signal dbgdat_1             :  std_logic_vector(63 downto 0);
signal dbgdat_2             :  std_logic_vector(63 downto 0);
signal dbgdat_3             :  std_logic_vector(63 downto 0);
signal dbgrdy               :  std_logic_vector(3 downto 0);
signal dbgaddr              :  std_logic_vector(3 downto 0);
signal dbgvalid             :  std_logic_vector(3 downto 0);
signal emptydsp                 :  std_logic;
signal emptydac                 :  std_logic;
signal dspmode_i            :  std_logic_vector(7 downto 0);
signal voicegate_i            :  std_logic_vector(15 downto 0);

signal freqs_i : PhaseArr := (others=>(others=>'0'));
signal      oscWavs : OscWaves;

--I2S Signals
signal sda_dac        :  std_logic :='0';
signal wavewren_i : stD_logic := '0';
signal wavesel_i : integer range 0 to 3;
signal wavewrdat_i :  std_logic_vector(23 downto 0);
signal wavewrrdy_i :   std_logic;
signal dspctl_i :  std_logic_vector(7 downto 0);
signal     mixlvol_i    :  std_logic_vector(23 downto 0);
signal     mixrvol_i    :  std_logic_vector(23 downto 0);
signal    Osc0Vol_i :  std_logic_vector(23 downto 0);
signal    Osc1Vol_i :  std_logic_vector(23 downto 0);
signal    Osc2Vol_i :  std_logic_vector(23 downto 0);
signal    Osc3Vol_i :  std_logic_vector(23 downto 0);

begin

mclkfwd:ODDR
GENERIC MAP (INIT=>'0',
TXCLK_POL=>'0'
)
PORT MAP (
Q0=>MCLKXCO_OUT,
Q1=>open,
D0=>'1',
D1=>'0',
TX=>'0',
CLK=>mclk
);

MUTEEN <= soften_i(0);
--FPGA67 <= soften_i(0);
FPGA75 <= I2S_BCK;
FPGA77 <=  sda_dac;-- when soften_i(1) = '0' else I2S_SDA_IN_RPI;
FPGA71 <= I2S_LRCK_DAC;
I2S_SDA_DAC <= sda_dac;

audioclk_gen : fpiga_clks
    port map (
        lock => clocks_locked,
        clkout0 => mclk,-- 12.2881mhz
        clkout1 => open,--I2S_BCK_RPI, -- 12.2881mhz*2
        clkout2 => sysclk_i,-- ~100mhz
        clkin => CLK_50M
    );

gen_i2s_rst : process(I2S_BCK)

begin
    if rising_edge(I2S_BCK)then


        if(clocks_locked = '0' )then
            i2srstcnt <= 0;
            i2srst <= '0';
            i2s_softrst_i <= '0';
            i2s_softrst_r <= '0';
            i2s_softrst_rr <= '0';
        else
          --  Soft Reset CDC
            i2s_softrst_i <= i2s_softrst_r;
            i2s_softrst_r <= i2s_softrst_rr;
            i2s_softrst_rr <= softrst_i(1);

            if(i2srstcnt < 50)then
                i2srstcnt <= i2srstcnt + 1;
                i2srst <= '0';
            elsif(i2s_softrst_i = '1')then
                i2srstcnt <= 0;
            else
                i2srst <= '1';
            end if;
        end if;
    end if;
end process;

gen_sys_rst : process(sysclk_i)

begin
    if rising_edge(sysclk_i)then
        if(clocks_locked = '0')then
            sysrstcnt <= 0;

        else
            if(sysrstcnt < 50)then
                sysrstcnt <= sysrstcnt + 1;
                rstn_i <= '0';
            else
                rstn_i <= '1';
            end if;
        end if;
    end if;
end process;

i2ccore : FPiGA_I2C 
	generic map(
		ID_REGISTER => x"01",
		DEVADDR  => x"12",
        NCORES => 0
	)
	port map(
        -- I2C Lines (to pins and expecting external pull up resistor)
        SCL	=> SCL_IN,
        SDA	=> SDA_IN,
        -- Clocking/Reset/Enable
        SYSCLK  => sysclk_i,
        RSTN  => rstn_i,
        SOFT_RST  => softrst_i,
        SOFT_EN  => soften_i,
        CONFREG0 => i2smode_i,
        CONFREG1 => dspmode_i,
        --WaveTable Registers
        FREQ    => freqs_i,

        OscWave => oscWavs,
Osc0Vol =>Osc0Vol_i,
Osc1Vol =>Osc1Vol_i,
Osc2Vol =>Osc2Vol_i, 
Osc3Vol =>Osc3Vol_i, 
        VOICE_GATE => voicegate_i,
    WAVEWR_EN      => wavewren_i  ,        
    WAVEWR_WAVESEL => wavesel_i,
    WAVEWR_DATA    => wavewrdat_i,
    WAVEWR_RDY     => wavewrrdy_i,
DSP_CTL => dspctl_i,
LVOL    => mixlvol_i,
RVOL   =>  mixrvol_i


	);

dsp_core: FPiGA_Audio_DSP 
  Port map( 

    BCK => I2S_BCK,
    I2S_RESETN=> i2srst,
    SYSCLK => sysclk_i,
    SYS_RSTN  => softrst_i(0),
    DSP_DIN      => dspdout_i,
    DSP_DINVALID => dspwren_i,
    DSP_DOUT => dacdout_i,
    DSP_DOUTVALID => dacdvalid_i,
     DAC_DIN_RDY =>dacdsprdy_i,
--        WaveTable Registers
        FREQ    => freqs_i,
        OscWave => oscWavs,
Osc0Vol =>Osc0Vol_i,
Osc1Vol =>Osc1Vol_i,
Osc2Vol =>Osc2Vol_i, 
Osc3Vol =>Osc3Vol_i, 
        VOICE_GATE => voicegate_i,
    DSP_MODE => dspmode_i,
    WAVEWR_EN      => wavewren_i  ,        
    WAVEWR_WAVESEL => wavesel_i,
    WAVEWR_DATA    => wavewrdat_i,
    WAVEWR_RDY     => wavewrrdy_i,
    DB_OUT => FPGA67,
DSP_CTL => dspctl_i,
LVOL    => mixlvol_i,
RVOL   =>  mixrvol_i

  );

i2s_core : FPiGA_I2S 
  Port map ( 
    MCLK => mclk,
    BCK => I2S_BCK,
    DAC_LRCK => I2S_LRCK_DAC,
    ADC_LRCK=> I2S_LRCK_ADC,
    I2S_RSTN=> i2srst,
    RPI_BCK => I2S_BCK_RPI,
    RPI_LRCK => I2S_LRCK_RPI,
    RPI_DIN => I2S_SDA_IN_RPI,
    RPI_DOUT => open,
    DSP_DOUT   => dspdout_i,
    DSP_DVALID => dspwren_i,
    I2S_ADC_DAT => I2S_SDA_ADC,
    I2S_DAC_DATA =>sda_dac,-- I2S_SDA_DAC,
    I2S_MODE => i2smode_i,
    I2S_CTL => x"00",
    DAC_DIN => dacdout_i,
    DAC_DINVALID => dacdvalid_i,
        DAC_DIN_RDY =>dacdsprdy_i

  
  
  );

end RTL;
