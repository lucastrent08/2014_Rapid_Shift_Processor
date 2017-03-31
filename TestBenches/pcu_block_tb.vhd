----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- 
-- Create Date:    March 2014
-- Module Name:    CISC 04
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: VHDL Test Bench for Control Unit
--
-- Notes:
-- Verifies PCU Block (AM2930) operations. Originally asserted that PC was seen
-- at next clock cycle, but CISC 04 handles this, and test shows it appearing at
-- the same cycle as the carry in. 
---------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY pcu_block_tb_vhd IS
END pcu_block_tb_vhd;

ARCHITECTURE behavior OF pcu_block_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT pcu_block
	PORT(
		pcu_instr : IN std_logic_vector(4 downto 0);
		clk : IN std_logic;
		reset : IN std_logic;
		cc : IN std_logic;
		pcu_ci : IN std_logic;
		d : IN std_logic_vector(15 downto 0);          
		pcu_out : OUT std_logic_vector(15 downto 0);
		pc : OUT std_logic_vector (15 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL reset : std_logic := '0';
	SIGNAL cc :  std_logic := '0';
	SIGNAL pcu_ci :  std_logic := '0';
	SIGNAL pcu_instr :  std_logic_vector(4 downto 0) := (others=>'0');
	SIGNAL d :  std_logic_vector(15 downto 0) := (others=>'0');

	--Outputs
	SIGNAL pcu_out :  std_logic_vector(15 downto 0);
	SIGNAL pc : std_logic_vector (15 downto 0);
	
	-- Clock period
	constant period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: pcu_block PORT MAP(
		pcu_instr => pcu_instr,
		clk => clk,
		reset => reset,
		cc => cc,
		pcu_ci => pcu_ci,
		d => d,
		pcu_out => pcu_out,
		pc => pc
	);
	
	-- Generate clock
	m50MHZ_Clock: process
	begin
		clk <= '0'; wait for period;
		clk <= '1'; wait for period;
	end process m50MHZ_Clock;

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
		
		-- D and R
		d <= x"000F"; pcu_instr <= "00011";
		wait for 2*period;
		assert (pcu_out = x"000F") report "fail dbb " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		d <= x"000F"; pcu_instr <= "00010";
		wait for 2*period;
		assert (pcu_out = x"000F") report "fail dbb " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		-- Program counter
		pcu_instr <= "00001"; pcu_ci <= '0';
		wait for 2*period;
		assert (pcu_out = x"0000") report "fail 1" & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		pcu_instr <= "00001"; pcu_ci <= '1';
		wait for 2*period;
		assert (pcu_out = x"0001") report "fail 2" & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		pcu_instr <= "00001"; pcu_ci <= '1';
		wait for 2*period;
		assert (pcu_out = x"0002") report "fail 2a" & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		pcu_instr <= "00001"; pcu_ci <= '0';
		wait for 2*period;
		assert (pcu_out = x"0002") report "fail 3 " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		-- Stack Push		
		pcu_instr <= "01011"; pcu_ci <= '1'; -- PC=3, Stack=2
		wait for 2*period;
		assert (pcu_out = x"0003") report "fail 4 psh " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		pcu_instr <= "01011"; -- PC=4, Stack=3
		wait for 2*period;
		assert (pcu_out = x"0004") report "fail 5 psh " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		-- Stack pop
		pcu_instr <= "00001"; pcu_ci <= '0'; -- Verify PC
		wait for 2*period;
		assert (pcu_out = x"0004") report "fail 5 pc " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		pcu_instr <= "01101"; -- Verify Stack Pop
		wait for 2*period;
		assert (pcu_out = x"0004") report "fail 6 pop " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		pcu_instr <= "01101"; -- Verify Stack Pop
		wait for 2*period;
		assert (pcu_out = x"0003") report "fail 7 pop " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		-- Done
		pcu_instr <= "11110";	-- Hold
		wait for 2*period;
		assert (pcu_out = x"0004") report "fail 6 " & integer'image(to_integer(unsigned(pcu_out))) severity error;
		
		pcu_instr <= "11111";	-- Suspend
		wait for 2*period;
		assert (pcu_out = "ZZZZZZZZZZZZZZZZ") report "fail 5" severity error;
		
		report "Test done" severity note;
		
		wait; -- will wait forever
	END PROCESS;

END;
