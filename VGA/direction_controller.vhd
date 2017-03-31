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

entity direction_controller is
    Port ( keycode : in  STD_LOGIC_VECTOR (7 downto 0);
           direction : out  STD_LOGIC_VECTOR (1 downto 0);
			  we : out  STD_LOGIC;
           direction_change : out  STD_LOGIC);
end direction_controller;

architecture Behavioral of direction_controller is

begin

with (keycode) select
	we <= '0' when x"6B",
			'0' when x"74",
			'0' when x"72",
			'0' when x"75",
			'0' when x"12",
			'0' when x"54",
			'0' when x"66",
			'0' when x"5A",
			'1' when OTHERS;
			
with keycode select
	direction <= "01" when x"6B",
					 "01" when x"66",
					 "10" when x"75",
					 "11" when x"72",
					 "11" when x"5A",
					 "00" when OTHERS;
				
direction_change <= '0' when (keycode=x"12" or keycode=x"54") else '1';

end Behavioral;

