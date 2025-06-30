--###############################
--# Project Name : FPiGA_CoreLib
--# File         : fpigai2creg.vhd
--# Project      : Radical Computer Technologies FPiGA Core Lib
--# Engineer     : Joseph Vincent
--# Version      : 1.0.0
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.FPiGA_Audio_Pkg.all;
entity FPiGA_I2C_REGBANK is
	generic(
		ID_REGISTER : std_logic_vector(7 downto 0) := x"00";
         NCORES : integer range 0 to 4 := 0
	);
	port(
        RSTN : in std_logic;
	    --
		address		: in	std_logic_vector(7 downto 0);
		clock		: in	std_logic;
		data		: in	std_logic_vector(7 downto 0);
		wren		: in	std_logic;
		dataout		: out	std_logic_vector(7 downto 0);
        rden        : in std_logic;
        --General Control Registers
        SOFT_RST   : out std_logic_vector(7 downto 0);
        SOFT_EN  : out std_logic_vector(7 downto 0);
        CONFREG0 : out std_logic_vector(7 downto 0);
        CONFREG1 : out std_logic_vector(7 downto 0);
        --WaveTable Registers
        FREQ : out PhaseArr; -- Phase Increment
    OscWave : out OscWaves;
    Osc0Vol : out std_logic_vector(23 downto 0);
    Osc1Vol : out std_logic_vector(23 downto 0);
    Osc2Vol : out std_logic_vector(23 downto 0);
    Osc3Vol : out std_logic_vector(23 downto 0);
        VOICE_GATE : out std_logic_vector(15 downto 0);
        WAVEWR_EN : out std_logic;
        WAVEWR_WAVESEL : out integer range 0 to 3;
        WAVEWR_DATA : out std_logic_vector(23 downto 0);
        WAVEWR_RDY : in std_logic;
        DSP_CTL : out std_logic_vector(7 downto 0);
        LVOL    : out std_logic_vector(23 downto 0);
        RVOL    : out std_logic_vector(23 downto 0)


	);
end FPiGA_I2C_REGBANK;

