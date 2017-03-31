----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Stephen Shannon
-- 
-- Create Date:    Spring 2010
-- Module Name:    PCU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: PCU Stack RAM.
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pcu_stack is
   port(
      clk: in std_logic;
		reset : in std_logic;
      we: in std_logic;
		pcu_instr : in std_logic_vector(4 downto 0);
		address: in std_logic_vector(3 downto 0);
      din : in std_logic_vector(15 downto 0);
      dout: inout std_logic_vector(15 downto 0)
   );
end pcu_stack;

architecture Behavioral of pcu_stack is
   type ram_type is array (0 to 2**4-1)
        of std_logic_vector (15 downto 0);
   signal ram: ram_type := (
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
		x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000"
		);

	signal address_reg : std_logic_vector (3 downto 0) := (OTHERS => '0');
	
	signal sp, next_sp : std_logic_vector (3 downto 0) := (OTHERS => '0');
begin

	process (clk, reset)
	begin
		if (reset = '1') then
			sp <= (OTHERS => '0');
		elsif (clk'event and clk='1') then
			sp <= next_sp;
		end if;
	end process;
	
	-- Change stack pointer
	process (clk, reset)
	begin
		if (reset = '1') then
			next_sp <= (OTHERS => '0');
		elsif (clk'event and clk='1') then
			case pcu_instr is
				when "00000" => next_sp <= (OTHERS => '0');
				when "01011" => next_sp <= sp+'1';
				when "01100" => next_sp <= sp-'1';
				when "01101" => next_sp <= sp-'1';
				when "01110" => next_sp <= sp+'1';
				when "10110" => next_sp <= sp+'1';
				when "10111" => next_sp <= sp+'1';
				when "11000" => next_sp <= sp+'1';
				when "11001" => next_sp <= sp+'1';
				when "11010" => next_sp <= sp+'1';
				when "11011" => next_sp <= sp+'1';
				when "11100" => next_sp <= sp-'1';
				when "11101" => next_sp <= sp-'1';
				when OTHERS => null;
			end case;
		end if;
	end process;
	
	process(clk)
   begin
     if (clk'event and clk = '1') then	  
        if (we = '0') then
			  -- Stack pointer is preincremented
           ram(to_integer(unsigned(sp))) <= din;
        end if;
     end if;
	  address_reg <= sp;
   end process;
	dout <= ram(to_integer(unsigned(address_reg))) when we='1';

	-- read/write cycle
--   process(clk)
--   begin
--     if (clk'event and clk = '1') then
--	  
--        if (we = '0') then
--			  -- Stack pointer is preincremented
--           ram(to_integer(unsigned(address)-1)) <= din;
--        end if;
--     end if;
--	  address_reg <= address;
--   end process;
--	dout <= ram(to_integer(unsigned(address_reg))) when we='1';

end Behavioral;
