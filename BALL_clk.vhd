LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------
ENTITY BALL_clk IS 
	PORT (	clk	 	        :	IN  STD_LOGIC;
            rst  	           :	IN  STD_LOGIC;	
	         Speed_C          :   IN  STD_LOGIC;
				max_tick         :   OUT STD_LOGIC);
	END ENTITY;
--------------------------------------------------------------------------
ARCHITECTURE rtl OF BALL_clk IS
--CONSTANTS
	CONSTANT UNO_1    			 : STD_LOGIC 			    		   := '1'; 
	CONSTANT ZERO_1    			 : STD_LOGIC 			    		   := '0';
	CONSTANT PULSE_5M 			 : STD_LOGIC_VECTOR(22 DOWNTO 0) := "10011000100101100111111";
	CONSTANT n						 : STD_LOGIC_VECTOR(22 DOWNTO 0) := "00000000000000000000000";
	CONSTANT FIVE_4				 : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0101";
	CONSTANT ZERO_4				 : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";
	CONSTANT UNO_4				    : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0001";
--SIGNALS 
	SIGNAL max_2, min_2 : STD_LOGIC;
	SIGNAL max_count_s  : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL max :STD_LOGIC_VECTOR(3 DOWNTO 0);
	BEGIN
	
	max <= max_count_s WHEN ((max_count_s > "0000") AND (max_count_s < "0110")) ELSE 
	       "0000";
			 
	TimerR: ENTITY work.univ_timer_up2100
		PORT MAP( clk            => clk,
					 rst            => rst,
					 go             => UNO_1,
					 syn_clr        => ZERO_1,
					 max_decimales  => max,
					 max_unidades   => ZERO_4,
					 max_decenas    => ZERO_4,
					 max_cronometro => PulSE_5M,
					 max_tick  	    => max_tick);
	n_control: ENTITY work.univ_bin_counter2
		PORT MAP(clk        => Speed_C,
					rst        => rst,
					ena 		  => UNO_1,
					syn_clr 	  => ZERO_1,
					load		  => ZerO_1,
					up 	     => ZERO_1,
					d 	 		  => FIVE_4,
					max_tick   => max_2,
					min_tick   => min_2,
					counter    => max_count_s);
	END ARCHITECTURE;