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
-- Description: Drives the LCD screen of the Spartan 3
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.data_types.all;

entity lcd_driver is
	Port (clk : in STD_LOGIC;
			irq0 : in STD_LOGIC;
			irq3 : in STD_LOGIC;
			ascii : in std_logic_vector (127 downto 0);
			address : in std_logic_vector (7 downto 0);
			mdr : in std_logic_vector (15 downto 0);
			line1 : out ascii_array (0 to 15);
			line2 : out ascii_array (0 to 15)
			);
end lcd_driver;

architecture Behavioral of lcd_driver is
	
begin
	
	line1(0)	 <= to_bitvector(ascii(127 downto 120))	when irq0='0' else x"52";
	line1(1)	 <= to_bitvector(ascii(119 downto 112))	when irq0='0' else x"55";
	line1(2)	 <= to_bitvector(ascii(111 downto 104))	when irq0='0' else x"4E";
	line1(3)	 <= to_bitvector(ascii(103 downto 96))		when irq0='0' else x"20";
	line1(4)	 <= to_bitvector(ascii(95 downto 88)) 	when irq3='1' else x"20";
	line1(5)	 <= to_bitvector(ascii(87 downto 80)) 	when irq3='1' else x"20";
	line1(6)	 <= to_bitvector(ascii(79 downto 72)) 	when irq3='1' else x"20";
	line1(7)	 <= to_bitvector(ascii(71 downto 64)) 	when irq3='1' else x"20";
	line1(8)	 <= to_bitvector(ascii(63 downto 56)) 	when irq3='1' else x"20";
	line1(9)	 <= to_bitvector(ascii(55 downto 48)) 	when irq3='1' else x"20";
	line1(10) <= to_bitvector(ascii(47 downto 40)) 	when irq3='1' else x"20";
	line1(11) <= to_bitvector(ascii(39 downto 32)) 	when irq3='1' else x"20";
	line1(12) <= to_bitvector(ascii(31 downto 24)) 	when irq3='1' else x"20";
	line1(13) <= to_bitvector(ascii(23 downto 16)) 	when irq3='1' else x"20";
	line1(14) <= to_bitvector(ascii(15 downto 8)) 	when irq3='1' else x"20";
	line1(15) <= to_bitvector(ascii(7 downto 0)) 	when irq3='1' else x"20";
	
	line2(2) <= x"20";
	line2(7 to 15) <= ((x"20"), (x"20"), (x"20"), (x"20"), (x"20"), 
							 (x"20"), (x"20"), (x"20"), (x"20"));
	
	with address(7 downto 4) select
		line2(0) <= 	x"30" when "0000",
							x"31" when "0001",
							x"32" when "0010",
							x"33" when "0011",
							x"34" when "0100",
							x"35" when "0101",
							x"36" when "0110",
							x"37" when "0111",
							x"38" when "1000",
							x"39" when "1001",
							x"41" when "1010",
							x"42" when "1011",
							x"43" when "1100",
							x"44" when "1101",
							x"45" when "1110",
							x"46" when OTHERS;
							
		with address(3 downto 0) select
		line2(1) <= 	x"30" when "0000",
							x"31" when "0001",
							x"32" when "0010",
							x"33" when "0011",
							x"34" when "0100",
							x"35" when "0101",
							x"36" when "0110",
							x"37" when "0111",
							x"38" when "1000",
							x"39" when "1001",
							x"41" when "1010",
							x"42" when "1011",
							x"43" when "1100",
							x"44" when "1101",
							x"45" when "1110",
							x"46" when OTHERS;
							
		with mdr(15 downto 12) select
		line2(3) <= 	x"30" when "0000",
							x"31" when "0001",
							x"32" when "0010",
							x"33" when "0011",
							x"34" when "0100",
							x"35" when "0101",
							x"36" when "0110",
							x"37" when "0111",
							x"38" when "1000",
							x"39" when "1001",
							x"41" when "1010",
							x"42" when "1011",
							x"43" when "1100",
							x"44" when "1101",
							x"45" when "1110",
							x"46" when OTHERS;
							
		with mdr(11 downto 8) select
		line2(4) <= 	x"30" when "0000",
							x"31" when "0001",
							x"32" when "0010",
							x"33" when "0011",
							x"34" when "0100",
							x"35" when "0101",
							x"36" when "0110",
							x"37" when "0111",
							x"38" when "1000",
							x"39" when "1001",
							x"41" when "1010",
							x"42" when "1011",
							x"43" when "1100",
							x"44" when "1101",
							x"45" when "1110",
							x"46" when OTHERS;
							
		with mdr(7 downto 4) select
		line2(5) <= 	x"30" when "0000",
							x"31" when "0001",
							x"32" when "0010",
							x"33" when "0011",
							x"34" when "0100",
							x"35" when "0101",
							x"36" when "0110",
							x"37" when "0111",
							x"38" when "1000",
							x"39" when "1001",
							x"41" when "1010",
							x"42" when "1011",
							x"43" when "1100",
							x"44" when "1101",
							x"45" when "1110",
							x"46" when OTHERS;
							
		with mdr(3 downto 0) select
		line2(6) <= 	x"30" when "0000",
							x"31" when "0001",
							x"32" when "0010",
							x"33" when "0011",
							x"34" when "0100",
							x"35" when "0101",
							x"36" when "0110",
							x"37" when "0111",
							x"38" when "1000",
							x"39" when "1001",
							x"41" when "1010",
							x"42" when "1011",
							x"43" when "1100",
							x"44" when "1101",
							x"45" when "1110",
							x"46" when OTHERS;
							
end Behavioral;

