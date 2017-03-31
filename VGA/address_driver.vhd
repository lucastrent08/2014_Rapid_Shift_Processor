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

entity address_driver is
    Port ( direction : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
			  enable : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
			  leds : out STD_LOGIC_VECTOR (7 downto 0);
			  cur_y : buffer  STD_LOGIC_VECTOR (4 downto 0);
           cur_x : buffer  STD_LOGIC_VECTOR (6 downto 0));
end address_driver;

architecture Behavioral of address_driver is
begin

process (clk, reset) -- clock only triggered when direction changes
begin
	if (reset = '1') then
		cur_x <= (OTHERS => '0');
		cur_y <= (OTHERS => '0');
	elsif (clk'event and clk='1') then
		if (enable='1') then
			case (direction) is
				when "01" => 	-- Left
					cur_x <= cur_x - '1'; 
				when "10" => 	-- Up
					cur_y <= cur_y - '1';
				when "11" => 	-- Down
					cur_y <= cur_y + '1';
				when OTHERS =>	-- Right	
					cur_x <= cur_x + '1';
			end case;
		end if;
	end if;
end process;

leds <= '0' & cur_x;

end Behavioral;

