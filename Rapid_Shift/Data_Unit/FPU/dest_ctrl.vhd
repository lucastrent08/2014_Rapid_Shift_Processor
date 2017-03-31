-----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors
-- Department: R&D
-- Engineer: Lucas Trent

-- 
-- Create Date:    3/10/2014
-- Design Name:    Updated CISC Processor
-- Module Name:    CPU
-- Project Name:   CPU Specifics
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: Stores data-values at temporary memory locations
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dest_ctrl is
    Port ( dest : in  STD_LOGIC_VECTOR (3 downto 0);
           we : out  STD_LOGIC;
           q_sel : out  STD_LOGIC;
			  ram_sel : out  STD_LOGIC;
			  q_hold : out  STD_LOGIC;
           ram_hold : out  STD_LOGIC);
end dest_ctrl;

architecture Behavioral of dest_ctrl is

begin

with (dest) select
	we <= '0' when "1111",
			'1' when OTHERS;

with (dest) select
	q_hold <= '1' when "0000",
				 '1' when "0001",
				 '1' when "0100",
				 '1' when "1000",
				 '1' when "1001",
				 '1' when "1100",
				 '1' when "1110",
				 '1' when "1111",
				 '0' when OTHERS;
				 
with (dest) select
	ram_hold <= '1' when "0101",
					'1' when "0110",
					'1' when "1100",
					'1' when "1101",
					'0' when OTHERS;
				 
with (dest) select
	q_sel <=  '0' when "0110",
				 '0' when "0111",
				 '1' when OTHERS;
				 
with (dest) select
	ram_sel <=  '0' when "0100",
					'0' when "0111",
					'0' when "1111", 
					'1' when OTHERS;


end Behavioral;