architecture rtl of FPiGA_I2C_REGBANK is
    --I2C Registers
	signal dev_id_reg : std_logic_vector(7 downto 0) := ID_REGISTER; -- READ ONLY - DEVICE ID REGISTER
	signal ctrl_reg0 : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE RESET REGISTER  
	signal ctrl_reg1 : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal conf_reg0 : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal conf_reg1 : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal freq0_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal freq1_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal freq2_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal freq3_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal oscwav_reg : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal voicegate_reg : std_logic_vector(15 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal wavewrctl_reg : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal dspstat_reg : std_logic_vector(7 downto 0) := (others=>'0'); --  READ ONLY - SOFTWARE GENERAL ENABLE REGISTER
	signal wavedata_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal dspctl_reg  : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal mixlvol_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal mixrvol_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal osc0vol_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal osc1vol_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal osc2vol_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER
	signal osc3vol_reg : std_logic_vector(23 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER






begin
 
	RAM : process(clock)
	begin
		if rising_edge(clock) then
--            if(RSTN = '0')then
 --           Output register data
--                ctrl_reg0      <=  (others=>'0'); 
--                ctrl_reg1        <=  (others=>'0'); 
--                conf_reg0        <=  (others=>'0'); 
--                conf_reg1        <=  (others=>'0'); 
--                freq0_reg   <=  (others=>'0'); 
--                freq1_reg         <=  (others=>'0'); 
--                freq2_reg          <=  (others=>'0'); 
--                freq3_reg   <=  (others=>'0'); 
--                oscwav_reg   <=  (others=>'0'); 
--                voicegate_reg         <=  (others=>'0'); 
--                wavewrctl_reg     <=  (others=>'0'); 
--                wavedata_reg       <=  (others=>'0'); 

			if (wren = '0') then
			    if(unsigned(address) = 0 )then
				    dataout <= dev_id_reg;
				elsif(unsigned(address) = 1)then
				    dataout <= ctrl_reg0;
				elsif(unsigned(address) = 2)then
				    dataout <= ctrl_reg1;
                elsif(unsigned(address) = 3)then
                    dataout <= conf_reg0;
                elsif(unsigned(address) = 4)then
                    dataout <= conf_reg1;
                elsif(unsigned(address) = 5)then
                    dataout <= freq0_reg(7 downto 0);
                elsif(unsigned(address) = 6)then
                    dataout <= freq0_reg(15 downto 8);
                elsif(unsigned(address) = 7)then
                    dataout <= freq0_reg(23 downto 16);
                elsif(unsigned(address) = 8)then
                    dataout <= freq1_reg(7 downto 0);
                elsif(unsigned(address) = 9)then
                    dataout <= freq1_reg(15 downto 8);
                elsif(unsigned(address) = 10)then
                    dataout <= freq1_reg(23 downto 16);
                elsif(unsigned(address) = 11)then
                    dataout <= freq2_reg(7 downto 0);
                elsif(unsigned(address) = 12)then
                    dataout <= freq2_reg(15 downto 8);
                elsif(unsigned(address) = 13)then
                    dataout <= freq2_reg(23 downto 16);
                elsif(unsigned(address) = 14)then
                    dataout <= freq3_reg(7 downto 0);
                elsif(unsigned(address) = 15)then
                    dataout <= freq3_reg(15 downto 8);
                elsif(unsigned(address) = 16)then
                    dataout <= freq3_reg(23 downto 16);
                elsif(unsigned(address) = 17)then
                    dataout <= oscwav_reg;
                elsif(unsigned(address) = 18)then
                    dataout <= voicegate_reg(7 downto 0); 
                elsif(unsigned(address) = 19)then
                    dataout <= voicegate_reg(15 downto 8);
                elsif(unsigned(address) = 20)then
                    dataout <= dspstat_reg;
                elsif(unsigned(address) = 24)then
                    dataout <= dspctl_reg;
                elsif(unsigned(address) = 25)then
                    dataout <= mixlvol_reg(7 downto 0);
                elsif(unsigned(address) = 26)then
                    dataout <= mixlvol_reg(15 downto 8);
                elsif(unsigned(address) = 27)then
                    dataout <= mixlvol_reg(23 downto 16);
                elsif(unsigned(address) = 28)then
                    dataout <= mixrvol_reg(7 downto 0);
                elsif(unsigned(address) = 29)then
                    dataout <= mixrvol_reg(15 downto 8);
                elsif(unsigned(address) = 30)then
                    dataout <= mixrvol_reg(23 downto 16);
                elsif(unsigned(address) = 31)then
                    dataout <= osc0vol_reg(7 downto 0);
                elsif(unsigned(address) = 32)then
                    dataout <= osc0vol_reg(15 downto 8);
                elsif(unsigned(address) = 33)then
                    dataout <= osc0vol_reg(23 downto 16);
                elsif(unsigned(address) = 34)then
                    dataout <= osc1vol_reg(7 downto 0);
                elsif(unsigned(address) = 35)then
                    dataout <= osc1vol_reg(15 downto 8);
                elsif(unsigned(address) = 36)then
                    dataout <= osc1vol_reg(23 downto 16);
                elsif(unsigned(address) = 37)then
                    dataout <= osc2vol_reg(7 downto 0);
                elsif(unsigned(address) = 38)then
                    dataout <= osc2vol_reg(15 downto 8);
                elsif(unsigned(address) = 39)then
                    dataout <= osc2vol_reg(23 downto 16);
                elsif(unsigned(address) = 40)then
                    dataout <= osc3vol_reg(7 downto 0);
                elsif(unsigned(address) = 41)then
                    dataout <= osc3vol_reg(15 downto 8);
                elsif(unsigned(address) = 42)then
                    dataout <= osc3vol_reg(23 downto 16);




				else
				    dataout <= (others=>'0');
                    ctrl_reg0 <= ctrl_reg0;
                    ctrl_reg1     <=    ctrl_reg1 ;    
                    conf_reg0     <=    conf_reg0;  
                    conf_reg1     <=    conf_reg1 ;
                    freq0_reg     <=    freq0_reg ; 
                    freq1_reg     <=    freq1_reg;    
                    freq2_reg     <=    freq2_reg;   
                    freq3_reg     <=    freq3_reg;    
                    oscwav_reg    <=    oscwav_reg ;  
                    voicegate_reg <=    voicegate_reg;
                    wavewrctl_reg <=    wavewrctl_reg;
                    wavedata_reg  <=    wavedata_reg ;  
				end if;
            --Register write cases
            -- BASE CTRL REGISTER WRITES
			elsif(unsigned(address) = 1)then
				ctrl_reg0 <= data;
				dataout <= data;  -- ????
			elsif(unsigned(address) = 2)then
				ctrl_reg1 <= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 3)then
                conf_reg0 <= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 4)then
                conf_reg1 <= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 5)then
                freq0_reg(7 downto 0)<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 6)then
                freq0_reg(15 downto 8)<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 7)then
                freq0_reg(23 downto 16)<= data;
				dataout <= data;  -- ????
                FREQ(0) <= unsigned(data & freq0_reg(15 downto 0));
            elsif(unsigned(address) = 8)then
                freq1_reg(7 downto 0)<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 9)then
                freq1_reg(15 downto 8)<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 10)then
                freq1_reg(23 downto 16)<= data;
				dataout <= data;  -- ????
                FREQ(1) <= unsigned(data & freq1_reg(15 downto 0));
            elsif(unsigned(address) = 11)then
                freq2_reg(7 downto 0)<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 12)then
                freq2_reg(15 downto 8)<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 13)then
                freq2_reg(23 downto 16)<= data;
				dataout <= data;  -- ????
                FREQ(2) <= unsigned(data & freq2_reg(15 downto 0));
            elsif(unsigned(address) = 14)then
                freq3_reg(7 downto 0)<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 15)then
                freq3_reg(15 downto 8)<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 16)then
                freq3_reg(23 downto 16)<= data;
				dataout <= data;  -- ????
                FREQ(3) <= unsigned(data & freq3_reg(15 downto 0));

            elsif(unsigned(address) = 17)then
                oscwav_reg<= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 18)then
                voicegate_reg(7 downto 0) <= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 19)then
                voicegate_reg(15 downto 8) <= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 20)then
                wavewrctl_reg <= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 21)then
                wavedata_reg(7 downto 0) <= data;
				dataout <= data;  -- ????
            elsif(unsigned(address) = 22)then
                wavedata_reg(15 downto 8) <= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 23)then
                wavedata_reg(23 downto 16) <= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 24)then
                dspctl_reg<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 25)then
                mixlvol_reg(7 downto 0)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 26)then
                mixlvol_reg(15 downto 8)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 27)then
                mixlvol_reg(23 downto 16)<= data;
				dataout <= data;  -- ???? 
                LVOL <= data &  mixlvol_reg(15 downto 0);
            elsif(unsigned(address) = 28)then
                mixrvol_reg(7 downto 0)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 29)then
                mixrvol_reg(15 downto 8)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 30)then
                mixrvol_reg(23 downto 16)<= data;
				dataout <= data;  -- ???? 
                RVOL <= data &  mixrvol_reg(15 downto 0);
            elsif(unsigned(address) = 31)then
                osc0vol_reg(7 downto 0)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 32)then
                osc0vol_reg(15 downto 8)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 33)then
                osc0vol_reg(23 downto 16)<= data;
				dataout <= data;  -- ???? 
               Osc0Vol <= data & osc0vol_reg(15 downto 0);
            elsif(unsigned(address) = 34)then
                osc1vol_reg(7 downto 0)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 35)then
                osc1vol_reg(15 downto 8)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 36)then
                osc1vol_reg(23 downto 16)<= data;
				dataout <= data;  -- ???? 
                Osc1Vol <= data & osc1vol_reg(15 downto 0);

            elsif(unsigned(address) = 37)then
                osc2vol_reg(7 downto 0)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 38)then
                osc2vol_reg(15 downto 8)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 39)then
                osc2vol_reg(23 downto 16)<= data;
				dataout <= data;  -- ???? 
                 Osc2Vol <= data & osc2vol_reg(15 downto 0);

            elsif(unsigned(address) = 40)then
                osc3vol_reg(7 downto 0)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 41)then
                osc3vol_reg(15 downto 8)<= data;
				dataout <= data;  -- ???? 
            elsif(unsigned(address) = 42)then
                osc3vol_reg(23 downto 16)<= data;
				dataout <= data;  -- ???? 
                Osc3Vol <= data & osc3vol_reg(15 downto 0);



            else
		      ctrl_reg0 <= ctrl_reg0;

		      dataout <= data;  -- ????


            ctrl_reg1     <=    ctrl_reg1 ;    
            conf_reg0     <=    conf_reg0;  
            conf_reg1     <=    conf_reg1 ;
            freq0_reg     <=    freq0_reg ; 
            freq1_reg     <=    freq1_reg;    
            freq2_reg     <=    freq2_reg;   
            freq3_reg     <=    freq3_reg;    
            oscwav_reg    <=    oscwav_reg ;  
            voicegate_reg <=    voicegate_reg;
            wavewrctl_reg <=    wavewrctl_reg;
            wavedata_reg  <=    wavedata_reg ;  
			end if;
		end if;
	end process RAM;
	REGISTER_OUTPUTS : process(clock)
        begin
		if rising_edge(clock) then
            SOFT_RST <= ctrl_reg0;
            -- I2S_EN <= ctrl_reg0(1);
            SOFT_EN <= ctrl_reg1;
            CONFREG0 <= conf_reg0; 
            CONFREG1 <= conf_reg1;
