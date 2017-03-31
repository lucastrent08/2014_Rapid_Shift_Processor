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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY top_level_tb_vhd IS
END top_level_tb_vhd;

ARCHITECTURE behavior OF top_level_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT top_level
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ps2_clk : IN std_logic;
		ps2_data : IN std_logic;          
		red : OUT std_logic;
		green : OUT std_logic;
		blue : OUT std_logic;
		leds : OUT std_logic_vector(7 downto 0);
		hsync : OUT std_logic;
		vsync : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL ps2_clk :  std_logic := '0';
	SIGNAL ps2_data :  std_logic := '0';

	--Outputs
	SIGNAL red :  std_logic;
	SIGNAL green :  std_logic;
	SIGNAL blue :  std_logic;
	SIGNAL leds :  std_logic_vector(7 downto 0);
	SIGNAL hsync :  std_logic;
	SIGNAL vsync :  std_logic;
	
	signal keycode : std_logic_vector(10 downto 0);
	constant Num: integer := 15;
	type testVectorType is array (0 to Num-1)
        of std_logic_vector(7 downto 0);
   -- ROM definition
   constant TV: testVectorType:=(   
   x"14",x"1C",x"1C",x"1C",x"F0",x"1c",x"F0",x"14",
	x"E0",x"14",x"E0",x"14",x"E0",x"F0",x"14");


BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: top_level PORT MAP(
		clk => clk,
		reset => reset,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		red => red,
		green => green,
		blue => blue,
		leds => leds,
		hsync => hsync,
		vsync => vsync
	);
	
	m50MHZ_Clock: process is
	begin
		clk <='0','1' after 25 ns,'0' after 25 ns; 
	end process;


	tb : PROCESS
	BEGIN
	
		-- Wait 100 ns for global reset to finish
		PS2_Data <='1';
		reset <= '1';
		wait for 100 ns;
		PS2_Data <='1';
		PS2_Clk <='1';
		reset <= '0';

		-- Place stimulus here
		
		for j in 0 to Num-1
		loop
			keycode <= b"11" & TV(j) & '0';		-- parity is always 1 because its a DC
			wait for 10 us;
			for i in 0 to 10
			loop
				PS2_Data <= keycode(i); 
				PS2_Clk <='0' after 50 us,'1' after 100 us;
				wait for 100 us;
			end loop;
			wait for 500 us;
		end loop;


		wait; -- will wait forever
	END PROCESS;

END;
