LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------------------------------------
ENTITY LEDS IS
	PORT (	clk			  :  IN  STD_LOGIC;
				rst			  :  IN  STD_LOGIC;
				Pos_R1 	     :  IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
            Pos_R2        :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0); 
				Pos_ball_x	  :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
				Pos_ball_y	  :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		      Win_or_Lose	  :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);	
			   rst_led	  	  :  OUT STD_LOGIC;
				Pos_mtx1		  :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				Pos_mtx2		  :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				Neg_mtx1		  :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				Neg_mtx2		  :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;
------------------------------------------------------------------
ARCHITECTURE behaviour OF LEDS IS
	TYPE state IS (Rackets, BALL, WINp1, WINp2);
	SIGNAL	pr_state,nxt_state  	: state; 
	SIGNAL 	Pos_R1_s, Pos_R2_s   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL 	Pos_R1_11, Pos_R1_21 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL 	Pos_R1_31, Neg_R1_11 : STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL 	Neg_R1_21, Neg_R1_31 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL 	Pos_R2_11, Pos_R2_21 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL 	Pos_R2_31, Neg_R2_11 : STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL 	Neg_R2_21, Neg_R2_31 : STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL 	Pos_R1_12, Pos_R1_22 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL 	Pos_R1_32, Neg_R1_12 : STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL 	Neg_R1_22, Neg_R1_32 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL 	Pos_R2_12, Pos_R2_22 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL 	Pos_R2_32, Neg_R2_12 : STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL 	Neg_R2_22, Neg_R2_32 : STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL   Pos_mtx1R, Pos_mtx2R : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL   Neg_mtx1R, Neg_mtx2R : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL   Pos_mtx1B, Pos_mtx2B : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL   Neg_mtx1B, Neg_mtx2B : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL   Pos_ball_x_s         : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL   Pos_ball_y_s         : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL	pulse_50MHZ				: STD_LOGIC_VECTOR(22 DOWNTO 0);
	SIGNAL   clkDisplay				: STD_LOGIC;
	CONSTANT ONE_1						: STD_LOGIC:='1';
	CONSTANT ZERO_1					: STD_LOGIC:='0';
	CONSTANT ONE 					   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
	CONSTANT SECHZEHN	    		   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	CONSTANT MAX 						: STD_LOGIC_VECTOR(22 DOWNTO 0) :="00000000110010110010000";
	BEGIN
	WITH Pos_R1 SELECT 
	Pos_R1_s	<=	"0001"	WHEN	"11100000",
					"0010"	WHEN	"01110000",
					"0011"	WHEN	"00111000",
					"0100"	WHEN	"00011100",
					"0101"	WHEN	"00001110",
					"0110"	WHEN	"00000111",
					"0111"	WHEN	OTHERS;
	WITH Pos_R2 SELECT 				
	Pos_R2_s	<=	"0001"	WHEN	"11100000",
					"0010"	WHEN	"01110000",
					"0011"	WHEN	"00111000",
					"0100"	WHEN	"00011100",
					"0101"	WHEN	"00001110",
					"0110"	WHEN	"00000111",
					"0111"	WHEN	OTHERS;
					
	Pos_ball_x_s <= (STD_LOGIC_VECTOR(UNSIGNED(Pos_ball_x)+1)) WHEN (Pos_ball_x < "1111") ELSE
	                 "0000";
	Pos_ball_Y_s <= (STD_LOGIC_VECTOR(UNSIGNED(Pos_ball_y)+1)) WHEN (Pos_ball_y < "1111") ELSE
	                 "0000";
	Rst_led <= '0';					  
	LED1_R1: ENTITY work.ultimate_mtx
		PORT MAP(	Pos_x 	=> ONE,
						Pos_y 	=> Pos_R1_s  ,
						Pos_mtx1	=>	Pos_R1_11 ,
						Pos_mtx2	=>	Pos_R1_12 ,
						Neg_mtx1	=> Neg_R1_11 ,
						Neg_mtx2	=> Neg_R1_12);
	LED2_R1: ENTITY work.ultimate_mtx
		PORT MAP(	Pos_x 	=> ONE,
						Pos_y 	=> STD_LOGIC_VECTOR(UNSIGNED(Pos_R1_s)+1),
						Pos_mtx1	=>	Pos_R1_21 ,
						Pos_mtx2	=>	Pos_R1_22 ,
						Neg_mtx1	=> Neg_R1_21 ,
						Neg_mtx2	=> Neg_R1_22);
	LED3_R1: ENTITY work.ultimate_mtx
		PORT MAP(	Pos_x 	=> ONE,
						Pos_y 	=> STD_LOGIC_VECTOR(UNSIGNED(Pos_R1_s)+2),
						Pos_mtx1	=>	Pos_R1_31 ,
						Pos_mtx2	=>	Pos_R1_32 ,
						Neg_mtx1	=> Neg_R1_31 ,
						Neg_mtx2	=> Neg_R1_32);
	LED1_R2: ENTITY work.ultimate_mtx
		PORT MAP(	Pos_x 	=> SECHZEHN,
						Pos_y 	=> Pos_R2_s  ,
						Pos_mtx1	=>	Pos_R2_11 ,
						Pos_mtx2	=>	Pos_R2_12 ,
						Neg_mtx1	=> Neg_R2_11 ,
						Neg_mtx2	=> Neg_R2_12);
	LED2_R2: ENTITY work.ultimate_mtx
		PORT MAP(	Pos_x 	=> SECHZEHN,
						Pos_y 	=> STD_LOGIC_VECTOR(UNSIGNED(Pos_R2_s)+1),
						Pos_mtx1	=>	Pos_R2_21 ,
						Pos_mtx2	=>	Pos_R2_22 ,
						Neg_mtx1	=> Neg_R2_21 ,
						Neg_mtx2	=> Neg_R2_22);
	LED3_R2: ENTITY work.ultimate_mtx
		PORT MAP(	Pos_x 	=> SECHZEHN,
						Pos_y 	=> STD_LOGIC_VECTOR(UNSIGNED(Pos_R2_s)+2),
						Pos_mtx1	=>	Pos_R2_31 ,
						Pos_mtx2	=>	Pos_R2_32 ,
						Neg_mtx1	=> Neg_R2_31 ,
						Neg_mtx2	=> Neg_R2_32);						
	BOLA: ENTITY work.ultimate_mtx
		PORT MAP(	Pos_x 	=> Pos_ball_x_s,
						Pos_y 	=> Pos_ball_y_s,
						Pos_mtx1	=>	Pos_mtx1B ,
						Pos_mtx2	=>	Pos_mtx2B ,
						Neg_mtx1	=> Neg_mtx1B ,
						Neg_mtx2	=> Neg_mtx2B);
	Contador_cronometro: ENTITY work.univ_bit_counter_23bits
		PORT MAP( clk      => clk,
					 rst      => ZERO_1,
					 ena      => ONE_1,
					 syn_clr  => ZERO_1,
					 max_count=> MAX,
					 max_tick => clkDisplay,
					 counter  => pulse_50MHZ);					
	Pos_mtx1R <= ( Pos_R1_11 OR Pos_R1_21 OR  Pos_R1_31);
	Pos_mtx2R <= (  Pos_R2_12 OR Pos_R2_22 OR  Pos_R2_32);
	Neg_mtx1R <= ( Neg_R1_11 AND Neg_R1_21 AND Neg_R1_31);
	Neg_mtx2R <= ( Neg_R2_12 AND Neg_R2_22 AND Neg_R2_32);
	
	state_logic: PROCESS (rst, clkDisplay, nxt_state)
		BEGIN 
		   IF (rst='1') THEN
				pr_state <= Rackets;
			ELSIF (rising_edge(clkDisplay)) THEN
				pr_state <= nxt_state;
	    	END IF;
	END PROCESS;
	PROCESS(pr_state, Pos_mtx1R, Pos_mtx2B, Pos_mtx1B, Pos_mtx2R, Neg_mtx1R, Neg_mtx2B, Neg_mtx1B, Neg_mtx2R)
	BEGIN
			CASE pr_state IS
				WHEN Rackets  =>	
					Pos_mtx1 <= Pos_mtx1R;
					Pos_mtx2 <= Pos_mtx2R;
					Neg_mtx1 <= Neg_mtx1R;
					Neg_mtx2 <= Neg_mtx2R;
					IF(Win_or_Lose = "01") 	  THEN
						nxt_state <= Winp1;
					ELSIF(Win_or_Lose = "10") THEN
						nxt_state <= Winp2;
					ELSE
						nxt_state <= BALL;
					END IF;
			  WHEN BALL =>
					Pos_mtx1 <= Pos_mtx1B;
					Pos_mtx2 <= Pos_mtx2B;
					Neg_mtx1 <= Neg_mtx1B;
					Neg_mtx2 <= Neg_mtx2B;
					IF(Win_or_Lose = "01")    THEN
						nxt_state <= Winp1;
					ELSIF(Win_or_Lose = "10") THEN
						nxt_state <= Winp2;
					ELSE
						nxt_state <= Rackets;
					END IF;
			  WHEN Winp1	=>
					Pos_mtx1 <= "00000000";
					Pos_mtx2 <= "11111111";
					Neg_mtx1 <= "00000000";
					Neg_mtx2 <= "00000000";
					IF(rst='1') THEN
						nxt_state <= Rackets;
					ELSE	
						nxt_state <= Winp1;
					END IF;
				WHEN Winp2	=>
					Pos_mtx1 <= "11111111";
					Pos_mtx2 <= "00000000";
					Neg_mtx1 <= "00000000";
					Neg_mtx2 <= "00000000";
					IF(rst='1') THEN
						nxt_state <= Rackets;
					ELSE	
						nxt_state <= Winp2;
					END IF;
			END CASE;
		END PROCESS;
	END ARCHITECTURE;