----------------------------------------------------------------------------------
-- Company: Bryant Electric Motors/University of Massachusetts Dartmouth
-- Department: Electrical and Computer Engineering
-- Engineer: Lucas Trent
-- Create Date:    March 2014
-- Module Name:    FPU
-- Project Name: 	 CISC 04
-- Target Devices: Spartan-3E
-- Tool versions:	 Xilinx ISE 9.2-- Description: Shift linkage multiplexer.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift_linkage_mux is
    Port ( clk : in STD_LOGIC;
			  MC : in STD_LOGIC;
			  MN : in STD_LOGIC;
			  shift_instr : in  STD_LOGIC_VECTOR (4 downto 0);
           Q : in  STD_LOGIC_VECTOR (15 downto 0);
           RAM : in  STD_LOGIC_VECTOR (15 downto 0);
			  CCR : in STD_LOGIC_VECTOR (3 downto 0);
           Qout : out  STD_LOGIC_VECTOR (15 downto 0);
           RAMout : out  STD_LOGIC_VECTOR (15 downto 0));
end shift_linkage_mux;

architecture Behavioral of shift_linkage_mux is
begin

-- MC <= tmp_mc;

process (shift_instr, clk)
	variable tmp_ram, tmp_q : STD_LOGIC_VECTOR (15 downto 0) := (OTHERS => '0');
	variable ram_lsb, q_lsb, tmp_mc : STD_LOGIC := '0';
begin
	if (clk'event and clk='0') then
	
		tmp_ram := RAM;
		tmp_q := Q;

		
		-- Shift linkage
		case shift_instr is
			when "00000" =>
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := '0';
				tmp_q(15) := '0';
			when "00001" =>
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := '1';
				tmp_q(15) := '1';
			when "00010" =>
				tmp_mc := tmp_ram(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := '0';
				tmp_q(15) := MN;
			when "00011" =>
				ram_lsb := tmp_ram(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := '1';
				tmp_q(15) := ram_lsb;
			when "00100" =>
				ram_lsb := tmp_ram(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := MC;
				tmp_q(15) := ram_lsb;
			when "00101" =>
				ram_lsb := tmp_ram(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := MN;
				tmp_q(15) := ram_lsb;
			when "00110" =>
				ram_lsb := tmp_ram(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := '0';
				tmp_q(15) := ram_lsb;
			when "00111" =>
				ram_lsb := tmp_ram(0);
				tmp_mc := tmp_q(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := '0';
				tmp_q(15) := ram_lsb;
			when "01000" =>
				tmp_mc := tmp_ram(0);
				ram_lsb := tmp_ram(0);
				q_lsb := tmp_q(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := ram_lsb;
				tmp_q(15) := q_lsb;
			when "01001" =>
				ram_lsb := tmp_ram(0);
				q_lsb := tmp_q(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := MC;
				tmp_q(15) := q_lsb;
				tmp_mc := ram_lsb;
			when "01010" =>
				ram_lsb := tmp_ram(0);
				q_lsb := tmp_q(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := ram_lsb;
				tmp_q(15) := q_lsb;
			when "01011" =>
				ram_lsb := tmp_ram(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := CCR(0); 		-- IC
				tmp_q(15) := ram_lsb;
			when "01100" =>
				ram_lsb := tmp_ram(0);
				q_lsb := tmp_q(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := MC;
				tmp_q(15) := ram_lsb;
				tmp_mc := q_lsb;
			when "01101" =>
				tmp_mc := tmp_ram(0);
				ram_lsb := tmp_ram(0);
				q_lsb := tmp_q(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := q_lsb;
				tmp_q(15) := ram_lsb;
			when "01110" =>
				ram_lsb := tmp_ram(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := CCR(3) xor CCR(2);		-- IN + IOVR
				tmp_q(15) := ram_lsb;
			when "01111" =>
				ram_lsb := tmp_ram(0);
				q_lsb := tmp_q(0);
				for i in 1 to 15 loop
					tmp_ram(i-1) := tmp_ram(i);
					tmp_q(i-1) := tmp_q(i);
				end loop;
				tmp_ram(15) := q_lsb;	
				tmp_q(15) := ram_lsb;
			when "10000" =>
				tmp_mc := tmp_ram(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := '0';
				tmp_q(0) := '0';
			when "10001" =>
				tmp_mc := tmp_ram(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := '1';
				tmp_q(0) := '1';
			when "10010" =>
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := '0';
				tmp_q(0) := '0';
			when "10011" =>
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := '1';
				tmp_q(0) := '1';
			when "10100" =>
				tmp_mc := tmp_ram(15);
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := q_lsb;
				tmp_q(0) := '0';
			when "10101" =>
				tmp_mc := tmp_ram(15);
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := q_lsb;
				tmp_q(0) := '1';
			when "10110" =>
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := q_lsb;
				tmp_q(0) := '0';
			when "10111" =>
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := q_lsb;
				tmp_q(0) := '1';
			when "11000" =>
				ram_lsb := tmp_ram(15);
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := ram_lsb;
				tmp_q(0) := q_lsb;
				tmp_mc := ram_lsb;
			when "11001" =>
				ram_lsb := tmp_ram(15);
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := MC;
				tmp_q(0) := q_lsb;
				tmp_mc := ram_lsb;
			when "11010" =>
				ram_lsb := tmp_ram(15);
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := ram_lsb;
				tmp_q(0) := q_lsb;
			when "11011" =>
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := MC;
				tmp_q(0) := '0';
			when "11100" =>
				ram_lsb := tmp_ram(15);
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := q_lsb;
				tmp_q(0) := MC;
				tmp_mc := ram_lsb;
			when "11101" =>
				ram_lsb := tmp_ram(15);
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := q_lsb;
				tmp_q(0) := ram_lsb;
				tmp_mc := ram_lsb;
			when "11110" =>
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := q_lsb;
				tmp_q(0) := MC;
			when OTHERS =>
				ram_lsb := tmp_ram(15);
				q_lsb := tmp_q(15);
				for i in 15 downto 1 loop
					tmp_ram(i) := tmp_ram(i-1);
					tmp_q(i) := tmp_q(i-1);
				end loop;
				tmp_ram(0) := q_lsb;
				tmp_q(0) := ram_lsb;
		end case;
		
		Qout <= tmp_q;
		RAMout <= tmp_ram;
	end if;
end process;


end Behavioral;

