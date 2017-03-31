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

entity debounce_long is
    Port ( clk : in  STD_LOGIC;
           key : in  STD_LOGIC;
           pulse : out  STD_LOGIC);
end debounce_long;

architecture Behavioral of debounce_long is
	signal cnt : STD_LOGIC_VECTOR (2 DOWNTO 0);
begin
  process (clk, key, cnt)
  begin
    if Key = '1' then
      cnt <= "000";
    elsif (clk'EVENT and clk = '1') then
      if (cnt /= "111") then cnt <= cnt + 1; end if;
    end if;
    if (cnt = "110") and (Key = '0') then pulse <= '1'; else pulse <= '0'; end if;
  end process;

end Behavioral;
