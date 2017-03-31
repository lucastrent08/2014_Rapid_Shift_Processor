
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:08:05 06/09/2014
-- Design Name:   shift_linkage_mux
-- Module Name:   C:/Xilinx/9.2/ISE/Trent_test/FPU/shift_linkage_mux_tb.vhd
-- Project Name:  FPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shift_linkage_mux
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY shift_linkage_mux_tb_vhd IS
END shift_linkage_mux_tb_vhd;

ARCHITECTURE behavior OF shift_linkage_mux_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT shift_linkage_mux
	PORT(
		clk : IN std_logic;
		MC : IN std_logic;
		MN : IN std_logic;
		shift_instr : IN std_logic_vector(4 downto 0);
		Q : IN std_logic_vector(15 downto 0);
		RAM : IN std_logic_vector(15 downto 0);          
		CCR : IN std_logic_vector(3 downto 0);  
		Qout : OUT std_logic_vector(15 downto 0);
		RAMout : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL MC :  std_logic := '0';
	SIGNAL MN :  std_logic := '0';
	SIGNAL shift_instr :  std_logic_vector(4 downto 0) := (others=>'0');
	SIGNAL Q :  std_logic_vector(15 downto 0) := (others=>'0');
	SIGNAL RAM :  std_logic_vector(15 downto 0) := (others=>'0');
	SIGNAL CCR :  std_logic_vector(3 downto 0) := (others=>'0');

	--Outputs
	SIGNAL Qout :  std_logic_vector(15 downto 0);
	SIGNAL RAMout :  std_logic_vector(15 downto 0);
	
	constant period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: shift_linkage_mux PORT MAP(
		clk => clk,
		MC => MC,
		MN => MN,
		shift_instr => shift_instr,
		Q => Q,
		RAM => RAM,
		CCR => CCR,
		Qout => Qout,
		RAMout => RAMout
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

		-- Place stimulus here
		RAM 	<= "0000000000000011";
		Q 		<= "0000000000000011";
		
		-- Shift Right
		
		shift_instr <= "00000"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed LSR - RAM" severity error;
		assert (Qout 	= "0000000000000001") report "Failed LSR - Q" severity error;
		
		shift_instr <= "00001"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed SRM - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed SRM - Q" severity error;
		
		shift_instr <= "00010"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed ASRQ - RAM" severity error;
		assert (Qout 	= "0000000000000001") report "Failed ASRQ - Q" severity error;
		
		shift_instr <= "00011"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed SRMQ - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed SRMQ - Q" severity error;
		
		shift_instr <= "00100"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed SRCD - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed SRCD - Q" severity error;
		
		shift_instr <= "00101"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed ASRD - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed ASRD - Q" severity error;
		
		shift_instr <= "00110"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed LSMD - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed LSMD - Q" severity error;
		
		shift_instr <= "00111"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed SRDC - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed SRDC - Q" severity error;
		
		shift_instr <= "01000"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed RACQ - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed RACQ - Q" severity error;
		
		shift_instr <= "01001"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed RORC - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed RORC - Q" severity error;
		
		shift_instr <= "01010"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed MQM - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed MQM - Q" severity error;
		
		shift_instr <= "01011"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed SRID - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed SRID - Q" severity error;
		
		shift_instr <= "01100"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed RACD - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed RACD - Q" severity error;
		
		shift_instr <= "01101"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed RACS - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed RACS - Q" severity error;
		
		shift_instr <= "01110"; wait for 100 ns;
		assert (RAMout = "0000000000000001") report "Failed SRVD - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed SRVD - Q" severity error;
		
		shift_instr <= "01111"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed RSD - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed RSD - Q" severity error;
		
		-- Shift Left
		RAM 	<= "1100000000000000";
		Q 		<= "1100000000000000";
		
		shift_instr <= "10000"; wait for 100 ns;
		assert (RAMout = "1000000000000000") report "Failed LQLD - RAM" severity error;
		assert (Qout 	= "1000000000000000") report "Failed LQLD - Q" severity error;
		
		shift_instr <= "10001"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed LSNC - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed LSNC - Q" severity error;
		
		shift_instr <= "10010"; wait for 100 ns;
		assert (RAMout = "1000000000000000") report "Failed LSL - RAM" severity error;
		assert (Qout 	= "1000000000000000") report "Failed LSL - Q" severity error;
		
		shift_instr <= "10011"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed QLN - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed QLN - Q" severity error;
		
		shift_instr <= "10100"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed SLDC - RAM" severity error;
		assert (Qout 	= "1000000000000000") report "Failed SLDC - Q" severity error;
		
		shift_instr <= "10101"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed SLQN - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed SLQN - Q" severity error;
		
		shift_instr <= "10110"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed SLD - RAM" severity error;
		assert (Qout 	= "1000000000000000") report "Failed SLD - Q" severity error;
		
		shift_instr <= "10111"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed SLND - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed SLND - Q" severity error;
		
		shift_instr <= "11000"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed RLCQ - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed RLCQ - Q" severity error;
		
		shift_instr <= "11001"; wait for 100 ns;
		assert (RAMout = "1000000000000000") report "Failed ROLC - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed ROLC - Q" severity error;
		
		shift_instr <= "11010"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed ROL - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed ROL - Q" severity error;
		
		shift_instr <= "11011"; wait for 100 ns;
		assert (RAMout = "1000000000000000") report "Failed SLCL - RAM" severity error;
		assert (Qout 	= "1000000000000000") report "Failed SLCL - Q" severity error;
		
		shift_instr <= "11100"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed RLCD - RAM" severity error;
		assert (Qout 	= "1000000000000000") report "Failed RLCD - Q" severity error;
		
		shift_instr <= "11101"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed RLCS - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed RLCS - Q" severity error;
		
		shift_instr <= "11110"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed SLCD - RAM" severity error;
		assert (Qout 	= "1000000000000000") report "Failed SLCD - Q" severity error;
		
		shift_instr <= "11111"; wait for 100 ns;
		assert (RAMout = "1000000000000001") report "Failed RLO - RAM" severity error;
		assert (Qout 	= "1000000000000001") report "Failed RLO - Q" severity error;

		report "Test done." severity note;
		wait; -- will wait forever
	END PROCESS;

END;
