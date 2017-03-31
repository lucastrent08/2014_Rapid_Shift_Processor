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
-- Description: Program control unit internal block.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pcu_block is
    Port ( pcu_instr : in  STD_LOGIC_VECTOR (4 downto 0);
           clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
           cc : in  STD_LOGIC;
           pcu_ci : in  STD_LOGIC;
			  d : in STD_LOGIC_VECTOR (15 downto 0);
           pcu_out : out STD_LOGIC_VECTOR (15 downto 0);
			  
			  -- Test Bench Outputs
			  pc : out STD_LOGIC_VECTOR (15 downto 0)
			  );
end pcu_block;

architecture Behavioral of pcu_block is

	signal cp : std_logic;
	
	signal stack_pointer : std_logic_vector (3 downto 0) := (OTHERS => '0');
	signal pc_wire, pc_in, pcu_out_wire : std_logic_vector (15 downto 0) := (OTHERS => '0');
	signal r_wire, reg_in_wire : std_logic_vector (15 downto 0) := (OTHERS => '0');
	signal s_wire, stack_out, stack_in : std_logic_vector (15 downto 0) := (OTHERS => '0');
	signal stack_we : std_logic := '0';
	signal pc_hold : std_logic := '0';
begin

-- Outputs
pcu_out <= pcu_out_wire;

-- Test Bench Outputs
pc <= pc_wire;

PCU_MUX : entity pcu_mux
	port map(
				pcu_instr => pcu_instr,
				pc => pc_wire,
				pcu_out => pcu_out_wire,
				stack_out => stack_out,
				d => d,
				reg_in => reg_in_wire,
				stack_in => stack_in,
				stack_we => stack_we,
				pc_hold => pc_hold,
				pc_in => pc_in,
				s => s_wire
				);

PROGRAM_COUNTER: entity program_counter
	port map(
				clk => clk,
				reset => reset,
				pc_hold => pc_hold,
				pc_in => pc_in,
				ci => pcu_ci,
				pc => pc_wire
				);
				
PCU_STACK: entity pcu_stack
	port map(
				clk => clk,
				reset => reset,
				we => stack_we,
				pcu_instr => pcu_instr,
				address => stack_pointer,
				din => stack_in,
				dout => stack_out
				);
				
PCU_REGISTER: entity pcu_register
	port map(
				clk => clk,
				we => '0',			-- RE in 2930
				input => reg_in_wire,
				output => r_wire
				);
				
				
PCU_ADDER: entity pcu_adder
	port map(clk => clk,
				pcu_instr => pcu_instr,
				s => s_wire,
				r => r_wire,
				ci => pcu_ci,
				d => d,
				pc => pc_wire,
				pcu_out => pcu_out_wire
				);

end Behavioral;

