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
-- Description: PCU Adder.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pcu_adder is
    Port ( clk : in STD_LOGIC;
			  pcu_instr : in  STD_LOGIC_VECTOR (4 downto 0);
           R : in  STD_LOGIC_VECTOR (15 downto 0);
           D : in  STD_LOGIC_VECTOR (15 downto 0);
           PC : in  STD_LOGIC_VECTOR (15 downto 0);
			  CI : in STD_LOGIC;
           S : in  STD_LOGIC_VECTOR (15 downto 0);
			  pcu_out : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end pcu_adder;

architecture Behavioral of pcu_adder is
	signal pcu_drive : std_logic_vector (15 downto 0) := (OTHERS => '0');
begin

with pcu_instr select
	pcu_out <= 	
					-- Low 16
					(OTHERS => '0')	when "00000",
					PC						when "00001",
					R						when "00010",
					D						when "00011",
					R + D					when "00100",
					D + PC				when "00101",
					R + PC 				when "00110",
					S + D					when "00111",
					PC 					when "01000",
					R + D					when "01001",
					PC 					when "01010",
					PC 					when "01011",
					PC 					when "01100",
					S						when "01101",
					PC 					when "01110",
					PC 					when "01111",
					
					-- High 16
					R 						when "10000",
					D 						when "10001",
					(OTHERS => '0')	when "10010",
					R + D					when "10011",
					D + PC 				when "10100",
					R + PC 				when "10101",
					R						when "10110",
					D						when "10111",
					(OTHERS => '0')	when "11000",
					R + D					when "11001",
					D + PC 				when "11010",
					R + PC 				when "11011",
					S						when "11100",
					S + D					when "11101",
					PC						when "11110",
					(OTHERS => 'Z')	when OTHERS;
					


end Behavioral;

