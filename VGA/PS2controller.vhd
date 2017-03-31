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

entity PS2controller is
    Port ( reset : in  STD_LOGIC;
           ps2_clk : in  STD_LOGIC;
           ps2_data : in  STD_LOGIC;
           keycode : out  STD_LOGIC_VECTOR (7 downto 0);
			  valid : out STD_LOGIC);
end PS2controller;

architecture Behavioral of PS2controller is

type state_type is (s_start, s_d0, s_d1, s_d2, s_d3, s_d4, s_d5, s_d6, s_d7, 
		s_parity, s_stop);  
signal state : state_type;
begin
	FSM: process (PS2_Clk, reset)
	begin
		if (reset = '1') then
			state <= s_start;
		-- this FSM is driven by the keyboard clock signal
		elsif (PS2_CLK'EVENT and PS2_CLK = '1') then
			case state is
			when s_start =>
				state <= s_d0;
			when s_d0 =>
				state <= s_d1;
			when s_d1 =>
				state <= s_d2;
			when s_d2 =>
				state <= s_d3;
			when s_d3 =>
				state <= s_d4;
			when s_d4 =>
				state <= s_d5;
			when s_d5 =>
				state <= s_d6;
			when s_d6 =>
				state <= s_d7;
			when s_d7 =>
				state <= s_parity;
			when s_parity =>
				state <=s_stop;
			when s_stop =>
				state <=s_start;
			when others =>
			end case;
		end if;
	end process;

	output_logic: process (state, PS2_Data)
	begin
		case state is
		when s_d0 =>
			keycode(0) <= PS2_Data; -- read in bit 0 from keyboard
		when s_d1 =>
			keycode(1) <= PS2_Data; -- read in bit 1 from keyboard
		when s_d2 =>
			keycode(2) <= PS2_Data; -- read in bit 2 from keyboard
		when s_d3 =>
			keycode(3) <= PS2_Data; -- read in bit 3 from keyboard
		when s_d4 =>
			keycode(4) <= PS2_Data; -- read in bit 4 from keyboard
		when s_d5 =>
			keycode(5) <= PS2_Data; -- read in bit 5 from keyboard
		when s_d6 =>
			keycode(6) <= PS2_Data; -- read in bit 6 from keyboard
		when s_d7 =>
			keycode(7) <= PS2_Data; -- read in bit 7 from keyboard
		when others =>
		end case;
	end process;
	
	valid <= '1' when state = s_stop else '0';
end Behavioral;


