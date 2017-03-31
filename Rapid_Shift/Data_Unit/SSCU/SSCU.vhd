----------------------------------------------------------------------------------
-- Company: University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Stephen Shannon
-- 
-- Create Date:    Spring 2010
-- Module Name:    SSCU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: Status and Shift Control Unit.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity SSCU is
	Port (clk : in  std_logic;
			sscu_cem : in std_logic;
			sscu_oe : in std_logic;
			sscu_ci : in std_logic_vector (1 downto 0);
			sscu_instr : in std_logic_vector (5 downto 0);
			sscu_s : in std_logic;
			sscu_ceu : in std_logic;
			ccr : in std_logic_vector (3 downto 0);
			IR : in std_logic_vector (5 downto 0);
			yccr : out std_logic_vector (3 downto 0);
			MC : out std_logic;
			MN : out std_logic;
			CC : out std_logic
			);
end SSCU;

architecture Behavioral of SSCU is
	signal mccr_out, uccr_out, yccr_out : std_logic_vector (3 downto 0) := (OTHERS => '0');
	signal sscu_ctrl : std_logic_vector (5 downto 0) := (OTHERS => '0'); -- Control inputs for cc_mux and pol
begin

-- Output MC and MN
mc <= mccr_out(0);
mn <= mccr_out(3);

-- Output SSCU
yccr <= yccr_out;

-- Select inputs to cc_mux and pol based on sscu_s from pipeline or instruction register
sscu_ctrl <= sscu_instr when sscu_s='1' else IR;

SSCU_MSR: entity Macro_Status_Register
	port map(clk => clk,
				en => sscu_cem,
				sscu_instr => sscu_instr,
				ccr => ccr,
				mccr => mccr_out,
				uccr => uccr_out,
				yccr => yccr_out
				);
				
SSCU_USR: entity Micro_Status_Register
	port map(clk => clk,
				en => sscu_ceu,
				sscu_instr => sscu_instr,
				ccr => ccr,
				mccr => mccr_out,
				uccr => uccr_out
				);
				
SSCU_CC_MUX: entity cc_mux
	port map(sel => sscu_ctrl(5 downto 4),
				mccr => mccr_out,
				uccr => uccr_out,
				ccr => ccr,
				yccr => yccr_out
				);
				
SSCU_CC_OUT: entity sscu_out
	port map(sel => sscu_ctrl(3 downto 0),
				yccr => yccr_out,
				oe => sscu_oe,
				cc => cc
				);

end Behavioral;

