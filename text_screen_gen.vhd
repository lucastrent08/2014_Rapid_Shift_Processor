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

entity text_screen_gen is
	port (
		clk : in STD_LOGIC;
		direction_change : in STD_LOGIC;
		direction_change_enable : in STD_LOGIC;
		reset : in STD_LOGIC;
		we : in STD_LOGIC;
		direction : in STD_LOGIC_VECTOR (1 downto 0);
		sw : in STD_LOGIC_VECTOR (6 downto 0);
		pixel_x : in STD_LOGIC_VECTOR(9 downto 0);
		pixel_y : in STD_LOGIC_VECTOR(9 downto 0);
--		leds : out STD_LOGIC_VECTOR (7 downto 0);
		red : out std_logic;
		blue : out std_logic;
		font_bit: out STD_LOGIC
	);
end text_screen_gen;

architecture Behavioral of text_screen_gen is

	signal char_addr_wire : STD_LOGIC_VECTOR (6 downto 0);
	signal data_wire : STD_LOGIC_VECTOR (7 downto 0);
	signal cur_x_wire : STD_LOGIC_VECTOR (6 downto 0);
	signal cur_y_wire : STD_LOGIC_VECTOR (4 downto 0);
	signal cur_x_wire_reg : STD_LOGIC_VECTOR (6 downto 0);
	signal cur_y_wire_reg : STD_LOGIC_VECTOR (4 downto 0);
	signal delayed_pixel_x : STD_LOGIC_VECTOR (2 downto 0);
	signal delayed_pixel_x_int : STD_LOGIC_VECTOR (2 downto 0);
	signal pixel_x_reg, pixel_y_reg : STD_LOGIC_VECTOR (9 downto 0);
begin

blue <= '0';

U1: entity font_rom 
	port map(clk => clk,
				addr (10 downto 4) => char_addr_wire,
				addr (3 downto 0) => pixel_y(3 downto 0),
				data => data_wire
				);
							  
U2: entity xilinx_dual_port_ram_sync 
	generic map(ADDR_WIDTH => 12,
					DATA_WIDTH => 8)
	port map(clk => clk,
				we => we,
				reset => reset,
				addr_a (11 downto 7) => cur_y_wire,
				addr_a (6 downto 0) => cur_x_wire, 
				addr_b (11 downto 7) => pixel_y(8 downto 4), 
				addr_b (6 downto 0) => pixel_x(9 downto 3),
				din_a (7) => '0',
				din_a (6 downto 0) => sw,
				dout_b => char_addr_wire
				);
				
CURSOR : entity cursor_controller
	port map(clk => clk,
				addr_a (11 downto 7) => cur_y_wire,
				addr_a (6 downto 0) => cur_x_wire, 
				addr_b (11 downto 7) => pixel_y(8 downto 4), 
				addr_b (6 downto 0) => pixel_x(9 downto 3),
				direction => direction,
				red => red
				);
										 
U3: entity address_driver 
	port map(reset => reset,
				clk => direction_change_enable,
				enable => direction_change,
				direction => direction,
--				leds => leds,
				cur_x => cur_x_wire,
				cur_y => cur_y_wire
				);
									  
U4: entity generic_mux 
	generic map (n => 3)
	port map(inp => data_wire,
				sel => delayed_pixel_x,
				output => font_bit
				);
									  
R1: entity reg 
	generic map (n => 3)
	port map(clk => clk,
				input => pixel_x(2 downto 0),
				output => delayed_pixel_x
				);
						
--R2: entity reg 
--	generic map (n => 3)
--	port map(clk => clk,
--				input => delayed_pixel_x_int,
--				output => delayed_pixel_x
--				);
--						
--R3: entity reg 
--	generic map (n => 7)
--	port map(clk => clk,
--				input => cur_x_wire_reg,
--				output => cur_x_wire
--				);
--						
--R4: entity reg 
--	generic map (n => 5)
--	port map(clk => clk,
--				input => cur_y_wire_reg,
--				output => cur_y_wire
--				);
--						
--								 
--R5: entity reg_falling
--	generic map (n => 10)
--	port map(clk => clk,
--				input => pixel_x,
--				output => pixel_x_reg);
--				
--R6: entity reg_falling
--	generic map (n => 10)
--	port map(clk => clk,
--				input => pixel_y,
--				output => pixel_y_reg);				  

end Behavioral;
