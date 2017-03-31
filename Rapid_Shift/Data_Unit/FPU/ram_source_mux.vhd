----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: RAM source multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram_source_mux is
    Port ( PL : in  STD_LOGIC_VECTOR (7 downto 0);
           IR : in  STD_LOGIC_VECTOR (7 downto 0);
           BS : in  STD_LOGIC;
           AS : in  STD_LOGIC;
           AADR : out  STD_LOGIC_VECTOR (3 downto 0);
           BADR : out  STD_LOGIC_VECTOR (3 downto 0));
end ram_source_mux;

architecture Behavioral of ram_source_mux is

begin
	with (AS) select
		AADR <= 	IR(3 downto 0) when '0',
					PL(3 downto 0) when OTHERS;
					
	with (BS) select
		BADR <= 	IR(7 downto 4) when '0',
					PL(7 downto 4) when OTHERS;

end Behavioral;

