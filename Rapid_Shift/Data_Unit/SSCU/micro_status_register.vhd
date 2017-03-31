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
-- Description: SSCU micro status register and multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity micro_status_register is
    Port (
			clk : in std_logic;
			en : in std_logic;
			sscu_instr : in std_logic_vector (5 downto 0);
			ccr : in std_logic_vector (3 downto 0);
			mccr : in std_logic_vector (3 downto 0);
			uccr : out std_logic_vector (3 downto 0)
			);
end micro_status_register;

architecture Behavioral of micro_status_register is
	signal uccr_reg : std_logic_vector (3 downto 0) := (OTHERS => '0');
begin

uccr <= uccr_reg when en='0';

-- Set condition codes
-- Order: NZVC
-- 		 3210
process (clk)
begin
	if (clk'event and clk='1') then
		case sscu_instr is
		
			-- Bit Operations
			when O"10" =>
				uccr_reg(2) <= '0';
			when O"11" =>
				uccr_reg(2) <= '1';
			when O"12" =>
				uccr_reg(0) <= '0';
			when O"13" =>
				uccr_reg(0) <= '1';
			when O"14" =>
				uccr_reg(3) <= '0';
			when O"15" =>
				uccr_reg(3) <= '1';
			when O"16" =>
				uccr_reg(1) <= '0';
			when O"17" =>
				uccr_reg(1) <= '1';
				
			-- Register Operations
			when O"00" =>
				uccr_reg <= mccr;
			when O"01" =>
				uccr_reg <= (OTHERS => '1');
			when O"02" =>
				uccr_reg <= mccr;
			when O"03" =>
				uccr_reg <= (OTHERS => '0');
				
			-- Load Operations
			
			-- Load with overflow retain
			when O"06" =>
				uccr_reg(3) <= ccr(3);
				uccr_reg(2) <= ccr(2);
				uccr_reg(1) <= ccr(1) or uccr_reg(1);
				uccr_reg(0) <= ccr(0);
			when O"07" =>
				uccr_reg(3) <= ccr(3);
				uccr_reg(2) <= ccr(2);
				uccr_reg(1) <= ccr(1) or uccr_reg(1);
				uccr_reg(0) <= ccr(0);
			-- Load with carry invert
			when O"30" =>
				uccr_reg(3) <= ccr(3);
				uccr_reg(2) <= ccr(2);
				uccr_reg(1) <= ccr(1);
				uccr_reg(0) <= not ccr(0);
			when O"31" =>
				uccr_reg(3) <= ccr(3);
				uccr_reg(2) <= ccr(2);
				uccr_reg(1) <= ccr(1);
				uccr_reg(0) <= not ccr(0);
			when O"50" =>
				uccr_reg(3) <= ccr(3);
				uccr_reg(2) <= ccr(2);
				uccr_reg(1) <= ccr(1);
				uccr_reg(0) <= not ccr(0);
			when O"51" =>
				uccr_reg(3) <= ccr(3);
				uccr_reg(2) <= ccr(2);
				uccr_reg(1) <= ccr(1);
				uccr_reg(0) <= not ccr(0);
			when O"70" =>
				uccr_reg(3) <= ccr(3);
				uccr_reg(2) <= ccr(2);
				uccr_reg(1) <= ccr(1);
				uccr_reg(0) <= not ccr(0);
			when O"71" =>
				uccr_reg(3) <= ccr(3);
				uccr_reg(2) <= ccr(2);
				uccr_reg(1) <= ccr(1);
				uccr_reg(0) <= not ccr(0);
			-- Load directly from I bits
			when OTHERS =>
				uccr_reg <= ccr;
		end case;
	end if;
end process;


end Behavioral;

