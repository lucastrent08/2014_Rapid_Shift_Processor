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

entity kb_monitor is
    Port ( 
			  clk : in STD_LOGIC;								-- Clock
			  reset : in STD_LOGIC;								-- Asynchronous Reset
			  keycode : in  STD_LOGIC_VECTOR (7 downto 0);
			  write_mem : out STD_LOGIC;
			  new_kc : out STD_LOGIC;
			  keycode_out : out STD_LOGIC_VECTOR (7 downto 0);
           ascii : out  STD_LOGIC_VECTOR (6 downto 0));
end kb_monitor;

architecture Behavioral of kb_monitor is

type states is (init, read_break, read_keycode);
signal state : states := init;
signal ascii_temp, ascii_temp_shift : STD_LOGIC_VECTOR (6 downto 0) := (OTHERS => '0');
signal shift_pressed : STD_LOGIC := '0';
signal enter_pressed : STD_LOGIC := '1';

begin

with keycode select
	ascii_temp <=
		"1100001" when x"1C",	-- a
		"1100010" when x"32",	-- b
		"1100011" when x"21",	-- c
		"1100100" when x"23",	-- d
		"1100101" when x"24",	-- e
		"1100110" when x"2B",	-- f
		"1100111" when x"34",	-- g
		"1101000" when x"33",	-- h
		"1101001" when x"43",	-- i
		"1101010" when x"3B",	-- j
		"1101011" when x"42",	-- k
		"1101100" when x"4B",	-- l
		"1101101" when x"3A",	-- m
		"1101110" when x"31",	-- n
		"1101111" when x"44",	-- o
		"1110000" when x"4D",	-- p
		"1110001" when x"15",	-- q
		"1110010" when x"2D",	-- r
		"1110011" when x"1B",	-- s
		"1110100" when x"2C",	-- t
		"1110101" when x"3C",	-- u
		"1110110" when x"2A",	-- v
		"1110111" when x"1D",	-- w
		"1111000" when x"22",	-- x
		"1111001" when x"35",	-- y
		"1111010" when x"1A",	-- z
		
		"1100000" when x"0E",	-- `
		"0110000" when x"45",	-- 0
		"0110001" when x"16",	-- 1
		"0110010" when x"1E",	-- 2
		"0110011" when x"26",	-- 3
		"0110100" when x"25",	-- 4
		"0110101" when x"2E",	-- 5
		"0110110" when x"36",	-- 6
		"0110111" when x"3D",	-- 7
		"0111000" when x"3E",	-- 8
		"0111001" when x"46",	-- 9
		"0101101" when x"4E",	-- -
		"0111101" when x"55",	-- =
		"1011100" when x"5D",	-- \
		"0010000" when x"29",	-- Space
--		"1000010" when x"66",	-- Backspace (B)
		
--		"1000101" when x"76",	-- Esc (E)
--		"0110001" when x"05",	-- F1 (1)
--		"0110010" when x"06",	-- F2 (2)
--		"0110011" when x"04",	-- F3 (3)
--		"0110100" when x"0C",	-- F4 (4)
--		"0110101" when x"03",	-- F5 (5)
--		"0110110" when x"0B",	-- F6 (6)
--		"0110111" when x"83",	-- F7 (7)
--		"0111000" when x"0A",	-- F8 (8)
--		"0111001" when x"01",	-- F9 (9)
--		"0110000" when x"09",	-- F10 (0)
--		"0110001" when x"78",	-- F11 (1)
--		"0110010" when x"07",	-- F12 (2)
		
--		"1010100" when x"0D",	-- Tab (T)
--		"1000011" when x"58",	-- Caps Lock (C)
--		"1000011" when x"14",	-- Ctrl (C)
--		"1000001" when x"11",	-- Alt (A)
--		"1000101" when x"5A",	-- Enter (E)
--		
--		"1010101" when x"75",	-- Up (U)
--		"1000100" when x"72",	-- Down (D)
--		"1001100" when x"6B",	-- Left (L)
--		"1010010" when x"74",	-- Right (R)
		
		"1011011" when x"54",	-- [
		"1011101" when x"5B",	-- ]
		"0111011" when x"4C",	-- ;
		"0100111" when x"52",	-- '
		"0101100" when x"41",	-- ,
		"0101110" when x"49",	-- .
		"0101111" when x"4A",	-- /
		
		"0000000" when OTHERS; -- Null
		
with keycode select
	ascii_temp_shift <=
		"1000001" when x"1C",	-- A
		"1000010" when x"32",	-- B
		"1000011" when x"21",	-- C
		"1000100" when x"23",	-- D
		"1000101" when x"24",	-- E
		"1000110" when x"2B",	-- F
		"1000111" when x"34",	-- G
		"1001000" when x"33",	-- H
		"1001001" when x"43",	-- I
		"1001010" when x"3B",	-- J
		"1001011" when x"42",	-- K
		"1001100" when x"4B",	-- L
		"1001101" when x"3A",	-- M
		"1001110" when x"31",	-- N
		"1001111" when x"44",	-- O
		"1010000" when x"4D",	-- P
		"1010001" when x"15",	-- Q
		"1010010" when x"2D",	-- R
		"1010011" when x"1B",	-- S
		"1010100" when x"2C",	-- T
		"1010101" when x"3C",	-- U
		"1010110" when x"2A",	-- V
		"1010111" when x"1D",	-- W
		"1011000" when x"22",	-- X
		"1011001" when x"35",	-- Y
		"1011010" when x"1A",	-- Z
		
		"1111110" when x"0E",	-- ~
		"0100001" when x"16",	-- !
		"1000000" when x"1E",	-- @
		"0100011" when x"26",	-- #
		"0100100" when x"25",	-- $
		"0100101" when x"2E",	-- %
		"1011110" when x"36",	-- ^
		"0100110" when x"3D",	-- &
		"0101010" when x"3E",	-- *
		"0101000" when x"46",	-- (
		"0101001" when x"45",	-- )
		"1011111" when x"4E",	-- _
		"0101011" when x"55",	-- +
		"1111100" when x"5D",	-- |
		
		"1111011" when x"54",	-- {
		"1111101" when x"5B",	-- }
		"0111010" when x"4C",	-- :
		"0100010" when x"52",	-- "
		"0111100" when x"41",	-- <
		"0111110" when x"49",	-- >
		"0111111" when x"4A",	-- ?
		
		"0000000" when OTHERS; -- Null
		
write_mem <= enter_pressed;
		
get_char: process (reset, keycode, clk)
begin

	if (reset = '1') then
			state <= init;
	elsif (CLK'EVENT and CLK = '1') then
		case state is
			when init =>
				if (keycode/=x"12" and keycode/=x"59" and keycode/=x"5A"
						and keycode/=x"E0" and keycode/=x"F0") then
					new_kc <= '0';
				end if;
			
				if keycode=x"E0" then
					state <= init;
				elsif keycode=x"F0" then
					state <= read_keycode;
				else
					state <= read_break;
				end if;
				
				-- Shift press
				if (keycode=x"12" or keycode=x"59") then
					shift_pressed <= '1';
				end if;
				
				if (keycode=x"5A") then
					enter_pressed <= '0';
				else
					enter_pressed <= '1';
				end if;
				
			when read_break =>
				if keycode=x"F0" then
					state <= read_keycode;
				elsif keycode=x"E0" then
					state <= read_break;
				else
					state <= init;
				end if;
			when read_keycode =>
				state <= init;
				-- Shift release
				if (keycode=x"12" or keycode=x"59") then
					shift_pressed <= '0';
				elsif (keycode=x"5A") then
					enter_pressed <= '1';
				else 
					if shift_pressed = '1' then
						ascii <= ascii_temp_shift(6 downto 0);
					else
						ascii <= ascii_temp(6 downto 0);
					end if;
					
					if (ascii_temp_shift /= x"00" or ascii_temp /= x"00" or keycode=x"66") then
						new_kc <= '1';
					end if;
				end if;
				
				keycode_out <= keycode;
				
			when OTHERS =>
		end case;
	end if;
end process get_char;

end Behavioral;

