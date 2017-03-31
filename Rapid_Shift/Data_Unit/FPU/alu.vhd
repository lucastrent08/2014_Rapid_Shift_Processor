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
-- Description: Arithmetic Logic Unit
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
---------------------------------------
entity alu is
	 
    Port ( S	: in 	STD_LOGIC_VECTOR(15 downto 0);	-- Input 1
			  R	: in 	STD_LOGIC_VECTOR(15 downto 0);	-- Input 2
			  CIN : in  STD_LOGIC;								-- Carry In
           SEL : in  STD_LOGIC_VECTOR (3 downto 0);	-- Select ALU Operation
			  CCR : out STD_LOGIC_VECTOR (3 downto 0);	-- Condition Codes (N,Z,V,C)
           F : out  STD_LOGIC_VECTOR (15 downto 0));	-- Output
end alu;
---------------------------------------
architecture Behavioral of alu is
	signal arith: STD_LOGIC_VECTOR (16 downto 0) := (OTHERS => '0'); 	-- Holds results of arithmetic blocks
	signal logic: STD_LOGIC_VECTOR (15 downto 0) := (OTHERS => '0');	-- Holds results of logical blocks
	signal ccr_temp: STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');	-- Holds condition code register
	signal S2, R2: STD_LOGIC_VECTOR (16 downto 0) := (OTHERS => '0');
begin

	-- Test bench doesn't like when dimensions don't match up
	S2 <= '0' & S;
	R2 <= '0' & R;

	----- Arithmetic Unit: -----
	with sel(2 downto 0) select
		arith <=	"11111111111111111"	when "000",	-- HIGH
					S2 - R2 - 1 + CIN		when "001",	-- SRS
					R2 - S2 - 1 + CIN		when "010",	-- SSR
					R2 + S2 + CIN			when "011",	-- ADD
					S2 + CIN			when "100", -- PAS
					not S2 + CIN					when "101",	-- COMS
					R2 + CIN 				when "110",	-- PAR
					not R2 + CIN			when OTHERS;-- PARS
	----- End Arithmetic Unit -----
	
	----- Logic unit: -----
	with sel(2 downto 0) select
		logic <=	(OTHERS => '0')	when "000",		-- LOW
					not R and S			when "001",		-- CRAS
					R xnor S				when "010",		-- XNRS
					R xor S				when "011",		-- XOR
					R and S				when "100",		-- AND
					R nor S				when "101",		-- NOR
					R nand S				when "110",		-- NAND
					R or S				when OTHERS;	-- OR
	----- End Logic Unit -----
	
	----- Set Condition Code Register: -----
	ccr_temp(3) <= arith(15);
	ccr_temp(2) <= '1' when arith(15 downto 0)="0000000000000000" else '0';
	ccr_temp(1) <= arith(16) xor arith(15);
	ccr_temp(0) <= arith(16);
	
	with sel(3) select
		F <= arith(15 downto 0) when '0',
			  logic when OTHERS;
	
	with sel(3) select
		ccr <= ccr_temp when '0',
				 "0000" when OTHERS;
							
	----- End Set Condition Code Register -----

end Behavioral;
---------------------------------------
