--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--Tool Version: V1.9.11
--Part Number: GW5A-LV25MG121NC1/I0
--Device: GW5A-25
--Device Version: B
--Created Time: Fri May 16 21:37:51 2025

library IEEE;
use IEEE.std_logic_1164.all;

entity Mult24 is
    port (
        dout: out std_logic_vector(47 downto 0);
        a: in std_logic_vector(23 downto 0);
        b: in std_logic_vector(23 downto 0);
        clk: in std_logic;
        ce: in std_logic;
        reset: in std_logic
    );
end Mult24;

architecture Behavioral of Mult24 is

    signal dout_w: std_logic_vector(14 downto 0);
    signal gw_gnd: std_logic;
    signal A_i: std_logic_vector(26 downto 0);
    signal B_i: std_logic_vector(35 downto 0);
    signal D_i: std_logic_vector(25 downto 0);
    signal CLK_i: std_logic_vector(1 downto 0);
    signal CE_i: std_logic_vector(1 downto 0);
    signal RESET_i: std_logic_vector(1 downto 0);
    signal DOUT_o: std_logic_vector(62 downto 0);

    --component declaration
    component MULT27X36
        generic (
              AREG_CLK : string := "BYPASS";
              AREG_CE : string := "CE0";
              AREG_RESET : string := "RESET0";
              BREG_CLK : string := "BYPASS";
              BREG_CE : string := "CE0";
              BREG_RESET : string := "RESET0";
              DREG_CLK : string := "BYPASS";
              DREG_CE : string := "CE0";
              DREG_RESET : string := "RESET0";
              PADDSUB_IREG_CLK : string := "BYPASS";
              PADDSUB_IREG_CE : string := "CE0";
              PADDSUB_IREG_RESET : string := "RESET0";
              PREG_CLK : string := "BYPASS";
              PREG_CE : string := "CE0";
              PREG_RESET : string := "RESET0";
              PSEL_IREG_CLK : string := "BYPASS";
              PSEL_IREG_CE : string := "CE0";
              PSEL_IREG_RESET : string := "RESET0";
              OREG_CLK : string := "BYPASS";
              OREG_CE : string := "CE0";
              OREG_RESET : string := "RESET0";
              MULT_RESET_MODE : string := "SYNC";
              DYN_P_SEL : string := "FALSE";
              P_SEL : bit := '0';
              DYN_P_ADDSUB : string := "FALSE";
              P_ADDSUB : bit := '0'
        );
        port (
            DOUT: out std_logic_vector(62 downto 0);
            A: in std_logic_vector(26 downto 0);
            B: in std_logic_vector(35 downto 0);
            D: in std_logic_vector(25 downto 0);
            PSEL: in std_logic;
            PADDSUB: in std_logic;
            CLK: in std_logic_vector(1 downto 0);
            CE: in std_logic_vector(1 downto 0);
            RESET: in std_logic_vector(1 downto 0)
        );
    end component;
begin
    gw_gnd <= '0';

    A_i <= a(23) & a(23) & a(23) & a(23 downto 0);
    B_i <= b(23) & b(23) & b(23) & b(23) & b(23) & b(23) & b(23) & b(23) & b(23) & b(23) & b(23) & b(23) & b(23 downto 0);
    D_i <= gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd;
    CLK_i <= gw_gnd & clk;
    CE_i <= gw_gnd & ce;
    RESET_i <= gw_gnd & reset;
    dout <= DOUT_o(47 downto 0);

    mult27x36_inst: MULT27X36
        generic map (
            AREG_CLK => "CLK0",
            AREG_CE => "CE0",
            AREG_RESET => "RESET0",
            BREG_CLK => "CLK0",
            BREG_CE => "CE0",
            BREG_RESET => "RESET0",
            DREG_CLK => "BYPASS",
            DREG_CE => "CE0",
            DREG_RESET => "RESET0",
            PADDSUB_IREG_CLK => "BYPASS",
            PADDSUB_IREG_CE => "CE0",
            PADDSUB_IREG_RESET => "RESET0",
            PREG_CLK => "BYPASS",
            PREG_CE => "CE0",
            PREG_RESET => "RESET0",
            PSEL_IREG_CLK => "BYPASS",
            PSEL_IREG_CE => "CE0",
            PSEL_IREG_RESET => "RESET0",
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
            DOUT => DOUT_o,
            A => A_i,
            B => B_i,
            D => D_i,
            PSEL => gw_gnd,
            PADDSUB => gw_gnd,
            CLK => CLK_i,
            CE => CE_i,
            RESET => RESET_i
        );

end Behavioral; --Mult24
