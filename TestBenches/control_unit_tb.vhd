----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- 
-- Create Date:    March 2014
-- Module Name:    CISC 04
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: VHDL Test Bench for Control Unit
--
-- Notes:
-- Verifies control unit outputs correct microwords for fetch microcycle and
-- loads correct microword from IR. Verifies that each microword is changed 
-- after 1 clock cycle.
---------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY control_unit_tb_vhd IS
END control_unit_tb_vhd;

ARCHITECTURE behavior OF control_unit_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT control_unit
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		sscu_cc : IN std_logic;
		ir : IN std_logic_vector(7 downto 0);
		idb : IN std_logic_vector(7 downto 0);
		irq : IN std_logic_vector(3 downto 0);          
		pipeline : OUT std_logic_vector(57 downto 0);
		oe : OUT std_logic;
		cc_out : OUT std_logic;
		upc : OUT std_logic_vector(7 downto 0);
		y_out : OUT std_logic_vector(7 downto 0);
		r_out : OUT std_logic_vector(7 downto 0);
		map_out : OUT std_logic_vector(7 downto 0);
		ctrl_out : OUT std_logic_vector(8 downto 0);
		stack_out : OUT std_logic_vector(7 downto 0);
		s_out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL sscu_cc :  std_logic := '0';
	SIGNAL ir :  std_logic_vector(7 downto 0) := (others=>'0');
	SIGNAL idb :  std_logic_vector(7 downto 0) := (others=>'0');
	SIGNAL irq :  std_logic_vector(3 downto 0) := (others=>'1');

	--Outputs
	SIGNAL pipeline :  std_logic_vector(57 downto 0);
	SIGNAL oe : std_logic;
	SIGNAL cc_out : std_logic;
	SIGNAL upc :  std_logic_vector(7 downto 0);
	SIGNAL y_out :  std_logic_vector(7 downto 0);
	SIGNAL r_out :  std_logic_vector(7 downto 0);
	SIGNAL map_out :  std_logic_vector(7 downto 0);
	SIGNAL ctrl_out :  std_logic_vector(8 downto 0);
	SIGNAL stack_out :  std_logic_vector(7 downto 0);
	SIGNAL s_out :  std_logic_vector(7 downto 0);
	
	-- Clock period
	constant period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: control_unit PORT MAP(
		clk => clk,
		reset => reset,
		sscu_cc => sscu_cc,
		ir => ir,
		idb => idb,
		irq => irq,
		pipeline => pipeline,
		oe => oe,
		cc_out => cc_out,
		upc => upc,
		y_out => y_out,
		r_out => r_out,
		map_out => map_out,
		ctrl_out => ctrl_out,
		stack_out => stack_out,
		s_out => s_out
	);

	-- Generate clock
	m50MHZ_Clock: process
	begin
		clk <= '0'; wait for period;
		clk <= '1'; wait for period;
	end process m50MHZ_Clock;

	tb : PROCESS
	BEGIN

		-- Wait a period for rising edge
		wait for period;
		
		-- Microword 00
		-- 	Selects uWD 01 from uPC
		wait for 2*period;
		assert (pipeline=x"00000050004000F") report "Failed PL 00" severity error;
		-- Microword 01
		-- 	Loads IR
		IR <= x"03";
		wait for 2*period;
		assert (pipeline=x"00000850000000E") report "Failed PL 01" severity error;
		-- Microword 20
		wait for 2*period;
		assert (pipeline=x"000007C00031817") report "Failed PL 20" severity error;
		-- Microword 21
		wait for 2*period;
		assert (pipeline=x"000007C00031019") report "Failed PL 21" severity error;
		
		report "Test done." severity note;
		wait; -- will wait forever
	END PROCESS;

END;
