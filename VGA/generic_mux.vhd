----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors
-- Department: R&D
-- Engineer: Lucas Trent

-- 
-- Create Date:    3/10/2014
-- Design Name:    Updated CISC Processor
-- Module Name:    text_screen_gen
-- Project Name:   VGA Controller
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: Drives the cursor (write address)
-- 	based on the keys pressed on the PS/2 keyboard.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity generic_mux is
	generic (n: integer := 3);
	Port (inp: IN STD_LOGIC_VECTOR (0 to (2**n)-1);
			sel: IN STD_LOGIC_VECTOR (n-1 downto 0);
			output: OUT STD_LOGIC);
end generic_mux;

architecture Behavioral of generic_mux is
begin
	output <= inp(conv_integer(sel));
end Behavioral;
