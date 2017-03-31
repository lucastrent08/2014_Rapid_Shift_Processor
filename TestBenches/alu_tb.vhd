----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- 
-- Create Date:    March 2014
-- Module Name:    CISC 04
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: VHDL Test Bench for ALU
--
-- Notes:
-- Verifies simple ALU operations.
---------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.ALL;

ENTITY alu_tb_vhd IS
END alu_tb_vhd;

ARCHITECTURE behavior OF alu_tb_vhd IS 

	COMPONENT ALU
	port (  S	: in 	STD_LOGIC_VECTOR(15 downto 0);	-- Input 1
			  R	: in 	STD_LOGIC_VECTOR(15 downto 0);	-- Input 2
			  CIN : in  STD_LOGIC;								-- Carry In
           SEL : in  STD_LOGIC_VECTOR (3 downto 0);	-- Select ALU Operation
			  CCR : out STD_LOGIC_VECTOR (3 downto 0);	-- Condition Codes (N,Z,V,C)
           F : out  STD_LOGIC_VECTOR (15 downto 0));	-- Output
	END COMPONENT;

	--Inputs
	SIGNAL CIN :  std_logic := '0';
	SIGNAL S :  std_logic_vector(15 downto 0) := (others=>'0');
	SIGNAL R :  std_logic_vector(15 downto 0) := (others=>'0');
	SIGNAL SEL :  std_logic_vector(3 downto 0) := (others=>'0');

	--Outputs
	SIGNAL CCR :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL F :  std_logic_vector(15 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: alu PORT MAP(
		S => S,
		R => R,
		CIN => CIN,
		SEL => SEL,
		CCR => CCR,
		F => F
	);

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
		
		report "Start ALU Test Bench" severity NOTE;
		
		S <= "0000000000000001";
		R <= "0000000000000001";
		CIN <= '0';

		----- Arithmetic Tests -----
		SEL <= "0000"; wait for 10ns;
		assert (F = "1111111111111111") report "Failed HIGH" severity ERROR;
		SEL <= "0001"; wait for 10ns;
		assert (F = "1111111111111111") report "Failed SRS" severity ERROR;
		SEL <= "0010"; wait for 10ns;
		assert (F = "1111111111111111") report "Failed SSR" severity ERROR;			
		SEL <= "0011"; wait for 10ns;
		assert (F = "0000000000000010") report "Failed ADD" severity ERROR;
		SEL <= "0100"; wait for 10ns;
		assert (F = "0000000000000001") report "Failed PAS" severity ERROR;
		SEL <= "0101"; wait for 10ns;
		assert (F = "1111111111111110") report "Failed COMS" severity ERROR;
		SEL <= "0110"; wait for 10ns;
		assert (F = "0000000000000001") report "Failed PAR" severity ERROR;
		SEL <= "0111"; wait for 10ns;
		assert (F = "1111111111111110") report "Failed PARS" severity ERROR;
			
		----- Logic Tests -----
		SEL <= "1000"; wait for 10ns;
		assert (F = "0000000000000000") report "Failed LOW" severity ERROR;
		SEL <= "1001"; wait for 10ns;
		assert (F = "0000000000000000") report "Failed CRAS" severity ERROR;
		SEL <= "1010"; wait for 10ns;
		assert (F = "1111111111111111") report "Failed XNRS" severity ERROR;
		SEL <= "1011"; wait for 10ns;
		assert (F = "0000000000000000") report "Failed XOR" severity ERROR;
		SEL <= "1100"; wait for 10ns;
		assert (F = "0000000000000001") report "Failed AND" severity ERROR;
		SEL <= "1101"; wait for 10ns;
		assert (F = "1111111111111110") report "Failed NOR" severity ERROR;
		SEL <= "1110"; wait for 10ns;
		assert (F = "1111111111111110") report "Failed NAND" severity ERROR;
		SEL <= "1111"; wait for 10ns;
		assert (F = "0000000000000001") report "Failed OR" severity ERROR;
		
		----- Condition Code Tests -----
		
		-- Negative Bit
		S <= "1100000000000001";
		R <= "0000000000000001";
		SEL <= "0011"; wait for 10ns; 
		assert (CCR(3) = '1') report "Failed Negative Bit" severity ERROR;
		
		-- Zero Bit
		S <= "0000000000000001"; 
		R <= "1111111111111111"; 
		SEL <= "0011"; wait for 10ns; 
		assert (CCR(2) = '1') report "Failed Zero Bit" severity ERROR;		
		
		-- Overflow Bit
		S <= "0111111111111111"; 
		R <= "0000000000000001"; 
		SEL <= "0011"; wait for 10ns; 
		assert (CCR(1) = '1') report "Failed Overflow Bit" severity ERROR;						
		
		-- Carry Bit
		S <= "1111111111111111"; 
		R <= "0000000000000001"; 
		SEL <= "0011"; wait for 10ns; 
		assert (CCR(0) = '1') report "Failed Carry Bit" severity ERROR;
		
		report "Test done." severity note;
		wait; -- End Test
	END PROCESS;

END;
