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
use work.all;

entity top_level is
    Port ( 
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  ps2_clk : in STD_LOGIC;
			  ps2_data : in STD_LOGIC;
			  red : out  STD_LOGIC ;
           green : out  STD_LOGIC ;
			  blue : out  STD_LOGIC ;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

	signal direction_change_wire, dir_change_enable_wire : STD_LOGIC;
	signal direction_wire : STD_LOGIC_VECTOR (1 downto 0);
	signal pixel_x_wire, pixel_y_wire : STD_LOGIC_VECTOR (9 downto 0);
	signal pixel_tick_wire : STD_LOGIC;
	signal font_bit_wire : STD_LOGIC;
	signal we_wire : STD_LOGIC;
	signal sw_wire : STD_LOGIC_VECTOR (6 downto 0);
	
begin

U1: entity text_screen_gen 
	port map(clk => clk,
				direction_change => direction_change_wire,
				direction_change_enable => dir_change_enable_wire,
				reset => reset,
				we => we_wire,
				direction => direction_wire,
				sw => sw_wire,
				pixel_x => pixel_x_wire,
				pixel_y => pixel_y_wire,
--				leds => leds,
				blue => blue,
				red => red,
				font_bit => font_bit_wire
				);
										
U2: entity vga_controller 
	port map(clk => clk,
				reset => reset,
				hs => hsync,
				vs => vsync,
				pixel_tick => pixel_tick_wire,
				pixel_x => pixel_x_wire,
				pixel_y => pixel_y_wire
				);
										
U3: entity rgb_reg 
	port map(rgb_next => font_bit_wire,
				pixel_tick => pixel_tick_wire,
				green => green
				);
							 
U4: entity ps2_project 
	port map(clk => clk,
				reset => reset,
				ps2_clk => ps2_clk,
				ps2_data => ps2_data,
				direction_change => direction_change_wire,
				direction_change_enable => dir_change_enable_wire,
				direction => direction_wire,
				we => we_wire,
				output => sw_wire
				);

end Behavioral;

