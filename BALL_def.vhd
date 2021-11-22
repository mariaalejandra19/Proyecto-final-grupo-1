LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------
ENTITY BALL_def IS
	PORT (	clk			  :  IN  STD_LOGIC;
				rst			  :  IN  STD_LOGIC;
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
ARCHITECTURE rtl OF BALL_def IS
	CONSTANT ZERO_1 : STD_LOGIC := '0';
--DEFINITION OF SIGNALS
	TYPE state IS (init,diagonalup_l,straight_l,diagonaldo_l,diagonalup_r,straight_r,diagonaldo_r);
	SIGNAL	pr_state,nx_state  		: state; 
   SIGNAL   Pos_R1_s, Pos_R2_s 		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL   Pos_x, Pos_y	    		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL   Pos_x_next, Pos_y_next	: UNSIGNED(3 DOWNTO 0);
	SIGNAL 	sel_x, sel_y				: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL   Move_ball_s     	 		: UNSIGNED(6 DOWNTO 0);
	SIGNAL   ena_s							: STD_LOGIC;
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
	---------Process of the state logic----------
	Move_ball_x <= Pos_x;
	Move_ball_y <= Pos_y;
	
	Pos_x_next <= UNSIGNED(Pos_x) 	 WHEN sel_x = "00" ELSE
					  UNSIGNED(Pos_x) + 1 WHEN sel_x = "01" ELSE
					  UNSIGNED(Pos_x) - 1 WHEN sel_x = "10" ELSE
					  "1000";
	Pos_y_next <= UNSIGNED(Pos_y) 	 WHEN sel_y = "00" ELSE
					  UNSIGNED(Pos_y) + 1 WHEN sel_y = "01" ELSE
					  UNSIGNED(Pos_y) - 1 WHEN sel_y = "10" ELSE
					  "0100";
	Pos_x_dff: ENTITY work.my_dff
		PORT MAP(
					clk        => clk,
					rst        => rst,
					ena 		  => ena_s,
					prn 	  	  => ZERO_1,
					q		     => Pos_x,
					d 	 		  => STD_LOGIC_VECTOR(Pos_x_next)
		);
	Pos_y_dff: ENTITY work.my_dff
		PORT MAP(
					clk        => clk,
					rst        => rst,
					ena 		  => ena_s,
					prn 	  	  => ZERO_1,
					q		     => Pos_y,
					d 	 		  => STD_LOGIC_VECTOR(Pos_y_next)
		);
	   state_logic: PROCESS (rst, clk)
		BEGIN 
		   IF (rst='1') THEN
				pr_state <= init;
			ELSIF (rising_edge(clk)) THEN
				pr_state <= nx_state;
	    	END IF;
	END PROCESS;
	
	PROCESS(pr_state,Pos_x,Pos_y,rst)
	BEGIN
			CASE pr_state IS
				WHEN init      =>	
					   sel_x 	<= "11";
						sel_y 	<= "11";
				   IF (rst='1') THEN
						nx_state    <= init;
						Touch_R1  <= '0';
						Touch_R2  <= '0';
						Border_p1 <= '0';
						Border_p2 <= '0';
					ELSE 
						nx_state  <= straight_l;
						Touch_R1  <= '0';
						Touch_R2  <= '0';
						Border_p1 <= '0';
						Border_p2 <= '0';
					END IF;
				WHEN straight_l =>
					sel_x <= "10";
					sel_y <= "00";
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF (pos_x_next = 0 AND pos_y_next = UNSIGNED(pos_R1_s)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= straight_r;
						ELSIF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)- 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_r;
						ELSIF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)+ 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state    <= straight_l;
						END IF;
					ELSIF (pos_y = "0000") THEN
						IF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)- 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state    <= diagonaldo_l;
						END IF;
					ELSIF (pos_y="0111") THEN
						IF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)+ 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonalup_l;
						END IF;
					END IF;
				WHEN diagonalup_l =>
				   sel_x <= "10";
					sel_y <= "10";
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF (pos_x_next = 0 AND pos_y_next = UNSIGNED(pos_R1_s)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= straight_r;
						ELSIF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)- 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_r;
						ELSIF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)+ 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state    <= diagonalup_l;
						END IF;
					ELSIF (pos_y = "0000") THEN
						IF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)- 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state    <= diagonaldo_l;
						END IF;
					ELSIF (pos_y="0111") THEN
						IF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)+ 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonalup_l;
						END IF;
					END IF;
				WHEN diagonaldo_l =>
				   sel_x <= "10";
					sel_y <= "01";
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF (pos_x_next = 0 AND pos_y_next = UNSIGNED(pos_R1_s)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= straight_r;
						ELSIF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)- 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_r;
						ELSIF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)+ 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonaldo_l;
						END IF;
					ELSIF (pos_y = "0000") THEN
						IF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)- 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state    <= diagonaldo_l;
						END IF;
					ELSIF (pos_y="0111") THEN
						IF (pos_x_next = 0 AND pos_y_next = (UNSIGNED(pos_R1_s)+ 1)) THEN
							Touch_R1  <= '1';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_r;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '1';
							Border_p2 <= '0';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonalup_l;
						END IF;
					END IF;
				WHEN diagonalup_r =>
				   sel_x <= "01";
					sel_y <= "10";
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF (pos_x_next = 15 AND pos_y_next = UNSIGNED(pos_R2_s)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= straight_l;
						ELSIF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)- 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_l;
						ELSIF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)+ 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_l;
						ELSIF (pos_x_next = 15) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonalup_r;
						END IF;
					ELSIF (pos_y = "0000") THEN
						IF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)- 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_l;
						ELSIF (pos_x_next = 15) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state    <= diagonaldo_r;
						END IF;
					ELSIF (pos_y="0111") THEN
						IF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)+ 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_l;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonalup_r;
						END IF;
					END IF;
