----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: S Multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity s_mux is
	Port (  clk : in STD_LOGIC;
			  oe : in STD_LOGIC;
			  sel : in STD_LOGIC_VECTOR (1 downto 0);
			  pc : in  STD_LOGIC_VECTOR (7 downto 0);
           r : in  STD_LOGIC_VECTOR (7 downto 0);
           d : in  STD_LOGIC_VECTOR (7 downto 0);
           f : in STD_LOGIC_VECTOR (7 downto 0);
			  s : out STD_LOGIC_VECTOR (7 downto 0)
			  );
end s_mux;

architecture Behavioral of s_mux is
	signal s_reg, s_drive : std_logic_vector (7 downto 0) := (OTHERS => '0');
begin

s <= s_reg when oe='1' else (OTHERS => '0');

with (sel) select
	s_reg <= pc when "00",
				r	when "01",
				f 	when "10",
				d	when OTHERS;

end Behavioral;

