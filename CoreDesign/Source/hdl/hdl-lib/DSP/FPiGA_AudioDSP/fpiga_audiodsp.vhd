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
entity FPiGA_Audio_DSP is
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
    WAVEWR_RDY : out std_logic := '0';
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
end FPiGA_Audio_DSP;


architecture Behavioral of FPiGA_Audio_DSP is
type outarr is array (0 to 3) of std_logic_vector(47 downto 0);
--type wavearr is array (0 to 3) of std_logic_vector(23 downto 0);
--type oscSel is array (0 to 3) of integer range 0 to 3;
type DSP_STATE is (IDLE, GETSAMPLE, PROCSAMPLES,GETWAVEFORMS, WRITEWAVEFORMS, MIXOSCS, MIXSAMPLES, SENDSAMPLES);
component FPiGA_WaveTable is
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
    --Osc1Wave : in integer range 0 to 3;
    --Osc2Wave : in integer range 0 to 3;
    --Osc3Wave : in integer range 0 to 3;
    REQ_SAMPLE : in std_logic; -- Pulsed for one CLK Sample
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
end component;

component AUD_DSP_MULT
    port (
        dout: out std_logic_vector(47 downto 0);
        a: in std_logic_vector(23 downto 0);
        b: in std_logic_vector(23 downto 0);
        clk: in std_logic;
        ce: in std_logic;
        reset: in std_logic
    );
end component;



CONSTANT DSP_MODE_PASS : std_logic_vector(7 downto 0) := x"00";
CONSTANT DSP_MODE_SYNTH : std_logic_vector(7 downto 0) := x"01";
CONSTANT DSP_MODE_LOADWAVE : std_logic_vector(7 downto 0) := x"02";

signal buff : outarr := (others=>(others=>'0'));
signal buffwrptr : integer range 0 to 3 := 0;
signal buffrdptr : integer range 0 to 3 := 0;

signal dspdin_i :  std_logic_vector(47 downto 0);
signal dspdin_r :  std_logic_vector(47 downto 0);
signal dspdin_rr :  std_logic_vector(47 downto 0);
signal dspdinvalid_i : std_logic := '0';
signal dspdinvalid_l : std_logic := '0';

signal dspdinvalid_r : std_logic := '0';
signal dspdinvalid_rr : std_logic := '0';

signal dspoutwren_i : std_logic := '0';
signal dspoutwren_r : std_logic := '0';
signal dspoutwren_rr : std_logic := '0';
signal dspdout_r :  std_logic_vector(47 downto 0);

signal dspdout_i :  std_logic_vector(47 downto 0);
signal dspdvalid_i :  std_logic_vector(47 downto 0);
signal dspdloaded_i: std_logic := '0';

signal  dspdataout_i :  std_logic_vector(47 downto 0);
signal dspdoutvalid_i: std_logic := '0';
signal wavewren_r : std_logic := '0';

signal datarcvd_i : std_logic := '0';
signal datarcvd_r : std_logic := '0';
signal dacdataloaded : std_logic := '0';

signal     freqs : PhaseArr := (others=>(others=>'0'));
signal     oscOut : PhaseArr := (others=>(others=>'0'));
signal     req_sample_i :  std_logic := '0'; -- Pulsed for one CLK Sample
signal     req_sample_r :  std_logic := '0'; -- Pulsed for one CLK Sample

signal     voice_sel_i   :  integer range 0 to 15;
signal     wave_wsample_i :  std_logic_vector(23 downto 0);

signal     dsp_mult_dout : signed(47 downto 0);
signal     dsp_mult_dina : signed(23 downto 0);
signal     dsp_mult_dinb : signed(23 downto 0);
signal     mix_cnt : integer range 0 to 3;
signal     mixosc_cnt : integer range 0 to 6;

signal     wave_wen_i :  std_logic;
signal     wave_waddr_i : std_logic_vector(11 downto 0);
signal     wave_addrcnt_i :  unsigned(11 downto 0);

signal     voiceSamples : VoiceSample;
signal     voicevalid : std_logic;
signal      dspdac_sample : signed(47 downto 0);

signal     mixedVoices : VoiceSample;

