----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: Interrupt ROM.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity int_rom is
    Port ( clk : in STD_LOGIC;
			  irq : in  STD_LOGIC_VECTOR (3 downto 0);
           output : out  STD_LOGIC_VECTOR (7 downto 0));
end int_rom;

architecture Behavioral of int_rom is
	signal output_reg : std_logic_vector (7 downto 0) := (OTHERS => '0');
	type rom_type is array (0 to 3)
        of std_logic_vector (7 downto 0);
   signal rom: rom_type := (
	x"F0", x"F4", x"F8", x"FC"
	);

	signal address : std_logic_vector (1 downto 0) := (OTHERS => '0');
begin

	address <= 	"00" when irq(0) = '0' else
					"01" when irq(1) = '0' else
					"10" when irq(2) = '0' else
					"11";
					
	-- read cycle
   process(clk)
   begin
     if (clk'event and clk = '1') then
        output_reg <= rom(to_integer(unsigned(address)));
     end if;
   end process;
	output <= output_reg;
	
end Behavioral;

