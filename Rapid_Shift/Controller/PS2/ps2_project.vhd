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

entity ps2_project is
	Port ( 
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		ps2_clk : in  STD_LOGIC;
      ps2_data : in  STD_LOGIC;
		new_kc : out STD_LOGIC;
		write_mem : out STD_LOGIC;
		cursor : in std_logic_vector (3 downto 0);
		keycode : out STD_LOGIC_VECTOR (7 downto 0);
		output : out STD_LOGIC_VECTOR (6 downto 0);
		instruction : out  STD_LOGIC_VECTOR (31 downto 0)
	);
end ps2_project;

architecture Behavioral of ps2_project is

signal key_wire : STD_LOGIC_VECTOR (7 downto 0);
signal ascii_wire : STD_LOGIC_VECTOR (6 downto 0);
signal keycode_out_wire : STD_LOGIC_VECTOR (7 downto 0);
signal valid_wire, new_kc_wire, write_mem_wire, write_mem_latch: STD_LOGIC;

begin

-- Set outputs
keycode <= keycode_out_wire;
new_kc <= new_kc_wire;
write_mem <= write_mem_wire;
output <= ascii_wire;

PS2_CONTROLLER: entity PS2controller
	port map(
				ps2_clk => ps2_clk,
				ps2_data => ps2_data,
				reset => reset,
				keycode => key_wire,
				valid => valid_wire
				);

KB_MONITOR: entity kb_monitor
	port map(
				clk => valid_wire,
				reset => reset,
				keycode => key_wire,
				write_mem => write_mem_wire,
				new_kc => new_kc_wire,
				keycode_out => keycode_out_wire,
				ascii => ascii_wire
				);
				 
INSTRUCTION_CONTROL: entity instruction_controller
	port map(clk => clk,
				write_mem => write_mem_latch,
				cursor => cursor,
				new_kc => new_kc_wire,
				ascii(7) => '0',
				ascii(6 downto 0) => ascii_wire,
				instruction => instruction
				);		

end Behavioral;

