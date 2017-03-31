----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: CCU Map ROM.
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity map_rom is
   port(
      clk: in std_logic;
		reset: in std_logic;
      address : in std_logic_vector (4 downto 0);
		output : out std_logic_vector (7 downto 0)
   );
end map_rom;

architecture Behavioral of map_rom is
	
	signal output_reg : std_logic_vector (7 downto 0) := (OTHERS => '0');
   type rom_type is array (0 to 2**5-1)
        of std_logic_vector (7 downto 0);
   signal rom: rom_type := (
	x"04", -- 00 WAI	
	x"10", -- 01 MOVE	#N, RB
	x"14", -- 02 MOVE	#NNNN, RB
	x"18", -- 03 MOVE	RA, (RB)
	x"20", -- 04 MOVE	#NNNN, (RA,RB)
	x"28", -- 05 MOVE	RA, -(SP)
	x"30", -- 06 MOVE	(SP)+, RB
	x"38", -- 07 MOVE	RA, @(RB)
	x"00", -- 08 ADD	NNNN, RB
	x"00", -- 09 MOVE	RA, RB
	x"08", -- 0A BCC	*+NNNN
	x"0C", -- 0B SUB	#N, RB
	x"5C", -- 0C MOVE #N, (RB)
	x"0A", -- 0D SUB	RA, RB
	x"68", -- 0E AND	#NNNN, RB
	x"6C", -- 0F SUB	(RA), RB
	x"70", -- 10 ADD	RA, NNNN
	x"80", -- 11 ADD	(RA), (RB)
	x"00", -- 12
	x"8C", -- 13 PUSH	(RA)
	x"00", -- 14
	x"90", -- 15 ASR	#N, RB
	x"00", -- 16	
	x"54", -- 17 ADD	RA, RB
	x"A0", -- 18 DBRA	RB, NNNN
	x"A2", -- 19 MOVE	RB, NNNN
	x"A6", -- 1A JMP	NNNN
	x"A7", -- 1B INC	RB
	x"00", -- 1C
	x"00", -- 1D
	x"00", -- 1E
	x"00" -- 1F
		);
begin
	-- read cycle
   process(clk, reset)
   begin
	  if (reset = '1') then
		  output_reg <= x"00";
     elsif (clk'event and clk = '0') then
        output_reg <= rom(to_integer(unsigned(address)));
     end if;
   end process;
	output <= output_reg;

end Behavioral;
