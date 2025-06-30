--
--Written by GowinSynthesis
--Tool Version "V1.9.11"
--Thu Mar 27 21:34:00 2025

--Source file index table:
--file0 "\/home/jvincent/gowin/IDE/bin/fpga_project/src/i2s_cdc_fifo/temp/FIFO/fifo_define.v"
--file1 "\/home/jvincent/gowin/IDE/bin/fpga_project/src/i2s_cdc_fifo/temp/FIFO/fifo_parameter.v"
--file2 "\/home/jvincent/gowin/IDE/ipcore/FIFO/data/edc.v"
--file3 "\/home/jvincent/gowin/IDE/ipcore/FIFO/data/fifo.v"
--file4 "\/home/jvincent/gowin/IDE/ipcore/FIFO/data/fifo_top.v"
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library gw5a;
use gw5a.components.all;

entity i2s_cdc_fifo is
port(
  Data :  in std_logic_vector(1 downto 0);
  WrClk :  in std_logic;
  RdClk :  in std_logic;
  WrEn :  in std_logic;
  RdEn :  in std_logic;
  Almost_Empty :  out std_logic;
  Almost_Full :  out std_logic;
  Q :  out std_logic_vector(1 downto 0);
  Empty :  out std_logic;
  Full :  out std_logic);
end i2s_cdc_fifo;
architecture beh of i2s_cdc_fifo is
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO31\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO30\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO29\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO28\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO27\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO26\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO25\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO24\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO23\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO22\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO21\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO20\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO19\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO18\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO17\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO16\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO15\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO14\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO13\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO12\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO11\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO10\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO9\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO8\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO7\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO6\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO5\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO4\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO3\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO2\ : std_logic ;
  signal fifo_inst_n12 : std_logic ;
  signal fifo_inst_n16 : std_logic ;
  signal fifo_inst_arempty_val : std_logic ;
  signal fifo_inst_n92 : std_logic ;
  signal fifo_inst_rempty_val : std_logic ;
  signal fifo_inst_wfull_val : std_logic ;
  signal fifo_inst_n91 : std_logic ;
  signal fifo_inst_arempty_val_5 : std_logic ;
  signal fifo_inst_arempty_val_6 : std_logic ;
  signal fifo_inst_wfull_val_7 : std_logic ;
  signal fifo_inst_wfull_val_8 : std_logic ;
  signal \fifo_inst_Equal.wbinnext_0\ : std_logic ;
  signal fifo_inst_rbin_num_next_0 : std_logic ;
  signal GND_0 : std_logic ;
  signal VCC_0 : std_logic ;
  signal \fifo_inst/rbin_num\ : std_logic_vector(0 downto 0);
  signal \fifo_inst/Equal.wq1_rptr\ : std_logic_vector(1 downto 0);
  signal \fifo_inst/Equal.wq2_rptr\ : std_logic_vector(1 downto 0);
  signal \fifo_inst/Equal.rq1_wptr\ : std_logic_vector(1 downto 0);
  signal \fifo_inst/Equal.rq2_wptr\ : std_logic_vector(1 downto 0);
  signal \fifo_inst/Equal.rptr\ : std_logic_vector(1 downto 0);
  signal \fifo_inst/Equal.wptr\ : std_logic_vector(1 downto 0);
  signal \fifo_inst/Equal.wbin\ : std_logic_vector(0 downto 0);
  signal \fifo_inst/Equal.wbinnext\ : std_logic_vector(1 downto 1);
  signal \fifo_inst/Equal.wgraynext\ : std_logic_vector(0 downto 0);
  signal \fifo_inst/rbin_num_next\ : std_logic_vector(1 downto 1);
  signal \fifo_inst/Equal.rgraynext\ : std_logic_vector(0 downto 0);
  signal NN : std_logic;
  signal NN_0 : std_logic;
