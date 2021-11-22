LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------------------
ENTITY proyect_2_G1 IS	
	PORT (clk			: IN  STD_LOGIC;
			rst 			: IN  STD_LOGIC;
			Joy_1 		: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			Joy_2    	: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			Hex0			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			Hex1			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			Hex2			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			Hex3			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			Positivo1   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			Positivo2   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			Negativo1   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			Negativo2   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));		
END ENTITY;
---------------------------------------------------------------------
ARCHITECTURE behaviour OF  proyect_2_G1 IS
-- CONSTANT DEFINITION
	CONSTANT ZERO_7   : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
	CONSTANT THREE_4  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
	CONSTANT ZERO_4   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	CONSTANT FIVE_4    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
	CONSTANT ONE      : STD_LOGIC := '1';
	CONSTANT ZERO     : STD_LOGIC := '0';
	CONSTANT PULSE_5M : STD_LOGIC_VECTOR(22 DOWNTO 0) := "10011000100101100111111";
	CONSTANT NUM17_5  : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10001";
	CONSTANT ZERO_5   : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
	-- SIGNALS DEFINITION
	SIGNAL points_p1, points_p2 			: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL max_cp1, max_cp2       		: STD_LOGIC;
	SIGNAL clk_2      	         		: STD_LOGIC;
	SIGNAL min_cp1, min_cp2		   		: STD_LOGIC;
	SIGNAL win_p1, win_p2, round_end_s	: STD_LOGIC;
	SIGNAL win_count1, win_count2 		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL T_rst_s, N_rst_s       		: STD_LOGIC;
	SIGNAL touch_r1_s, touch_r2_s   		: STD_LOGIC;
	SIGNAL border_p1_s,border_p2_s   	: STD_LOGIC;
	SIGNAL rst_3                        : STD_LOGIC;
	SIGNAL input_p1_s,input_p2_s        : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL rst_1_s, clk_1, New_game_rst	: STD_LOGIC;
	SIGNAL rst_2_s, Speed_C            	: STD_LOGIC;
	SIGNAL Winner_s							: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Points								: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Pos_R1_s, Pos_R2_s				: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Hex0_s, Hex1_s 		    		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Hex2_s, Hex3_s					: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Hex_s         					: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Move_ball_x_s, Move_ball_y_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
	BEGIN
	rst_1_s  	<= T_rst_s OR N_rst_s;
	Winner_s 	<= win_p1 & win_p2;
	rst_3 		<= rst OR new_game_rst;
	round_end_s <= rst;
	input_p1_s  <= Joy_1;
	input_p2_s  <= Joy_2;
	
	TimerR: ENTITY work.univ_timer_up2100
		PORT MAP( clk            => clk,
					 rst            => rst_1_s,
					 go             => ONE,
					 syn_clr        => ZERO,
					 max_decimales  => THREE_4,
					 max_unidades   => ZERO_4,
					 max_decenas    => ZERO_4,
					 max_cronometro => PULSE_5M ,
					 max_tick  	    => clk_2);
	   COUNTER_P1: ENTITY work.univ_bin_counter
		PORT MAP(clk        => clk,
					rst        => T_rst_s,
					ena 		  => touch_r1_s,
					syn_clr 	  => ZERO,
					load		  => ZERO,
					up 	     => ONE,
					d 	 		  => ZERO_7,
					max_tick   => max_cp1,
					min_tick   => min_cp1,
					counter    => points_p1);					
		COUNTER_P2: ENTITY work.univ_bin_counter
		PORT MAP(clk        => clk,
					rst        => T_rst_s,
					ena 		  => touch_r2_s,
					syn_clr 	  => ZERO,
					load		  => ZERO,
					up 	     => ONE,
					d 	 		  => ZERO_7,
					max_tick   => max_cp2,
					min_tick   => min_cp2,
					counter    => points_p2);
		LOSE_P1: ENTITY work.univ_bit_counter_4bits
		PORT MAP( clk      => clk,
					 rst      => T_rst_s,
					 ena      => border_p1_s,
					 syn_clr  => ZERO,
					 max_count=> THREE_4,
					 max_tick => win_p1,
					 counter  => win_count1);
		LOSE_P2: ENTITY work.univ_bit_counter_4bits
		PORT MAP( clk      => clk,
					 rst      => T_rst_s,
					 ena      => border_p2_s,
					 syn_clr  => ZERO,
					 max_count=> THREE_4,
					 max_tick => win_p2,
					 counter  => win_count2);
		CONTADOR: ENTITY work.univ_bit_counter_4bits
		PORT MAP( clk      => clk,
					 rst      => T_rst_s,
					 ena      => touch_r2_s,
					 syn_clr  => ZERO,
					 max_count=> FIVE_4,
					 max_tick => Speed_C,
					 counter  => Points);
		Racket_P1: ENTITY work.racket_p1
		PORT MAP( clk      => clk_2,
					 rst      => rst_1_s,
					 input_p1 => input_p1_s,
					 move_p1  => Pos_R1_s);
		Racket_P2: ENTITY work.racket_p2
		PORT MAP( clk      => clk_2,
					 rst      => rst_1_s,
					 input_p2 => input_p2_s,
					 move_p2  => Pos_R2_s);
		Conversor: ENTITY work.CONVERSOR
		PORT MAP( A_bin      => points_p1,
					 B_bin      => points_p2,
					 Hex0 		=> Hex0_s,
					 Hex1  	   => Hex1_s,
					 Hex2       => Hex2_s,
					 Hex3       => Hex3_s);
		Reset: ENTITY work.Reset
		PORT MAP( T_rst    	=> T_rst_s,
					 N_rst    	=> N_rst_s,
					 R_button 	=> rst_3,
					 Round_end  => round_end_s);
		BALL: ENTITY work.BALL_def2
		PORT MAP( clk       		=> clk,
					 rst           => rst_1_s,
					 Speed_C		   => Speed_C,
					 Pos_R1 		   => Pos_R1_s,
					 Pos_R2  	   => Pos_R2_s,
					 Move_ball_x   => Move_ball_x_s,
					 Move_ball_y   => Move_ball_y_S,
					 Border_p1		=> Border_p1_s,
					 Border_p2		=> Border_p2_s,
					 Touch_R1 		=> Touch_r1_s,
					 Touch_R2		=> Touch_r2_s);
		MATRIX_LEDS: ENTITY work.LEDS
		PORT MAP( clk			     => clk,
				    rst			  	  => rst_1_s,
				    Pos_R1 	        => Pos_R1_s,
                Pos_R2          => Pos_R2_s,
					 Pos_ball_x	  	  => Move_ball_x_s,
					 Pos_ball_y	  	  => Move_ball_y_s,
					 Win_or_Lose	  => Winner_s,
					 rst_led	  	 	  => New_game_rst,
					 Pos_mtx1		  => Positivo1,
					 Pos_mtx2		  => Positivo2,
					 Neg_mtx1		  => Negativo1,
					 Neg_mtx2		  => Negativo2);					 
		Hex_0: ENTITY work.sevenSeg
		PORT MAP( bin      	=> win_count2,
					 sseg       => Hex0);
		Hex_1: ENTITY work.sevenSeg
		PORT MAP( bin      	=> win_count1,
					 sseg       => Hex1);
		Hex_2: ENTITY work.sevenSeg
		PORT MAP( bin      	=> Hex2_s,
					 sseg       => Hex2);
		Hex_3: ENTITY work.sevenSeg
		PORT MAP( bin      	=> Hex3_s,
					 sseg       => Hex3);		 
END ARCHITECTURE;