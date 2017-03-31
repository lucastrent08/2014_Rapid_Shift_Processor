----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: CCU Counter.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mcu_ctr is
    Port ( clk : in std_logic;
			  sel : in  STD_LOGIC_VECTOR (1 downto 0);
			  y : in STD_LOGIC_VECTOR (7 downto 0);
           ctr : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end mcu_ctr;

architecture Behavioral of mcu_ctr is
	signal ctr_reg : std_logic_vector (7 downto 0) := (OTHERS => '0');
begin

ctr <= ctr_reg;

process (clk)
begin

	if (clk'event and clk='1') then
		case sel is
			when "10" =>
				if (ctr_reg="00000000") then
					ctr_reg <= y;
				else
					ctr_reg <= ctr_reg - '1';
				end if;
			when "11" =>
				ctr_reg <= y;
			when OTHERS =>
				null;
		end case;
	end if;
end process;

end Behavioral;

