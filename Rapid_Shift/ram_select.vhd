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
-- Description: Selects external RAM control
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram_select is
    Port ( irq0 : in  STD_LOGIC;
			  irq3 : in  STD_LOGIC;
           pcu_out : in  STD_LOGIC_VECTOR (7 downto 0);
			  pcu_we : in STD_LOGIC;
			  pcu_din : in STD_LOGIC_VECTOR (15 downto 0);
           address_ctr : in  STD_LOGIC_VECTOR (7 downto 0);
			  address_we : in STD_LOGIC;
			  address_din : in STD_LOGIC_VECTOR (15 downto 0);
           ram_addr : out  STD_LOGIC_VECTOR (7 downto 0);
			  ram_we : out STD_LOGIC;
			  ram_din : out STD_LOGIC_VECTOR (15 downto 0)
			  );
end ram_select;

architecture Behavioral of ram_select is
	signal address_we_temp : std_logic;
begin

-- Select RAM access based on interrupt state
ram_addr <= pcu_out when irq0='1' else address_ctr;
ram_we <= pcu_we when irq0='1' else address_we_temp;
ram_din <= pcu_din when irq0='1' else address_din;

-- Control address_we
address_we_temp <= address_we when irq3='0' else '1';

end Behavioral;

