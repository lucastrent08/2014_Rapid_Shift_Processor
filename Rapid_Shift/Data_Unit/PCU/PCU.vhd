----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Stephen Shannon
-- 
-- Create Date:    Spring 2010
-- Module Name:    PCU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: Program control unit.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity PCU is
    Port(clk : in std_logic;
			reset : in std_logic;
			mem_rw : in std_logic;
			mem_ir : in std_logic;
			mem_dbb : in std_logic;
			cc : in std_logic;
			pcu_oe : in std_logic;
			pcu_ci : in std_logic;
			pcu_instr : in std_logic_vector (4 downto 0);
			idb_pl : in std_logic_vector (2 downto 0);
			ccr : in std_logic_vector (3 downto 0);
			yccr : in std_logic_vector (3 downto 0);
			alu_bus : in std_logic_vector (15 downto 0);
			imm_mask : in std_logic_vector (15 downto 0);
			mdr : in std_logic_vector (15 downto 0);
			IR : out std_logic_vector (15 downto 0);
			IDB : out std_logic_vector (15 downto 0);
			DBB : out std_logic_vector (15 downto 0);
			pcu_out : out std_logic_vector (15 downto 0);
			
			-- Test Bench Outputs
			pc : out STD_LOGIC_VECTOR (15 downto 0)
	);
end PCU;

architecture Behavioral of PCU is
	signal mdr_wire, dbb_wire, dbb_latch, ir_wire, pcu_out_wire, pcu_out_latch, idb_wire, alu_bus_latch : std_logic_vector (15 downto 0) := (OTHERS => '0');
begin

-- Outputs
dbb <= dbb_wire;
ir <= ir_wire;
idb <= idb_wire;
pcu_out <= pcu_out_wire when pcu_oe='0';

DBB_REG : entity dbb_reg
	port map(
				load => mem_dbb,
				sel => mem_rw,
				da => mdr,
				db => idb_wire,
				q => dbb_wire);
				
IDB_MUX : entity idb_mux
	port map(
				sel => idb_pl,
				dbb => dbb_latch,
				alu => alu_bus,
				pcu => pcu_out_latch,
				ccr => yccr, 
				pl => imm_mask,
				ir => ir_wire,
				idb => idb_wire
				);
				
IR_REG : entity ir_reg
	port map(clk => clk,
				load => mem_ir,
				da => mdr,
				q => ir_wire);

LATCH_DBB : entity reg
	generic map (N => 16)
	port map(clk => clk,
				input => dbb_wire,
				output => dbb_latch
				);
				
LATCH_PCU : entity reg
	generic map (N => 16)
	port map(clk => clk,
				input => pcu_out_wire,
				output => pcu_out_latch
				);
				
PCU_BLOCK : entity pcu_block
	port map(clk => clk,
				reset => reset,
				pcu_instr => pcu_instr,
				pcu_ci => pcu_ci,
				d => idb_wire,
				cc => cc,
				pcu_out => pcu_out_wire,
				
				-- Test Bench Outputs
				pc => pc
				);

end Behavioral;

