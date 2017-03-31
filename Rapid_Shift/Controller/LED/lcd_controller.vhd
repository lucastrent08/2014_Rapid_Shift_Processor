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
-- Description: Determines when the LCD Screen should light up and where it should light up based on register values.
---------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.data_types.all;

entity lcd_controller is
	Port(
		clk, reset : in std_logic;
		cursor : in std_logic_vector (3 downto 0);
		line1 : in ascii_array (0 to 15);
		line2 : in ascii_array (0 to 15);
		lcd_d : out bit_vector(3 downto 0);
		lcd_e, lcd_rs, lcd_rw: out bit);
end lcd_controller;

architecture behavior of lcd_controller is

type tx_sequence is (high_setup, high_hold, oneus, low_setup, low_hold, fortyus, done);
signal tx_state : tx_sequence := done;
signal tx_byte : bit_vector(7 downto 0);
signal tx_init : bit := '0';

type init_sequence is (idle, fifteenms, one, two, three, four, five, six, seven, eight, done);
signal init_state : init_sequence := idle;
signal init_init, init_done : bit := '0';

constant refreshrate : integer := 300000;
constant blinkrate : integer := 30000000;

signal address : bit_vector (7 downto 0) := "10000000";
signal line : ascii_array (0 to 15);

signal i : integer range 0 to 750000 := 0;
signal i2 : integer range 0 to 2000 := 0;
signal i3 : integer range 0 to 82000 := 0;
signal i4 : integer range 0 to refreshrate := 0;
signal i5 : integer range 0 to blinkrate := 0;

signal lcd_d0, lcd_d1 : bit_vector(3 downto 0);
signal LCD_E0, LCD_E1 : bit;
signal mux : bit;

type display_state is (init, function_set, entry_set, set_display, clr_display, pause, set_addr, char_1, char_2, char_3, char_4, char_5, 
	char_6, char_7, char_8, char_9, char_10, char_11, char_12, char_13, char_14, char_15, char_16, done);
signal cur_state : display_state := init;

