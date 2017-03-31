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
use ieee.numeric_std.all;

entity cursor_controller is
    Port ( clk : in  STD_LOGIC;
           addr_a : in  STD_LOGIC_VECTOR (11 downto 0);
           addr_b : in  STD_LOGIC_VECTOR (11 downto 0);
			  direction : in std_logic_vector(1 downto 0);
           red : out  STD_LOGIC);
end cursor_controller;

architecture Behavioral of cursor_controller is
	signal count : integer := 0;
begin

process (clk)
begin
if (clk'event and clk='1') then
	-- Increment count
	if (count = 50000000) then
		count <= 0;
	else
		count <= count + 1;
	end if;
	
	-- Blink cursor
	if (direction = "00") then
		if ((to_integer(unsigned(addr_a(6 downto 0)))+1) = to_integer(unsigned(addr_b(6 downto 0))) 
				and addr_a(11 downto 7) = addr_b(11 downto 7)
				and count <= 25000000) then
			red <= '1';
		else
			red <= '0';
		end if;
	elsif (direction = "01") then
		if ((to_integer(unsigned(addr_a(6 downto 0)))-1) = to_integer(unsigned(addr_b(6 downto 0))) 
				and addr_a(11 downto 7) = addr_b(11 downto 7)
				and count <= 25000000) then
			red <= '1';
		else
			red <= '0';
		end if;
	elsif (direction = "10") then
		if (addr_a(6 downto 0) = addr_b(6 downto 0) 
				and (to_integer(unsigned(addr_a(11 downto 7)))-1) = to_integer(unsigned(addr_b(11 downto 7)))
				and count <= 25000000) then
			red <= '1';
		else
			red <= '0';
		end if;
	else
		if (addr_a(6 downto 0) = addr_b(6 downto 0) 
				and (to_integer(unsigned(addr_a(11 downto 7)))+1) = to_integer(unsigned(addr_b(11 downto 7)))
				and count <= 25000000) then
			red <= '1';
		else
			red <= '0';
		end if;
	end if;
end if;
end process;

end Behavioral;

