--
--Written by GowinSynthesis
--Tool Version "V1.9.11"
--Fri May 16 18:46:11 2025

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
  Data :  in std_logic_vector(47 downto 0);
  Reset :  in std_logic;
  WrClk :  in std_logic;
  RdClk :  in std_logic;
  WrEn :  in std_logic;
  RdEn :  in std_logic;
  Rnum :  out std_logic_vector(6 downto 0);
  Q :  out std_logic_vector(47 downto 0);
  Empty :  out std_logic;
  Full :  out std_logic);
end i2s_cdc_fifo;
architecture beh of i2s_cdc_fifo is
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO31\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO30\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO29\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO28\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO27\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO26\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO25\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO24\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO23\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO22\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO21\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO20\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO19\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO18\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO17\ : std_logic ;
  signal \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO16\ : std_logic ;
  signal fifo_inst_rcnt_sub_0 : std_logic ;
  signal fifo_inst_rcnt_sub_1 : std_logic ;
  signal fifo_inst_rcnt_sub_2 : std_logic ;
  signal fifo_inst_rcnt_sub_3 : std_logic ;
  signal fifo_inst_rcnt_sub_4 : std_logic ;
  signal fifo_inst_rcnt_sub_5 : std_logic ;
  signal fifo_inst_rcnt_sub_6 : std_logic ;
  signal fifo_inst_n245 : std_logic ;
  signal fifo_inst_n245_3 : std_logic ;
  signal fifo_inst_n246 : std_logic ;
  signal fifo_inst_n246_3 : std_logic ;
  signal fifo_inst_n247 : std_logic ;
  signal fifo_inst_n247_3 : std_logic ;
  signal fifo_inst_n248 : std_logic ;
  signal fifo_inst_n248_3 : std_logic ;
  signal fifo_inst_n249 : std_logic ;
  signal fifo_inst_n249_3 : std_logic ;
  signal fifo_inst_n250 : std_logic ;
  signal fifo_inst_n250_3 : std_logic ;
  signal fifo_inst_n25 : std_logic ;
  signal fifo_inst_n29 : std_logic ;
  signal fifo_inst_n260 : std_logic ;
  signal fifo_inst_wfull_val : std_logic ;
  signal \fifo_inst_Equal.rgraynext_5\ : std_logic ;
  signal \fifo_inst_Equal.wgraynext_2\ : std_logic ;
  signal \fifo_inst_Equal.wgraynext_4\ : std_logic ;
  signal fifo_inst_wfull_val_4 : std_logic ;
  signal fifo_inst_wfull_val_5 : std_logic ;
  signal fifo_inst_wfull_val_7 : std_logic ;
  signal \fifo_inst_Equal.wbinnext_6\ : std_logic ;
  signal fifo_inst_wfull_val_8 : std_logic ;
  signal fifo_inst_wfull_val_9 : std_logic ;
  signal fifo_inst_wfull_val_10 : std_logic ;
  signal fifo_inst_wfull_val_12 : std_logic ;
  signal \fifo_inst_Equal.wbinnext_4\ : std_logic ;
  signal \fifo_inst_Equal.rgraynext_2\ : std_logic ;
  signal fifo_inst_rbin_num_next_0 : std_logic ;
  signal \fifo_inst_Equal.wbinnext_0\ : std_logic ;
  signal fifo_inst_rempty_val : std_logic ;
  signal fifo_inst_n4 : std_logic ;
  signal fifo_inst_n9 : std_logic ;
  signal GND_0 : std_logic ;
  signal VCC_0 : std_logic ;
  signal \fifo_inst/reset_r\ : std_logic_vector(1 downto 0);
  signal \fifo_inst/reset_w\ : std_logic_vector(1 downto 0);
  signal \fifo_inst/rbin_num\ : std_logic_vector(6 downto 0);
  signal \fifo_inst/Equal.wq1_rptr\ : std_logic_vector(6 downto 0);
  signal \fifo_inst/Equal.wq2_rptr\ : std_logic_vector(6 downto 0);
  signal \fifo_inst/Equal.rq1_wptr\ : std_logic_vector(6 downto 0);
  signal \fifo_inst/Equal.rq2_wptr\ : std_logic_vector(6 downto 0);
  signal \fifo_inst/Equal.rptr\ : std_logic_vector(5 downto 0);
  signal \fifo_inst/Equal.wptr\ : std_logic_vector(6 downto 0);
  signal \fifo_inst/Equal.wbin\ : std_logic_vector(5 downto 0);
  signal \fifo_inst/rcnt_sub\ : std_logic_vector(6 downto 0);
  signal \fifo_inst/Equal.rgraynext\ : std_logic_vector(5 downto 0);
  signal \fifo_inst/Equal.wcount_r\ : std_logic_vector(5 downto 0);
  signal \fifo_inst/Equal.wgraynext\ : std_logic_vector(5 downto 0);
  signal \fifo_inst/rbin_num_next\ : std_logic_vector(6 downto 1);
  signal \fifo_inst/Equal.wbinnext\ : std_logic_vector(6 downto 1);
  signal NN : std_logic;
  signal NN_0 : std_logic;