begin
\fifo_inst/rbin_num_0_s0\: DFFRE
port map (
  Q => \fifo_inst/rbin_num\(0),
  D => fifo_inst_rbin_num_next_0,
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_1_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(1),
  D => \fifo_inst/Equal.rptr\(1),
  CLK => WrClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_0_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(0),
  D => \fifo_inst/Equal.rptr\(0),
  CLK => WrClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_1_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(1),
  D => \fifo_inst/Equal.wq1_rptr\(1),
  CLK => WrClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_0_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(0),
  D => \fifo_inst/Equal.wq1_rptr\(0),
  CLK => WrClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_1_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(1),
  D => \fifo_inst/Equal.wptr\(1),
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_0_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(0),
  D => \fifo_inst/Equal.wptr\(0),
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_1_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(1),
  D => \fifo_inst/Equal.rq1_wptr\(1),
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_0_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(0),
  D => \fifo_inst/Equal.rq1_wptr\(0),
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.rptr_1_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.rptr\(1),
  D => \fifo_inst/rbin_num_next\(1),
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.rptr_0_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.rptr\(0),
  D => \fifo_inst/Equal.rgraynext\(0),
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.wptr_1_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.wptr\(1),
  D => \fifo_inst/Equal.wbinnext\(1),
  CLK => WrClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.wptr_0_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.wptr\(0),
  D => \fifo_inst/Equal.wgraynext\(0),
  CLK => WrClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.wbin_0_s0\: DFFRE
port map (
  Q => \fifo_inst/Equal.wbin\(0),
  D => \fifo_inst_Equal.wbinnext_0\,
  CLK => WrClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Full_s0\: DFFRE
port map (
  Q => NN_0,
  D => fifo_inst_wfull_val,
  CLK => WrClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Almost_Empty_s0\: DFFRE
port map (
  Q => Almost_Empty,
  D => fifo_inst_arempty_val,
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Empty_s0\: DFFRE
port map (
  Q => NN,
  D => fifo_inst_rempty_val,
  CLK => RdClk,
  RESET => GND_0,
  CE => VCC_0);
\fifo_inst/Equal.mem_Equal.mem_0_0_s\: SDPB
generic map (
  BIT_WIDTH_0 => 2,
  BIT_WIDTH_1 => 2,
  READ_MODE => '0',
  RESET_MODE => "SYNC",
  BLK_SEL_0 => "000",
  BLK_SEL_1 => "000"
)
port map (
  DO(31) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO31\,
  DO(30) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO30\,
  DO(29) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO29\,
  DO(28) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO28\,
  DO(27) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO27\,
  DO(26) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO26\,
  DO(25) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO25\,
  DO(24) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO24\,
  DO(23) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO23\,
  DO(22) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO22\,
  DO(21) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO21\,
  DO(20) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO20\,
  DO(19) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO19\,
  DO(18) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO18\,
  DO(17) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO17\,
  DO(16) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO16\,
  DO(15) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO15\,
  DO(14) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO14\,
  DO(13) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO13\,
  DO(12) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO12\,
  DO(11) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO11\,
  DO(10) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO10\,
  DO(9) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO9\,
  DO(8) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO8\,
  DO(7) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO7\,
  DO(6) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO6\,
  DO(5) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO5\,
  DO(4) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO4\,
  DO(3) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO3\,
  DO(2) => \fifo_inst_Equal.mem_Equal.mem_0_0_0_DO2\,
  DO(1 downto 0) => Q(1 downto 0),
  CLKA => WrClk,
  CEA => fifo_inst_n12,
  CLKB => RdClk,
  CEB => fifo_inst_n16,
  OCE => GND_0,
  RESET => GND_0,
  ADA(13) => GND_0,
  ADA(12) => GND_0,
  ADA(11) => GND_0,
  ADA(10) => GND_0,
  ADA(9) => GND_0,
  ADA(8) => GND_0,
  ADA(7) => GND_0,
  ADA(6) => GND_0,
  ADA(5) => GND_0,
  ADA(4) => GND_0,
  ADA(3) => GND_0,
  ADA(2) => GND_0,
  ADA(1) => \fifo_inst/Equal.wbin\(0),
  ADA(0) => GND_0,
  ADB(13) => GND_0,
  ADB(12) => GND_0,
  ADB(11) => GND_0,
  ADB(10) => GND_0,
  ADB(9) => GND_0,
  ADB(8) => GND_0,
  ADB(7) => GND_0,
  ADB(6) => GND_0,
  ADB(5) => GND_0,
  ADB(4) => GND_0,
  ADB(3) => GND_0,
  ADB(2) => GND_0,
  ADB(1) => \fifo_inst/rbin_num\(0),
  ADB(0) => GND_0,
  DI(31) => GND_0,
  DI(30) => GND_0,
  DI(29) => GND_0,
  DI(28) => GND_0,
  DI(27) => GND_0,
  DI(26) => GND_0,
  DI(25) => GND_0,
  DI(24) => GND_0,
  DI(23) => GND_0,
  DI(22) => GND_0,
  DI(21) => GND_0,
  DI(20) => GND_0,
  DI(19) => GND_0,
  DI(18) => GND_0,
  DI(17) => GND_0,
  DI(16) => GND_0,
  DI(15) => GND_0,
  DI(14) => GND_0,
  DI(13) => GND_0,
  DI(12) => GND_0,
  DI(11) => GND_0,
  DI(10) => GND_0,
  DI(9) => GND_0,
  DI(8) => GND_0,
  DI(7) => GND_0,
  DI(6) => GND_0,
  DI(5) => GND_0,
  DI(4) => GND_0,
  DI(3) => GND_0,
  DI(2) => GND_0,
  DI(1 downto 0) => Data(1 downto 0),
  BLKSELA(2) => GND_0,
  BLKSELA(1) => GND_0,
  BLKSELA(0) => GND_0,
  BLKSELB(2) => GND_0,
  BLKSELB(1) => GND_0,
  BLKSELB(0) => GND_0);
\fifo_inst/Almost_Full_s1\: DFFSE
port map (
  Q => Almost_Full,
  D => fifo_inst_n91,
  CLK => WrClk,
  SET => fifo_inst_n92,
  CE => VCC_0);
\fifo_inst/n12_s1\: LUT2
generic map (
  INIT => X"4"
)
port map (
  F => fifo_inst_n12,
  I0 => NN_0,
  I1 => WrEn);
\fifo_inst/n16_s0\: LUT2
generic map (
  INIT => X"4"
)
port map (
  F => fifo_inst_n16,
  I0 => NN,
  I1 => RdEn);
\fifo_inst/arempty_val_s1\: LUT4
generic map (
  INIT => X"EAB3"
)
port map (
  F => fifo_inst_arempty_val,
  I0 => fifo_inst_arempty_val_5,
  I1 => fifo_inst_arempty_val_6,
  I2 => RdEn,
  I3 => \fifo_inst/rbin_num\(0));
\fifo_inst/n92_s0\: LUT2
generic map (
  INIT => X"4"
)
port map (
  F => fifo_inst_n92,
  I0 => fifo_inst_n91,
  I1 => WrEn);
\fifo_inst/rempty_val_s2\: LUT4
generic map (
  INIT => X"8061"
)
port map (
  F => fifo_inst_rempty_val,
  I0 => \fifo_inst/rbin_num\(0),
  I1 => fifo_inst_n16,
  I2 => fifo_inst_arempty_val_5,
  I3 => fifo_inst_arempty_val_6);
\fifo_inst/wfull_val_s2\: LUT4
generic map (
  INIT => X"0268"
)
port map (
  F => fifo_inst_wfull_val,
  I0 => fifo_inst_wfull_val_7,
  I1 => \fifo_inst/Equal.wbin\(0),
  I2 => fifo_inst_n12,
  I3 => fifo_inst_wfull_val_8);
\fifo_inst/n91_s2\: LUT4
generic map (
  INIT => X"E77E"
)
port map (
  F => fifo_inst_n91,
  I0 => \fifo_inst/Equal.wq2_rptr\(1),
  I1 => \fifo_inst/Equal.wptr\(1),
  I2 => \fifo_inst/Equal.wq2_rptr\(0),
  I3 => \fifo_inst/Equal.wbin\(0));
\fifo_inst/arempty_val_s2\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => fifo_inst_arempty_val_5,
  I0 => \fifo_inst/Equal.rq2_wptr\(0),
  I1 => \fifo_inst/Equal.rptr\(1));
\fifo_inst/arempty_val_s3\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => fifo_inst_arempty_val_6,
  I0 => \fifo_inst/Equal.rq2_wptr\(1),
  I1 => \fifo_inst/Equal.rptr\(1));
\fifo_inst/wfull_val_s3\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => fifo_inst_wfull_val_7,
  I0 => \fifo_inst/Equal.wq2_rptr\(1),
  I1 => \fifo_inst/Equal.wptr\(1));
\fifo_inst/wfull_val_s4\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => fifo_inst_wfull_val_8,
  I0 => \fifo_inst/Equal.wq2_rptr\(0),
  I1 => \fifo_inst/Equal.wptr\(1));
