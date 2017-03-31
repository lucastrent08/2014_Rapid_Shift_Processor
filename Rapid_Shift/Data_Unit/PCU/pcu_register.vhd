----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Stephen Shannon
-- 
-- Create Date:    Spring 2010
-- Module Name:    PCU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: PCU Register.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pcu_register is
	port (clk : in STD_LOGIC;
			we : in STD_LOGIC;
			input : in STD_LOGIC_VECTOR (15 downto 0);
			output : out STD_LOGIC_VECTOR (15 downto 0)
			);
end pcu_register;

architecture Behavioral of pcu_register is
begin

process (clk)
begin
	if (clk'event and clk='1') then
		if (we = '0') then
			output <= input;
		end if;
	end if;
end process;

end Behavioral;

