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
-- Description: Generic Regsiter on Falling Edge
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_falling is
	generic (n: natural := 8);
	port (clk : in STD_LOGIC;
			input : in STD_LOGIC_VECTOR (n-1 downto 0);
			output : out STD_LOGIC_VECTOR (n-1 downto 0)
			);
end reg_falling;

architecture Behavioral of reg_falling is

begin

process (clk)
begin
	if (clk'event and clk='1') then
		output <= input;
	end if;
end process;

end Behavioral;

