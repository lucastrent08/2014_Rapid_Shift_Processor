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

entity rgb_reg is
    Port ( rgb_next : in  STD_LOGIC;
           pixel_tick : in  STD_LOGIC;
           green : out  STD_LOGIC);
end rgb_reg;

architecture Behavioral of rgb_reg is
begin

	process (pixel_tick)
	begin
		if (pixel_tick'event and pixel_tick='1') then
			if (rgb_next = '1') then
				green <= '1';
			else
				green <= '0';
			end if;
		end if;
	
	end process;

end Behavioral;

