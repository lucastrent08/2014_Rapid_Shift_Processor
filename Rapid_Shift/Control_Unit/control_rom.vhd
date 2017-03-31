----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: CCU Control ROM.
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity control_rom is
   port(
      clk: in std_logic;
      address : in std_logic_vector (4 downto 0);
		output : out std_logic_vector (8 downto 0)
   );
end control_rom;

architecture Behavioral of control_rom is
	
	signal output_reg : std_logic_vector (8 downto 0) := (OTHERS => '0');
   type rom_type is array (0 to 2**5-1)
        of std_logic_vector (8 downto 0);
   signal rom: rom_type := (
	"000000000", -- JZ
	"000000000",
	"111110000", -- CJS
	"000010000",
	"110010001", -- JMAP
	"110010001",
	"110010000", -- CJP
	"000010000",
	"001111100", -- PUSH
	"001110000",
	"011110000", -- JSRP
	"111110000",
	"000011110", -- LDIR
	"000011110",
	"010010000", -- JRP
	"110010000",
	"100011000", -- RFPL
	"100011000",
	"000011000", -- RUPL
	"000011000",
	"101010000", -- CRTN
	"000010000",
	"111010000", -- CJPP
	"000011100",
	"000011100", -- LDCT
	"000011100",
	"100010000", -- LOOP
	"000010000",
	"000010000", -- CONT
	"000010000",
	"000011000", -- TWB
	"100011000"
	);
		
begin
	-- read cycle
   process(clk)
   begin
     if (clk'event and clk = '0') then
        output_reg <= rom(to_integer(unsigned(address)));
     end if;
   end process;
	output <= output_reg;
	
--	with address select
--		output <=	"000000000" when "00000", -- JZ
--						"000000000" when "00001",
--						"111110000" when "00010", -- CJS
--						"000010000" when "00011",
--						"110010001" when "00100", -- JMAP
--						"110010001" when "00101",
--						"110010000" when "00110", -- CJP
--						"000010000" when "00111",
--						"001111100" when "01000", -- PUSH
--						"001110000" when "01001",
--						"011110000" when "01010", -- JSRP
--						"111110000" when "01011",
--						"000011110" when "01100", -- LDIR
--						"000011110" when "01101",
--						"010010000" when "01110", -- JRP
--						"110010000" when "01111",
--						"100011000" when "10000", -- RFPL
--						"100011000" when "10001",
--						"000011000" when "10010", -- RUPL
--						"000011000" when "10011",
--						"101010000" when "10100", -- CRTN
--						"000010000" when "10101",
--						"111010000" when "10110", -- CJPP
--						"000011100" when "10111",
--						"000011100" when "11000", -- LDCT
--						"000011100" when "11001",
--						"100010000" when "11010", -- LOOP
--						"000010000" when "11011",
--						"000010000" when "11100", -- CONT
--						"000010000" when "11101",
--						"000011000" when "11110", -- TWB
--						"100011000" when OTHERS;

end Behavioral;
