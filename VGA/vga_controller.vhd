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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY vga_controller IS
        PORT(clk	                    : IN STD_LOGIC;
		  reset : in STD_LOGIC;
			 hs, vs   : OUT STD_LOGIC;
			 pixel_tick : OUT STD_LOGIC;
			 pixel_x, pixel_y : OUT STD_LOGIC_VECTOR (9 downto 0));
        END vga_controller;
        
ARCHITECTURE behavioral OF vga_controller IS

-- Video Display Signals   
signal hc,vc: std_logic_vector(9 Downto 0);

-- Signals for Video Memory for Pixel Data
signal col_address, row_address: std_logic_vector(7 Downto 0);
signal col_count, row_count: std_logic_vector(2 Downto 0);
constant H_max : std_logic_vector(9 Downto 0) := CONV_STD_LOGIC_VECTOR(799,10); 
constant V_max : std_logic_vector(9 Downto 0) := CONV_STD_LOGIC_VECTOR(524,10); 

signal clkdiv: STD_LOGIC;
begin           


--This cuts the 50Mhz clkdiv in half
	process(clk, reset)
	begin
		if (reset = '1') then
			clkdiv <= '0';
		elsif(clk = '1' and clk'EVENT) then
			clkdiv <= not clkdiv;
		end if;
	end process;

-----------------------------------------------------

--Generate Horizontal and Vertical Timing Signals for Video Signal
VIDEO_DISPLAY: Process
Begin

Wait until(clkdiv'Event and clkdiv='1');

-- hc counts pixels (640 + extra time for sync signals)
If (hc >= H_max) then
   hc <= "0000000000";
Else
	hc <= hc + "0000000001";
End if;

--Generate Horizontal Sync Signal
If (hc <= CONV_STD_LOGIC_VECTOR(755,10)) and (hc >= CONV_STD_LOGIC_VECTOR(659,10)) Then
   hs <= '0';
ELSE
   hs <= '1';
End if;

--vc counts rows of pixels (480 + extra time for sync signals)
If (vc >= V_max) and (hc >= CONV_STD_LOGIC_VECTOR(699,10)) then
	vc <= "0000000000";
Else If (hc = CONV_STD_LOGIC_VECTOR(699,10)) Then
	vc <= vc + "0000000001";
End if;


-- Generate Vertical Sync Signal
If (vc <= CONV_STD_LOGIC_VECTOR(494,10)) and (vc >= CONV_STD_LOGIC_VECTOR(493,10)) Then
   vs <= '0';
ELSE
   vs <= '1';
End if;

-- Generate row and col address for 7 by 5 superpixel to map into 64 by 64 video memory

if (hc <= CONV_STD_LOGIC_VECTOR(639,10)) Then
   If col_count < CONV_STD_LOGIC_VECTOR(7,3) Then
   		col_count <= col_count + '1';
   Else
   		col_count <= "000";
   		col_address <= col_address + '1';
   End if;
ELSE
   col_count <= "000";
   col_address <= "00000000";
End if;

IF(hc = CONV_STD_LOGIC_VECTOR(641,10)) Then
    row_count <= row_count + '1';
If (row_count = CONV_STD_LOGIC_VECTOR(5,3)) THEN
   row_count <= "000";
   row_address <= row_address + '1';
End if;
End if;

If (vc >= CONV_STD_LOGIC_VECTOR(479,10)) Then
   row_count <= "000";
   row_address <= "00000000";
End if;
end if;
end process VIDEO_DISPLAY;

-- Output pixels
pixel_y <= vc;
pixel_x <= hc;
pixel_tick <= clkdiv;

END behavioral;




