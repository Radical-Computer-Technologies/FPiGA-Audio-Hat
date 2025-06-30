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

library work;
use work.FPiGA_Audio_Pkg.all;


entity FPiGA_WaveTable is
  Port ( 
    CLK : in std_logic;
    RST_EN : in std_logic;

    -- WAVEFORM Selects which waveform will be used - 0 - 3 is SINE, TRIANGLE, RAMP, SQUARE loaded by default - option to load custom waves in from Pi
    FREQ0 : in unsigned(23 downto 0); -- Phase Increment
    FREQ1 : in unsigned(23 downto 0); -- Phase Increment
    FREQ2 : in unsigned(23 downto 0); -- Phase Increment
    FREQ3 : in unsigned(23 downto 0); -- Phase Increment
    OscWave : in OscWaves;
    Osc0Vol : in signed(23 downto 0);
    Osc1Vol : in signed(23 downto 0);
    Osc2Vol : in signed(23 downto 0);
    Osc3Vol : in signed(23 downto 0);

    REQ_SAMPLE : in std_logic; -- Pulsed for one CLK Sample
   -- VOICE   : in integer range 0 to 15;
    -- Frequency in the form of Phase Increment 1024 CLK cycles for a single waveform, and phase is a 24 bit 8.16 value,
    -- This means that  at a value of 1, the wavetable would generate 46.87Hz at 48k . All non fractional values will increment in values of 46.87Hz till 12K 
    -- is reached. fractionally, there are 65536 intermediate values between each integer value, 46.87Hz - ~24kHz with steps of 0.000015259 Hz 
    -- Of course, this will require some filter based averaging to mitigate odd aliasing effects at high frequencies. Thoughts are currently to 
    -- grab 8 samples per request at 8 equally spaced increments and pass through a low pass filter with center frequency at 24K (nyquist for 48k) to generate a clean
    -- average waveform with a small wavetable of 1024 samples.


    DOUT_OSC0 : out signed(23 downto 0);
    DOUT_OSC1 : out signed(23 downto 0);
    DOUT_OSC2 : out signed(23 downto 0);
    DOUT_OSC3 : out signed(23 downto 0);

    DOUTVALID : out std_logic;

    WSAMPLE : in std_logic_vector(23 downto 0);
    WEN : in std_logic;
    WADDR: in std_logic_vector(11 downto 0)

  );
end FPiGA_WaveTable;


architecture Behavioral of FPiGA_WaveTable is

--type RamType is array (0 to 4095) of std_logic_vector(23 downto 0);
--type PhaseArr is array (0 to 3) of unsigned(23 downto 0); -- 4 oscillators per voice
--type VoicePhase is array (0 to 15) of PhaseArr;
--type OscWaves is array (0 to 3) of integer range 0 to 3;
signal rst : std_logic := '0';

--signal RAM : RamType := (others=>(others=>'0')); -- We can only use file in init!
signal  addr :  std_logic_vector(11 downto 0); -- I DO NOT KNOW IF THIS WILL WORK
signal intaddr :  std_logic_vector(11 downto 0); 
signal we: std_logic := '0' ; 
signal writesample :  std_logic_vector(23 downto 0);
signal phase : VoicePhase;
signal oscCnt : integer range 0 to 8;
signal validCnt : integer range 0 to 6;
signal freqs : PhaseArr;
signal validsent : std_logic := '0';
signal ramout_i : std_logic_vector(23 downto 0);
signal wavSel_i : OscWaves;
signal osc_dout : signed(47 downto 0);
signal osc_dina : signed(23 downto 0);
signal osc_dinb : signed(23 downto 0);
signal volume_tmp : signed(24 downto 0);

component WaveTableBram
    port (
        dout: out std_logic_vector(23 downto 0);
        clk: in std_logic;
        oce: in std_logic;
        ce: in std_logic;
        reset: in std_logic;
        wre: in std_logic;
        ad: in std_logic_vector(11 downto 0);
        din: in std_logic_vector(23 downto 0)
    );
end component;

begin

rst <= not RST_EN;

bram_proc: WaveTableBram
    port map (
        dout => ramout_i,
        clk => clk,
        oce => '1',
        ce => '1',
        reset => rst,
        wre => WE,
        ad => addr,
        din => writesample
    );


freqs(0) <= FREQ0;
freqs(1) <= FREQ1;
freqs(2) <= FREQ2;
freqs(3) <= FREQ3;

--osc_vol : process(clk)
--begin
--    if rising_edge(clk)then
--            osc_dout <= osc_dina * osc_dinb;
--    end if;

--end process;


