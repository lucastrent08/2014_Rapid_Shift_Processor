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
-- Description: Instruction register.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ir_reg is
    Port ( clk : in  STD_LOGIC;
           load : in  STD_LOGIC;
           da : in  STD_LOGIC_VECTOR (15 downto 0);
           q : out  STD_LOGIC_VECTOR (15 downto 0)
           );
end ir_reg;

architecture Behavioral of ir_reg is
	signal ir_drive : std_logic_vector (15 downto 0) := (OTHERS => '0');
begin

process (clk)
begin
	if (clk'event and clk='1') then
		ir_drive <= da;
	end if;
end process;

q <= ir_drive when load='0';

end Behavioral;

