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
-- Description: PCU Block multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pcu_mux is
    Port ( pcu_instr : in  STD_LOGIC_VECTOR (4 downto 0);
           pc : in  STD_LOGIC_VECTOR (15 downto 0);
           pcu_out : in  STD_LOGIC_VECTOR (15 downto 0);
			  stack_out : in  STD_LOGIC_VECTOR (15 downto 0);
           d : in  STD_LOGIC_VECTOR (15 downto 0);
           reg_in : out  STD_LOGIC_VECTOR (15 downto 0);
			  stack_in : out  STD_LOGIC_VECTOR (15 downto 0);
			  stack_we : out  STD_LOGIC;
			  pc_hold : out  STD_LOGIC;
           pc_in : out  STD_LOGIC_VECTOR (15 downto 0);
			  s :  out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end pcu_mux;

architecture Behavioral of pcu_mux is

begin

-- Set input to register
with pcu_instr select
	reg_in <= 	pcu_out when "01000",
					pcu_out when "01001",
					d when OTHERS;

-- Set input to program counter
with pcu_instr select
	pc_in <= x"0000" 	when "00000",
				pc 		when "00001",
				pc 		when "00010",
				pc 		when "00011",
				pc 		when "00100",
				pc 		when "00101",
				pc 		when "00110",
				pc 		when "00111",
				pc 		when "01000",
				pc 		when "01010",
				pc 		when "01011",
				pc 		when "01100",
				pc 		when "01101",
				pc 		when "01110",
				pc 		when "01111",
				pcu_out 	when OTHERS; -- UPDATE
				
-- Set hold for program counter
with pcu_instr select
	pc_hold <= 	'1' when "01111",
					'1' when "11110",
					'1' when "11111",
					'0' when OTHERS;
					
-- Prepare data for pushing into stack
with pcu_instr select
	stack_in <= pc 	when "01011",
					d 		when "01100",
					pc 	when "10110",
					pc 	when "10111",
					pc 	when "11000",
					pc 	when "11001",
					pc 	when "11010",
					pc 	when "11011",
					(OTHERS => '-') when OTHERS;
with pcu_instr select
	stack_we <= '0'	when "01011",
					'0' 	when "01100",
					'0'	when "10110",
					'0' 	when "10111",
					'0' 	when "11000",
					'0' 	when "11001",
					'0' 	when "11010",
					'0' 	when "11011",
					'1' 	when OTHERS;
					
-- Pop stack
with pcu_instr select
	s <= 	stack_out when "01101",
			stack_out when "11100",
			stack_out when "11101",
			(OTHERS => '-') when OTHERS;


end Behavioral;