begin
	
	LCD_RW <= '0'; --write only

	--The following "with" statements simplify the process of adding and removing states.

	--when to transmit a command/data and when not to
	with cur_state select
		tx_init <= '0' when init | pause | done,
			'1' when others;

	--control the bus
	with cur_state select
		mux <= '1' when init,
			'0' when others;

	--control the initialization sequence
	with cur_state select
		init_init <= '1' when init,
			'0' when others;
	
	--register select
	with cur_state select
		LCD_RS <= '0' when function_set|entry_set|set_display|clr_display|set_addr,
			'1' when others;

	--what byte to transmit to lcd
	--refer to datasheet for an explanation of these values
	with cur_state select
		tx_byte <= "00101000" when function_set,
			"00000110" when entry_set,
			"00001100" when set_display,
			"00000001" when clr_display,
			address when set_addr,
			line(0) when char_1,
			line(1) when char_2,
			line(2) when char_3,
			line(3) when char_4,
			line(4) when char_5,
			line(5) when char_6,
			line(6) when char_7,
			line(7) when char_8,
			line(8) when char_9,
			line(9) when char_10,
			line(10) when char_11,
			line(11) when char_12,
			line(12) when char_13,
			line(13) when char_14,
			line(14) when char_15,
			line(15) when char_16,
			"00000000" when others;
		
	--main state machine
	display_proc: process(clk, reset)
	begin
		if(reset='1') then
			cur_state <= function_set;
		elsif(clk='1' and clk'event) then
			case cur_state is
				--refer to intialize state machine below
				when init =>
					if(init_done = '1') then
						cur_state <= function_set;
					else
						cur_state <= init;
					end if;

				--every other state but pause uses the transmit state machine
				when function_set =>
					if(i2 = 2000) then
						cur_state <= entry_set;
					else
						cur_state <= function_set;
					end if;	
				
				when entry_set =>
					if(i2 = 2000) then
						cur_state <= set_display;
					else
						cur_state <= entry_set;
					end if;
				
				when set_display =>
					if(i2 = 2000) then
						cur_state <= clr_display;
					else
						cur_state <= set_display;
					end if;
				
				when clr_display =>
					i3 <= 0;
					if(i2 = 2000) then
						cur_state <= pause;
					else
						cur_state <= clr_display;
					end if;

				when pause =>
					if(i3 = 82000) then
						cur_state <= set_addr;
						i3 <= 0;
					else
						cur_state <= pause;
						i3 <= i3 + 1;
					end if;

				when set_addr =>
					if(i2 = 2000) then
						cur_state <= char_1;
					else
						cur_state <= set_addr;
					end if;

				when char_1 =>
					if(i2 = 2000) then
						cur_state <= char_2;
					else
						cur_state <= char_1;
					end if;

				when char_2 =>
					if(i2 = 2000) then
						cur_state <= char_3;
					else
						cur_state <= char_2;
					end if;

				when char_3 =>
					if(i2 = 2000) then
						cur_state <= char_4;
					else
						cur_state <= char_3;
					end if;

				when char_4 =>
					if(i2 = 2000) then
						cur_state <= char_5;
					else
						cur_state <= char_4;
					end if;
				
				when char_5 =>
					if(i2 = 2000) then
						cur_state <= char_6;
					else
						cur_state <= char_5;
					end if;
					
				when char_6 =>
					if(i2 = 2000) then
						cur_state <= char_7;
					else
						cur_state <= char_6;
					end if;
					
				when char_7 =>
					if(i2 = 2000) then
						cur_state <= char_8;
					else
						cur_state <= char_7;
					end if;
					
				when char_8 =>
					if(i2 = 2000) then
						cur_state <= char_9;
					else
						cur_state <= char_8;
					end if;
					
				when char_9 =>
					if(i2 = 2000) then
						cur_state <= char_10;
					else
						cur_state <= char_9;
					end if;
					
				when char_10 =>
					if(i2 = 2000) then
						cur_state <= char_11;
					else
						cur_state <= char_10;
					end if;
					
				when char_11 =>
					if(i2 = 2000) then
						cur_state <= char_12;
					else
						cur_state <= char_11;
					end if;
					
				when char_12 =>
					if(i2 = 2000) then
						cur_state <= char_13;
					else
						cur_state <= char_12;
					end if;
					
				when char_13 =>
					if(i2 = 2000) then
						cur_state <= char_14;
					else
						cur_state <= char_13;
					end if;
					
				when char_14 =>
					if(i2 = 2000) then
						cur_state <= char_15;
					else
						cur_state <= char_14;
					end if;
					
				when char_15 =>
					if(i2 = 2000) then
						cur_state <= char_16;
					else
						cur_state <= char_15;
					end if;
					
				when char_16 =>
					if(i2 = 2000) then
						if (address = "10000000") then
							address <= "11000000";
							line <= line2;
							cur_state <= set_addr;
						else
							cur_state <= done;
						end if;						
					else
						cur_state <= char_16;
					end if;				

				when done =>
					address <= "10000000";
					line <= line1;
					
					if (i5 >= blinkrate/2) then
						line(conv_integer(cursor)) <= x"5F";
					end if;
					
					if (i5 = blinkrate) then
						i5 <= 0;
					else
						i5 <= i5 + 1;
					end if;
					
					if (i4 >= refreshrate) then
						cur_state <= function_set;
						i4 <= 0;
					else
						cur_state <= done;
						i4 <= i4 + 1;
					end if;

			end case;
		end if;
	end process display_proc;

	with mux select
		lcd_d <= lcd_d0 when '0', --transmit
			lcd_d1 when others;	--initialize
	with mux select
		LCD_E <= LCD_E0 when '0', --transmit
			LCD_E1 when others; --initialize

	--specified by datasheet
	transmit : process(clk, reset, tx_init)
	begin
		if(reset='1') then
			tx_state <= done;
		elsif(clk='1' and clk'event) then
			case tx_state is
				when high_setup => --40ns
					LCD_E0 <= '0';
					lcd_d0 <= tx_byte(7 downto 4);
					if(i2 = 2) then
						tx_state <= high_hold;
						i2 <= 0;
					else
						tx_state <= high_setup;
						i2 <= i2 + 1;
					end if;

				when high_hold => --230ns
					LCD_E0 <= '1';
					lcd_d0 <= tx_byte(7 downto 4);
					if(i2 = 12) then
						tx_state <= oneus;
						i2 <= 0;
					else
						tx_state <= high_hold;
						i2 <= i2 + 1;
					end if;

				when oneus =>
					LCD_E0 <= '0';
					if(i2 = 50) then
						tx_state <= low_setup;
						i2 <= 0;
					else
						tx_state <= oneus;
						i2 <= i2 + 1;
					end if;

				when low_setup =>
					LCD_E0 <= '0';
					lcd_d0 <= tx_byte(3 downto 0);
					if(i2 = 2) then
						tx_state <= low_hold;
						i2 <= 0;
					else
						tx_state <= low_setup;
						i2 <= i2 + 1;
					end if;

				when low_hold =>
					LCD_E0 <= '1';
					lcd_d0 <= tx_byte(3 downto 0);
					if(i2 = 12) then
						tx_state <= fortyus;
						i2 <= 0;
					else
						tx_state <= low_hold;
						i2 <= i2 + 1;
					end if;

				when fortyus =>
					LCD_E0 <= '0';
					if(i2 = 2000) then
						tx_state <= done;
						i2 <= 0;
					else
						tx_state <= fortyus;
						i2 <= i2 + 1;
					end if;

				when done =>
					LCD_E0 <= '0';
					if(tx_init = '1') then
						tx_state <= high_setup;
						i2 <= 0;
					else
						tx_state <= done;
						i2 <= 0;
					end if;

			end case;
		end if;
	end process transmit;
					
	--specified by datasheet
	power_on_initialize: process(clk, reset, init_init) --power on initialization sequence
	begin
		if(reset='1') then
			init_state <= idle;
			init_done <= '0';
		elsif(clk='1' and clk'event) then
			case init_state is
				when idle =>	
					init_done <= '0';
					if(init_init = '1') then
						init_state <= fifteenms;
						i <= 0;
					else
						init_state <= idle;
						i <= i + 1;
					end if;
				
				when fifteenms =>
					init_done <= '0';
					if(i = 750000) then
						init_state <= one;
						i <= 0;
					else
						init_state <= fifteenms;
						i <= i + 1;
					end if;

				when one =>
					lcd_d1 <= "0011";
					LCD_E1 <= '1';
					init_done <= '0';
					if(i = 11) then
						init_state<=two;
						i <= 0;
					else
						init_state<=one;
						i <= i + 1;
					end if;

				when two =>
					LCD_E1 <= '0';
					init_done <= '0';
					if(i = 205000) then
						init_state<=three;
						i <= 0;
					else
						init_state<=two;
						i <= i + 1;
					end if;

				when three =>
					lcd_d1 <= "0011";
					LCD_E1 <= '1';
					init_done <= '0';
					if(i = 11) then	
						init_state<=four;
						i <= 0;
					else
						init_state<=three;
						i <= i + 1;
					end if;

				when four =>
					LCD_E1 <= '0';
					init_done <= '0';
					if(i = 5000) then
						init_state<=five;
						i <= 0;
					else
						init_state<=four;
						i <= i + 1;
					end if;

				when five =>
					lcd_d1 <= "0011";
					LCD_E1 <= '1';
					init_done <= '0';
					if(i = 11) then
						init_state<=six;
						i <= 0;
					else
						init_state<=five;
						i <= i + 1;
					end if;

				when six =>
					LCD_E1 <= '0';
					init_done <= '0';
					if(i = 2000) then
						init_state<=seven;
						i <= 0;
					else
						init_state<=six;
						i <= i + 1;
					end if;

				when seven =>
					lcd_d1 <= "0010";
					LCD_E1 <= '1';
					init_done <= '0';
					if(i = 11) then
						init_state<=eight;
						i <= 0;
					else
						init_state<=seven;
						i <= i + 1;
					end if;

				when eight =>
					LCD_E1 <= '0';
					init_done <= '0';
					if(i = 2000) then
						init_state<=done;
						i <= 0;
					else
						init_state<=eight;
						i <= i + 1;
					end if;

				when done =>
					init_state <= done;
					init_done <= '1';

			end case;

		end if;
	end process power_on_initialize;

end behavior;

