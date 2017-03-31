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
-- Description: SSCU macro status register and multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity macro_status_register is
    Port (
			clk : in std_logic;
			en : in std_logic;
			sscu_instr : in std_logic_vector (5 downto 0);
			ccr : in std_logic_vector (3 downto 0);
			uccr : in std_logic_vector (3 downto 0);
			yccr : in std_logic_vector (3 downto 0);
			mccr : buffer std_logic_vector (3 downto 0)
			);
end macro_status_register;

architecture Behavioral of macro_status_register is
	signal mccr_reg : std_logic_vector (3 downto 0) := (OTHERS => '0');
begin

mccr <= mccr_reg when en='0';

-- Set condition codes
-- Order: NZVC
-- 		 3210
process (clk, mccr)
	variable mccr_temp : std_logic_vector (3 downto 0);
begin
	mccr_temp := mccr;
	if (clk'event and clk='1') then
		case sscu_instr is
							
			-- Register Operations
			when O"00" =>
				mccr_reg <= yccr;
			when O"01" =>
				mccr_reg <= (OTHERS => '1');
			when O"02" =>
				mccr_reg <= uccr;
			when O"03" =>
				mccr_reg <= (OTHERS => '0');
			when O"05" =>
				mccr_reg <= not mccr_reg;
				
			-- Load Operations
			
			-- Load for shift through overflow
			when O"04" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= mccr_temp(0);
				mccr_reg(0) <= mccr_temp(1);
			-- Load with carry invert
			when O"10" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
			when O"11" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
			when O"30" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
			when O"31" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
			when O"50" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
			when O"51" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
			when O"70" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
			when O"71" =>
				mccr_reg(3) <= ccr(3);
				mccr_reg(2) <= ccr(2);
				mccr_reg(1) <= ccr(1);
				mccr_reg(0) <= not ccr(0);
			
			-- Load directly from I bits
			when OTHERS =>
				mccr_reg <= ccr;
		end case;
	end if;
end process;


end Behavioral;

