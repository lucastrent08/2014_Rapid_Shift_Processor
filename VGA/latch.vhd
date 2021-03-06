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

entity latch is
	port (clk : in STD_LOGIC;
			input : in STD_LOGIC;
			output : out STD_LOGIC
			);
end latch;

architecture Behavioral of latch is

begin

process (clk)
begin
	if (clk'event and clk='1') then
		output <= input;
	end if;
end process;

end Behavioral;

