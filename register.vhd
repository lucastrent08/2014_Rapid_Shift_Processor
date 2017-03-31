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

entity reg is
	generic (n: natural := 8);
	port (clk : in STD_LOGIC;
			input : in STD_LOGIC_VECTOR (n-1 downto 0);
			output : out STD_LOGIC_VECTOR (n-1 downto 0)
			);
end reg;

architecture Behavioral of reg is

begin

process (clk)
begin
	if (clk'event and clk='1') then
		output <= input;
	end if;
end process;

end Behavioral;

