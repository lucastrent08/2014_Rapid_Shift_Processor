----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: Y Multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity y_mux is
    Port ( 
			  sel : in STD_LOGIC_VECTOR (1 downto 0);
			  pl : in  STD_LOGIC_VECTOR (7 downto 0);
           map_in : in  STD_LOGIC_VECTOR (7 downto 0);
           ir : in  STD_LOGIC_VECTOR (7 downto 0);
           idb : in  STD_LOGIC_VECTOR (7 downto 0);
           y_out : out  STD_LOGIC_VECTOR (7 downto 0));
end y_mux;

architecture Behavioral of y_mux is
begin

with (sel) select
	y_out <= pl 		when "00",
				map_in 	when "01",
				ir 		when "10",
				idb 		when OTHERS;
				
end Behavioral;

