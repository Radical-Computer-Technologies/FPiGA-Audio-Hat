library IEEE;
use IEEE.std_logic_1164.all;

library gw5a;
use gw5a.components.all;

entity AUD_DSP_MULT is
    port (
        dout  : out std_logic_vector(47 downto 0);
        a     : in  std_logic_vector(23 downto 0);
        b     : in  std_logic_vector(23 downto 0);
        clk   : in  std_logic;
        ce    : in  std_logic;
        reset : in  std_logic
    );
end entity AUD_DSP_MULT;

architecture rtl of AUD_DSP_MULT is
    signal a_ext : std_logic_vector(26 downto 0);
    signal b_ext : std_logic_vector(35 downto 0);
    signal prod  : std_logic_vector(62 downto 0);
    signal ce_i    : std_logic_vector(1 downto 0);
    signal clk_i   : std_logic_vector(1 downto 0);
    signal reset_i : std_logic_vector(1 downto 0);
begin
    a_ext <= a(23) & a(23) & a(23) & a;
    b_ext <= b(23) & b(23) & b(23) & b(23) & b(23) & b(23) &
             b(23) & b(23) & b(23) & b(23) & b(23) & b(23) & b;
    ce_i <= ce & ce;
    clk_i <= clk & clk;
    reset_i <= reset & reset;

    -- Explicit GW5A DSP multiplier primitive. The DSP path uses signed 24x24
    -- fixed-point products; the wrapper keeps the historic AUD_DSP_MULT port
    -- shape while avoiding Gowin multiply inference.
    u_mult : MULT27X36
        generic map (
            AREG_CLK => "CLK0",
            AREG_CE => "CE0",
            AREG_RESET => "RESET0",
            BREG_CLK => "CLK0",
            BREG_CE => "CE0",
            BREG_RESET => "RESET0",
            DREG_CLK => "BYPASS",
            PREG_CLK => "BYPASS",
            OREG_CLK => "CLK0",
            OREG_CE => "CE0",
            OREG_RESET => "RESET0",
            MULT_RESET_MODE => "SYNC",
            DYN_P_SEL => "FALSE",
            P_SEL => '0',
            DYN_P_ADDSUB => "FALSE",
            P_ADDSUB => '0'
        )
        port map (
            A => a_ext,
            B => b_ext,
            D => (others => '0'),
            CE => ce_i,
            CLK => clk_i,
            RESET => reset_i,
            PSEL => '0',
            PADDSUB => '0',
            DOUT => prod
        );

    dout <= prod(47 downto 0);
end architecture rtl;
