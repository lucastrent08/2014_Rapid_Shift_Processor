----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Stephen Shannon
-- 
-- Create Date:    Spring 2010
-- Module Name:    SSCU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: SSCU CC multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cc_mux is
    Port(sel : in  STD_LOGIC_VECTOR (1 downto 0);
			ccr : in  STD_LOGIC_VECTOR (3 downto 0);
			mccr : in  STD_LOGIC_VECTOR (3 downto 0);
			uccr : in  STD_LOGIC_VECTOR (3 downto 0);
         yccr : out  STD_LOGIC_VECTOR (3 downto 0));
end cc_mux;

architecture Behavioral of cc_mux is

begin

with sel select
	yccr <= mccr when "10",
				ccr when "11",
			  uccr when OTHERS;	

end Behavioral;

