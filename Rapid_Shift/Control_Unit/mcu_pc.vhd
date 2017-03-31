----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: CCU Program Counter.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mcu_pc is
	Port (
		clk : in std_logic;
		pc_in : in std_logic_vector (7 downto 0);
		pc : out std_logic_vector (7 downto 0)
		);
end mcu_pc;

architecture Behavioral of mcu_pc is
	signal next_pc : std_logic_vector (7 downto 0) := (OTHERS => '0');
begin

process (clk)
begin
	if (clk'event and clk='1') then
		next_pc <= pc_in + '1';
	end if;
end process;

pc <= next_pc;

end Behavioral;

