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
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;
use work.data_types.all;

entity lcd_module is
		Port(
			clk : in std_logic;
			irq0 : in std_logic;
			irq3 : in std_logic;
			reset : in std_logic;
			valid : in std_logic;
			keycode : in std_logic_vector (7 downto 0);
			cursor : in std_logic_vector (3 downto 0);
			ascii : in std_logic_vector (127 downto 0);
			address : in std_logic_vector (7 downto 0);
			mdr : in std_logic_vector (15 downto 0);
			lcd_d : out bit_vector(3 downto 0);
			lcd_e, lcd_rs, lcd_rw: out bit);
end lcd_module;

architecture Behavioral of lcd_module is
	signal line1_wire, line2_wire : ascii_array (0 to 15);
begin

LCD_CONTROLLER: entity lcd_controller
	port map(clk => clk,
				reset => reset,
				cursor => cursor,
				line1 => line1_wire,
				line2 => line2_wire,
				lcd_d => lcd_d,
				lcd_e => lcd_e,
				lcd_rs => lcd_rs,
				lcd_rw => lcd_rw);
				
LCD_DRIVER: entity lcd_driver
	port map(clk => clk,
				irq0 => irq0,
				irq3 => irq3,
				ascii => ascii,
				address => address,
				mdr => mdr,
				line1 => line1_wire,
				line2 => line2_wire);

end Behavioral;

