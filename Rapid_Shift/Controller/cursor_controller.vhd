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

entity cursor_controller is
    Port ( irq3 : in STD_LOGIC;
			  keycode : in  STD_LOGIC_VECTOR (7 downto 0);
			  reset : in STD_LOGIC;
           new_kc : in  STD_LOGIC;
			  write_mem : in STD_LOGIC;
           cursor : out  STD_LOGIC_VECTOR (3 downto 0));
end cursor_controller;

architecture Behavioral of cursor_controller is
	signal cursor_reg : std_logic_vector (3 downto 0) := (OTHERS => '0');
begin

cursor <= cursor_reg when irq3='0' else "1111";

process (new_kc, reset, write_mem)
begin
	if (reset='1' or write_mem='0') then
		cursor_reg <= (OTHERS => '0');
	elsif (new_kc'event and new_kc='1') then
		if (keycode = x"66" and cursor_reg /= "0000") then
			cursor_reg <= cursor_reg - '1';
		elsif (keycode /= x"12" and keycode /= x"59" and keycode /= x"5A" and keycode /= x"66") then
			if (cursor_reg >= "0011") then
				cursor_reg <= "0000";
			else
				cursor_reg <= cursor_reg + '1';
			end if;
		end if;
--	elsif (write_mem='1') then
--		if (keycode /= x"12" and keycode /= x"59" and keycode /= x"5A" and keycode /= x"66") then
--			cursor_reg <= cursor_reg + '1';
--		end if;
		
	end if;
	
end process;

end Behavioral;
