----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- 
-- Create Date:    March 2014
-- Module Name:    CISC 04
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: VHDL Test Bench for CISC 04
--
-- Notes:
-- Generates clock and lets CISC 04 run. Individual asserts were not incorporated
-- due to changing executing code often. Verified by examining waveforms against
-- expected output.
---------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY cisc04_tb_vhd IS
END cisc04_tb_vhd;

ARCHITECTURE behavior OF cisc04_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT cisc04
	PORT(
		clk : IN std_logic;
		IRQ0 : IN std_logic;
		IRQ1 : IN std_logic;
		IRQ2 : IN std_logic;
		IRQ3 : IN std_logic;
		btn_south : IN std_logic;
		ps2_clk : IN std_logic;
		ps2_data : IN std_logic;
		rotary_a : IN std_logic;
		rotary_b : IN std_logic;
		
		-- Test Bench Outputs
		PIPELINE_TB : out std_logic_vector (57 downto 0);
		SSCU_OUT : out std_logic_vector (3 downto 0);
		MAR_OUT_TB : out std_logic_vector (7 downto 0);
		PC_TB : out std_logic_vector (15 downto 0);
		ALU_OUT : out std_logic_vector (15 downto 0);
		A_OUT_TB : out std_logic_vector(15 downto 0);
		B_OUT_TB : out std_logic_vector(15 downto 0);
		MDR_OUT_TB : out std_logic_vector (15 downto 0);
		PCU_OUT_TB : out std_logic_vector (15 downto 0);
		DBB_OUT_TB : out std_logic_vector (15 downto 0);
		IR_OUT_TB : out std_logic_vector (15 downto 0);
		IDB_OUT_TB : out std_logic_vector (15 downto 0);
		RAM_WE_TB : out std_logic;
		RAM_DIN_TB : out std_logic_vector (15 downto 0);
		
		-- Outputs
		strataflash_oe : OUT std_logic;
		strataflash_ce : OUT std_logic;
		strataflash_we : OUT std_logic;
		lcd_d : OUT bit_vector(3 downto 0);
		lcd_e : OUT bit;
		lcd_rs : OUT bit;
		lcd_rw : OUT bit
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL IRQ0 :  std_logic := '1';
	SIGNAL IRQ1 :  std_logic := '1';
	SIGNAL IRQ2 :  std_logic := '1';
	SIGNAL IRQ3 :  std_logic := '1';
	SIGNAL btn_south :  std_logic := '0';
	SIGNAL ps2_clk :  std_logic := '0';
	SIGNAL ps2_data :  std_logic := '0';
	SIGNAL rotary_a :  std_logic := '0';
	SIGNAL rotary_b :  std_logic := '0';

	-- Test Bench Outputs
	SIGNAL PIPELINE_TB:  std_logic_vector(57 downto 0);
	SIGNAL SSCU_OUT :  std_logic_vector(3 downto 0);
	SIGNAL MAR_OUT_TB : std_logic_vector (7 downto 0);
	SIGNAL PC_TB :  std_logic_vector(15 downto 0);
	SIGNAL ALU_OUT :  std_logic_vector(15 downto 0);
	SIGNAL A_OUT_TB :  std_logic_vector(15 downto 0);
	SIGNAL B_OUT_TB :  std_logic_vector(15 downto 0);
	SIGNAL MDR_OUT_TB :  std_logic_vector(15 downto 0);
	SIGNAL PCU_OUT_TB :  std_logic_vector(15 downto 0);
	SIGNAL DBB_OUT_TB : std_logic_vector (15 downto 0);
	SIGNAL IR_OUT_TB :  std_logic_vector(15 downto 0);
	SIGNAL IDB_OUT_TB : std_logic_vector (15 downto 0);
	SIGNAL RAM_WE_TB : std_logic;
	SIGNAL RAM_DIN_TB : std_logic_vector (15 downto 0);

	-- Outputs
	SIGNAL strataflash_oe :  std_logic;
	SIGNAL strataflash_ce :  std_logic;
	SIGNAL strataflash_we :  std_logic;
	SIGNAL lcd_d :  bit_vector(3 downto 0);
	SIGNAL lcd_e :  bit;
	SIGNAL lcd_rs :  bit;
	SIGNAL lcd_rw :  bit;
	
	-- Clock period
	constant period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: cisc04 PORT MAP(
		clk => clk,
		IRQ0 => IRQ0,
		IRQ1 => IRQ1,
		IRQ2 => IRQ2,
		IRQ3 => IRQ3,
		
		-- Test Bench Outputs
		PIPELINE_TB => PIPELINE_TB,
		SSCU_OUT => SSCU_OUT,
		MAR_OUT_TB => MAR_OUT_TB,
		PC_TB => PC_TB,
		ALU_OUT => ALU_OUT,
		A_OUT_TB => A_OUT_TB,
		B_OUT_TB => B_OUT_TB,
		MDR_OUT_TB => MDR_OUT_TB,
		PCU_OUT_TB => PCU_OUT_TB,
		DBB_OUT_TB => DBB_OUT_TB,
		IR_OUT_TB => IR_OUT_TB,
		IDB_OUT_TB => IDB_OUT_TB,
		RAM_WE_TB => RAM_WE_TB,
		RAM_DIN_TB => RAM_DIN_TB,
		
		-- Inputs
		btn_south => btn_south,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		rotary_a => rotary_a,
		rotary_b => rotary_b,
		
		-- Outputs
		strataflash_oe => strataflash_oe,
		strataflash_ce => strataflash_ce,
		strataflash_we => strataflash_we,
		lcd_d => lcd_d,
		lcd_e => lcd_e,
		lcd_rs => lcd_rs,
		lcd_rw => lcd_rw
	);
	
	-- Generate clock
	m50MHZ_Clock: process
	begin
		clk <= '0'; wait for period;
		clk <= '1'; wait for period;
	end process m50MHZ_Clock;

	tb : PROCESS
	BEGIN
		wait; -- will wait forever
	END PROCESS;

END;
