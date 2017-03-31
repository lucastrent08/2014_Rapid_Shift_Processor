----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors
-- Department: R&D
-- Engineer: Lucas Trent

-- 
-- Create Date:    3/10/2014
-- Design Name:    Updated CISC Processor
-- Module Name:    Processor Components
-- Project Name:   VGA Controller
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: Selector Switch
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_source_mux is
    Port ( Src : in STD_LOGIC_VECTOR (2 downto 0);
           Q : in  STD_LOGIC_VECTOR (15 downto 0);
			  DA : in  STD_LOGIC_VECTOR (15 downto 0);
           DB : in  STD_LOGIC_VECTOR (15 downto 0);
			  A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
			  R : out  STD_LOGIC_VECTOR (15 downto 0);
           S : out  STD_LOGIC_VECTOR (15 downto 0));
end alu_source_mux;

architecture Behavioral of alu_source_mux is

begin

with (src(2)) select
	R <= 	A when '0',
			DA when OTHERS;

with (src(1 downto 0)) select
	S <= 	B when "00",
			DB when "01",
			Q when OTHERS;


end Behavioral;