--            if(unsigned(address) = 33)then
--                OscWave.volume(0) <= signed(data & osc0vol_reg(15 downto 0));
--            elsif(unsigned(address) = 36) then
--                OscWave.volume(1) <= signed(data & osc1vol_reg(15 downto 0));
--            elsif(unsigned(address) = 39) then
--                OscWave.volume(2) <= signed(data & osc2vol_reg(15 downto 0));
--            elsif(unsigned(address) = 42) then
--                OscWave.volume(3) <= signed(data & osc3vol_reg(15 downto 0));
--            else
--                OscWave.volume(0) <= OscWave.volume(2);
--                OscWave.volume(1) <= OscWave.volume(3);
--                OscWave.volume(2) <= OscWave.volume(2);
--                OscWave.volume(3) <= OscWave.volume(3);
--            end if;
            OscWave(0) <= to_integer(unsigned(oscwav_reg(1 downto 0)));
            OscWave(1) <= to_integer(unsigned(oscwav_reg(3 downto 2)));
            OscWave(2) <= to_integer(unsigned(oscwav_reg(5 downto 4)));
            OscWave(3) <= to_integer(unsigned(oscwav_reg(7 downto 6)));
            dspstat_reg<= "00000" & WAVEWR_RDY  & "00";
            VOICE_GATE <= voicegate_reg;
            WAVEWR_EN <= wavewrctl_reg(0);
            WAVEWR_WAVESEL <= to_integer(unsigned(wavewrctl_reg(2 downto 1)));
            WAVEWR_DATA <= wavedata_reg;
            DSP_CTL <= dspctl_reg;
        end if;
    end process;

end rtl;