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
-- Description: External RAM
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity RAM is
   port(
      clk: in std_logic;
      we: in std_logic;
		vma: in std_logic;
		din: in std_logic_vector(15 downto 0);
      mar : in std_logic_vector(7 downto 0);
      mdr: out std_logic_vector(15 downto 0)
   );
end RAM;

architecture Behavioral of RAM is
   type ram_type is array (0 to 2**8-1)
        of std_logic_vector (15 downto 0);
   signal ram: ram_type := (
		x"1A08", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 00 - 07
		x"0113", x"0125", x"1721", x"1920", x"0001", x"1721", x"1920", x"0002", -- 08 - 0F
		x"1B20", x"1920", x"0003", x"0A21", x"1920", x"0004", x"0000", x"0000", -- 10 - 17
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 18 - 1F
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 20 - 27
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 28 - 2F
		x"0010", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 30 - 37
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 38 - 3F
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 40 - 47
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 48 - 4F
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 50 - 57
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 58 - 5F
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 60 - 67
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 68 - 6F
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 70 - 77
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 78 - 7F
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 80 - 87
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 88 - 8F
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 90 - 97
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- 98 - 9F
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- A0 - A7
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- A8 - AF
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- B0 - B7
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- B8 - BF
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- C0 - C7
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- C8 - CF
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- D0 - D7
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- D8 - DF
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- E0 - E7
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", -- E8 - EF
		x"0000", x"0000", x"0000", x"0000", x"1A00", x"0000", x"0000", x"0000", -- F0 - F7
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000" 	-- F8 - FF
		);
	signal mar_reg : std_logic_vector (7 downto 0);
begin
	-- write cycle
   process(clk, mar)
   begin
     if (clk'event and clk = '1') then
        if (we = '0' and vma='1') then
           ram(to_integer(unsigned(mar))) <= din;
        end if;
     end if;
	  mar_reg <= mar;
   end process;
	
	--mdr <= ram(to_integer(unsigned(mar_reg))) when we='0' and vma='1' else (OTHERS => 'Z');
	mdr <= ram(to_integer(unsigned(mar_reg))) when we='1' and vma='1';

end Behavioral;
