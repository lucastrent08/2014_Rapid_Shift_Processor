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

entity cisc04_controller is
	Port (
		clk : in std_logic;
		reset : in std_logic;
		ps2_clk : in std_logic;
		ps2_data : in std_logic;
		rotary_a : in std_logic;
      rotary_b : in std_logic;
		irq0 : in std_logic;
		irq3 : in std_logic;
		mdr : in std_logic_vector (15 downto 0);
		write_mem : out std_logic;
		address_out : out std_logic_vector (7 downto 0);
		address_din : out std_logic_vector (15 downto 0);
		lcd_d : out bit_vector(3 downto 0);
		lcd_e, lcd_rs, lcd_rw: out bit);
end cisc04_controller;

architecture Behavioral of cisc04_controller is
	
	signal new_kc, read_mem, write_mem_wire, backspace : std_logic := '0';	
	signal cursor, cursor_wire : std_logic_vector (3 downto 0) := (OTHERS => '0');
	signal ascii : std_logic_vector (6 downto 0) := (OTHERS => '0');
	signal address , keycode: std_logic_vector (7 downto 0) := (OTHERS => '0');
	signal instr_hex : std_logic_vector (15 downto 0);
	signal instruction : std_logic_vector (31 downto 0) := (OTHERS => '0');
	signal ascii_disp, ascii_mem : std_logic_vector (127 downto 0) := (OTHERS => '0');
begin

-- Set outputs
address_out <= address;
write_mem <= write_mem_wire;

-- Control cursor
cursor_wire <= cursor when irq3='0' else (OTHERS => '0');
				
H2A: entity hex_to_ascii
	port map(hex => mdr,
				ascii => ascii_mem
				);
				
A2H: entity ascii_to_hex
	port map(ascii => instruction,
				hex => instr_hex
				);
				
REG_INSTR: entity reg
	generic map (N => 16)
	port map(clk => clk,
				input => instr_hex,
				output => address_din
				);
				
ascii_disp <= ascii_mem when irq3='1' 
	else instruction & x"202020202020202020202020";
	
				
CURSOR_CONTROL: entity cursor_controller
	port map(irq3 => irq3,
				new_kc => new_kc,
				write_mem => write_mem_wire,
				reset => reset,
				keycode => keycode,
				cursor => cursor
				);				
				
ROTARY: entity rotary_control
	port map(clk => clk,
				rotary_a => rotary_a,
				rotary_b => rotary_b,
				read_mem => read_mem,
				address => address
				);
				
LCD: entity lcd_module
	port map(clk => clk,
				reset => reset,
				irq0 => irq0,
				irq3 => irq3,
				valid => new_kc,
				keycode => keycode,
				ascii => ascii_disp,
				address => address,
				mdr => mdr,
				cursor => cursor_wire,
				lcd_d => lcd_d,
				lcd_e => lcd_e,
				lcd_rs => lcd_rs,
				lcd_rw => lcd_rw);

PS2: entity ps2_project
	port map(clk => clk,
				reset => reset,
				ps2_clk => ps2_clk,
				ps2_data => ps2_data,
				new_kc => new_kc,
				write_mem => write_mem_wire,
				cursor => cursor_wire,
				keycode => keycode,
				instruction => instruction,
				output => ascii
				);				

end Behavioral;