signal dsp_sm : DSP_STATE := IDLE;

begin

wavetable_i : FPiGA_WaveTable 
  Port map ( 
    CLK => SYSCLK,
    RST_EN => '1',
    FREQ0    => FREQ(0) , 
    FREQ1    => FREQ(1) ,  
    FREQ2    => FREQ(2) ,  
    FREQ3    => FREQ(3) ,   
    OscWave => OscWave,
Osc0Vol=>(others=>'0'), --Osc0Vol, 
Osc1Vol=>(others=>'0'), --Osc1Vol, 
Osc2Vol=>(others=>'0'), --Osc2Vol, 
Osc3Vol=>(others=>'0'), --Osc3Vol, 
    REQ_SAMPLE => req_sample_i,
    
    DOUT_OSC0 => voiceSamples(0)(0),
    DOUT_OSC1 => voiceSamples(0)(1),
    DOUT_OSC2 => voiceSamples(0)(2),
    DOUT_OSC3 => voiceSamples(0)(3),
    DOUTVALID=> voicevalid,

    WSAMPLE => wave_wsample_i,
    WEN => wave_wen_i,
    WADDR => wave_waddr_i

  );
DB_OUT <= voicevalid;
dsp_cdc : process(SYSCLK)

begin
    if rising_edge(SYSCLK)then

            dspdinvalid_r <= DSP_DINVALID;
            dspdinvalid_rr <= dspdinvalid_r;
            datarcvd_r <= datarcvd_i;
            dspdin_r <= DSP_DIN;
            dspdin_rr <= dspdin_r;
            
            -- input data
            if(dspdinvalid_rr = '1' and dspdinvalid_r = '1')then
                dspdin_i <= DSP_DIN;
                dspdinvalid_i <= '1';
            else
                dspdinvalid_i <= '0';

            end if;


            if(datarcvd_i = '1' and datarcvd_r = '0')then
                dspoutwren_i <= '0';
                
            elsif((dspdoutvalid_i = '1' or dspdloaded_i = '1') and dspoutwren_i = '0')then 
                dspoutwren_i <= '1';
                dspdout_i <= dspdataout_i;
            elsif(dspdoutvalid_i = '1')then
                dspdloaded_i <= '1';
            end if;


    end if;
end process;

--mixer_mult: AUD_DSP_MULT
--    port map (
--        dout => mix_mult_dout,
--        a => mix_mult_dina,
--        b => mix_mult_dinb,
--        clk => SYSCLK,
--        ce => '1',
--        reset => '1'
--    );

dsp_mult_0 : process(SYSCLK)
begin
    if rising_edge(SYSCLK)then
            dsp_mult_dout <= dsp_mult_dina * dsp_mult_dinb;
    end if;

end process;

dsp_processor : process(SYSCLK)

begin
    if rising_edge(SYSCLK)then
        if(SYS_RSTN = '0')then
