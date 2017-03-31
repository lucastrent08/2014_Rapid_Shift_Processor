----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- 
-- Create Date:    March 2014
-- Module Name:    CISC 04
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: VHDL Test Bench for FPU
--
-- Notes:
-- Verifies simple ALU operations and simulated processor operations using latches
-- and related arithmetic. Also, verifies that registers can be loaded, added, and stored.
---------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY FPU_tb_vhd IS
END FPU_tb_vhd;

ARCHITECTURE behavior OF FPU_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT FPU
	PORT(
		clk : IN std_logic;
		IR : IN std_logic_vector(7 downto 0);
		Src : IN std_logic_vector(2 downto 0);
		ALU_Fctn : IN std_logic_vector(3 downto 0);
		ALU_Dest : IN std_logic_vector(3 downto 0);
		SHIFT : IN std_logic_vector(3 downto 0);
		SSCU_CI : IN std_logic_vector(1 downto 0);
		MC : IN std_logic;
		MN : IN std_logic;
		IMMEDIATE_AS : IN std_logic;
		IMMEDIATE_BS : IN std_logic;
		IMMEDIATE_MASK : IN std_logic_vector(15 downto 0);
		IDB : IN std_logic_vector(15 downto 0);          
		F : OUT std_logic_vector(15 downto 0);
		CCR : OUT std_logic_vector(3 downto 0);
		
		-- Test Bench Outputs
		ALU_OUT : OUT std_logic_vector(15 downto 0);
		A_OUT_TB : out STD_LOGIC_VECTOR (15 downto 0);
		B_OUT_TB : out STD_LOGIC_VECTOR (15 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL MC :  std_logic := '0';
	SIGNAL MN :  std_logic := '0';
	SIGNAL IMMEDIATE_AS :  std_logic := '0';
	SIGNAL IMMEDIATE_BS :  std_logic := '0';
	SIGNAL IR :  std_logic_vector(7 downto 0) := (others=>'0');
	SIGNAL Src :  std_logic_vector(2 downto 0) := (others=>'0');
	SIGNAL ALU_Fctn :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL ALU_Dest :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL SHIFT :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL SSCU_CI :  std_logic_vector(1 downto 0) := (others=>'0');
	SIGNAL IMMEDIATE_MASK :  std_logic_vector(15 downto 0) := (others=>'0');
	SIGNAL IDB :  std_logic_vector(15 downto 0) := (others=>'0');

	--Outputs
	SIGNAL F :  std_logic_vector(15 downto 0);
	SIGNAL CCR :  std_logic_vector(3 downto 0);
	
	-- Test Bench outputs
	SIGNAL ALU_OUT :  std_logic_vector(15 downto 0);
	SIGNAL A_OUT_TB : STD_LOGIC_VECTOR (15 downto 0);
	SIGNAL B_OUT_TB : STD_LOGIC_VECTOR (15 downto 0);

	constant period : time := 20 ns;
BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: FPU PORT MAP(
		clk => clk,
		IR => IR,
		Src => Src,
		ALU_Fctn => ALU_Fctn,
		ALU_Dest => ALU_Dest,
		SHIFT => SHIFT,
		SSCU_CI => SSCU_CI,
		MC => MC,
		MN => MN,
		IMMEDIATE_AS => IMMEDIATE_AS,
		IMMEDIATE_BS => IMMEDIATE_BS,
		IMMEDIATE_MASK => IMMEDIATE_MASK,
		IDB => IDB,
		F => F,
		CCR => CCR,
		
		ALU_OUT => ALU_OUT,
		A_OUT_TB => A_OUT_TB,
		B_OUT_TB => B_OUT_TB
	);
	
	m50MHZ_Clock: process
	begin
		clk <= '0'; wait for period;
		clk <= '1'; wait for period;
	end process m50MHZ_Clock;

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
	
		-- Test HIGH
		alu_fctn <= "0000"; alu_dest <= "1111"; wait for 100 ns;
		assert (F 		 = x"FFFF") report "Failed HIGH-RAMF F" severity error;
		assert (ALU_OUT = x"FFFF") report "Failed HIGH-RAMF ALU" severity error;
		assert (CCR		 = "1001") report "Failed HIGH-RAMF CCR" severity error;
		
		-- Test right shift
		alu_fctn <= "0000"; alu_dest <= "0001"; shift <= "0000"; wait for 100 ns;
		assert (F 		 = x"7FFF") report "Failed HIGH-RAMF F (Shift right)" severity error;
		assert (ALU_OUT = x"FFFF") report "Failed HIGH-RAMF ALU (Shift right)" severity error;
		
		-- Test left shift
		alu_fctn <= "0000"; alu_dest <= "1000"; shift <= "0000"; wait for 100 ns;
		assert (F 		 = x"FFFE") report "Failed HIGH-RAMF F (Shift left)" severity error;
		assert (ALU_OUT = x"FFFF") report "Failed HIGH-RAMF ALU (Shift left)" severity error;
		
		-- Test LOW with hold (shifts left)
		alu_fctn <= "1000"; alu_dest <= "0101"; wait for 100 ns;
		assert (F 		 = x"FFFE") report "Failed LOW with hold" severity error;
		assert (ALU_OUT = x"0000") report "Failed LOW with hold" severity error;
		
		-- Test LOW with different shifts
		alu_fctn <= "1000"; alu_dest <= "0000"; shift <= "0001"; wait for 100 ns;
		assert (F 		 = x"8000") report "Failed LOW with shift" severity error;
		assert (ALU_OUT = x"0000") report "Failed LOW with shift" severity error;
		shift <= "0011"; wait for 100 ns;
		assert (F 		 = x"8000") report "Failed LOW with shift" severity error;
		assert (ALU_OUT = x"0000") report "Failed LOW with shift" severity error;
		alu_dest <= "1000"; shift <= "0001"; wait for 100 ns;
		assert (F 		 = x"0001") report "Failed LOW with shift" severity error;
		assert (ALU_OUT = x"0000") report "Failed LOW with shift" severity error;
		shift <= "0101"; wait for 100 ns; 
		assert (F 		 = x"0000") report "Failed LOW with shift" severity error;
		assert (ALU_OUT = x"0000") report "Failed LOW with shift" severity error;
		
		-- Test setting S and R
		alu_fctn <= "1000"; alu_dest <= "0111"; wait for 100 ns; -- Set Q to x"0000"
		alu_dest <= "1111"; IDB <= x"0001"; alu_fctn <= "0011"; src <= "111"; wait for 100 ns;
		assert (F = x"0001") report "Failed ADD" severity error;
		alu_dest <= "0111"; wait for 100 ns; -- Set Q to output
		
		-- Test incrementing adder
		alu_dest <= "1111"; IDB <= x"0001"; alu_fctn <= "0011"; src <= "111"; wait for 100 ns;
		assert (F = x"0003") report "Failed ADD" severity error;
		
		-- Test processor operations
		
		-- Fetch
		alu_dest <= "0000"; alu_fctn <= "0000";
		wait for 4*period;
		
		-- Move #N, RB
		alu_fctn <= "0110"; -- R + CN
		alu_dest <= "1111"; -- RAMF
		src <= "100";		  -- DA B

		ir <= x"13"; idb <= x"0003";
		wait for 2*period;
		
		-- Fetch
		alu_dest <= "0000"; alu_fctn <= "0000";
		wait for 2*period;
		assert(a_out_tb = x"0000") report "Failed RA" severity error;
		assert(b_out_tb = x"0003") report "Failed RB" severity error;
		wait for 2*period;
		
		-- Move #N, RB
		alu_fctn <= "0110"; -- R + CN
		alu_dest <= "1111"; -- RAMF
		src <= "100";		  -- DA B
		
		ir <= x"25";
		idb <= x"0005";
		wait for 2*period;
		
		-- Fetch
		alu_dest <= "0000"; alu_fctn <= "0000";
		wait for 2*period;
		assert(a_out_tb = x"0000") report "Failed RA" severity error;
		assert(b_out_tb = x"0005") report "Failed RB" severity error;
		wait for 2*period;
		
		-- Add
		alu_dest <= "1100"; -- HOLD
		alu_fctn <= "0011"; -- S + R + CN
		src <= "000";		  -- DA B		
		ir <= x"12";
		
		wait for 2*period;
		
		alu_dest <= "1111"; -- RAMF
		alu_fctn <= "0011"; -- S + R + CN
		src <= "000";		  -- A DB
		wait for 2*period;
		
		-- Fetch
		alu_dest <= "0000"; alu_fctn <= "0000";
		wait for 2*period;
		assert(a_out_tb = x"0005") report "Failed RA" severity error;
		assert(b_out_tb = x"0008") report "Failed RB" severity error;
		wait for 2*period;
		
		-- Move RB, NNNN
		ir <= x"10";
		alu_dest <= "1100";
		alu_fctn <= "0100";
		src <= "000";
		wait for 2*period;
		assert(a_out_tb = x"0005") report "Failed RA" severity error;
		assert(b_out_tb = x"0008") report "Failed RB" severity error;

		report "Test done." severity note;
		wait; -- will wait forever
	END PROCESS;

END;
