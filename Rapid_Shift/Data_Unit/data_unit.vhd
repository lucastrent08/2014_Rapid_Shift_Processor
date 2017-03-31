----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Stephen Shannon
-- 
-- Create Date:    Spring 2010
-- Module Name:    SSCU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: Top Level Data Unit. Contains FPU, PCU, and SSCU.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity Data_Unit is
	Port (
		clk : in std_logic;
		reset : in STD_LOGIC;
		pipeline : in std_logic_vector (57 downto 0);
		idb : out std_logic_vector (15 downto 0);
		pcu_ir : out std_logic_vector (15 downto 0);
		mdr_read : in std_logic_vector (15 downto 0);
		mdr_write : out std_logic_vector (15 downto 0);
		pcu_out : out std_logic_vector (15 downto 0);
		
		-- For test bench
		sscu_out : out std_logic_vector (3 downto 0);
		sscu_cc : out std_logic;
		pc : out std_logic_vector (15 downto 0);
		alu_out : out std_logic_vector (15 downto 0);
		a_out_tb : out std_logic_vector (15 downto 0);
		b_out_tb : out std_logic_vector (15 downto 0)
		);
end Data_Unit;

architecture Behavioral of Data_Unit is
	signal mc_wire, mn_wire, cc_wire : std_logic := '0';
	signal CCR_wire, yccr_wire : STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');
	signal F_wire, IR_Wire, IDB_Wire, mdr_wire, pcu_out_wire : STD_LOGIC_VECTOR (15 downto 0) := (OTHERS => '0');
begin

-- Outputs
sscu_cc <= cc_wire;
pcu_ir <= ir_wire;
idb <= idb_wire;
pcu_out <= pcu_out_wire;

-- Outputs for test bench
sscu_out <= yccr_wire;
alu_out <= F_wire;

FPU: entity FPU
	port map(clk => clk,
				IR => IR_Wire(7 downto 0), 
				Src => pipeline(9 downto 7),
				ALU_Fctn => pipeline(13 downto 10),
				ALU_Dest => pipeline(17 downto 14),
				SHIFT => pipeline(29 downto 26),
				SSCU_CI => pipeline(31 downto 30),
				MC => mc_wire,
				MN => mn_wire,
				IMMEDIATE_AS => pipeline(40),
				IMMEDIATE_BS => pipeline(41),
				IMMEDIATE_MASK => pipeline(57 downto 42),
				idb => IDB_Wire,
				F => F_wire,
				CCR => CCR_wire,

				ALU_OUT => open,
				A_OUT_TB => a_out_tb,
				B_OUT_TB => b_out_tb
				);

PCU: entity PCU
	port map(clk => clk,
				reset => reset,
				mem_ir => pipeline(0),
				mem_dbb => pipeline(1),
				mem_rw => pipeline(2),
				idb_pl => pipeline(6 downto 4),
				pcu_oe => pipeline(33),
				pcu_instr => pipeline(38 downto 34),
				pcu_ci => pipeline(39),
				ccr => ccr_wire,
				cc => cc_wire,
				imm_mask => pipeline(57 downto 42),
				alu_bus => f_wire,
				mdr => mdr_read,
				yccr => yccr_wire,
				IR => IR_wire,
				IDB => IDB_wire,
				DBB => mdr_write,
				PCU_OUT => PCU_OUT_wire,
				
				-- Test Bench Outputs
				pc => pc
				);
				
SSCU: entity SSCU
	port map(clk => clk,
				ccr => ccr_wire,
				sscu_oe => pipeline(33),
				sscu_cem => pipeline(32),
				sscu_ci => pipeline(31 downto 30),
				sscu_instr => pipeline(25 downto 20),
				sscu_s => pipeline(19),
				sscu_ceu => pipeline(18),
				ir => ir_wire(5 downto 0),
				yccr => yccr_wire,
				mc => mc_wire,
				mn => mn_wire,
				cc => cc_wire
				);

---- Put bidirectional into high impedance when not in use				
--mdr_wire <= dbb_wire when pipeline(2)='1' else mdr;


end Behavioral;

