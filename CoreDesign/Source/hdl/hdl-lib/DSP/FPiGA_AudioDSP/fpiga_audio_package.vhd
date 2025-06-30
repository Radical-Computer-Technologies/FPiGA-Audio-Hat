-- Declaration of a function in a package
--
-- function_package_1.vhd
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package FPiGA_Audio_Pkg is
type SampArr is array (0 to 3) of signed(23 downto 0); -- 4 oscillators per voice

type PhaseArr is array (0 to 3) of unsigned(23 downto 0); -- 4 oscillators per voice
type VoicePhase is array (0 to 15) of PhaseArr;
type VoiceSample is array (0 to 15) of SampArr;

type OscWaves is array (0 to 3) of integer range 0 to 3;
type WaveSel is array (0 to 15) of OscWaves;
--type conosc is array (0 to 15) of std_logic_vector(3 downto 0);
type OscVol is array (0 to 3)  of signed(23 downto 0);

  -- Outputs from the FIFO.
  type VOICES is record
    voice  : signed(23 downto 0);                -- FIFO Full Flag
    valid : std_logic;                -- FIFO Empty Flag
  end record VOICES;  

  type OscConf is record
    waveform  : OscWaves;                -- FIFO Full Flag
    volume : OscVol;                -- FIFO Empty Flag
  end record OscConf;  
--  type VOICE_CONFIG is record
--    phase  : VoicePhase;                -- FIFO Full Flag
--    waveIdx : WaveSel;
    --conf_osc : conosc;
--    enable : std_logic_vector(15 downto 0);
--  end record VOICE_CONFIG;  


end FPiGA_Audio_Pkg;

package body FPiGA_Audio_Pkg is




end FPiGA_Audio_Pkg;


