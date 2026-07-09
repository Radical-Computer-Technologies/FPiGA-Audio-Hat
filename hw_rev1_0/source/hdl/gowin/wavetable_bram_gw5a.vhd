library IEEE;
use IEEE.std_logic_1164.all;

library gw5a;
use gw5a.components.all;

entity WaveTableBram is
    port (
        dout  : out std_logic_vector(23 downto 0);
        clk   : in  std_logic;
        oce   : in  std_logic;
        ce    : in  std_logic;
        reset : in  std_logic;
        wre   : in  std_logic;
        ad    : in  std_logic_vector(11 downto 0);
        din   : in  std_logic_vector(23 downto 0)
    );
end entity WaveTableBram;

architecture rtl of WaveTableBram is
    signal do_i : std_logic_vector(31 downto 0);
    signal ad_i : std_logic_vector(13 downto 0);
    signal di_i : std_logic_vector(31 downto 0);
begin
    ad_i <= "00" & ad;
    di_i <= x"00" & din;

    -- Explicit GW5A BSRAM primitive. The waveform table stores 4096 entries:
    -- four 1024-sample waveforms with one 24-bit sample per address.
    u_ram : SP
        generic map (
            BIT_WIDTH => 32,
            READ_MODE => '0',
            WRITE_MODE => "01",
            BLK_SEL => "000",
            RESET_MODE => "SYNC"
        )
        port map (
            DO => do_i,
            CLK => clk,
            CE => ce,
            OCE => oce,
            RESET => reset,
            WRE => wre,
            AD => ad_i,
            BLKSEL => "000",
            DI => di_i
        );

    dout <= do_i(23 downto 0);
end architecture rtl;
