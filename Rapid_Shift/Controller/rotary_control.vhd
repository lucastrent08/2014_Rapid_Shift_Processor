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
-- Description: Drives the cursor (write address)
-- 	based on the keys pressed on the PS/2 keyboard.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rotary_control is
    Port (clk : in std_logic;
          rotary_a : in std_logic;
          rotary_b : in std_logic;
			 read_mem : out std_logic;
			 address : out std_logic_vector (7 downto 0)
          );
end rotary_control;

architecture Behavioral of rotary_control is

type display_state is (fctn_st, dest_st, shift_st, src_st, imm_st, pcu_instr_st);
signal cur_display_state : display_state := fctn_st;

signal rotary_a_in : std_logic;
signal rotary_b_in : std_logic;
signal rotary_in : std_logic_vector(1 downto 0);
signal rotary_q1 : std_logic;
signal rotary_q2 : std_logic;
signal delay_rotary_q1 : std_logic;
signal rotary_event : std_logic;
signal rotary_left : std_logic;

signal address_reg : std_logic_vector (7 downto 0) := "00000000";

begin

  rotary_filter: process(clk)
  begin
    if clk'event and clk='1' then

      --Sync inputs
      rotary_a_in <= rotary_a;
      rotary_b_in <= rotary_b;

      rotary_in <= rotary_b_in & rotary_a_in;
      case rotary_in is

        when "00" => rotary_q1 <= '0';         
                     rotary_q2 <= rotary_q2;
 
        when "01" => rotary_q1 <= rotary_q1;
                     rotary_q2 <= '0';

        when "10" => rotary_q1 <= rotary_q1;
                     rotary_q2 <= '1';

        when "11" => rotary_q1 <= '1';
                     rotary_q2 <= rotary_q2; 

        when others => rotary_q1 <= rotary_q1; 
                       rotary_q2 <= rotary_q2; 
      end case;

    end if;
  end process rotary_filter;

  direction: process(clk)
  begin
    if clk'event and clk='1' then

      delay_rotary_q1 <= rotary_q1;
      if rotary_q1='1' and delay_rotary_q1='0' then
        rotary_event <= '1';
        rotary_left <= rotary_q2;
       else
        rotary_event <= '0';
        rotary_left <= rotary_left;
      end if;

    end if;
  end process direction;
  
  -- Update instruction with rotary movement
  read_mem <= rotary_event;
  change_instr: process(clk)
  begin
    if clk'event and clk='1' then

      if rotary_event='1' then
			-- Rotate left
        if rotary_left='1' then 
				address_reg <= address_reg+'1';
			 -- Rotate right
         else
				address_reg <= address_reg-'1';
        end if;
      end if;

    end if;
  end process change_instr;
  
  -- Set signal
  address <= address_reg;

end Behavioral;