writerd_handle:process(clk)
begin
    if rising_edge(clk) then
        if(RST_EN = '0')then
            oscCnt <= 0;
            --freqs <= (others=>(others=>'0'));
            phase <= (others=>(others=>(others=>'0')));
            --validsent <= '1';
            DOUTVALID <= '0'; 
            --wavSel_i <= (others=>0);
            addr <= (others=>'0');
            WE <= '0';
            writesample <= (others=>'0');
        else
            WE <= WEN;
            if(REQ_SAMPLE = '1')then
                --WE <= '0';
--                if(oscCnt < 4)then
--                    phase(VOICE)(oscCnt) <= phase(VOICE)(oscCnt) + freqs(oscCnt) ;
--                    if(oscCnt
--                    addr <=  std_logic_vector(resize(phase(VOICE)(oscCnt)(23 downto 14),12) + to_unsigned(wavSel_i(oscCnt)*1024,12));
--                
--                end if;
                if(oscCnt = 0)then
                    addr <= std_logic_vector(to_unsigned(OscWave(0),2)) & std_logic_vector( phase(0)(0)(23 downto 14));
                    phase(0)(0) <= phase(0)(0) + freqs(0) ;
                     DOUTVALID <= '0'; 
                    --DOUT <= (others=>'0');

                elsif(oscCnt = 1)then
                    addr <= std_logic_vector(to_unsigned(OscWave(1),2)) & std_logic_vector(phase(0)(1)(23 downto 14));
                    phase(0)(1) <= phase(0)(1) + freqs(1) ;
                    DOUTVALID <= '0'; 
                    --DOUT <= (others=>'0');

                elsif(oscCnt = 2)then
                    addr <= std_logic_vector(to_unsigned(OscWave(2),2)) & std_logic_vector(phase(0)(2)(23 downto 14));
                    phase(0)(2) <= phase(0)(2) + freqs(2) ;
                    --OSC_0 <= ramout_i;
                    --DOUT.voice(0)(0) <= signed(ramout_i);
                    --osc_dina <= signed(ramout_i);
                    --osc_dinb <= Osc0Vol;
                    --DOUT <= (others=>'0');
                    DOUT_OSC0 <= signed(ramout_i);

                     DOUTVALID <= '0'; 
                elsif(oscCnt = 3)then
                    addr <= std_logic_vector(to_unsigned(OscWave(3),2)) & std_logic_vector(phase(0)(3)(23 downto 14));
                    phase(0)(3) <= phase(0)(3) + freqs(3) ;
                    --DOUT.voice(0)(1) <= signed(ramout_i);
                    DOUT_OSC1 <= signed(ramout_i);




                    DOUTVALID <= '0'; 
                    osc_dina <= signed(ramout_i);
                    osc_dinb <= Osc1Vol;
                    --DOUT <= (others=>'0');

                elsif(oscCnt = 4)then
                    --DOUT.voice(0)(2) <= signed(ramout_i);

                    DOUTVALID <= '0'; 
                    osc_dina <= signed(ramout_i);
                    osc_dinb <= Osc2Vol;
                    --DOUT <= (others=>'0');
                    DOUT_OSC2 <= signed(ramout_i);

                    volume_tmp  <= osc_dout(47 downto 23);
                elsif(oscCnt = 5)then
                    DOUTVALID <= '1'; 
                    --DOUT.voice(0)(3) <= signed(ramout_i);

                    osc_dina <= signed(ramout_i);
                    osc_dinb <= Osc3Vol;
                    --DOUT <= (others=>'0');
                    DOUT_OSC3 <= signed(ramout_i);

                    --DOUT.voice(0)(0) 
                    volume_tmp <= (volume_tmp + resize(osc_dout(47 downto 24),25));


                end if;

                if(oscCnt < 5)then
                    oscCnt <= oscCnt + 1;
                end if;
            elsif WEN = '1' then
                writesample <= WSAMPLE;
                --WE <= '1';
                --phase <= (others=>(others=>(others=>'0')));
                DOUTVALID <= '0'; 
                --validsent <= '1';
                addr <= WADDR;
                oscCnt <= 0;

            else
                DOUTVALID <= '0'; 

                oscCnt <= 0;
                --WE <= '0';
                --validsent <= validsent;
            end if;
        end if;

    end if;
end process;


--bram_proc:process(clk)
--begin
--    if rising_edge(clk) then
--        if WE = '1' then
--            RAM(to_integer(unsigned(addr))) <= writesample;
--            ramout_i <= writesample;
--        else 
--            ramout_i <= RAM(to_integer(unsigned(addr)));
--        end if;
--        
--    end if;
--end process;

end Behavioral;

