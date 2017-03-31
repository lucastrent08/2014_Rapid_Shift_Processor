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

package data_types is
	constant m: integer := 1;
	type vector_array is array (natural range <>) of 
		STD_LOGIC_VECTOR(m-1 downto 0);
end data_types;
