LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------
ENTITY BALL_def2 IS
	PORT (	clk			  :  IN  STD_LOGIC;
				rst			  :  IN  STD_LOGIC;
				Speed_c		  :  IN  STD_LOGIC;
				Pos_R1 	     :  IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
            Pos_R2        :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0); 
				Move_ball_x	  :  OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
				Move_ball_y	  :  OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		      Border_p1	  :  OUT STD_LOGIC;	
			   Border_p2	  :  OUT STD_LOGIC;
				Touch_R1		  :  OUT STD_LOGIC;
				Touch_R2		  :  OUT STD_LOGIC);
END ENTITY;
---------------------------------------------------------
ARCHITECTURE rtl OF BALL_def2 IS
	CONSTANT ZERO_1 : STD_LOGIC := '0';
--DEFINITION OF SIGNALS
	TYPE state IS (init,diagonalup_l,straight_l,diagonaldo_l,diagonalup_r,straight_r,diagonaldo_r);
	SIGNAL	pr_state,nxt_state  		: state; 
   SIGNAL   Pos_R1_s, Pos_R2_s 		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL   Pos_x, Pos_y	    		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL   Pos_x_next, Pos_y_next	: UNSIGNED(3 DOWNTO 0);
	SIGNAL 	sel_x, sel_y				: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL   ena_s							: STD_LOGIC;
	SIGNAL   Border_p1_s, Border_p2_s: STD_LOGIC;
	SIGNAL   clk_1                   :STD_LOGIC;
 	BEGIN
	
	Border_p1 <= border_p1_s;
	Border_p2 <= border_p2_s;
	ena_s <= clk_1 OR rst OR Border_p1_s OR Border_p2_s;
	
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
					
	Move_ball_x <= Pos_x;
	Move_ball_y <= Pos_y;
	
	Pos_x_next <= UNSIGNED(Pos_x) 	 WHEN sel_x = "00" ELSE
					  UNSIGNED(Pos_x) + 1 WHEN sel_x = "01" ELSE
					  UNSIGNED(Pos_x) - 1 WHEN sel_x = "10" ELSE
					  "1000"              WHEN sel_x = "11" ELSE
					  "1000";
	Pos_y_next <= UNSIGNED(Pos_y) 	 WHEN sel_y = "00" ELSE
					  UNSIGNED(Pos_y) + 1 WHEN sel_y = "01" ELSE
					  UNSIGNED(Pos_y) - 1 WHEN sel_y = "10" ELSE
					  "0100"              WHEN sel_x = "11" ELSE
					  "0100";
	Pos_x_dff: ENTITY work.my_dff
		PORT MAP(
					clk        => clk,
					rst        => ZERO_1,
					ena 		  => ena_s,
					prn 	  	  => ZERO_1,
					q		     => Pos_x,
					d 	 		  => STD_LOGIC_VECTOR(Pos_x_next));
	Pos_y_dff: ENTITY work.my_dff
		PORT MAP(
					clk        => clk,
					rst        => ZERO_1,
					ena 		  => ena_s,
					prn 	  	  => ZERO_1,
					q		     => Pos_y,
					d 	 		  => STD_LOGIC_VECTOR(Pos_y_next));
	Reloj: ENTITY work.BALL_clk
		PORT MAP( clk        => clk,
					 rst        => rst,
					 Speed_C    => Speed_C,
					 max_tick  	=> clk_1);
	   state_logic: PROCESS (rst, clk, nxt_state)
		BEGIN 
		   IF (rst='1') THEN
				pr_state <= init;
			ELSIF (rising_edge(clk)) THEN
				pr_state <= nxt_state;
	    	END IF;
	END PROCESS;
	
	PROCESS(pr_state,Pos_x,Pos_y,rst, Pos_R1_s, Pos_R2_s)
	BEGIN
			CASE pr_state IS
				WHEN init      =>	
					   sel_x 	   <= "11";
						sel_y 	   <= "11";
						Touch_R1    <= '0';
						Touch_R2    <= '0';
						Border_p1_s <= '0';
						Border_p2_s <= '0';
						nxt_state   <= straight_l;
				   IF (rst='1') THEN
						sel_x 	   <= "11";
						sel_y 	   <= "11";
						Touch_R1    <= '0';
						Touch_R2    <= '0';
						Border_p1_s <= '0';
						Border_p2_s <= '0';
						nxt_state   <= init;
					ELSE 
						sel_x       <= "10";
						sel_y       <= "00";
						Touch_R1    <= '0';
						Touch_R2    <= '0';
						Border_p1_s <= '0';
						Border_p2_s <= '0';
						nxt_state   <= straight_l;
					END IF;
				WHEN straight_l =>
					sel_x       <= "10";
					sel_y       <= "00";
					Touch_R1    <= '0';
				   Touch_R2    <= '0';
					Border_p1_s <= '0';
					Border_p2_s <= '0';
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = UNSIGNED(pos_R1_s)) THEN
							sel_x       <= "01";
							sel_y       <= "00";
							Touch_R1    <= '1';
							Touch_R2    <= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= straight_r;
						ELSIF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)- 1)) THEN
							sel_x       <= "01";
							sel_y       <= "10";
							Touch_R1    <= '1';
							Touch_R2    <= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonalup_r;
						ELSIF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)+ 1)) THEN
							sel_x       <= "01";
							sel_y       <= "01";
							Touch_R1    <= '1';
							Touch_R2    <= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonaldo_r;
						ELSIF ((UNSIGNED(pos_x)) = 0) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							nxt_state   <= init;
						ELSE
							sel_x 		<= "10";
							sel_y 		<= "00";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= straight_l;
						END IF;
					ELSIF (rst='1') THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= init;
					ELSIF (pos_y = "0000") THEN
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)- 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_r;
						ELSIF ((UNSIGNED(pos_x)) = 0) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							nxt_state   <= init;
						ELSE
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonaldo_l;
						END IF;
					ELSE 
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)+ 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_r;
						ELSIF ((UNSIGNED(pos_x)) = 0) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= diagonalup_l;
						END IF;
					END IF;
				WHEN diagonalup_l =>
				   sel_x 		<= "10";
					sel_y 		<= "10";
					Touch_R1  	<= '0';
				   Touch_R2 	<= '0';
					Border_p1_s <= '0';
					Border_p2_s <= '0';
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = UNSIGNED(pos_R1_s)) THEN
							sel_x 		<= "01";
							sel_y 		<= "00";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= straight_r;
						ELSIF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)- 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_r;
						ELSIF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)+ 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_r;
						ELSIF ((UNSIGNED(pos_x)) = 0) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonalup_l;
						END IF;
					ELSIF (rst='1') THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= init;
					ELSIF (pos_y = "0000") THEN
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)- 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_r;
						ELSIF ((UNSIGNED(pos_x)) = 0) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonaldo_l;
						END IF;
					ELSE
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)+ 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_r;
						ELSIF ((UNSIGNED(pos_x)) = 0) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= diagonalup_l;
						END IF;
					END IF;
				WHEN diagonaldo_l =>
				   sel_x 				<= "10";
					sel_y 				<= "01";
					Touch_R1  			<= '0';
				   Touch_R2  			<= '0';
					Border_p1_s 		<= '0';
					Border_p2_s 		<= '0';
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = UNSIGNED(pos_R1_s)) THEN
							sel_x 		<= "01";
							sel_y 		<= "00";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= straight_r;
						ELSIF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)- 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_r;
						ELSIF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)+ 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_r;
						ELSIF ((UNSIGNED(pos_x)) = 0) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= diagonaldo_l;
						END IF;
					ELSIF (rst='1') THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= init;
					ELSIF (pos_y = "0000") THEN
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)- 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1 	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_r;
						ELSIF ((UNSIGNED(pos_x)) = 0) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							nxt_state   <= init;
						ELSE
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonaldo_l;
						END IF;
					ELSE
						IF ((UNSIGNED(pos_x)-1) = 0 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R1_s)+ 1)) THEN
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '1';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_r;
						ELSIF ((UNSIGNED(pos_x))=0) THEN
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '1';
							Border_p2_s <= '0';
							sel_x 		<= "11";
							sel_y 		<= "11";
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= diagonalup_l;
						END IF;
					END IF;
				WHEN diagonalup_r =>
				   sel_x 	 	<= "01";
					sel_y 	 	<= "10";
					Touch_R1  	<= '0';
				   Touch_R2  	<= '0';
					Border_p1_s <= '0';
					Border_p2_s <= '0';
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = UNSIGNED(pos_R2_s)) THEN
							sel_x 	 	<= "10";
							sel_y 	 	<= "00";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= straight_l;
						ELSIF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)- 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_l;
						ELSIF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)+ 1)) THEN
						   sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_l;
						ELSIF ((UNSIGNED(pos_x))=15) THEN
							sel_x 		<= "11";
							sel_y		   <= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= diagonalup_r;
						END IF;
					ELSIF (rst='1') THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= init;
					ELSIF (pos_y = "0000") THEN
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)- 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_l;
						ELSIF ((UNSIGNED(pos_x)+1)=15) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonaldo_r;
						END IF;
					ELSE
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)+ 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_l;
						ELSIF ((UNSIGNED(pos_x))=15) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonalup_r;
						END IF;
					END IF;
