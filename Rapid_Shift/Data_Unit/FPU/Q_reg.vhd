----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: Q register.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Q_reg is
    Port ( clk : in STD_LOGIC;
			  Q : in  STD_LOGIC_VECTOR (15 downto 0);
           F : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_sel : in  STD_LOGIC;
           hold : in  STD_LOGIC;
           Qout : out  STD_LOGIC_VECTOR (15 downto 0));
end Q_reg;

architecture Behavioral of Q_reg is
begin

process (clk, Q_sel)
begin
	if (clk'event and clk='1' and hold='0') then
		if (Q_sel='1') then
			Qout <= Q;
		else
			Qout <= F;
		end if;
	end if;
end process;


end Behavioral;

