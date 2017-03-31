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
-- Description: Drives the cursor (write address)
-- 	based on the keys pressed on the PS/2 keyboard.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_controller is
    Port ( clk : in STD_LOGIC;
			  write_mem : in  STD_LOGIC;
           new_kc : in  STD_LOGIC;
			  cursor : in std_logic_vector (3 downto 0);
           ascii : in  STD_LOGIC_VECTOR (7 downto 0);
           instruction : out  STD_LOGIC_VECTOR (31 downto 0));
end instruction_controller;

architecture Behavioral of instruction_controller is
	signal cur_instr, next_instr : std_logic_vector (31 downto 0) := x"20202020";
begin

instruction <= next_instr;

process (write_mem, new_kc)
begin
	if (new_kc'event and new_kc='1') then
		case cursor is
			when "0000" => next_instr(31 downto 24) 	<= ascii;
			when "0001" => next_instr(23 downto 16) 	<= ascii;
			when "0010" => next_instr(15 downto 8) 	<= ascii;
			when "0011" => next_instr(7 downto 0) 		<= ascii;
			when OTHERS => null;
		end case;
	end if;
end process;

end Behavioral;

