--###############################
--# Project Name : FPiGA_CoreLib
--# File         : I2SCore.vhd
--# Project      : Radical Computer Technologies FPiGA Core Lib
--# Engineer     : Joseph Vincent (jvincent@radcomp.tech)
--# Version      : 1.0.0
--###############################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
library gw5a;
use gw5a.components.all;

entity FPiGA_I2S is
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
end FPiGA_I2S;

architecture RTL of FPiGA_I2S is

component i2s_cdc_fifo
	port (
  Data :  in std_logic_vector(47 downto 0);
  Reset :  in std_logic;
  WrClk :  in std_logic;
  RdClk :  in std_logic;
  WrEn :  in std_logic;
  RdEn :  in std_logic;
  Rnum :  out std_logic_vector(6 downto 0);
  Q :  out std_logic_vector(47 downto 0);
  Empty :  out std_logic;
  Full :  out std_logic
	);
end component;


signal i2sBckRpi : std_logic;
signal i2sRst_i : std_logic := '0';
signal rpiDinValid_i : std_logic := '0';
signal nextpisamp : std_logic_vector(47 downto 0);
signal pidatain_i : std_logic_vector(47 downto 0);
signal pidatain_r : std_logic_vector(47 downto 0);
signal pidataout_i : std_logic_vector(47 downto 0);
signal pidataout_r : std_logic_vector(47 downto 0);
signal pidinempty : std_logic;
signal rdnum_pdin  : std_logic_vector(6 downto 0);
signal rdnum_pdout  : std_logic_vector(6 downto 0);
signal rden_pdout  : std_logic_vector(6 downto 0);
signal sysrst_i : std_logic := '0';
signal i2sen_bck : std_logic := '0';
signal i2sen_r : std_logic := '0';
signal i2sen_rr : std_logic := '0';
signal i2sen_rrr : std_logic := '0';
signal i2sen_i : std_logic := '0';

begin
sysrst_i <= not SYS_RSTN;

i2s_cdc : process(I2S_BCK_ADC)
begin
    if rising_edge(I2S_BCK_ADC)then 
        i2sen_r <= I2S_EN;
        i2sen_rr <= i2sen_r;
        i2sen_rrr <= i2sen_rr;
        i2sen_i <= i2sen_rrr;
    end if;

end process;


-- Raspberry Pi I2S Handling

rpi_bck_fwd:ODDR
PORT MAP (
Q0=>I2S_BCK_RPI,
Q1=>open,
D0=>'1',
D1=> '0',
TX=>'0',
CLK=>I2S_BCK_ADC
);

pidatainbuff : i2s_cdc_fifo
	port map (
  Data => pidatain_r, --STD_LOGIC_VECTOR(I2S_LRCK_IN & I2S_SDA_IN),
  WrClk => I2S_BCK_ADC,
  RdClk => SYSCLK,
  WrEn => rpiDinValid_i,
  RdEn => DSP_PI_DOUTRDY, --'1',
  Reset => i2srst_i,
  Rnum =>rdnum_pdin,
  Q => DSP_PI_DOUT,
  Empty => pidinempty,
  Full => open
	);

DSP_PI_DOUTVALID <= (not pidinempty) and DSP_PI_DOUTRDY;

pidatain : process(I2S_BCK_ADC)
    variable incnt : integer range 0 to 47 := 0;
    variable lrck_r : std_logic := '1';
    variable syncd : std_logic := '0';

begin

    if rising_edge(I2S_BCK_ADC)then
        if(i2sAdcRst_i = '1' or i2sen_i = '0') then
            syncd := '0';
            rpiDinValid_i <= '0';
            incnt := 0;
            lrck_r := '1';
        else

            if( syncd = '0') then
                if(I2S_LRCK_ADC = '1' and lrck_r = '0')then
                    incnt := 0;
                    rpiDinValid_i<= '0';
                    syncd := '1';
                    pidatain_i(0) <= I2S_SDA_IN_RPI;
                else
                    rpiDinValid_i<= '0';
                end if;
            elsif(syncd = '1')then
                if(incnt < 31)then
                    incnt := incnt + 1;

                else
                    incnt := 0;

                end if;
                pidatain_i(incnt) <= I2S_SDA_IN_RPI;

                if(incnt = 0 and unsigned(rdnum_pdin) < 31) then
                    pidatain_r <= pidatain_i;
                    rpiDinValid_i<= '1';
                else
                    rpiDinValid_i<= '0';
                end if;
            else
                rpiDinValid_i<= '0';
            end if;

            lrck_r := I2S_LRCK_ADC;

        end if;
    end if;
end process;

pidataoutbuff : i2s_cdc_fifo
	port map (
  Data => DSP_PI_DIN, --STD_LOGIC_VECTOR(I2S_LRCK_IN & I2S_SDA_IN),
  WrClk => SYSCLK,
  RdClk => I2S_BCK_ADC,
  WrEn => DSP_PI_DINVALID,
  RdEn => rden_pdout, --'1',
  Reset => sysrst_i,
  Rnum =>rdnum_pdout,
  Q => pidataout_i,
  Empty => open,
  Full => open
	);

pidataout :  process(I2S_BCK_ADC)
    variable i2sbitcnt : integer range 0 to 47 := 0;
    variable lrckr : std_logic := '1';
    variable syncd_o : std_logic := '0';

begin

    if rising_edge(I2S_BCK_ADC)then
        if(i2sAdcRst_i = '1' or i2sen_i = '0') then
            lrckr := '1';
            I2S_SDA_OUT_RPI <= '0';
            i2sbitcnt := 0;
            syncd_o := '0';
        else
            
            if(unsigned(rdnum_pdout) > 3)then
                rden_pdout <= '1';
            else
                rden_pdout <= '0';
            end if;

            if(fiford = '1')then
                pidataout_r <= pidataout_i;
            end if;

            if( syncd_o = '0') then
                if(I2S_LRCK_ADC = '1' and lrckr = '0')then
                    i2sbitcnt := 1;
                    syncd_o := '1';
                    I2S_SDA_OUT_RPI <= pidataout_r(1);
                    nextpisamp <= pidataout_r;
                else
                    I2S_SDA_OUT_RPI <= '0';
                end if;
            elsif(syncd_o = '1')then
                I2S_SDA_OUT_RPI <= nextpisamp(i2sbitcnt);
                if(i2sbitcnt < 47) then
                    i2sbitcnt := i2sbitcnt + 1;
                else
                    nextpisamp <= pidataout_r;
                    i2sbitcnt := 0;
                end if;
            end if;
            lrckr := I2S_LRCK_ADC;
        end if;
    end if;
end process;

end RTL;