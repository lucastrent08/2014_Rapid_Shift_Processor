----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: Top level FPU.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FPU is
	Port (
		clk : in STD_LOGIC;
		IR : in STD_LOGIC_VECTOR(7 downto 0);
		Src : in  STD_LOGIC_VECTOR (2 downto 0);
	   ALU_Fctn : in  STD_LOGIC_VECTOR (3 downto 0);
   	ALU_Dest : in  STD_LOGIC_VECTOR (3 downto 0);
		SHIFT : in  STD_LOGIC_VECTOR (3 downto 0);
	   SSCU_CI : in  STD_LOGIC_VECTOR (1 downto 0);
	   MC : in  STD_LOGIC;
		MN : in  STD_LOGIC;
		IMMEDIATE_AS : in  STD_LOGIC;
	   IMMEDIATE_BS : in  STD_LOGIC;
	   IMMEDIATE_MASK : in  STD_LOGIC_VECTOR (15 downto 0);
		IDB : in  STD_LOGIC_VECTOR (15 downto 0);
		F : out STD_LOGIC_VECTOR (15 downto 0);
		CCR : out STD_LOGIC_VECTOR (3 downto 0);
		
		-- Test Bench Outputs
		ALU_OUT : out STD_LOGIC_VECTOR (15 downto 0);
		A_OUT_TB : out STD_LOGIC_VECTOR (15 downto 0);
		B_OUT_TB : out STD_LOGIC_VECTOR (15 downto 0)
	);
end FPU;

architecture Behavioral of FPU is
	signal qsel_wire, qhold_wire, ramsel_wire, ramhold_wire, we_wire, CO_wire : STD_LOGIC := '0';
	signal ALU_Fctn_wire : STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');
	signal P_wire : STD_LOGIC_VECTOR (69 downto 0) := (OTHERS => '0');
	signal R_wire, S_wire : STD_LOGIC_VECTOR (15 downto 0) := (OTHERS => '0');
	signal AADR_Wire, BADR_Wire, CCR_wire, ccr_latch : STD_LOGIC_VECTOR (3 downto 0) := (OTHERS => '0');
	signal dout_a_wire, dout_b_wire : STD_LOGIC_VECTOR (15 downto 0) := (OTHERS => '0');
	signal a_wire, b_wire, f_wire, q_wire, ram_wire, qout_wire, ramout_wire, ramout_latch: STD_LOGIC_VECTOR (15 downto 0) := (OTHERS => '0');
begin

-- Outputs
F <= ramout_wire;
CCR <= CCR_latch;

-- Test Bench Outputs
ALU_out <= f_wire;
A_OUT_TB <= a_wire;
B_OUT_TB <= b_wire;

ALU: entity alu 
	port map(S => s_wire,
				R => r_wire,
				CIN => CO_Wire,
				SEL => alu_fctn,
				CCR => CCR_wire,
				F => F_wire);
				
ALU_SRC_MUX: entity alu_source_mux 
	port map(src => src,
				Q => qout_wire,
				DA => IDB,		
				DB => immediate_mask,
				A => a_wire,
				B => b_wire,
				R => R_wire,
				S => S_wire);
										  
CN_CTRL: entity CN_Control 
	port map(CI => sscu_ci,
				CO => CO_Wire);
				
DESTINATION_CTRL: entity dest_ctrl 
	port map(dest => alu_dest,
				we => we_wire,
				q_sel => qsel_wire,
				ram_sel => ramsel_wire,
				q_hold => qhold_wire,
				ram_hold => ramhold_wire);
				
Q_REGISTER: entity Q_Reg 
	port map(clk => clk,
				Q => q_wire,
				F => F_wire,
				Q_sel => qsel_wire,
				hold => qhold_wire,
				Qout => qout_wire);
				
LATCH_CCR : entity reg
	generic map (N => 4)
	port map(clk => clk,
				input => ccr_wire,
				output => ccr_latch
				);

RAM_SRC_MUX: entity ram_source_mux 
	port map(PL => immediate_mask(7 downto 0),
				IR => IR,
				BS => immediate_bs,
				AS => immediate_as,
				AADR => AADR_Wire,
				BADR => BADR_Wire);
										
RAM: entity xilinx_dual_port_ram_sync 
	generic map(ADDR_WIDTH => 4,
					DATA_WIDTH => 16)
	port map(clk => clk,
				we => we_wire,
				din => ramout_wire,
				addr_a => AADR_WIRE,
				addr_b => BADR_WIRE,
				dout_a => dout_a_wire,
				dout_b => dout_b_wire);

RAMA_LATCH: entity reg_falling
	generic map (n => 16) 
	port map(clk => clk,
				input => dout_a_wire,
				output => a_wire);
										
RAMB_LATCH: entity reg_falling
	generic map (n => 16) 
	port map(clk => clk,
				input => dout_b_wire,
				output => b_wire);
									
RAM_REGISTER: entity RAM_Reg 
	port map(clk => clk,
				RAM => ram_wire,
				F => F_wire,
				RAM_sel => ramsel_wire,
				hold => ramhold_wire,
				RAMout => ramout_wire
				);

SHIFT_LINKAGE: entity shift_linkage_mux 
	port map(clk => clk,
				MC => MC,
				MN => MN,
				shift_instr(4) => alu_dest(3),
				shift_instr(3 downto 0) => shift,
				Q => F_wire,
				RAM => F_wire,
				CCR => CCR_wire,
				Qout => q_wire,
				RAMout => ram_wire);

end Behavioral;
