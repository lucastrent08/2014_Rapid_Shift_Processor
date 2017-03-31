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
use IEEE.STD_LOGIC_1164.all;

package components is
								 
	component ps2_project is
	 Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  ps2_clk : in  STD_LOGIC;
           ps2_data : in  STD_LOGIC;
			  direction_change : out STD_LOGIC;
			  direction_change_enable : out STD_LOGIC;
			  direction : out STD_LOGIC_VECTOR (1 downto 0);
			  we : out STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
	component PS2controller is
    Port ( reset : in  STD_LOGIC;
           ps2_clk : in  STD_LOGIC;
           ps2_data : in  STD_LOGIC;
           keycode : out  STD_LOGIC_VECTOR (7 downto 0);
			  valid : out STD_LOGIC);
	end component;
	
	component kb_monitor is
    Port ( 
			  clk : in STD_LOGIC;								-- Clock
			  reset : in STD_LOGIC;								-- Asynchronous Reset
			  keycode : in  STD_LOGIC_VECTOR (7 downto 0);
			  direction_change_enable : out STD_LOGIC;
			  direction : out STD_LOGIC_VECTOR (1 downto 0);
			  we : out STD_LOGIC;
			  keycode_out : out  STD_LOGIC_VECTOR (7 downto 0);
           ascii : out  STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
	component direction_controller is
    Port ( keycode : in  STD_LOGIC_VECTOR (7 downto 0);
           direction : out  STD_LOGIC_VECTOR (1 downto 0);
			  we : out  STD_LOGIC;
           direction_change : out  STD_LOGIC);
	end component;

	component font_rom is
		port(
			clk: in std_logic;
			addr: in std_logic_vector(10 downto 0);
			data: out std_logic_vector(7 downto 0)
		);
	end component;
	
	component xilinx_dual_port_ram_sync is
	   generic(
			ADDR_WIDTH: integer:=12;
			DATA_WIDTH:integer:=8
		);
		port(
			clk: in std_logic;
			reset : in std_logic;
			we: in std_logic;
			direction : in std_logic_vector(1 downto 0);
			addr_a: in std_logic_vector(ADDR_WIDTH-1 downto 0);
			addr_b: in std_logic_vector(ADDR_WIDTH-1 downto 0);
			din_a: in std_logic_vector(6 downto 0);
			red : out std_logic;
			blue : out std_logic;
			dout_b: out std_logic_vector(6 downto 0)
		);
	end component;
	
	component address_driver is
	    Port ( direction : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
			  enable : in STD_LOGIC;
			  reset : in  STD_LOGIC;
			  leds : out STD_LOGIC_VECTOR (7 downto 0);
			  cur_y : buffer STD_LOGIC_VECTOR (4 downto 0);
           cur_x : buffer STD_LOGIC_VECTOR (6 downto 0));
	
	end component;
	component generic_mux is
		generic (n: integer := 3);
		Port (inp: IN STD_LOGIC_VECTOR ((2**n)-1 downto 0);
				sel: IN STD_LOGIC_VECTOR (n-1 downto 0);
				output: OUT STD_LOGIC);
	end component;
	
	component reg is
		generic (n: natural := 3);
		port (clk : in STD_LOGIC;
			input : in STD_LOGIC_VECTOR (n-1 downto 0);
			output : out STD_LOGIC_VECTOR (n-1 downto 0)
			);
	end component;
	
	component latch is
		port (clk : in STD_LOGIC;
			input : in STD_LOGIC;
			output : out STD_LOGIC
			);
	end component;
	
	component reg_falling is
		generic (n: natural := 3);
		port (clk : in STD_LOGIC;
			input : in STD_LOGIC_VECTOR (n-1 downto 0);
			output : out STD_LOGIC_VECTOR (n-1 downto 0)
			);
	end component;
	
	component latch_falling is
		port (clk : in STD_LOGIC;
			input : in STD_LOGIC;
			output : out STD_LOGIC
			);
	end component;
	
	component text_screen_gen is
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
			leds : out STD_LOGIC_VECTOR (7 downto 0);
			red : out std_logic;
			blue : out std_logic;
			font_bit: out STD_LOGIC
		);
	end component;
	
	component vga_controller is
		Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           hs : out  STD_LOGIC;
           vs : out  STD_LOGIC;
	     pixel_tick : out STD_LOGIC;
           pixel_x : out  STD_LOGIC_VECTOR (9 downto 0);
           pixel_y : out  STD_LOGIC_VECTOR (9 downto 0)
		  );
	end component;
	
	component rgb_reg is
	    Port ( rgb_next : in  STD_LOGIC;
           pixel_tick : in  STD_LOGIC;
           green : out  STD_LOGIC);
	end component;
 
end components;
