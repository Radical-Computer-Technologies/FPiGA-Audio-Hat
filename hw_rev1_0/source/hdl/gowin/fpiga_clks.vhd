library IEEE;
use IEEE.std_logic_1164.all;

library gw5a;
use gw5a.components.all;

entity fpiga_clks is
    port (
        lock    : out std_logic;
        clkout0 : out std_logic;
        clkout1 : out std_logic;
        clkout2 : out std_logic;
        clkin   : in  std_logic
    );
end entity fpiga_clks;

architecture rtl of fpiga_clks is
    signal clkfb_unused : std_logic;
    signal mdrdo_unused : std_logic_vector(7 downto 0);
begin
    -- GW5A PLLA wrapper for the FPiGA Audio HAT clock tree.
    -- Input is the board 50 MHz oscillator. With internal feedback:
    --   Fvco = 50 MHz / 1 * 1 * 20 = 1000 MHz
    --   clkout0 = 1000 / 81.375 = 12.288786 MHz audio MCLK
    --   clkout2 = 1000 / 10 = 100 MHz system/DSP clock
    -- clkout1 is reserved by the historical entity shape and not generated.
    u_pll : PLLA
        generic map (
            FCLKIN => "50",
            IDIV_SEL => 1,
            FBDIV_SEL => 1,
            ODIV0_SEL => 81,
            ODIV0_FRAC_SEL => 3,
            ODIV1_SEL => 40,
            ODIV2_SEL => 10,
            ODIV3_SEL => 8,
            ODIV4_SEL => 8,
            ODIV5_SEL => 8,
            ODIV6_SEL => 8,
            MDIV_SEL => 20,
            CLKOUT0_EN => "TRUE",
            CLKOUT1_EN => "FALSE",
            CLKOUT2_EN => "TRUE",
            CLKOUT3_EN => "FALSE",
            CLKOUT4_EN => "FALSE",
            CLKOUT5_EN => "FALSE",
            CLKOUT6_EN => "FALSE",
            CLKFB_SEL => "INTERNAL"
        )
        port map (
            CLKIN => clkin,
            CLKFB => '0',
            RESET => '0',
            PLLPWD => '0',
            RESET_I => '0',
            RESET_O => '0',
            PSSEL => (others => '0'),
            PSDIR => '0',
            PSPULSE => '0',
            SSCPOL => '0',
            SSCON => '0',
            SSCMDSEL => (others => '0'),
            SSCMDSEL_FRAC => (others => '0'),
            MDCLK => '0',
            MDOPC => (others => '0'),
            MDAINC => '0',
            MDWDI => (others => '0'),
            MDRDO => mdrdo_unused,
            LOCK => lock,
            CLKOUT0 => clkout0,
            CLKOUT1 => clkout1,
            CLKOUT2 => clkout2,
            CLKOUT3 => open,
            CLKOUT4 => open,
            CLKOUT5 => open,
            CLKOUT6 => open,
            CLKFBOUT => clkfb_unused
        );

    clkout1 <= '0';
end architecture rtl;
