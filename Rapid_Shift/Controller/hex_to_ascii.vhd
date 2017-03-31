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

entity hex_to_ascii is
    Port ( 
			  hex : in  STD_LOGIC_VECTOR (15 downto 0);
           ascii : out  STD_LOGIC_VECTOR (127 downto 0));
end hex_to_ascii;

architecture Behavioral of hex_to_ascii is

	function hex2asc(hex : std_logic_vector(7 downto 0)) return std_logic_vector is
	begin
		return x"30" + hex;
	end hex2asc;
	
begin

--ascii <= ascii_reg;

-- RA = 5241
-- RB = 5242
-- #	= 23
-- ,	= 2C

with hex(15 downto 8) select
	ascii <= x"57414920202020202020202020202020" when x"00",
--				x"4D4F56452023"&hex2asc(hex(7 downto 0))&x"2C524220202020202020" when x"01",
				x"4D4F5645202320202020202020202020" when x"01", -- UPDATE
				x"4D4F5645202320202020202020202020" when x"02",
				x"4D4F5645202020202020202020202020" when x"03",
				x"4D4F5645202320202020202020202020" when x"04",
				x"4D4F5645202020202020202020202020" when x"05",
				x"4D4F5645202020202020202020202020" when x"06",
				x"4D4F5645202020202020202020202020" when x"07",
				x"41444420202020202020202020202020" when x"08",
				x"42434320202020202020202020202020" when x"09",
				x"4D4F5645202020202020202020202020" when x"0A",
				x"53554220202020202020202020202020" when x"0B",
				x"4D4F5645202020202020202020202020" when x"0C",
				x"53554220202020202020202020202020" when x"0D",
				x"414E4420232020202020202020202020" when x"0E",
				x"53554220202020202020202020202020" when x"0F",
				x"41444420202020202020202020202020" when x"10",
				x"41444420202020202020202020202020" when x"11",
				x"50555348202020202020202020202020" when x"13",
				x"41535220232020202020202020202020" when x"15",
				x"41444420202020202020202020202020" when x"17",
				x"44425241202020202020202020202020" when x"18",
				x"4D4F5645202020202020202020202020" when x"19",
				x"4A4D5020202020202020202020202020" when x"1A",
				x"554e4b4e4f574e202020202020202020" when OTHERS;
				
--process (clk)
--begin
--	if (clk'event and clk='0') then
--		case hex is
--			when x"00" => -- WAI
--				ascii_reg <= x"57414920202020202020202020202020";
--			when x"01" =>	-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"02"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"03"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"04"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"05"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"06"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"07"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"08"	=>-- ADD
--				ascii_reg <= x"41444420202020202020202020202020";
--			when x"09" => -- BCC
--				ascii_reg <= x"42434320202020202020202020202020";
--			when x"0A"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"0B"	=>-- SUB
--				ascii_reg <= x"53554220202020202020202020202020";
--			when x"0C"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when x"0D"	=>-- SUB
--				ascii_reg <= x"53554220202020202020202020202020";
--			when x"0E"	=>-- AND
--				ascii_reg <= x"414E4420202020202020202020202020";
--			when x"0F"	=>-- SUB
--				ascii_reg <= x"53554220202020202020202020202020";
--			when x"10"	=>-- ADD
--				ascii_reg <= x"41444420202020202020202020202020";
--			when x"11"	=>-- ADD
--				ascii_reg <= x"41444420202020202020202020202020";
--			when x"13"	=>-- PUSH
--				ascii_reg <= x"50555348202020202020202020202020";
--			when x"15"	=>-- ASR
--				ascii_reg <= x"41535220202020202020202020202020";
--			when x"17"	=>-- ADD
--				ascii_reg <= x"41444420202020202020202020202020";
--			when x"18"	=>-- DBRA
--				ascii_reg <= x"44425241202020202020202020202020";
--			when x"19"	=>-- MOVE
--				ascii_reg <= x"4D4F7464202020202020202020202020";
--			when OTHERS =>	-- UNKNOWN
--				ascii_reg <= x"554e4b4e4f574e202020202020202020";
--		end case;
--	end if;
--end process;


end Behavioral;

