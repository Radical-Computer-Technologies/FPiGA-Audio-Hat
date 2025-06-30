--###############################
--# Project Name : FPiGA_Biquad
--# File         : FPiGA_Biquad.vhd
--# Project      : Radical Computer Technologies FPiGA Core Lib
--# Engineer     : Joseph Vincent (jvincent@radcomp.tech)
--# Version      : 1.0.0
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--Takes 13 cycles for 10 second order biquad outputs
        -- If cascaded, then multiply by the number of cascades, 
        -- so 8th order (4 biquads) would take 52 cycles
        -- This takes advantage of the many cycles inbetween 
        -- samples at lower sampling rates. We only need to utilized
        -- 5 multipliers (in theory we could use less, but might as well 
        -- vantage the FPGA parallelism a little). For example, at 48k audio 
        -- and a 200MHz Sysclk, we would have 200_000_000/48000 = 5172 cycles
        -- to perform DSP operations. This is interesting because (to me) it implies
        -- that we should be able to do some upsampling and still get away with a lot of headroom.
        -- (if we upsampled by 4x, we would have ~1300 cycles to perform operations) - This should be plenty
        -- depending on the application. Have implemented this before, but will eventually add generics to 
        -- enable upsampling. The FPiGA audio hat can support 96k, though, so the merits may be lost in this application

entity FPiGA_Biquad is
	port(
        -- Clocking/Reset/Enable
        SYSCLK      : in std_logic;
        RSTN        : in std_logic
        DATA_IN : in std_logic_vector(23 downto 0);
        DATA_VALID : in std_logic;
        --Config Bus
        Coef_b0 : in std_logic_vector(23 downto 0);
        Coef_b1 : in std_logic_vector(23 downto 0);
        Coef_b2 : in std_logic_vector(23 downto 0);
        Coef_a0 : in std_logic_vector(23 downto 0);
        Coef_a1 : in std_logic_vector(23 downto 0);
        Coef_ADDR : in integer range 0 to 9;
        Coef_valid : in std_logic;
        
        BQ0_DATA : out std_logic_vector(23 downto 0);
        BQ1_DATA : out std_logic_vector(23 downto 0);
        BQ2_DATA : out std_logic_vector(23 downto 0);
        BQ3_DATA : out std_logic_vector(23 downto 0);
        BQ4_DATA : out std_logic_vector(23 downto 0);
        BQ5_DATA : out std_logic_vector(23 downto 0);
        BQ6_DATA : out std_logic_vector(23 downto 0);
        BQ7_DATA : out std_logic_vector(23 downto 0);
        BQ8_DATA : out std_logic_vector(23 downto 0);
        BQ9_DATA : out std_logic_vector(23 downto 0);
        BQ_DVALID : out std_logic_vector(9 downto 0);
	);
end FPiGA_Biquad;

architecture rtl of FPiGA_Biquad is
type sampleRegisters is array 0 to 11 of std_logic_vector(23 downto 0); -- [0] is x0 [1] is x1 [4] is y0 [5] is y1 etc
type coreRegisters is array 0 to 9 of sampleRegisters; -- 1 set of sample registers per biquad
type coefficients is array 0 to 15 of STD_LOGIC_VECTOR(23 downto 0);
type coreCoef is array 0 to 9 of coefficients; -- 1 set of coeff per biquad
type multData is array 0 to 9 of std_logic_vector(23 downto 0);
type multResult is array 0 to 9 of std_logic_vector(47 downto 0);

component Mult24 is
    port (
        dout: out std_logic_vector(47 downto 0);
        a: in std_logic_vector(23 downto 0);
        b: in std_logic_vector(23 downto 0);
        clk: in std_logic;
        ce: in std_logic;
        reset: in std_logic
    );
end component;

signal rst_i : std_logic;
signal sampleReg : coreRegisters;
signal coeff : coreCoef;
signal sampleMult : multData;
signal coefMult : multData;
signal biquadCnt : integer range -1 to 13 := -1;
signal mult_ce : std_logic := '0';
begin

rst_i <= RSTN;

mult_0 : Mult24 
port map (
    dout => multResult(0),
    a => sampleMult(0),
    b => coefMult(0),
    clk => SYSCLK,
    ce => mult_ce,
    reset => rst_i
);

mult_1 : Mult24 
port map (
    dout => multResult(1),
    a => sampleMult(1),
    b => coefMult(1),
    clk => SYSCLK,
    ce => mult_ce,
    reset => rst_i
);

mult_2 : Mult24 
port map (
    dout => multResult(2),
    a => sampleMult(2),
    b => coefMult(2),
    clk => SYSCLK,
    ce => mult_ce,
    reset => rst_i
);

mult_3 : Mult24 
port map (
    dout => multResult(3),
    a => sampleMult(3),
    b => coefMult(3),
    clk => SYSCLK,
    ce => mult_ce,
    reset => rst_i
);



calcbiquad_inst : process(SYSCLK)
begin
    if rising_edge(SYSCLK)then

        if biquadCnt = -1 then
            if(DATA_VALID = '1')then
                --shift data registers
                coreRegisters(0)(0) <= DATA_IN;
                coreRegisters(0)(2 downto 1) <= coreRegisters(0)(1 downto 0); 
                coreRegisters(0)(5 downto 4) <= coreRegisters(0)(4 downto 3); 
                biquadCnt <= biquadCnt + 1;
            end if;
            BQ_DVALID <= (others=>'0');
            mult_ce <= '0';
        elsif biquadCnt = 0 then
            --x0 * b0
            sampleMult(0)  <= coreRegisters(0)(0); 
            coefMult(0) <= coeff(0)(2);
            --x1 * b1
            sampleMult(1)  <= coreRegisters(0)(1); 
            coefMult(1) <= coeff(0)(3);
            --x2 * b2
            sampleMult(2)  <= coreRegisters(0)(2); 
            coefMult(1) <= coeff(0)(4);
            --y1 * -a1
            sampleMult(3)  <= coreRegisters(0)(4); 
            coefMult(3) <=  std_logic_vector(-to_signed(coeff(0)(0)));
            --y2 * -a2
            sampleMult(4)  <= coreRegisters(0)(5); 
            coefMult(4) <= std_logic_vector(-to_signed(coeff(0)(1)));

            mult_ce <= '1';
            biquadCnt <= biquadCnt + 1;
        elsif biquadCnt = 1 then
            mult_ce <= '1'; 
        elsif biquadCnt = 2 then
            --A big divide here, so may want to account for this by setting larget coefficients to follow suit
            coreRegisters(0)(3) <= std_logic_vector(resize((signed(multResult(0)(23 downto 0))
                                                        + signed(multResult(1)(23 downto 0))
                                                        + signed(multResult(2)(23 downto 0))
                                                        + signed(multResult(3)(23 downto 0))),24));
            biquadCnt <= biquadCnt + 1;
            mult_ce <= '0'; -- typically would keep high to continue calc pipelining
        elsif biquadCnt = 3 then;
            BQ0_DATA <= coreRegisters(0)(3);
            BQ_DVALID(0) <= '1';
            biquadCnt <= -1;
            mult_ce <= '0'; -- typically would keep high to continue calc pipelining
        end if;
        
    end if;
end process;
end rtl;