----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/04/2024 11:41:56 AM
-- Design Name: 
-- Module Name: i2s_out - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Library xpm;
--use xpm.vcomponents.all;

entity FPiGA_I2S is
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

    DSP_DOUT : out std_logic_vector(47 downto 0);
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
end FPiGA_I2S;


architecture Behavioral of FPiGA_I2S is
constant I2SMODE_IDLE : std_logic_vector(7 downto 0) := x"00";
constant I2SMODE_48K : std_logic_vector(7 downto 0) := x"01";
constant I2SMODE_TEST : std_logic_vector(7 downto 0) := x"02";
constant I2SMODE_48k_DSP : std_logic_vector(7 downto 0) := x"03";

signal i2sctl_r : std_logic_vector(7 downto 0);
signal i2sctl_rr : std_logic_vector(7 downto 0);
signal i2sctl_i : std_logic_vector(7 downto 0);
signal mode_r : std_logic_vector(7 downto 0);
signal mode_rr : std_logic_vector(7 downto 0);
signal mode_i : std_logic_vector(7 downto 0);
signal mode_l : std_logic_vector(7 downto 0);

signal rpidin : std_logic_vector(47 downto 0);
signal rpidinvalid : std_logic := '0';
signal rpidin_r : std_logic_vector(47 downto 0);

signal dac_lrck_r : std_logic := '0';
signal rpidincnt : integer range 0 to 63 := 63;
signal rpidinbitcnt : integer range 0 to 48 := 0;

signal dacdout : std_logic_vector(47 downto 0);
signal dacdout_r : std_logic_vector(47 downto 0);
signal dacdoutcnt : integer range 0 to 63 := 63;
signal dacbitcnt : integer range 0 to 48 := 0;
signal rampcnt : signed(23 downto 0);

begin

DSP_DOUT <= rpidin_r;
DSP_DVALID <= rpidinvalid;


