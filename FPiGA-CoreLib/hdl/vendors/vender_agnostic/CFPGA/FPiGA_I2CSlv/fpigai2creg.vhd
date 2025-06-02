--###############################
--# Project Name : FPiGA_CoreLib
--# File         : fpigai2creg.vhd
--# Project      : Radical Computer Technologies FPiGA Core Lib
--# Engineer     : Joseph Vincent (jvincent@radcomp.tech)
--# Version      : 1.0.0
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FPiGA_I2C_REGBANK is
	generic(
		ID_REGISTER : std_logic_vector(7 downto 0) := x"00";
        NCORES : integer range 0 to 4 := 0
	);
	port(
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
      --Debug Core
      DBG_DATA0 : in std_logic_vector(63 downto 0);
      DBG_DATA1 : in std_logic_vector(63 downto 0);
      DBG_DATA2 : in std_logic_vector(63 downto 0);
      DBG_DATA3 : in std_logic_vector(63 downto 0);
      
      DBG_RDY : out std_logic_vector(3 downto 0);
      DBG_ADDR : out std_logic_vector(3 downto 0);
      DBG_VALID : in std_logic(3 downto 0)
	);
end FPiGA_I2C_REGBANK;

architecture rtl of FPiGA_I2C_REGBANK is
   --I2C Registers
   signal dev_id_reg : std_logic_vector(7 downto 0) := ID_REGISTER; -- READ ONLY - DEVICE ID REGISTER
   signal ctrl_reg0 : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE RESET REGISTER  
   signal ctrl_reg1 : std_logic_vector(7 downto 0) := (others=>'0'); -- READ/WRITE - SOFTWARE GENERAL ENABLE REGISTER

   signal dbgdata_reg0  : std_logic_vector(63 downto 0) := (others=>'0');
   signal dbgdata_reg1  : std_logic_vector(63 downto 0) := (others=>'0');
   signal dbgdata_reg2  : std_logic_vector(63 downto 0) := (others=>'0');
   signal dbgdata_reg3  : std_logic_vector(63 downto 0) := (others=>'0');   
   signal dbg_ctl_reg0  : std_logic_vector(7 downto 0) := (others=>'0');--  READ/WRITE [7 downto 4] RSVD - [3 downto 0] - Trigger En 
   signal trig_conf_reg : std_logic_vector(7 downto 0) := (others=>'0'); --  READ/WRITE [7 downto 0] trigger condition
   signal trig_cond_conf  : std_logic_vector(31 downto 0) := (others=>'0'); --  READ/WRITE trigger conditional
   signal dbg_info_reg0 : std_logic_vector(7 downto 0)  := x"0" & std_logic_vector(to_unsigned(NCORES,4));   --  READ ONLY [7 downto 4] triggered - [3 downto 0] ncores    
   signal dbgrdy : std_logic_vector(3 downto 0) := (others=>'0');
   -- other signals
   signal trig_r : std_logic_vector(3 downto 0) := (others=>'0'); 
