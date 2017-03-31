----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: Computer Control Unit.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity control_unit is
	Port (
		clk : in std_logic;
		reset : in STD_LOGIC;
		sscu_cc : in std_logic;
		ir : in std_logic_vector (7 downto 0);
		idb : in std_logic_vector (7 downto 0);
		irq : in std_logic_vector (3 downto 0);
		pipeline : out std_logic_vector (57 downto 0);
		
		-- Test Bench Outputs
		oe : out std_logic;
		cc_out : out std_logic;
		ctrl_load : out std_logic_vector (3 downto 0);
		upc : out std_logic_vector (7 downto 0);
		y_out : out std_logic_vector (7 downto 0);
		r_out : out std_logic_vector (7 downto 0);
		map_out : out std_logic_vector (7 downto 0);
		ctrl_out : out std_logic_vector (8 downto 0);
		stack_out : out std_logic_vector (7 downto 0);
		s_out : out std_logic_vector (7 downto 0)
		);
end control_unit;

architecture Behavioral of control_unit is
	signal cc : std_logic := '0';
	signal map_wire, y_wire, r_wire, s_wire, f_wire, pc_wire, int_wire : std_logic_vector (7 downto 0) := (OTHERS => '0');
	signal control_rom_wire : std_logic_vector (8 downto 0) := (OTHERS => '0');
	signal pipeline_wire : std_logic_vector (69 downto 0) := (OTHERS => '0');
begin

-- Test bench outputs
oe <= control_rom_wire (4);
ctrl_load <= pipeline_wire(61 downto 58);
cc_out <= cc;
upc <=  pc_wire;
y_out <= y_wire;
r_out <= r_wire;
map_out <= map_wire;
ctrl_out <= control_rom_wire;
stack_out <= f_wire;
s_out <= s_wire;

-- Set important pipeline bits
pipeline <= pipeline_wire (57 downto 0);

-- Set CC
cc <= (pipeline_wire(57) and not (irq(3) and irq(2) and irq(1) and irq(0))) or sscu_cc;

INT_ROM : entity int_rom
	port map(clk => clk,
				irq => irq,
				output => int_wire
				);

Y_MUX : entity y_mux
	port map(sel => control_rom_wire (1 downto 0),
				pl => pipeline_wire (69 downto 62),
				map_in => map_wire,
				ir => int_wire,										-- IR or INT??
				idb => idb,
				y_out => y_wire
				);
				
CTR : entity mcu_ctr
	port map(clk => clk,
				y => y_wire,
				sel => control_rom_wire (3 downto 2),
				ctr => r_wire
				);
				
MAP_ROM: entity map_rom
	port map(clk => clk,
				reset => reset,
				address => ir(4 downto 0),
				output => map_wire
				);

CONTROL_ROM: entity control_rom
	port map(clk => clk,
				address(4 downto 1) => pipeline_wire(61 downto 58),
				address(0) => cc,
				output => control_rom_wire
				);

MICROPROGRAM_ROM: entity microprogram_rom
	port map(clk => clk,
				address => s_wire,
				output => pipeline_wire
				);

S_MUX: entity s_mux
	port map(clk => clk,
				oe => control_rom_wire (4),
				sel => control_rom_wire (8 downto 7),
				pc => pc_wire,
				r => r_wire,
				d => y_wire,
				f => f_wire,
				s => s_wire
				);

MCU_PC: entity mcu_pc
	port map(
				clk => clk,
				pc_in => s_wire,
				pc => pc_wire
				);
				
MCU_STACK: entity mcu_stack
	port map(
				clk => clk,
				instr => control_rom_wire (6 downto 5),
				din => pc_wire,
				dout => f_wire
				);

end Behavioral;

