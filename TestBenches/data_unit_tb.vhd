----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- 
-- Create Date:    March 2014
-- Module Name:    CISC 04
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: VHDL Test Bench for Data Unit
--
-- Notes:
-- Deprecated test. Worked for lab 6, I never updated it with SSCU dependencies.
---------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

library std;
use std.textio.all;

ENTITY data_unit_tb_vhd IS
END data_unit_tb_vhd;

ARCHITECTURE behavior OF data_unit_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT Data_Unit
	PORT (
		clk : in std_logic;
		pipeline : in std_logic_vector (57 downto 0);
		idb : out std_logic_vector (15 downto 0);
		pcu_ir : out std_logic_vector (15 downto 0);
		mdr_read : in std_logic_vector (15 downto 0);
		mdr_write : out std_logic_vector (15 downto 0);
		pcu_out : out std_logic_vector (15 downto 0);
		
		-- For test bench
		sscu_out : out std_logic_vector (3 downto 0);
		sscu_cc : out std_logic;
		pc : out std_logic_vector (15 downto 0);
		alu_out : out std_logic_vector (15 downto 0);
		pcu_dbb : out std_logic_vector (15 downto 0)
		);
	END COMPONENT;
	
	-- Convert vector to string
	function vec2str(vec : std_logic_vector) return string is
		variable temp : string(vec'left+1 downto 1);
	begin
		for i in vec'reverse_range loop
			if 	vec(i)='1' then temp(i+1) := '1';
			elsif vec(i)='0' then temp(i+1) := '0';
			else  temp(i+1) := 'X';
			end if;
		end loop;
		return temp;
	end vec2str;
	
	function vec2str(vec : std_logic) return string is
	begin
		if 	vec='1' then return "1";
		elsif vec='0' then return "0";
		else  return "X";
		end if;
	end vec2str;
	
	-- Display inequality
	function disp_err(i: integer; vec1, vec2 : std_logic_vector) return string is
	begin
		return integer'image(i) & ": " & vec2str(vec1) & " /= " & vec2str(vec2);
	end disp_err;
	
	function disp_err(i: integer; vec1, vec2 : std_logic) return string is
	begin
		return integer'image(i) & ": " & vec2str(vec1) & " /= " & vec2str(vec2);
	end disp_err;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL pipeline :  std_logic_vector(57 downto 0) := (others=>'0');

	--Outputs
	SIGNAL pcu_ir : std_logic_vector (15 downto 0);
	SIGNAL mdr_read : std_logic_vector (15 downto 0);
	SIGNAL mdr_write : std_logic_vector (15 downto 0);
	SIGNAL pcu_out : std_logic_vector (15 downto 0);
	SIGNAL sscu_out : std_logic_vector (3 downto 0);
	SIGNAL sscu_cc : std_logic;
	SIGNAL pc : std_logic_vector (15 downto 0);
	SIGNAL alu_out : std_logic_vector (15 downto 0);
	SIGNAL pcu_dbb : std_logic_vector (15 downto 0);
	
	-- Clock period
	constant period : time := 20 ns;

	-- Test vector definition
	constant Num: integer := 20;
	type pipelineVectorType is array (0 to Num-1)
        of std_logic_vector(57 downto 0);
	type outputVectorType is array (0 to Num-1)
        of std_logic_vector(15 downto 0);
--	type outputVectorTypeIR is array (0 to Num-1)
--        of std_logic_vector(7 downto 0);
	type outputVectorTypeSSCU is array (0 to Num-1)
        of std_logic_vector(3 downto 0);
	type outputVectorTypeCC is array (0 to Num-1)
        of std_logic;
   
	-- Set input vector
   constant pipeline_vector: pipelineVectorType:=(   
--CCR: MASK              BS  AS PCU: CI  INSTR   OE SSCU: CEM CI   SHIFT  INSTR    S   Ceu ALU: Dest   Fctn   Src   IDB MEM: VMA RW  DBB IR
		-- SSCU
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"110000"&'0'&'1'&     "1111"&"0000"&"000"&"000"&   '0'&'0'&'1'&'0', 	-- output ccr
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"000011"&'0'&'0'&     "1111"&"0000"&"000"&"000"&   '0'&'0'&'1'&'1', 	-- load uccr low
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"000000"&'0'&'1'&     "1111"&"0000"&"000"&"000"&   '0'&'0'&'1'&'1', 	-- output uccr
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'1'&     '0'&"00"&"0000"&"000001"&'0'&'1'&     "1111"&"0000"&"000"&"000"&   '0'&'0'&'1'&'1', 	-- load mccr high
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"000"&   '0'&'0'&'1'&'1', 	-- output mccr
		-- PCU IDB
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"111"&   '0'&'0'&'0'&'1', 	-- idb out low
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"110"&   '0'&'0'&'0'&'1', 	-- idb out high
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"000"&   '0'&'0'&'0'&'1', 	-- idb out dbb
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"001"&   '0'&'0'&'0'&'1', 	-- idb out alu
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"010"&   '0'&'0'&'0'&'1', 	-- idb out pcu
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'0'&'0'&'1', 	-- idb out ccr
		-- PCU Memory
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '1'&'0'&'0'&'1', 	-- write to memory
		"0000000000000000"&'0'&'0' &   '0'&"00000"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'1'&'1'&'0', 	-- read from memory, store in IR
		-- PCU Block
		"0000000000000000"&'0'&'0' &   '0'&"00011"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'0'&'1'&'1', 	-- output IDB
		"0000000000000000"&'0'&'0' &   '0'&"00010"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'0'&'1'&'1', 	-- Latch IDB and output R
		"0000000000000000"&'0'&'0' &   '0'&"00001"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'0'&'1'&'1', 	-- Fetch PC
		"0000000000000000"&'0'&'0' &   '1'&"00001"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'0'&'1'&'1', 	-- Fetch PC and increment
		"0000000000000000"&'0'&'0' &   '0'&"00001"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'0'&'1'&'1', 	-- Fetch PC
		"0000000000000000"&'0'&'0' &   '0'&"01011"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'0'&'1'&'1', 	-- Push PC Stack
		"0000000000000000"&'0'&'0' &   '0'&"01101"&'0'&     '1'&"00"&"0000"&"100000"&'0'&'1'&     "1111"&"0000"&"000"&"011"&   '0'&'0'&'1'&'1' 	-- Pop PC Stack
	);
	
	-- Set output vectors
	constant alu_vector: outputVectorType:=(
		x"FFFF", -- ALU always High (Separate FPU test)
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF",
		x"FFFF"
	);
	constant pcu_vector: outputVectorType:=(
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"0000", -- RESET
		x"000F", -- Output D (CCR)
		x"000F", -- Output R (CCR)
		x"0000",	-- Fetch PC
		x"0000", -- Fetch PC (increment)              PRE OR POST?????
		x"0001", -- Fetch PC
		x"0001", -- Push PC Stack
		x"0001"	-- Pop PC Stack
	);
--	constant ir_vector: outputVectorType:=(
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Not loaded
--		x"0000", 	-- Loading
--		x"000F",  	-- CCR in IR
--		x"000F",  	-- CCR in IR
--		x"000F",  	-- CCR in IR
--		x"000F",  	-- CCR in IR
--		x"000F",  	-- CCR in IR
--		x"000F",  	-- CCR in IR
--		x"000F",  	-- CCR in IR
--		x"000F"  	-- CCR in IR
--	);
	constant dbb_vector: outputVectorType:=(
		x"0000", 	-- Not loaded
		x"0000", 	-- Not loaded
		x"0000", 	-- Not loaded
		x"0000", 	-- Not loaded
		x"0000", 	-- Not loaded
		x"0000", 	-- Low
		x"FFFF",		-- High
		x"FFFF",		-- DBB
		x"FFFF",		-- ALU
		x"0000",		-- PCU
		x"000F",		-- CCR
		x"000F",		-- Load CCR
		"ZZZZZZZZZZZZZZZZ",	-- Hi Impedance
		x"000F",		-- CCR
		x"000F",		-- CCR
		x"000F",		-- CCR
		x"000F",		-- CCR
		x"000F",		-- CCR
		x"000F",		-- CCR
		x"000F"					-- CCR
	);
	constant sscu_vector: outputVectorTypeSSCU:=(
		x"9",	-- CCR
		x"0",	-- Load UCCR Low
		x"0",	-- UCCR
		x"0",	-- Load MCCR High
		x"F",	-- MCCR
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F",	-- Keep MCCR High
		x"F"
	);
	constant cc_vector: outputVectorTypeCC:=(
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'0', -- SSCU_CC
		'0', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1', -- SSCU_CC
		'1'
	);
	
BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: Data_Unit PORT MAP(
		clk => clk,
		pipeline => pipeline,
		pcu_ir => pcu_ir,
		mdr_read => mdr_read,
		mdr_write => mdr_write,
		pcu_out => pcu_out,
		sscu_out => sscu_out,
		sscu_cc => sscu_cc,
		pc => pc,
		alu_out => alu_out,		
		pcu_dbb => pcu_dbb
	);
	
	-- Generate clock
	m50MHZ_Clock: process
	begin
		clk <= '0'; wait for period;
		clk <= '1'; wait for period;
	end process m50MHZ_Clock;

	tb : PROCESS
	BEGIN
		pipeline <= (OTHERS => '0');
		
		-- Wait 100 ns for global reset to finish		
		wait for 100 ns;

		-- Test expected inputs against expected outputs
		for i in 0 to 19
		loop
			pipeline <= pipeline_vector(i);
			wait for 4*period;
			assert (alu_out = alu_vector(i)) 	report "Failed ALU out "	& disp_err(i, alu_out, alu_vector(i)) 	severity error;
			assert (pcu_out = pcu_vector(i))		report "Failed PCU out " 	& disp_err(i, pcu_out, pcu_vector(i)) 	severity error;
			assert (pcu_dbb = dbb_vector(i)) 	report "Failed DBB out " 	& disp_err(i, pcu_dbb, dbb_vector(i)) 	severity error;
--			assert (pcu_ir = ir_vector(i)) 		report "Failed IR out " 	& disp_err(i, pcu_ir, ir_vector(i)) 	severity error;
			assert (sscu_out = sscu_vector(i)) 	report "Failed SSCU out "	& disp_err(i, sscu_out, sscu_vector(i)) severity error;
			assert (sscu_cc = cc_vector(i)) 		report "Failed CC out " 	& disp_err(i, sscu_cc, cc_vector(i)) 	severity error;
		end loop;

		report "Test done" severity note;
		wait; -- will wait forever
	END PROCESS;

END;
