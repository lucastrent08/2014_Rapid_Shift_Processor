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
-- Description: DBB multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dbb_reg is
    Port ( 
           load : in  STD_LOGIC;
			  sel : in  STD_LOGIC;
           da : in  STD_LOGIC_VECTOR (15 downto 0);
           db : in  STD_LOGIC_VECTOR (15 downto 0);
           q : out  STD_LOGIC_VECTOR (15 downto 0)
           );
end dbb_reg;

architecture Behavioral of dbb_reg is
	signal q_drive : std_logic_vector (15 downto 0) := (OTHERS => '0');
begin

q <= q_drive when load='0';

with sel select
	q_drive <= 	da when '1',
					db when OTHERS;

end Behavioral;