\fifo_inst/Equal.wbinnext_1_s3\: LUT4
generic map (
  INIT => X"DF20"
)
port map (
  F => \fifo_inst/Equal.wbinnext\(1),
  I0 => \fifo_inst/Equal.wbin\(0),
  I1 => NN_0,
  I2 => WrEn,
  I3 => \fifo_inst/Equal.wptr\(1));
\fifo_inst/Equal.wbinnext_0_s4\: LUT3
generic map (
  INIT => X"9A"
)
port map (
  F => \fifo_inst_Equal.wbinnext_0\,
  I0 => \fifo_inst/Equal.wbin\(0),
  I1 => NN_0,
  I2 => WrEn);
\fifo_inst/Equal.wgraynext_0_s1\: LUT4
generic map (
  INIT => X"45BA"
)
port map (
  F => \fifo_inst/Equal.wgraynext\(0),
  I0 => \fifo_inst/Equal.wbin\(0),
  I1 => NN_0,
  I2 => WrEn,
  I3 => \fifo_inst/Equal.wptr\(1));
\fifo_inst/rbin_num_next_1_s3\: LUT4
generic map (
  INIT => X"DF20"
)
port map (
  F => \fifo_inst/rbin_num_next\(1),
  I0 => \fifo_inst/rbin_num\(0),
  I1 => NN,
  I2 => RdEn,
  I3 => \fifo_inst/Equal.rptr\(1));
\fifo_inst/rbin_num_next_0_s4\: LUT3
generic map (
  INIT => X"9A"
)
port map (
  F => fifo_inst_rbin_num_next_0,
  I0 => \fifo_inst/rbin_num\(0),
  I1 => NN,
  I2 => RdEn);
\fifo_inst/Equal.rgraynext_0_s1\: LUT4
generic map (
  INIT => X"45BA"
)
port map (
  F => \fifo_inst/Equal.rgraynext\(0),
  I0 => \fifo_inst/rbin_num\(0),
  I1 => NN,
  I2 => RdEn,
  I3 => \fifo_inst/Equal.rptr\(1));
GND_s0: GND
port map (
  G => GND_0);
VCC_s0: VCC
port map (
  V => VCC_0);
GSR_0: GSR
port map (
  GSRI => VCC_0);
  Empty <= NN;
  Full <= NN_0;
end beh;