--            dspdinvalid_l <= '0';
--            dspdoutvalid_i <= '0';
            wave_wen_i <= '0';
            dsp_sm <= IDLE;
            wavewren_r <= '0';
            wave_addrcnt_i <= (others=>'0');
            mix_cnt <= 0;
            mixosc_cnt <= 0;
        else
           dspdinvalid_l <= dspdinvalid_i;
            --wave_wen_i <= '0';
            wavewren_r <= WAVEWR_EN;
            CASE dsp_sm is
                WHEN IDLE => 
                    dsp_sm <= GETSAMPLE;
                    wave_wen_i <= '0';
                    wave_waddr_i <= (others=>'0');
                    wave_addrcnt_i<= (others=>'0');
                    req_sample_i <= '0';
                    dspdoutvalid_i <= '0';
                    dspdataout_i<= (others=>'0');
                    mix_cnt <= 0;
                    mixosc_cnt <= 0;
                WHEN GETSAMPLE =>
                    mix_cnt <= 0;
                    mixosc_cnt <= 0;

                    if(dspdinvalid_i = '1' and dspdinvalid_l = '0')then
                        --dspdac_sample <= unsigned(dspdin_i);
                                 dspdac_sample <=  dspdin_i(0)
                                                 & dspdin_i(1)
                                                 & dspdin_i(2)
                                                 & dspdin_i(3)
                                                 & dspdin_i(4)
                                                 & dspdin_i(5)
                                                 & dspdin_i(6)
                                                 & dspdin_i(7)
                                                 & dspdin_i(8)
                                                 & dspdin_i(9)
                                                 & dspdin_i(10)
                                                 & dspdin_i(11)
                                                 & dspdin_i(12)
                                                 & dspdin_i(13)
                                                 & dspdin_i(14)
                                                 & dspdin_i(15)
                                                 & dspdin_i(16)
                                                 & dspdin_i(17)
                                                 & dspdin_i(18)
                                                 & dspdin_i(19)
                                                 & dspdin_i(20)
                                                 & dspdin_i(21)
                                                 & dspdin_i(22)
                                                 & dspdin_i(23)
                                                 & dspdin_i(24)
                                                 & dspdin_i(25)
                                                 & dspdin_i(26)
                                                 & dspdin_i(27)
                                                 & dspdin_i(28)
                                                 & dspdin_i(29)
                                                 & dspdin_i(30)
                                                 & dspdin_i(31)
                                                 & dspdin_i(32)
                                                 & dspdin_i(33)
                                                 & dspdin_i(34)
                                                 & dspdin_i(35)
                                                 & dspdin_i(36)
                                                 & dspdin_i(37)
                                                 & dspdin_i(38)
                                                 & dspdin_i(39)
                                                 & dspdin_i(40)
                                                 & dspdin_i(41)
                                                 & dspdin_i(42)
                                                 & dspdin_i(43)
                                                 & dspdin_i(44)
                                                 & dspdin_i(45)
                                                 & dspdin_i(46)
                                                 & dspdin_i(47);





                        --sdspdataout_i<= dspdin_i;
                        dsp_sm <= PROCSAMPLES;
                    else
                        dspdoutvalid_i <= '0';
                    end if;
                    wave_waddr_i <= (others=>'0');
                    wave_addrcnt_i <= (others=>'0');
                    wave_wen_i <= '0';
                    req_sample_i <= '0';





                WHEN PROCSAMPLES =>
                    wave_wen_i <= '0';
                    wave_addrcnt_i <= (others=>'0');
                    if(DSP_MODE = DSP_MODE_SYNTH)then
                        dsp_sm <= GETWAVEFORMS;
                    elsif(DSP_MODE = DSP_MODE_LOADWAVE)then
                        dsp_sm <= WRITEWAVEFORMS;
                    else
                        dsp_sm <= MIXSAMPLES;
                    end if;
                    req_sample_i <= '0';
                WHEN GETWAVEFORMS =>
                    wave_wen_i <= '0';


                        req_sample_i <= '1';
                        if(voicevalid = '1')then
                                --dspdac_sample <=   voiceSamples & voiceSamples; 
                            dsp_sm <= MIXOSCS;