begin
    debugcore : process(clock)
    begin
        if rising_edge(clock)then
            trig_r <= dbg_ctl_reg0(3 downto 0);

            if(dbg_ctl_reg0(0) = '1' and trig_r(0) = '0')then
                dbgrdy(0) <= '1';
            elsif(DBG_VALID(0) = '1' and dbgrdy(0) = '1')then
                --set trigger valid indicator
                dbg_info_reg0(4) <= '1';
                dbgdata_reg0 <= DBG_DATA0;
                dbgrdy(0) <= '0';
            elsif(rden = '1' and unsigned(address) = 134)then
                dbgrdy(0) <= '1';
                --clear trigger valid indicator
                dbg_info_reg0(4) <= '0';
            end if;

            if(dbg_ctl_reg0(1) = '1' and trig_r(1)  = '0')then
                dbgrdy(1) <= '1';
            elsif(DBG_VALID(1) = '1' and dbgrdy(1) = '1')then
                --set trigger valid indicator
                dbg_info_reg0(5) <= '1';
                dbgdata_reg1 <= DBG_DATA1;
                dbgrdy(1) <= '0';
            elsif(rden = '1' and unsigned(address) = 142)then
                dbgrdy(1) <= '1';
                --clear trigger valid indicator
                dbg_info_reg0(5) <= '0';
            end if;

            if(dbg_ctl_reg0(2) = '1' and trig_r(2)  = '0')then
                dbgrdy(2) <= '1';
            elsif(DBG_VALID(2) = '1' and dbgrdy(2) = '1')then
                --set trigger valid indicator
                dbg_info_reg0(6) <= '1';
                dbgdata_reg2 <= DBG_DATA2;
                dbgrdy(2) <= '0';
            elsif(rden = '1' and unsigned(address) = 150)then
                dbgrdy(2) <= '1';
                --clear trigger valid indicator
                dbg_info_reg0(6) <= '0';
            end if;

            if(dbg_ctl_reg0(3) = '1' and trig_r(3)  = '0')then
                dbgrdy(3) <= '1';
            elsif(DBG_VALID(3) = '1' and dbgrdy(3) = '1')then
                --set trigger valid indicator
                dbg_info_reg0(7) <= '1';
                dbgdata_reg2 <= DBG_DATA2;
                dbgrdy(3) <= '0';
            elsif(rden = '1' and unsigned(address) = 158)then
                dbgrdy(3) <= '1';
                --clear trigger valid indicator
                dbg_info_reg0(7) <= '0';
            end if;
        end if;
    end process;

	RAM : process(clock)
	begin
      if rising_edge(clock)then
         --Read data
         if(wren = '0')then
            if(unsigned(adress) = 0)then
               dataout <= dev_id_reg;
            elsif(unsigned(address) = 1)then
               dataout <= ctrl_reg0;
            elsif(unsigned(address) = 2)then
               dataout <= ctrl_reg1;
            --DEBUG CORE DATA READS
            elsif(unsigned(address) = 127)then
               dataout <= dbgdata_reg0(7 downto 0);
            elsif(unsigned(address) = 128)then
               dataout <= dbgdata_reg0(15 downto 8);
            elsif(unsigned(address) = 129)then
               dataout <= dbgdata_reg0(23 downto 16);
            elsif(unsigned(address) = 130)then
               dataout <= dbgdata_reg0(31 downto 24);
            elsif(unsigned(address) = 131)then
               dataout <= dbgdata_reg0(39 downto 32);
            elsif(unsigned(address) = 132)then
               dataout <= dbgdata_reg0(47 downto 40);
            elsif(unsigned(address) = 133)then
               dataout <= dbgdata_reg0(55 downto 48);
            elsif(unsigned(address) = 134)then
               dataout <= dbgdata_reg0(63 downto 56);
            elsif(unsigned(address) = 135)then
               dataout <= dbgdata_reg1(7 downto 0);
            elsif(unsigned(address) = 136)then
               dataout <= dbgdata_reg1(15 downto 8);
            elsif(unsigned(address) = 137)then
               dataout <= dbgdata_reg1(23 downto 16);
            elsif(unsigned(address) = 138)then
               dataout <= dbgdata_reg1(31 downto 24);
            elsif(unsigned(address) = 139)then
               dataout <= dbgdata_reg1(39 downto 32);
            elsif(unsigned(address) = 140)then
               dataout <= dbgdata_reg1(47 downto 40);
            elsif(unsigned(address) = 141)then
               dataout <= dbgdata_reg1(55 downto 48);
            elsif(unsigned(address) = 142)then
               dataout <= dbgdata_reg1(63 downto 56);
            elsif(unsigned(address) = 143)then
               dataout <= dbgdata_reg2(7 downto 0);
            elsif(unsigned(address) = 144)then
               dataout <= dbgdata_reg2(15 downto 8);
            elsif(unsigned(address) = 145)then
               dataout <= dbgdata_reg2(23 downto 16);
            elsif(unsigned(address) = 146)then
               dataout <= dbgdata_reg2(31 downto 24);
            elsif(unsigned(address) = 147)then
               dataout <= dbgdata_reg2(39 downto 32);
            elsif(unsigned(address) = 148)then
               dataout <= dbgdata_reg2(47 downto 40);
            elsif(unsigned(address) = 149)then
               dataout <= dbgdata_reg2(55 downto 48);
            elsif(unsigned(address) = 150)then
               dataout <= dbgdata_reg2(63 downto 56);
            elsif(unsigned(address) = 151)then
               dataout <= dbgdata_reg3(7 downto 0);
            elsif(unsigned(address) = 152)then
               dataout <= dbgdata_reg3(15 downto 8);
            elsif(unsigned(address) = 153)then
               dataout <= dbgdata_reg3(23 downto 16);
            elsif(unsigned(address) = 154)then
               dataout <= dbgdata_reg3(31 downto 24);
            elsif(unsigned(address) = 155)then
               dataout <= dbgdata_reg3(39 downto 32);
            elsif(unsigned(address) = 156)then
               dataout <= dbgdata_reg3(47 downto 40);
            elsif(unsigned(address) = 157)then
               dataout <= dbgdata_reg3(55 downto 48);
            elsif(unsigned(address) = 158)then
               dataout <= dbgdata_reg3(63 downto 56);
            --DEBUG CORE CONF/CTL READS
            elsif(unsigned(address) = 159)then
               dataout <= dbg_ctl_reg0;
            elsif(unsigned(address) = 160)then
               dataout <= trig_conf_reg;
            elsif(unsigned(address) = 161)then
               dataout <= trig_cond_conf(7 downto 0);
            elsif(unsigned(address) = 162)then
               dataout <= trig_cond_conf(15 downto 8);
            elsif(unsigned(address) = 163)then
               dataout <= trig_cond_conf(23 downto 16);
            elsif(unsigned(address) = 164)then
               dataout <= trig_cond_conf(31 downto 24);
            elsif(unsigned(address) = 165)then
               dataout <= dbg_info_reg0;
            else
               dataout <= (others=>'0');
            end if;
         --Register write cases
         -- BASE CTRL REGISTER WRITES
			elsif(unsigned(address) = 1)then
				ctrl_reg0 <= data;
				dataout <= data;  -- ????
			elsif(unsigned(address) = 2)then
				ctrl_reg1 <= data;
				dataout <= data;  -- ????
         elsif(unsigned(address) = 159)then
           dbg_ctl_reg0 <= data;
            dataout <= data;  -- ????
         --DBG CORE REGISTER WRITES
         elsif(unsigned(address) = 160)then
            trig_conf_reg<= data;
			   dataout <= data;  -- ????
         elsif(unsigned(address) = 161)then
            trig_cond_conf(7 downto 0)<= data;
			   dataout <= data;  -- ????
         elsif(unsigned(address) = 162)then
             trig_cond_conf(15 downto 8)<= data;
			   dataout <= data;  -- ????
         elsif(unsigned(address) = 163)then
            trig_cond_conf(23 downto 16)<= data;
			   dataout <= data;  -- ????
         elsif(unsigned(address) = 164)then
           trig_cond_conf(31 downto 24)<= data;
			   dataout <= data;  -- ????
         else
            ctrl_reg0 <= ctrl_reg0;
            ctrl_reg1 <= ctrl_reg1;
            dataout <= data;
         end if;
		end if;
	end process RAM;
	
	SOFT_RST <= ctrl_reg0;
   SOFT_EN <= ctrl_reg1;
end rtl;