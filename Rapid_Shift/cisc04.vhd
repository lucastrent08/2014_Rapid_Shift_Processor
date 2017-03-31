----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors
-- Department: R&D
-- Engineer: Lucas Trent

-- 
-- Create Date:    3/10/2014
-- Design Name:    Updated CISC Processor
-- Module Name:    text_screen_gen
-- Project Name:   VGA Controller
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2
-- Description: Toplevel
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity cisc04 is
    Port(
			-- Processor Inputs
			clk : in  std_logic;
			btn_south : in std_logic;
	 
			-- Interrupts
			IRQ0 : in  std_logic;
			IRQ1 : in  std_logic;
			IRQ2 : in  std_logic;
			IRQ3 : in  std_logic;
			
			-- Test Bench Outputs
			PIPELINE_TB : out std_logic_vector (57 downto 0);
			MAR_OUT_TB : out std_logic_vector (7 downto 0);
			MDR_OUT_TB : out std_logic_vector (15 downto 0);
			PCU_OUT_TB : out std_logic_vector (15 downto 0);
			DBB_OUT_TB : out std_logic_vector (15 downto 0);
			IR_OUT_TB : out std_logic_vector (15 downto 0);
			IDB_OUT_TB : out std_logic_vector (15 downto 0);
			SSCU_OUT : out std_logic_vector (3 downto 0);
			PC_TB : out std_logic_vector (15 downto 0);
			ALU_OUT : out std_logic_vector (15 downto 0);
			A_OUT_TB : out std_logic_vector (15 downto 0);
			B_OUT_TB : out std_logic_vector (15 downto 0);
			RAM_WE_TB : out std_logic;
			RAM_DIN_TB : out std_logic_vector (15 downto 0);

			-- Controller inputs
			ps2_clk : in std_logic;
			ps2_data : in std_logic;
			rotary_a, rotary_b : in std_logic;
			strataflash_oe : out std_logic;
			strataflash_ce : out std_logic;
			strataflash_we : out std_logic;
			lcd_d : out bit_vector(3 downto 0);
			lcd_e, lcd_rs, lcd_rw: out bit
	 );
end cisc04;

architecture Behavioral of cisc04 is
	signal address_ctr : std_logic_vector (7 downto 0) := (OTHERS => '0');
	signal ir, idb, pcu_out, pc : std_logic_vector (15 downto 0) := (OTHERS => '0');
	signal mdr_in, mdr_out, ram_din, address_din : std_logic_vector (15 downto 0) := (OTHERS => '0');
	signal pipeline : std_logic_vector (57 downto 0) := (OTHERS => '0');
	signal sscu_cc : std_logic := '0';
	signal write_mem : std_logic := '1';
	
	signal ram_addr : std_logic_vector (7 downto 0) := (OTHERS => '0');
	signal ram_we : std_logic := '1';
begin

-- StrataFLASH must be disabled to prevent it conflicting with the LCD display 
strataflash_oe <= '1';
strataflash_ce <= '1';
strataflash_we <= '1';

-- Test bench outputs
MAR_OUT_TB <= ram_addr;
MDR_OUT_TB <= mdr_out;
PCU_OUT_TB <= pcu_out;
IR_OUT_TB <= ir;
IDB_OUT_TB <= idb;
PIPELINE_TB <= pipeline;
PC_TB <= pc;
DBB_OUT_TB <= mdr_in;
RAM_WE_TB <= ram_we;
RAM_DIN_TB <= ram_din;

CONTROL : entity control_unit
	port map(clk => clk,
				reset => btn_south,
				sscu_cc => sscu_cc,
				ir => ir (15 downto 8),
				idb => idb (7 downto 0),
				irq(0) => irq0,
				irq(1) => irq1,
				irq(2) => irq2,
				irq(3) => irq3,
				pipeline => pipeline,
				
				-- Test Bench Outputs
				oe => open,
				cc_out => open,
				ctrl_load => open,
				upc => open,
				y_out => open,
				r_out => open,
				map_out => open,
				ctrl_out => open,
				stack_out => open,
				s_out => open
				);

DATA: entity data_unit
	port map(clk => clk,
				reset => btn_south,
				pipeline => pipeline,
				sscu_cc => sscu_cc,
				pcu_ir => ir,
				idb => idb,
				pcu_out => pcu_out,
				mdr_write => mdr_in,
				mdr_read => mdr_out,
				
				-- Test bench outputs
				sscu_out => sscu_out,
				alu_out => alu_out,
				a_out_tb => a_out_tb,
				b_out_tb => b_out_tb,
				
--				sscu_out => open,
--				alu_out => open,
--				a_out_tb => open,
--				b_out_tb => open,
				
				pc => pc
				);
				
RAM_SELECT: entity ram_select	
	port map(irq0 => irq0,
				irq3 => irq3,
				pcu_out => pcu_out (7 downto 0),
				pcu_we => pipeline(2),
				pcu_din => mdr_in,
				address_ctr => address_ctr,
				address_we => write_mem,	
				address_din => address_din,
				ram_addr => ram_addr,
				ram_we => ram_we,
				ram_din => ram_din
				);
				
RAM: entity RAM
	port map(clk => clk,
				we => ram_we,
				vma => pipeline(3),
				mar => ram_addr,
				din => ram_din,
				mdr => mdr_out
				);
				
CONTROLLER: entity cisc04_controller
	port map(clk => clk,
				reset => btn_south,
				ps2_clk => ps2_clk,
				ps2_data => ps2_data,
				rotary_a => rotary_a,
				rotary_b => rotary_b,
				irq0 => irq0,
				irq3 => irq3,
				mdr => mdr_out,
				write_mem => write_mem,
				address_out => address_ctr,
				address_din => address_din,
				lcd_d => lcd_d,
				lcd_e => lcd_e,
				lcd_rs => lcd_rs,
				lcd_rw => lcd_rw
				);
				
end Behavioral;