--                        elsif(DSP_MODE /= DSP_MODE_SYNTH)then
--                            dsp_sm <= GETSAMPLE;
                        end if;
                WHEN WRITEWAVEFORMS =>
                    req_sample_i <= '0';
                    if(DSP_MODE /= DSP_MODE_LOADWAVE)then
                        dsp_sm <= GETSAMPLE;
                        wave_wen_i <= '0';  
                    elsif(wavewren_r = '0' and WAVEWR_EN = '1')then
                        if(wave_addrcnt_i < 1023)then

                            wave_waddr_i <= STD_LOGIC_VECTOR(to_unsigned(WAVEWR_WAVESEL,2)) & std_logic_vector(wave_addrcnt_i(9 downto 0));
                            wave_wen_i <= '1';
                            wave_addrcnt_i <= wave_addrcnt_i+ 1;
                            wave_wsample_i <= WAVEWR_DATA;--std_logic_vector(wave_addrcnt_i) & std_logic_vector(wave_addrcnt_i);
                        else
                            wave_wen_i <= '1';
                            wave_waddr_i <= STD_LOGIC_VECTOR(to_unsigned(WAVEWR_WAVESEL,2)) & std_logic_vector(wave_addrcnt_i(9 downto 0));
                            wave_wsample_i <= WAVEWR_DATA;
                        end if;                        
                    end if;
                WHEN MIXOSCS =>
                    if(mixosc_cnt = 0)then
                            dsp_mult_dina <=  signed(Osc0Vol);
                            dsp_mult_dinb <= voiceSamples(0)(0);
                    elsif(mixosc_cnt = 1)then
                            dsp_mult_dina <=  signed(Osc1Vol);
                            dsp_mult_dinb <= voiceSamples(0)(1);
                    elsif(mixosc_cnt = 2)then
                            dsp_mult_dina <=  signed(Osc2Vol);
                            dsp_mult_dinb <= voiceSamples(0)(2);
                        mixedVoices(0)(0) <= dsp_mult_dout(47) & dsp_mult_dout(47) & signed(dsp_mult_dout(47 downto 26));
                    elsif(mixosc_cnt = 3)then
                        mixedVoices(0)(1) <=  dsp_mult_dout(47) & dsp_mult_dout(47) & signed(dsp_mult_dout(47 downto 26));

                    elsif(mixosc_cnt = 4)then
                        mixedVoices(0)(2) <= dsp_mult_dout(47) & dsp_mult_dout(47) & signed(dsp_mult_dout(47 downto 26));

                    else
                        dspdac_sample(47 downto 24) <= mixedVoices(0)(0) + mixedVoices(0)(1) + mixedVoices(0)(2);
                        dspdac_sample(23 downto 0) <= mixedVoices(0)(0) + mixedVoices(0)(1) + mixedVoices(0)(2);

                    end if;
                    if(mixosc_cnt < 5) then
                        mixosc_cnt <= mixosc_cnt + 1;
                    else
                        mixosc_cnt <= 0;
                        dsp_sm <= MIXSAMPLES;
                    end if;

                WHEN MIXSAMPLES =>
                    
                       
                    req_sample_i <= '0';
                    if(DSP_CTL(2) = '1')then
--                        dspdac_sample(23 downto 0) <= unsigned(LVOL) * unsigned(dspdac_sample(23 downto 0));
--                        dspdac_sample(23 downto 0) <= unsigned(RVOL) * unsigned(dspdac_sample(47 downto 24));
                        if(mix_cnt = 0)then
                            dsp_mult_dina <= signed(LVOL);
                            dsp_mult_dinb <= dspdac_sample(23 downto 0);
                           --ix_mult_dina <= LVOL;))(47 downto 24)
                            --mix_mult_dout <=  std_logic_vector(signed(LVOL) * dspdac_sample(23 downto 0));
                            --dspdac_sample(23 downto 0) <= unsigned((unsigned(RVOL) * dspdac_sample(47 downto 24)))(47 downto 24);
                            --mix_mult_dinb <= std_logic_vector(dspdac_sample(23 downto 0));
                       elsif(mix_cnt = 1)then
                            dsp_mult_dina <= signed(RVOL);
                            dsp_mult_dinb <= dspdac_sample(47 downto 24);
                            --mix_mult_dout <= std_logic_vector(signed(RVOL) * dspdac_sample(47 downto 24));
--                            mix_mult_dina <=RVOL;
--                            mix_mult_dinb <= std_logic_vector(dspdac_sample(47 downto 24));
                     elsif(mix_cnt = 2)then
                            dspdac_sample(23 downto 0) <= dsp_mult_dout(47 downto 24);

--                            mix_mult_dina <= (others=>'0');
--                            mix_mult_dinb <= (others=>'0');
                        elsif(mix_cnt = 3)then
                            dspdac_sample(47 downto 24) <= signed(dsp_mult_dout(47 downto 24));

--                            mix_mult_dina <= (others=>'0');
--                            mix_mult_dinb <= (others=>'0');
--                            unsigned(mix_mult_dout(47 downto 24));

--                        elsif(mix_cnt = 4)then
--                            dspdac_sample(47 downto 24) <= unsigned(mix_mult_dout(47 downto 24));

