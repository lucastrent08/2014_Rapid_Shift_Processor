----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- 
-- Create Date:    Spring 2016
-- Module Name:    CISC04 Controller
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: ASCII to Hex converter.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ascii_to_hex is
    Port ( ascii : in  STD_LOGIC_VECTOR (31 downto 0);
           hex : out  STD_LOGIC_VECTOR (15 downto 0));
end ascii_to_hex;

architecture Behavioral of ascii_to_hex is
	
	function asc2hex(asc : std_logic_vector(7 downto 0)) return std_logic_vector is
	begin
		if (asc >= x"40") then
			return asc - x"31";
		else
			return asc - x"30";
		end if;
	end asc2hex;
	
begin

hex(15 downto 12) <= asc2hex(ascii (31 downto 24)) when ascii(31 downto 24) 	/= x"20202020";
hex(11 downto 8) 	<= asc2hex(ascii (23 downto 16)) when ascii(23 downto 16) 	/= x"20202020";
hex(7 downto 4) 	<= asc2hex(ascii (15 downto 8)) 	when ascii(15 downto 8) 	/= x"20202020";
hex(3 downto 0) 	<= asc2hex(ascii (7 downto 0)) 	when ascii(7 downto 0) 		/= x"20202020";	

end Behavioral;