begin
\fifo_inst/reset_r_0_s0\: DFFPE
port map (
  Q => \fifo_inst/reset_r\(0),
  D => GND_0,
  CLK => fifo_inst_n4,
  PRESET => Reset,
  CE => VCC_0);
\fifo_inst/reset_w_1_s0\: DFFPE
port map (
  Q => \fifo_inst/reset_w\(1),
  D => \fifo_inst/reset_w\(0),
  CLK => fifo_inst_n9,
  PRESET => Reset,
  CE => VCC_0);
\fifo_inst/reset_w_0_s0\: DFFPE
port map (
  Q => \fifo_inst/reset_w\(0),
  D => GND_0,
  CLK => fifo_inst_n9,
  PRESET => Reset,
  CE => VCC_0);
\fifo_inst/rbin_num_6_s0\: DFFCE
port map (
  Q => \fifo_inst/rbin_num\(6),
  D => \fifo_inst/rbin_num_next\(6),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/rbin_num_5_s0\: DFFCE
port map (
  Q => \fifo_inst/rbin_num\(5),
  D => \fifo_inst/rbin_num_next\(5),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/rbin_num_4_s0\: DFFCE
port map (
  Q => \fifo_inst/rbin_num\(4),
  D => \fifo_inst/rbin_num_next\(4),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/rbin_num_3_s0\: DFFCE
port map (
  Q => \fifo_inst/rbin_num\(3),
  D => \fifo_inst/rbin_num_next\(3),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/rbin_num_2_s0\: DFFCE
port map (
  Q => \fifo_inst/rbin_num\(2),
  D => \fifo_inst/rbin_num_next\(2),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/rbin_num_1_s0\: DFFCE
port map (
  Q => \fifo_inst/rbin_num\(1),
  D => \fifo_inst/rbin_num_next\(1),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/rbin_num_0_s0\: DFFCE
port map (
  Q => \fifo_inst/rbin_num\(0),
  D => fifo_inst_rbin_num_next_0,
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_6_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(6),
  D => \fifo_inst/rbin_num\(6),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_5_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(5),
  D => \fifo_inst/Equal.rptr\(5),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_4_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(4),
  D => \fifo_inst/Equal.rptr\(4),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_3_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(3),
  D => \fifo_inst/Equal.rptr\(3),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_2_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(2),
  D => \fifo_inst/Equal.rptr\(2),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_1_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(1),
  D => \fifo_inst/Equal.rptr\(1),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq1_rptr_0_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq1_rptr\(0),
  D => \fifo_inst/Equal.rptr\(0),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_6_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(6),
  D => \fifo_inst/Equal.wq1_rptr\(6),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_5_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(5),
  D => \fifo_inst/Equal.wq1_rptr\(5),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_4_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(4),
  D => \fifo_inst/Equal.wq1_rptr\(4),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_3_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(3),
  D => \fifo_inst/Equal.wq1_rptr\(3),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_2_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(2),
  D => \fifo_inst/Equal.wq1_rptr\(2),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_1_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(1),
  D => \fifo_inst/Equal.wq1_rptr\(1),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wq2_rptr_0_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wq2_rptr\(0),
  D => \fifo_inst/Equal.wq1_rptr\(0),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_6_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(6),
  D => \fifo_inst/Equal.wptr\(6),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_5_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(5),
  D => \fifo_inst/Equal.wptr\(5),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_4_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(4),
  D => \fifo_inst/Equal.wptr\(4),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_3_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(3),
  D => \fifo_inst/Equal.wptr\(3),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_2_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(2),
  D => \fifo_inst/Equal.wptr\(2),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_1_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(1),
  D => \fifo_inst/Equal.wptr\(1),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq1_wptr_0_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq1_wptr\(0),
  D => \fifo_inst/Equal.wptr\(0),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_6_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(6),
  D => \fifo_inst/Equal.rq1_wptr\(6),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_5_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(5),
  D => \fifo_inst/Equal.rq1_wptr\(5),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_4_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(4),
  D => \fifo_inst/Equal.rq1_wptr\(4),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_3_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(3),
  D => \fifo_inst/Equal.rq1_wptr\(3),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_2_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(2),
  D => \fifo_inst/Equal.rq1_wptr\(2),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_1_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(1),
  D => \fifo_inst/Equal.rq1_wptr\(1),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rq2_wptr_0_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rq2_wptr\(0),
  D => \fifo_inst/Equal.rq1_wptr\(0),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rptr_5_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rptr\(5),
  D => \fifo_inst/Equal.rgraynext\(5),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rptr_4_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rptr\(4),
  D => \fifo_inst/Equal.rgraynext\(4),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rptr_3_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rptr\(3),
  D => \fifo_inst/Equal.rgraynext\(3),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rptr_2_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rptr\(2),
  D => \fifo_inst/Equal.rgraynext\(2),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rptr_1_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rptr\(1),
  D => \fifo_inst/Equal.rgraynext\(1),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.rptr_0_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.rptr\(0),
  D => \fifo_inst/Equal.rgraynext\(0),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Equal.wptr_6_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wptr\(6),
  D => \fifo_inst/Equal.wbinnext\(6),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wptr_5_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wptr\(5),
  D => \fifo_inst/Equal.wgraynext\(5),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wptr_4_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wptr\(4),
  D => \fifo_inst/Equal.wgraynext\(4),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wptr_3_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wptr\(3),
  D => \fifo_inst/Equal.wgraynext\(3),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wptr_2_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wptr\(2),
  D => \fifo_inst/Equal.wgraynext\(2),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wptr_1_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wptr\(1),
  D => \fifo_inst/Equal.wgraynext\(1),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wptr_0_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wptr\(0),
  D => \fifo_inst/Equal.wgraynext\(0),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wbin_5_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wbin\(5),
  D => \fifo_inst/Equal.wbinnext\(5),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wbin_4_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wbin\(4),
  D => \fifo_inst/Equal.wbinnext\(4),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wbin_3_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wbin\(3),
  D => \fifo_inst/Equal.wbinnext\(3),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wbin_2_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wbin\(2),
  D => \fifo_inst/Equal.wbinnext\(2),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wbin_1_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wbin\(1),
  D => \fifo_inst/Equal.wbinnext\(1),
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Equal.wbin_0_s0\: DFFCE
port map (
  Q => \fifo_inst/Equal.wbin\(0),
  D => \fifo_inst_Equal.wbinnext_0\,
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Empty_s0\: DFFPE
port map (
  Q => NN,
  D => fifo_inst_rempty_val,
  CLK => RdClk,
  PRESET => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Full_s0\: DFFCE
port map (
  Q => NN_0,
  D => fifo_inst_wfull_val,
  CLK => WrClk,
  CLEAR => \fifo_inst/reset_w\(1),
  CE => VCC_0);
\fifo_inst/Rnum_6_s0\: DFFCE
port map (
  Q => Rnum(6),
  D => \fifo_inst/rcnt_sub\(6),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Rnum_5_s0\: DFFCE
port map (
  Q => Rnum(5),
  D => \fifo_inst/rcnt_sub\(5),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Rnum_4_s0\: DFFCE
port map (
  Q => Rnum(4),
  D => \fifo_inst/rcnt_sub\(4),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Rnum_3_s0\: DFFCE
port map (
  Q => Rnum(3),
  D => \fifo_inst/rcnt_sub\(3),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Rnum_2_s0\: DFFCE
port map (
  Q => Rnum(2),
  D => \fifo_inst/rcnt_sub\(2),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Rnum_1_s0\: DFFCE
port map (
  Q => Rnum(1),
  D => \fifo_inst/rcnt_sub\(1),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/Rnum_0_s0\: DFFCE
port map (
  Q => Rnum(0),
  D => \fifo_inst/rcnt_sub\(0),
  CLK => RdClk,
  CLEAR => \fifo_inst/reset_r\(1),
  CE => VCC_0);
\fifo_inst/reset_r_1_s0\: DFFPE
port map (
  Q => \fifo_inst/reset_r\(1),
  D => \fifo_inst/reset_r\(0),
  CLK => fifo_inst_n4,
  PRESET => Reset,
  CE => VCC_0);
\fifo_inst/Equal.mem_Equal.mem_0_0_s\: SDPB
generic map (
  BIT_WIDTH_0 => 32,
  BIT_WIDTH_1 => 32,
  READ_MODE => '0',
  RESET_MODE => "ASYNC",
  BLK_SEL_0 => "000",
  BLK_SEL_1 => "000"
)
port map (
  DO(31 downto 0) => Q(31 downto 0),
  CLKA => WrClk,
  CEA => fifo_inst_n25,
  CLKB => RdClk,
  CEB => fifo_inst_n29,
  OCE => GND_0,
  RESET => \fifo_inst/reset_r\(1),
  ADA(13) => GND_0,
  ADA(12) => GND_0,
  ADA(11) => GND_0,
  ADA(10 downto 5) => \fifo_inst/Equal.wbin\(5 downto 0),
  ADA(4) => GND_0,
  ADA(3) => VCC_0,
  ADA(2) => VCC_0,
  ADA(1) => VCC_0,
  ADA(0) => VCC_0,
  ADB(13) => GND_0,
  ADB(12) => GND_0,
  ADB(11) => GND_0,
  ADB(10 downto 5) => \fifo_inst/rbin_num\(5 downto 0),
  ADB(4) => GND_0,
  ADB(3) => GND_0,
  ADB(2) => GND_0,
  ADB(1) => GND_0,
  ADB(0) => GND_0,
  DI(31 downto 0) => Data(31 downto 0),
  BLKSELA(2) => GND_0,
  BLKSELA(1) => GND_0,
  BLKSELA(0) => GND_0,
  BLKSELB(2) => GND_0,
  BLKSELB(1) => GND_0,
  BLKSELB(0) => GND_0);
\fifo_inst/Equal.mem_Equal.mem_0_1_s\: SDPB
generic map (
  BIT_WIDTH_0 => 32,
  BIT_WIDTH_1 => 32,
  READ_MODE => '0',
  RESET_MODE => "ASYNC",
  BLK_SEL_0 => "000",
  BLK_SEL_1 => "000"
)
port map (
  DO(31) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO31\,
  DO(30) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO30\,
  DO(29) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO29\,
  DO(28) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO28\,
  DO(27) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO27\,
  DO(26) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO26\,
  DO(25) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO25\,
  DO(24) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO24\,
  DO(23) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO23\,
  DO(22) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO22\,
  DO(21) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO21\,
  DO(20) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO20\,
  DO(19) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO19\,
  DO(18) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO18\,
  DO(17) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO17\,
  DO(16) => \fifo_inst_Equal.mem_Equal.mem_0_1_0_DO16\,
  DO(15 downto 0) => Q(47 downto 32),
  CLKA => WrClk,
  CEA => fifo_inst_n25,
  CLKB => RdClk,
  CEB => fifo_inst_n29,
  OCE => GND_0,
  RESET => \fifo_inst/reset_r\(1),
  ADA(13) => GND_0,
  ADA(12) => GND_0,
  ADA(11) => GND_0,
  ADA(10 downto 5) => \fifo_inst/Equal.wbin\(5 downto 0),
  ADA(4) => GND_0,
  ADA(3) => VCC_0,
  ADA(2) => VCC_0,
  ADA(1) => VCC_0,
  ADA(0) => VCC_0,
  ADB(13) => GND_0,
  ADB(12) => GND_0,
  ADB(11) => GND_0,
  ADB(10 downto 5) => \fifo_inst/rbin_num\(5 downto 0),
  ADB(4) => GND_0,
  ADB(3) => GND_0,
  ADB(2) => GND_0,
  ADB(1) => GND_0,
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
  DI(15 downto 0) => Data(47 downto 32),
  BLKSELA(2) => GND_0,
  BLKSELA(1) => GND_0,
  BLKSELA(0) => GND_0,
  BLKSELB(2) => GND_0,
  BLKSELB(1) => GND_0,
  BLKSELB(0) => GND_0);
\fifo_inst/rcnt_sub_0_s\: ALU
generic map (
  ALU_MODE => 1
)
port map (
  SUM => \fifo_inst/rcnt_sub\(0),
  COUT => fifo_inst_rcnt_sub_0,
  I0 => \fifo_inst/Equal.wcount_r\(0),
  I1 => \fifo_inst/rbin_num\(0),
  I3 => GND_0,
  CIN => VCC_0);
\fifo_inst/rcnt_sub_1_s\: ALU
generic map (
  ALU_MODE => 1
)
port map (
  SUM => \fifo_inst/rcnt_sub\(1),
  COUT => fifo_inst_rcnt_sub_1,
  I0 => \fifo_inst/Equal.wcount_r\(1),
  I1 => \fifo_inst/rbin_num\(1),
  I3 => GND_0,
  CIN => fifo_inst_rcnt_sub_0);
\fifo_inst/rcnt_sub_2_s\: ALU
generic map (
  ALU_MODE => 1
)
port map (
  SUM => \fifo_inst/rcnt_sub\(2),
  COUT => fifo_inst_rcnt_sub_2,
  I0 => \fifo_inst/Equal.wcount_r\(2),
  I1 => \fifo_inst/rbin_num\(2),
  I3 => GND_0,
  CIN => fifo_inst_rcnt_sub_1);
\fifo_inst/rcnt_sub_3_s\: ALU
generic map (
  ALU_MODE => 1
)
port map (
  SUM => \fifo_inst/rcnt_sub\(3),
  COUT => fifo_inst_rcnt_sub_3,
  I0 => \fifo_inst/Equal.wcount_r\(3),
  I1 => \fifo_inst/rbin_num\(3),
  I3 => GND_0,
  CIN => fifo_inst_rcnt_sub_2);
\fifo_inst/rcnt_sub_4_s\: ALU
generic map (
  ALU_MODE => 1
)
port map (
  SUM => \fifo_inst/rcnt_sub\(4),
  COUT => fifo_inst_rcnt_sub_4,
  I0 => \fifo_inst/Equal.wcount_r\(4),
  I1 => \fifo_inst/rbin_num\(4),
  I3 => GND_0,
  CIN => fifo_inst_rcnt_sub_3);
\fifo_inst/rcnt_sub_5_s\: ALU
generic map (
  ALU_MODE => 1
)
port map (
  SUM => \fifo_inst/rcnt_sub\(5),
  COUT => fifo_inst_rcnt_sub_5,
  I0 => \fifo_inst/Equal.wcount_r\(5),
  I1 => \fifo_inst/rbin_num\(5),
  I3 => GND_0,
  CIN => fifo_inst_rcnt_sub_4);
\fifo_inst/rcnt_sub_6_s\: ALU
generic map (
  ALU_MODE => 1
)
port map (
  SUM => \fifo_inst/rcnt_sub\(6),
  COUT => fifo_inst_rcnt_sub_6,
  I0 => fifo_inst_n260,
  I1 => GND_0,
  I3 => GND_0,
  CIN => fifo_inst_rcnt_sub_5);
\fifo_inst/n245_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_inst_n245,
  COUT => fifo_inst_n245_3,
  I0 => \fifo_inst/Equal.rgraynext\(0),
  I1 => \fifo_inst/Equal.rq2_wptr\(0),
  I3 => GND_0,
  CIN => GND_0);
\fifo_inst/n246_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_inst_n246,
  COUT => fifo_inst_n246_3,
  I0 => \fifo_inst/Equal.rgraynext\(1),
  I1 => \fifo_inst/Equal.rq2_wptr\(1),
  I3 => GND_0,
  CIN => fifo_inst_n245_3);
\fifo_inst/n247_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_inst_n247,
  COUT => fifo_inst_n247_3,
  I0 => \fifo_inst/Equal.rgraynext\(2),
  I1 => \fifo_inst/Equal.rq2_wptr\(2),
  I3 => GND_0,
  CIN => fifo_inst_n246_3);
\fifo_inst/n248_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_inst_n248,
  COUT => fifo_inst_n248_3,
  I0 => \fifo_inst/Equal.rgraynext\(3),
  I1 => \fifo_inst/Equal.rq2_wptr\(3),
  I3 => GND_0,
  CIN => fifo_inst_n247_3);
\fifo_inst/n249_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_inst_n249,
  COUT => fifo_inst_n249_3,
  I0 => \fifo_inst/Equal.rgraynext\(4),
  I1 => \fifo_inst/Equal.rq2_wptr\(4),
  I3 => GND_0,
  CIN => fifo_inst_n248_3);
\fifo_inst/n250_s0\: ALU
generic map (
  ALU_MODE => 3
)
port map (
  SUM => fifo_inst_n250,
  COUT => fifo_inst_n250_3,
  I0 => \fifo_inst/Equal.rgraynext\(5),
  I1 => \fifo_inst/Equal.rq2_wptr\(5),
  I3 => GND_0,
  CIN => fifo_inst_n249_3);
\fifo_inst/n25_s1\: LUT2
generic map (
  INIT => X"4"
)
port map (
  F => fifo_inst_n25,
  I0 => NN_0,
  I1 => WrEn);
\fifo_inst/n29_s0\: LUT2
generic map (
  INIT => X"4"
)
port map (
  F => fifo_inst_n29,
  I0 => NN,
  I1 => RdEn);
\fifo_inst/Equal.rgraynext_2_s0\: LUT3
generic map (
  INIT => X"1E"
)
port map (
  F => \fifo_inst/Equal.rgraynext\(2),
  I0 => \fifo_inst/rbin_num\(2),
  I1 => \fifo_inst_Equal.rgraynext_2\,
  I2 => \fifo_inst/rbin_num\(3));
\fifo_inst/Equal.rgraynext_4_s0\: LUT3
generic map (
  INIT => X"36"
)
port map (
  F => \fifo_inst/Equal.rgraynext\(4),
  I0 => \fifo_inst/rbin_num\(4),
  I1 => \fifo_inst/rbin_num\(5),
  I2 => \fifo_inst/rbin_num_next\(4));
\fifo_inst/Equal.rgraynext_5_s0\: LUT3
generic map (
  INIT => X"1E"
)
port map (
  F => \fifo_inst/Equal.rgraynext\(5),
  I0 => \fifo_inst/rbin_num\(5),
  I1 => \fifo_inst_Equal.rgraynext_5\,
  I2 => \fifo_inst/rbin_num\(6));
\fifo_inst/Equal.wcount_r_5_s0\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => \fifo_inst/Equal.wcount_r\(5),
  I0 => \fifo_inst/Equal.rq2_wptr\(6),
  I1 => \fifo_inst/Equal.rq2_wptr\(5));
\fifo_inst/Equal.wcount_r_2_s0\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => \fifo_inst/Equal.wcount_r\(2),
  I0 => \fifo_inst/Equal.rq2_wptr\(2),
  I1 => \fifo_inst/Equal.wcount_r\(3));
\fifo_inst/Equal.wcount_r_1_s0\: LUT3
generic map (
  INIT => X"96"
)
port map (
  F => \fifo_inst/Equal.wcount_r\(1),
  I0 => \fifo_inst/Equal.rq2_wptr\(2),
  I1 => \fifo_inst/Equal.rq2_wptr\(1),
  I2 => \fifo_inst/Equal.wcount_r\(3));
\fifo_inst/Equal.wcount_r_0_s0\: LUT4
generic map (
  INIT => X"6996"
)
port map (
  F => \fifo_inst/Equal.wcount_r\(0),
  I0 => \fifo_inst/Equal.rq2_wptr\(2),
  I1 => \fifo_inst/Equal.rq2_wptr\(1),
  I2 => \fifo_inst/Equal.rq2_wptr\(0),
  I3 => \fifo_inst/Equal.wcount_r\(3));
\fifo_inst/n260_s0\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => fifo_inst_n260,
  I0 => \fifo_inst/Equal.rq2_wptr\(6),
  I1 => \fifo_inst/rbin_num\(6));
\fifo_inst/Equal.wgraynext_1_s0\: LUT4
generic map (
  INIT => X"07F8"
)
port map (
  F => \fifo_inst/Equal.wgraynext\(1),
  I0 => \fifo_inst/Equal.wbin\(0),
  I1 => fifo_inst_n25,
  I2 => \fifo_inst/Equal.wbin\(1),
  I3 => \fifo_inst/Equal.wbin\(2));
\fifo_inst/Equal.wgraynext_2_s0\: LUT3
generic map (
  INIT => X"1E"
)
port map (
  F => \fifo_inst/Equal.wgraynext\(2),
  I0 => \fifo_inst/Equal.wbin\(2),
  I1 => \fifo_inst_Equal.wgraynext_2\,
  I2 => \fifo_inst/Equal.wbin\(3));
\fifo_inst/Equal.wgraynext_3_s0\: LUT4
generic map (
  INIT => X"07F8"
)
port map (
  F => \fifo_inst/Equal.wgraynext\(3),
  I0 => \fifo_inst/Equal.wbin\(2),
  I1 => \fifo_inst_Equal.wgraynext_2\,
  I2 => \fifo_inst/Equal.wbin\(3),
  I3 => \fifo_inst/Equal.wbin\(4));
\fifo_inst/Equal.wgraynext_4_s0\: LUT4
generic map (
  INIT => X"07F8"
)
port map (
  F => \fifo_inst/Equal.wgraynext\(4),
  I0 => \fifo_inst_Equal.wgraynext_2\,
  I1 => \fifo_inst_Equal.wgraynext_4\,
  I2 => \fifo_inst/Equal.wbin\(4),
  I3 => \fifo_inst/Equal.wbin\(5));
\fifo_inst/wfull_val_s0\: LUT4
generic map (
  INIT => X"0800"
)
port map (
  F => fifo_inst_wfull_val,
  I0 => fifo_inst_wfull_val_4,
  I1 => fifo_inst_wfull_val_5,
  I2 => fifo_inst_wfull_val_12,
  I3 => fifo_inst_wfull_val_7);
\fifo_inst/rbin_num_next_2_s3\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => \fifo_inst/rbin_num_next\(2),
  I0 => \fifo_inst/rbin_num\(2),
  I1 => \fifo_inst_Equal.rgraynext_2\);
\fifo_inst/rbin_num_next_3_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_inst/rbin_num_next\(3),
  I0 => \fifo_inst/rbin_num\(2),
  I1 => \fifo_inst_Equal.rgraynext_2\,
  I2 => \fifo_inst/rbin_num\(3));
\fifo_inst/rbin_num_next_4_s3\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_inst/rbin_num_next\(4),
  I0 => \fifo_inst/rbin_num\(2),
  I1 => \fifo_inst/rbin_num\(3),
  I2 => \fifo_inst_Equal.rgraynext_2\,
  I3 => \fifo_inst/rbin_num\(4));
\fifo_inst/rbin_num_next_5_s3\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => \fifo_inst/rbin_num_next\(5),
  I0 => \fifo_inst/rbin_num\(5),
  I1 => \fifo_inst_Equal.rgraynext_5\);
\fifo_inst/rbin_num_next_6_s2\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_inst/rbin_num_next\(6),
  I0 => \fifo_inst/rbin_num\(5),
  I1 => \fifo_inst_Equal.rgraynext_5\,
  I2 => \fifo_inst/rbin_num\(6));
\fifo_inst/Equal.wbinnext_2_s3\: LUT2
generic map (
  INIT => X"6"
)
port map (
  F => \fifo_inst/Equal.wbinnext\(2),
  I0 => \fifo_inst/Equal.wbin\(2),
  I1 => \fifo_inst_Equal.wgraynext_2\);
\fifo_inst/Equal.wbinnext_3_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_inst/Equal.wbinnext\(3),
  I0 => \fifo_inst/Equal.wbin\(2),
  I1 => \fifo_inst_Equal.wgraynext_2\,
  I2 => \fifo_inst/Equal.wbin\(3));
\fifo_inst/Equal.wbinnext_5_s3\: LUT3
generic map (
  INIT => X"78"
)
port map (
  F => \fifo_inst/Equal.wbinnext\(5),
  I0 => \fifo_inst/Equal.wbin\(4),
  I1 => \fifo_inst_Equal.wbinnext_4\,
  I2 => \fifo_inst/Equal.wbin\(5));
\fifo_inst/Equal.wbinnext_6_s2\: LUT4
generic map (
  INIT => X"7F80"
)
port map (
  F => \fifo_inst/Equal.wbinnext\(6),
  I0 => \fifo_inst_Equal.wgraynext_2\,
  I1 => \fifo_inst_Equal.wgraynext_4\,
  I2 => \fifo_inst_Equal.wbinnext_6\,
  I3 => \fifo_inst/Equal.wptr\(6));
\fifo_inst/Equal.rgraynext_5_s1\: LUT4
generic map (
  INIT => X"8000"
)
port map (
  F => \fifo_inst_Equal.rgraynext_5\,
  I0 => \fifo_inst/rbin_num\(2),
  I1 => \fifo_inst/rbin_num\(3),
  I2 => \fifo_inst/rbin_num\(4),
  I3 => \fifo_inst_Equal.rgraynext_2\);
\fifo_inst/Equal.wgraynext_2_s1\: LUT4
generic map (
  INIT => X"4000"
)
port map (
  F => \fifo_inst_Equal.wgraynext_2\,
  I0 => NN_0,
  I1 => WrEn,
  I2 => \fifo_inst/Equal.wbin\(0),
  I3 => \fifo_inst/Equal.wbin\(1));
\fifo_inst/Equal.wgraynext_4_s1\: LUT2
generic map (
  INIT => X"8"
)
port map (
  F => \fifo_inst_Equal.wgraynext_4\,
  I0 => \fifo_inst/Equal.wbin\(2),
  I1 => \fifo_inst/Equal.wbin\(3));
\fifo_inst/wfull_val_s1\: LUT4
generic map (
  INIT => X"9009"
)
port map (
  F => fifo_inst_wfull_val_4,
  I0 => \fifo_inst/Equal.wq2_rptr\(0),
  I1 => \fifo_inst/Equal.wgraynext\(0),
  I2 => \fifo_inst/Equal.wq2_rptr\(1),
  I3 => \fifo_inst/Equal.wgraynext\(1));
\fifo_inst/wfull_val_s2\: LUT4
generic map (
  INIT => X"6006"
)
port map (
  F => fifo_inst_wfull_val_5,
  I0 => fifo_inst_wfull_val_8,
  I1 => fifo_inst_wfull_val_9,
  I2 => \fifo_inst/Equal.wbin\(4),
  I3 => fifo_inst_wfull_val_10);
\fifo_inst/wfull_val_s4\: LUT4
generic map (
  INIT => X"0990"
)
port map (
  F => fifo_inst_wfull_val_7,
  I0 => \fifo_inst/Equal.wq2_rptr\(4),
  I1 => \fifo_inst/Equal.wgraynext\(4),
  I2 => \fifo_inst/Equal.wq2_rptr\(6),
  I3 => \fifo_inst/Equal.wbinnext\(6));
\fifo_inst/Equal.wbinnext_6_s3\: LUT2
generic map (
  INIT => X"8"
)
port map (
  F => \fifo_inst_Equal.wbinnext_6\,
  I0 => \fifo_inst/Equal.wbin\(4),
  I1 => \fifo_inst/Equal.wbin\(5));
\fifo_inst/wfull_val_s5\: LUT4
generic map (
  INIT => X"007F"
)
port map (
  F => fifo_inst_wfull_val_8,
  I0 => \fifo_inst/Equal.wbin\(4),
  I1 => \fifo_inst_Equal.wgraynext_2\,
  I2 => \fifo_inst_Equal.wgraynext_4\,
  I3 => \fifo_inst/Equal.wbin\(5));
\fifo_inst/wfull_val_s6\: LUT2
generic map (
  INIT => X"9"
)
port map (
  F => fifo_inst_wfull_val_9,
  I0 => \fifo_inst/Equal.wq2_rptr\(5),
  I1 => \fifo_inst/Equal.wptr\(6));
\fifo_inst/wfull_val_s7\: LUT4
generic map (
  INIT => X"07F8"
)
port map (
  F => fifo_inst_wfull_val_10,
  I0 => \fifo_inst/Equal.wbin\(2),
  I1 => \fifo_inst_Equal.wgraynext_2\,
  I2 => \fifo_inst/Equal.wbin\(3),
  I3 => \fifo_inst/Equal.wq2_rptr\(3));
\fifo_inst/Equal.wcount_r_4_s1\: LUT3
generic map (
  INIT => X"96"
)
port map (
  F => \fifo_inst/Equal.wcount_r\(4),
  I0 => \fifo_inst/Equal.rq2_wptr\(4),
  I1 => \fifo_inst/Equal.rq2_wptr\(6),
  I2 => \fifo_inst/Equal.rq2_wptr\(5));
\fifo_inst/wfull_val_s8\: LUT4
generic map (
  INIT => X"A956"
)
port map (
  F => fifo_inst_wfull_val_12,
  I0 => \fifo_inst/Equal.wq2_rptr\(2),
  I1 => \fifo_inst/Equal.wbin\(2),
  I2 => \fifo_inst_Equal.wgraynext_2\,
  I3 => \fifo_inst/Equal.wbin\(3));
\fifo_inst/Equal.rgraynext_3_s1\: LUT4
generic map (
  INIT => X"8778"
)
port map (
  F => \fifo_inst/Equal.rgraynext\(3),
  I0 => \fifo_inst/rbin_num\(2),
  I1 => \fifo_inst_Equal.rgraynext_2\,
  I2 => \fifo_inst/rbin_num\(3),
  I3 => \fifo_inst/rbin_num_next\(4));
\fifo_inst/Equal.wbinnext_4_s5\: LUT3
generic map (
  INIT => X"80"
)
port map (
  F => \fifo_inst_Equal.wbinnext_4\,
  I0 => \fifo_inst_Equal.wgraynext_2\,
  I1 => \fifo_inst/Equal.wbin\(2),
  I2 => \fifo_inst/Equal.wbin\(3));
\fifo_inst/Equal.rgraynext_2_s2\: LUT4
generic map (
  INIT => X"0800"
)
port map (
  F => \fifo_inst_Equal.rgraynext_2\,
  I0 => \fifo_inst/rbin_num\(0),
  I1 => \fifo_inst/rbin_num\(1),
  I2 => NN,
  I3 => RdEn);
\fifo_inst/rbin_num_next_1_s4\: LUT4
generic map (
  INIT => X"DF20"
)
port map (
  F => \fifo_inst/rbin_num_next\(1),
  I0 => \fifo_inst/rbin_num\(0),
  I1 => NN,
  I2 => RdEn,
  I3 => \fifo_inst/rbin_num\(1));
\fifo_inst/rbin_num_next_0_s4\: LUT3
generic map (
  INIT => X"9A"
)
port map (
  F => fifo_inst_rbin_num_next_0,
  I0 => \fifo_inst/rbin_num\(0),
  I1 => NN,
  I2 => RdEn);
\fifo_inst/Equal.wbinnext_1_s4\: LUT4
generic map (
  INIT => X"DF20"
)
port map (
  F => \fifo_inst/Equal.wbinnext\(1),
  I0 => \fifo_inst/Equal.wbin\(0),
  I1 => NN_0,
  I2 => WrEn,
  I3 => \fifo_inst/Equal.wbin\(1));
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
  I3 => \fifo_inst/Equal.wbin\(1));
