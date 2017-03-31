----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: CCU Stack.
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mcu_stack is
   port(
      clk: in std_logic;
		instr : in std_logic_vector(1 downto 0);
      din : in std_logic_vector(7 downto 0);
      dout: inout std_logic_vector(7 downto 0)
   );
end mcu_stack;

architecture Behavioral of mcu_stack is
   type ram_type is array (0 to 3)
        of std_logic_vector (7 downto 0);
   signal ram: ram_type := (
		x"00", x"00", x"00", x"00"
		);

	signal stack_pointer, address_reg : integer range 0 to 3 := 0;
begin

	-- read/write cycle
   process(clk)
   begin
     if (clk'event and clk = '1') then
	  
		address_reg <= stack_pointer;
		
			case (instr) is
				when "10" =>
					if (stack_pointer /= 0) then
						stack_pointer <= stack_pointer-1;
					end if;
				when "11" =>
					if (stack_pointer /= 3) then
						ram(stack_pointer) <= din;
						stack_pointer <= stack_pointer+1;
					end if;
				when OTHERS => null;
			end case;
	  
     end if;
   end process;
	
	dout <= ram(address_reg);

end Behavioral;