-------------------------------------------------------------------------------------------------------------------------------------------
				WHEN straight_r =>
				   sel_x 		<= "01";
					sel_y 		<= "00";
					Touch_R1  	<= '0';
				   Touch_R2  	<= '0';
					Border_p1_s <= '0';
					Border_p2_s <= '0';
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = UNSIGNED(pos_R2_s)) THEN
							sel_x 		<= "10";
							sel_y 		<= "00";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= straight_l;
						ELSIF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)- 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_l;
						ELSIF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)+ 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_l;
						ELSIF ((UNSIGNED(pos_x)) = 15) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE
							sel_x 		<= "01";
							sel_y 		<= "00";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= straight_r;
						END IF;
				ELSIF (rst='1') THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= init;
					ELSIF (pos_y = "0000") THEN
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)- 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_l;
						ELSIF ((UNSIGNED(pos_x)) = 15) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonaldo_r;
						END IF;
					ELSE
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)+ 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_l;
						ELSIF ((UNSIGNED(pos_x)) = 15) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1 	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= diagonalup_r;
						END IF;
					END IF;
				WHEN diagonaldo_r =>
				   sel_x 				<= "01";
					sel_y 				<= "01";
					Touch_R1  			<= '0';
				   Touch_R2  			<= '0';
					Border_p1_s 		<= '0';
					Border_p2_s 		<= '0';
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = UNSIGNED(pos_R2_s)) THEN
							sel_x 		<= "10";
							sel_y 		<= "00";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= straight_l;
						ELSIF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)- 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_l;
						ELSIF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)+ 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_l;
						ELSIF ((UNSIGNED(pos_x)) = 15) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= diagonaldo_r;
						END IF;
					ELSIF (rst='1') THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= init;
					ELSIF (pos_y = "0000") THEN
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)- 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2 	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonaldo_l;
						ELSIF ((UNSIGNED(pos_x)) = 15) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "01";
							sel_y 		<= "01";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state   <= diagonaldo_r;
						END IF;
					ELSE
						IF ((UNSIGNED(pos_x)+1) = 15 AND UNSIGNED(pos_y) = (UNSIGNED(pos_R2_s)+ 1)) THEN
							sel_x 		<= "10";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2  	<= '1';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state 	<= diagonalup_l;
						ELSIF ((UNSIGNED(pos_x)) = 15) THEN
							sel_x 		<= "11";
							sel_y 		<= "11";
							Touch_R1  	<= '0';
							Touch_R2  	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '1';
							nxt_state   <= init;
						ELSE 
							sel_x 		<= "01";
							sel_y 		<= "10";
							Touch_R1  	<= '0';
							Touch_R2 	<= '0';
							Border_p1_s <= '0';
							Border_p2_s <= '0';
							nxt_state  	<= diagonalup_r;
						END IF;
					END IF;
				END CASE;
	END PROCESS;
END ARCHITECTURE;
	