RPI_BCK <= BCK;
RPI_LRCK <= DAC_LRCK;
    conf_cdc : process(BCK)
    begin
        if rising_edge(BCK)then
            if (I2S_RSTN = '0')then
                i2sctl_r <= (others=>'0');
                i2sctl_rr <= (others=>'0');
                i2sctl_i <= (others=>'0');
                mode_r <= (others=>'0');
                mode_rr <= (others=>'0');
                mode_i <= (others=>'0');

            else
                --I2S Control triple register
                i2sctl_r <= I2S_CTL;
                i2sctl_rr <= i2sctl_r;
                i2sctl_i <= i2sctl_rr;
                --I2S mode triple register
                mode_r <= I2S_MODE;
                mode_rr <= mode_r;
                mode_i <= mode_rr;

            end if;
        end if;
    end process;

    rpi_din_reg : process(BCK)
    begin
        if rising_edge(BCK)then
            if ((I2S_RSTN = '0') or (mode_i = I2SMODE_IDLE))then
                rpidincnt <= 0;
                dac_lrck_r <= '0';
                rpidinvalid <= '0';
                rpidinbitcnt <= 0;
                rpidin  <= (others=>'0');
                
            elsif(mode_i = I2SMODE_48K or mode_i = I2SMODE_48k_DSP)then
                dac_lrck_r <= DAC_LRCK;
                if(dac_lrck_r = '1' and DAC_LRCK = '0')then
                    rpidincnt <= 1;
                    rpidinbitcnt <= 1;
                    rpidin(0) <= RPI_DIN;
                    rpidinvalid <= '0';
                elsif(rpidincnt < 63)then
                    if((rpidincnt < 24) or (rpidincnt > 31 and rpidincnt < 56))then
                        rpidinbitcnt <= rpidinbitcnt + 1;
                        rpidin(rpidinbitcnt) <= RPI_DIN;
                        rpidinvalid <= '0';
                    elsif(rpidincnt = 57)then
                        rpidin_r <= rpidin;
                        rpidinvalid <= '1';
                    else
                        rpidinvalid <= '0';
                    end if;
                    
                    rpidincnt <= rpidincnt + 1;
                end if;
            else
                rpidincnt <= 0;
                dac_lrck_r  <= DAC_LRCK;
                rpidinvalid <= '0';
                rpidinbitcnt <= 0;
                rpidin  <= (others=>'0');
            end if;
        end if;
    end process;

    dac_dout : process(BCK)
    begin
        if rising_edge(BCK)then
            if ((I2S_RSTN = '0') or (mode_i = I2SMODE_IDLE))then
                dacdoutcnt <= 1;
                dacbitcnt <= 1;
                dacdout <= (others=>'0');
                dacdout_r  <= (others=>'0');
                rampcnt<= (others=>'0');
                DAC_DIN_RDY <= '0';
            elsif(mode_i = I2SMODE_48K)then

                if(dac_lrck_r = '1' and DAC_LRCK = '0')then
                    dacdoutcnt <= 1;
                    dacbitcnt <= 1;
                    dacdout <= dacdout_r;
                    I2S_DAC_DATA <= dacdout_r(0);

                elsif(dacdoutcnt < 63)then
                    if((dacdoutcnt < 24) or (dacdoutcnt > 31 and dacdoutcnt < 56))then
                        dacbitcnt <= dacbitcnt + 1;
                        I2S_DAC_DATA <= dacdout(dacbitcnt);
                    else
                        I2S_DAC_DATA <= '0';
                    end if;
                    
                    if(rpidinvalid = '1')then
                        dacdout_r <= rpidin_r;
                    end if;
                    dacdoutcnt <= dacdoutcnt + 1;
                end if;
            elsif(mode_i = I2SMODE_TEST)then

                if(dac_lrck_r = '1' and DAC_LRCK = '0')then
                    dacdoutcnt <= 1;
                    dacbitcnt <= 1;
                    dacdout <= dacdout_r;
                    I2S_DAC_DATA <= dacdout_r(47);
                    dacdout_r<= (std_logic_vector(rampcnt) & std_logic_vector(rampcnt));
                    rampcnt<= rampcnt+40000;
                elsif(dacdoutcnt < 63)then
                    if((dacdoutcnt < 24) or (dacdoutcnt > 31 and dacdoutcnt < 56))then
                        dacbitcnt <= dacbitcnt + 1;
                        I2S_DAC_DATA <= dacdout(47-dacbitcnt);
                    else
                        I2S_DAC_DATA <= '0';
                    end if;
                    
--                    if(dacdoutcnt = 57)then
--                        dacdout_r <= std_logic_vector(rampcnt) & std_logic_vector(rampcnt);
--                        rampcnt<= rampcnt+40000;
--                    end if;
                    dacdoutcnt <= dacdoutcnt + 1;
                end if;
            elsif(mode_i = I2SMODE_48k_DSP)then

                if(dac_lrck_r = '1' and DAC_LRCK = '0')then
                    dacdoutcnt <= 1;
                    dacbitcnt <= 1;
                    dacdout <= dacdout_r;
                    I2S_DAC_DATA <= dacdout_r(0);
                    DAC_DIN_RDY <= '1';

                elsif(dacdoutcnt < 63)then
                    
                    if((dacdoutcnt < 24) or (dacdoutcnt > 31 and dacdoutcnt < 56))then
                        dacbitcnt <= dacbitcnt + 1;
                        I2S_DAC_DATA <= dacdout(dacbitcnt);
                    else
                        I2S_DAC_DATA <= '0';
                    end if;
                    
                    if(DAC_DINVALID = '1')then
                        dacdout_r <= DAC_DIN;
                        DAC_DIN_RDY <= '0';
                    end if;
                    dacdoutcnt <= dacdoutcnt + 1;
                end if;
            else
                dacdout_r <= (others=>'0');
                dacdoutcnt <= 0;
                dacbitcnt <= 0;
                dacdout <= (others=>'0');
            end if;
        end if;
    end process;

end Behavioral;

