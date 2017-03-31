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
-- Description: Carry control for necessary arithmetic
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CN_Control is
    Port ( CI : in  STD_LOGIC_VECTOR (1 downto 0);
           CO : out  STD_LOGIC);
end CN_Control;

architecture Behavioral of CN_Control is

begin

with (CI) select
	CO <= '0' when "00",
			'1' when "01",
			'-' when OTHERS;
			
end Behavioral;

