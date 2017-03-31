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
-- Description: PCU Program Counter.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program_counter is
	Port (
		clk : in std_logic;
		reset : in std_logic;
		pc_hold : in std_logic;
		ci : in std_logic;
		pc_in : in std_logic_vector (15 downto 0);
		pc : out std_logic_vector (15 downto 0)
		);
end program_counter;

architecture Behavioral of program_counter is
	signal next_pc: std_logic_vector (15 downto 0) := (OTHERS => '0');
begin

process (clk, reset)
begin
	if (reset = '1') then
		next_pc <= (OTHERS => '0');
	elsif (clk'event and clk='1') then
		if (pc_hold='0') then
			next_pc <= pc_in + ci;
		end if;
	end if;
end process;

pc <= next_pc;

end Behavioral;