--                        elsif(mix_cnt = 5)then
--                            mix_mult_dina <= (others=>'0');
--                            mix_mult_dinb <= (others=>'0');
                        end if;

                        if(mix_cnt < 3)then
                           mix_cnt <= mix_cnt + 1;
                        else
                            
                            dsp_sm <= SENDSAMPLES;
                            mix_cnt <= 0;
                        end if;
                    else
                        dsp_sm <= SENDSAMPLES;
                    end if;

                WHEN SENDSAMPLES =>
                   -- <= std_logic_vector(dspdac_sample);
                    dspdoutvalid_i <= '1';
                    dsp_sm <= GETSAMPLE;
                    req_sample_i <= '0';
                    wave_addrcnt_i <= (others=>'0');
                    wave_wen_i <= '0';

                                 dspdataout_i <=   dspdac_sample(0)
                                                 & dspdac_sample(1)
                                                 & dspdac_sample(2)
                                                 & dspdac_sample(3)
                                                 & dspdac_sample(4)
                                                 & dspdac_sample(5)
                                                 & dspdac_sample(6)
                                                 & dspdac_sample(7)
                                                 & dspdac_sample(8)
                                                 & dspdac_sample(9)
                                                 & dspdac_sample(10)
                                                 & dspdac_sample(11)
                                                 & dspdac_sample(12)
                                                 & dspdac_sample(13)
                                                 & dspdac_sample(14)
                                                 & dspdac_sample(15)
                                                 & dspdac_sample(16)
                                                 & dspdac_sample(17)
                                                 & dspdac_sample(18)
                                                 & dspdac_sample(19)
                                                 & dspdac_sample(20)
                                                 & dspdac_sample(21)
                                                 & dspdac_sample(22)
                                                 & dspdac_sample(23)
                                                 & dspdac_sample(24)
                                                 & dspdac_sample(25)
                                                 & dspdac_sample(26)
                                                 & dspdac_sample(27)
                                                 & dspdac_sample(28)
                                                 & dspdac_sample(29)
                                                 & dspdac_sample(30)
                                                 & dspdac_sample(31)
                                                 & dspdac_sample(32)
                                                 & dspdac_sample(33)
                                                 & dspdac_sample(34)
                                                 & dspdac_sample(35)
                                                 & dspdac_sample(36)
                                                 & dspdac_sample(37)
                                                 & dspdac_sample(38)
                                                 & dspdac_sample(39)
                                                 & dspdac_sample(40)
                                                 & dspdac_sample(41)
                                                 & dspdac_sample(42)
                                                 & dspdac_sample(43)
                                                 & dspdac_sample(44)
                                                 & dspdac_sample(45)
                                                 & dspdac_sample(46)
                                                 & dspdac_sample(47);
                

                WHEN others =>
                    dsp_sm <= GETSAMPLE;
                    wave_addrcnt_i <= (others=>'0');
                    req_sample_i <= '0';
                    dspdoutvalid_i <= '0';
                    dspdataout_i<= (others=>'0');
                    wave_wen_i <= '0';
            END CASE;
--            wavewren_r <= WAVEWR_EN;
--            CASE dsp_sm is
--                WHEN IDLE => 
--                    dsp_sm <= GETSAMPLE;
--                    dspdoutvalid_i <= '0';
--                    wave_wen_i <= '0';
--                    dsp_sm <= IDLE;
--                    WAVEWR_RDY <= '0';
--                    wave_addrcnt_i <= 0;
--                    wave_wsample_i <= (others=>'0');
                    --wavewren_r <= '0';
