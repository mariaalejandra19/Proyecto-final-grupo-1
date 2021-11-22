LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------
ENTITY racket_p1 IS
	PORT (	clk		 :    IN  STD_LOGIC;
				rst		 :    IN  STD_LOGIC;
				input_p1  :		IN	 STD_LOGIC_VECTOR(1 DOWNTO 0);	
            move_p1   : 	OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;
--------------------------
ARCHITECTURE position OF racket_p1 IS
	TYPE   state IS (pos_0,pos_1,pos_2,pos_3,pos_4,pos_5);
	SIGNAL  move_p1_s         : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL  pr_state,nx_state : state; 	
BEGIN
---------Process of the state logic----------
	   state_logic: PROCESS (rst, clk)
		BEGIN 
		   IF (rst='1') THEN
				pr_state <= pos_0;
				
			ELSIF (rising_edge(clk)) THEN
				pr_state <= nx_state;
	    	END IF;
	END PROCESS;
	
	move_p1 <= move_p1_s;
	
	PROCESS(pr_state,input_p1,rst, move_p1_s,clk)
	BEGIN

			CASE pr_state IS
				WHEN pos_0 =>	
					move_p1_s <= "11100000";
					IF (input_p1="01") THEN
							nx_state <= pos_1;
					ELSE
							nx_state <= pos_0;
					END IF;
					
				WHEN pos_1 =>
						move_p1_s <= "01110000";
						IF(input_p1="10") THEN
							nx_state<= pos_0;
						ELSIF(input_p1="01") THEN
							nx_state <= pos_2;
						ELSE	
							nx_state <= pos_1;
						END IF;
					
				WHEN pos_2 =>
						move_p1_s <= "00111000";
						IF(input_p1="10") THEN
							nx_state<= pos_1;
						ELSIF(input_p1="01") THEN
							nx_state <= pos_3;
						ELSE	
							nx_state <= pos_2;
						END IF;
					
				WHEN pos_3 =>
						move_p1_s <= "00011100";
						IF(input_p1="10") THEN
							nx_state<= pos_2;
						ELSIF(input_p1="01") THEN
							nx_state <= pos_4;
						ELSE	
							nx_state <= pos_3;
						END IF;
					
				WHEN pos_4 =>
						move_p1_s <= "00001110";
						IF(input_p1="10") THEN
							nx_state<= pos_3;
						ELSIF(input_p1="01") THEN
							nx_state <= pos_5;
						ELSE	
							nx_state <= pos_4;
						END IF;
					
				WHEN pos_5 =>
						move_p1_s <= "00000111";
					IF(input_p1="10") THEN
						nx_state<= pos_4;
					ELSE	
						nx_state <= pos_5;
					END IF;
				END CASE;
	END PROCESS;
END ARCHITECTURE;