\fifo_inst/rempty_val_s1\: LUT3
generic map (
  INIT => X"41"
)
port map (
  F => fifo_inst_rempty_val,
  I0 => fifo_inst_n250_3,
  I1 => \fifo_inst/Equal.rq2_wptr\(6),
  I2 => \fifo_inst/rbin_num_next\(6));
\fifo_inst/Equal.wbinnext_4_s6\: LUT4
generic map (
  INIT => X"6AAA"
)
port map (
  F => \fifo_inst/Equal.wbinnext\(4),
  I0 => \fifo_inst/Equal.wbin\(4),
  I1 => \fifo_inst_Equal.wgraynext_2\,
  I2 => \fifo_inst/Equal.wbin\(2),
  I3 => \fifo_inst/Equal.wbin\(3));
\fifo_inst/Equal.wgraynext_5_s1\: LUT4
generic map (
  INIT => X"956A"
)
port map (
  F => \fifo_inst/Equal.wgraynext\(5),
  I0 => \fifo_inst/Equal.wbinnext\(6),
  I1 => \fifo_inst/Equal.wbin\(4),
  I2 => \fifo_inst_Equal.wbinnext_4\,
  I3 => \fifo_inst/Equal.wbin\(5));
\fifo_inst/Equal.wcount_r_3_s1\: LUT4
generic map (
  INIT => X"6996"
)
port map (
  F => \fifo_inst/Equal.wcount_r\(3),
  I0 => \fifo_inst/Equal.rq2_wptr\(3),
  I1 => \fifo_inst/Equal.rq2_wptr\(4),
  I2 => \fifo_inst/Equal.rq2_wptr\(6),
  I3 => \fifo_inst/Equal.rq2_wptr\(5));
\fifo_inst/Equal.rgraynext_0_s1\: LUT4
generic map (
  INIT => X"6966"
)
port map (
  F => \fifo_inst/Equal.rgraynext\(0),
  I0 => \fifo_inst/rbin_num_next\(1),
  I1 => \fifo_inst/rbin_num\(0),
  I2 => NN,
  I3 => RdEn);
\fifo_inst/Equal.rgraynext_1_s1\: LUT3
generic map (
  INIT => X"96"
)
port map (
  F => \fifo_inst/Equal.rgraynext\(1),
  I0 => \fifo_inst/rbin_num_next\(1),
  I1 => \fifo_inst/rbin_num\(2),
  I2 => \fifo_inst_Equal.rgraynext_2\);
\fifo_inst/n4_s2\: INV
port map (
  O => fifo_inst_n4,
  I => RdClk);
\fifo_inst/n9_s2\: INV
port map (
  O => fifo_inst_n9,
  I => WrClk);
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