--                WHEN GETSAMPLE =>
--                    if(dspdinvalid_i = '1' and dspdinvalid_l = '0')then
--                        dspdac_sample <= dspdin_i;
--                        dsp_sm <= SENDSAMPLES;
--                        if(DSP_MODE = DSP_MODE_SYNTH)then
--                            if(VOICE_GATE /= x"0000")then
--                                dsp_sm <= GETWAVEFORMS;
--                            else
--                                dspdac_sample <= x"000000000000";
--                            end if;
--                        elsif(DSP_MODE = DSP_MODE_LOADWAVE)then
--                            dsp_sm <= WRITEWAVEFORMS;
--                            wave_addrcnt_i <= 0;
--                        else --DSP_MODE_PASS is default
--                            dsp_sm <= SENDSAMPLES;
--                            dspdac_sample <= dspdin_i;
--                        end if;
--                    end if;
--                    dspdoutvalid_i <= '0';
--                    WAVEWR_RDY <= '0';
--                    wave_wen_i <= '0';
--                    req_sample_r <= '0';
--                WHEN GETWAVEFORMS =>
--                    WAVEWR_RDY <= '0';
--                    wave_wen_i <= '0';
--                    if(req_sample_i = '0' and req_sample_r = '0')then
--                        req_sample_i <= '1';
--                        req_sample_r <= '1';
--                    else
--                        req_sample_i <= '0';
--                        if(voicevalid = '1')then
--                            for i in 0 to 23 loop
--                                dspdac_sample(24+i) <= voice0Samples(0)(23-i);
--                                dspdac_sample(i) <= voice0Samples(0)(23-i);
--                            end loop;
--                            dsp_sm <= SENDSAMPLES;
--                        end if;
--                    end if;
--                    dsp_sm <= SENDSAMPLES;
--                WHEN WRITEWAVEFORMS =>
                   
--                    if(wavewren_r = '0' and WAVEWR_EN = '1')then
                       -- wave_wsample_i <= WAVEWR_DATA;
--                        if(wave_addrcnt_i < 1024)then
--                            wave_wsample_i <= WAVEWR_DATA;
                           --wave_wsample_i <= std_logic_vector(unsigned(wave_wsample_i) +1);
--                            wave_wen_i <= '1';
--                            wave_waddr_i <= wave_addrcnt_i + WAVEWR_WAVESEL*1024;
                           -- wave_addrcnt_i <= wave_addrcnt_i + 1;
--                        end if;
--                       WAVEWR_RDY <= '1';
--                    else
--                        if(DSP_MODE /= DSP_MODE_LOADWAVE)then
--                           WAVEWR_RDY <= '0';
--                           dsp_sm <= GETSAMPLE;
--                        elsif(wave_addrcnt_i = 1024)then
--                            WAVEWR_RDY <= '0';
--                        else
--                            WAVEWR_RDY <= '1';
--                        end if;
--                        wave_wen_i <= '0';
--                    end if;
--                WHEN SENDSAMPLES =>
--                    dspdataout_i<= dspdac_sample;
--                    dspdoutvalid_i <= '1';
--                    dsp_sm <= GETSAMPLE;
--                    WAVEWR_RDY <= '0';
--                    wave_wen_i <= '0';
--                WHEN others =>
--                    dspdoutvalid_i <= '0';
--                    wave_wen_i <= '0';
--                    dsp_sm <= IDLE;
--                    WAVEWR_RDY <= '0';
--            END CASE;
        end if;
    end if;
end process;


dsp2dac_cdc : process(BCK)

begin
    if rising_edge(BCK)then
        if(I2S_RESETN = '0')then
            DSP_DOUTVALID <= '0';
            datarcvd_i <= '0';
            dacdataloaded<= '0';
            buffwrptr <= 0;
            buffrdptr <= 0;
            
        else
            dspoutwren_r <= dspoutwren_i;

            if(dspoutwren_i = '1' and dspoutwren_r = '1' and datarcvd_i = '0')then
                buff(buffwrptr) <=  dspdout_i;
                datarcvd_i <= '1';
                if(buffwrptr<3)then
                    buffwrptr <= buffwrptr + 1;
                else
                    buffwrptr <= 0;
                end if;
                dacdataloaded <= '1';
            else
                datarcvd_i <= '0';
            end if;


            if(DAC_DIN_RDY = '1' and dacdataloaded = '1')then
                dspdout_r<= dspdout_i;
                DSP_DOUT <= dspdout_i;
                DSP_DOUTVALID <= '1';
                if(buffrdptr<3)then
                    buffrdptr <= buffrdptr + 1;
                else
                    buffrdptr <= 0;
                end if;
            else
                datarcvd_i <= '0';
                DSP_DOUTVALID <= '0';

            end if;

        end if;

    end if;
end process;

end Behavioral;

