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
-- Description: Internal Data Bus multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity idb_mux is
	Port (
			sel : in std_logic_vector (2 downto 0);
			dbb : in std_logic_vector (15 downto 0);
			alu : in std_logic_vector (15 downto 0);
			pcu : in std_logic_vector (15 downto 0);
			ccr : in std_logic_vector (3 downto 0);
			pl : in std_logic_vector (15 downto 0);
			ir : in std_logic_vector (15 downto 0);
			IDB : out std_logic_vector (15 downto 0)
	);
end idb_mux;

architecture Behavioral of idb_mux is
begin

with sel select
	idb <= dbb 														when "000",
			 alu 														when "001",
			 pcu 														when "010",
			 "000000000000" & ccr 								when "011",
			 pl 														when "100",
			 x"00" & (ir(7 downto 0) AND pl(7 downto 0))	when "101",
			 (OTHERS => '1') 										when "110",
			 (OTHERS => '0') 										when OTHERS;

end Behavioral;