-------------------------------------------------------------------------------------------------------------------------------------------
					WHEN straight_r =>
				   sel_x <= "01";
					sel_y <= "00";
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF (pos_x_next = 15 AND pos_y_next = UNSIGNED(pos_R2_s)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= straight_l;
						ELSIF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)- 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_l;
						ELSIF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)+ 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_l;
						ELSIF (pos_x_next = 15) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= straight_r;
						END IF;
					ELSIF (pos_y = "0000") THEN
						IF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)- 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_l;
						ELSIF (pos_x_next = 15) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state    <= diagonaldo_r;
						END IF;
					ELSIF (pos_y="0111") THEN
						IF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)+ 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_l;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonalup_r;
						END IF;
					END IF;
					WHEN diagonaldo_r =>
				   sel_x <= "01";
					sel_y <= "01";
					IF(pos_y > "0000" AND pos_y < "0111") THEN
						IF (pos_x_next = 15 AND pos_y_next = UNSIGNED(pos_R2_s)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= straight_l;
						ELSIF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)- 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_l;
						ELSIF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)+ 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_r;
						ELSIF (pos_x_next = 15) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonaldo_r;
						END IF;
					ELSIF (pos_y = "0000") THEN
						IF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)- 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonaldo_l;
						ELSIF (pos_x_next = 15) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state    <= diagonaldo_r;
						END IF;
					ELSIF (pos_y="0111") THEN
						IF (pos_x_next = 15 AND pos_y_next = (UNSIGNED(pos_R2_s)+ 1)) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '1';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state <= diagonalup_l;
						ELSIF (pos_x_next = 0) THEN
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '1';
							nx_state    <= init;
						ELSE 
							Touch_R1  <= '0';
							Touch_R2  <= '0';
							Border_p1 <= '0';
							Border_p2 <= '0';
							nx_state  <= diagonalup_r;
						END IF;
					END IF;
				END CASE;
	END PROCESS;
END ARCHITECTURE;
	