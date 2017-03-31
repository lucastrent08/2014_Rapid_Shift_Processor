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
-- Description: SSCU CC out control.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sscu_out is
    Port ( sel : in  STD_LOGIC_VECTOR (3 downto 0);
			  yccr : in STD_LOGIC_VECTOR (3 downto 0);
           oe : in  STD_LOGIC;
           cc : out  STD_LOGIC);
end sscu_out;

architecture Behavioral of sscu_out is
	signal cc_drive, cc_drive_pol : std_logic := '0';
begin

with sel(3 downto 1) select
	cc_drive <= (yccr(3) xor yccr(1)) or yccr(2) when "000",
					yccr(3) xor yccr(1) 					when "001",
					yccr(2) 									when "010",
					yccr(1) 									when "011",
					yccr(0) or yccr(2) 					when "100",
					yccr(0) 									when "101",
					not yccr(0) or yccr(2) 				when "110",
					yccr(3) 									when OTHERS;

cc_drive_pol <= not cc_drive when sel(0)='1' else cc_drive;
cc <= cc_drive_pol when oe='0';

end Behavioral;

