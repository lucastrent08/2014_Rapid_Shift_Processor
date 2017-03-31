----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: RAM Select.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM_reg is
    Port ( clk : in STD_LOGIC;
			  RAM : in  STD_LOGIC_VECTOR (15 downto 0);
           F : in  STD_LOGIC_VECTOR (15 downto 0);
           RAM_sel : in  STD_LOGIC;
           hold : in  STD_LOGIC;
           RAMout : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end RAM_reg;

architecture Behavioral of RAM_reg is
	signal RAMout_drive : std_logic_vector (15 downto 0);
begin

RAMout <= RAMout_drive when hold='0';
RAMout_drive <= ram when ram_sel='1' else f;

end Behavioral;

