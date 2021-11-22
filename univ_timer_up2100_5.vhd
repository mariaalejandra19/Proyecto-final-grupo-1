LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY univ_timer_up2100_5 IS
	PORT		( clk	 	        :	IN  STD_LOGIC;
				  rst  	        :	IN  STD_LOGIC;
				  go	 	        :	IN  STD_LOGIC;
				  syn_clr        :	IN  STD_LOGIC;
				  max_decimales  : 	IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
				  max_unidades   : 	IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
				  max_decenas    : 	IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
				  max_cronometro : 	IN  STD_LOGIC_VECTOR(22 DOWNTO 0);
				  max_tick       :   OUT STD_LOGIC);
   END ENTITY; 
----------------------------------------------------------------------------------------------		  
	ARCHITECTURE rtl OF univ_timer_up2100_5 IS
	SIGNAL decimales 			:  STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL unidades 			:  STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL decenas 			:  STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Pulse_50MHZ 		:  STD_LOGIC_VECTOR(22 DOWNTO 0); 
	SIGNAL max_0s, max_1s   :  STD_LOGIC;
	SIGNAL max_2s, max_3s   :  STD_LOGIC;
	SIGNAL max_unidades_s   :  STD_LOGIC;
	SIGNAL max_decenas_s    :  STD_LOGIC;
	BEGIN
		max_unidades_s <= max_0s AND max_1s;
		max_decenas_s  <= max_0s AND max_1s AND max_2s;
		max_tick       <= max_0s AND max_1s AND max_2s AND max_3s;
		
		Contador_cronometro: ENTITY work.univ_bit_counter_23bits
		PORT MAP( clk      => clk,
					 rst      => rst,
					 ena      => go,
					 syn_clr  => syn_clr,
					 max_count=> max_cronometro,
					 max_tick => max_0s,
					 counter  => pulse_50MHZ);
					 
		Contador_decimales: ENTITY work.univ_bit_counter_5bits
		PORT MAP( clk      => clk,
					 rst      => rst,
					 ena      => max_0s,
					 syn_clr  => syn_clr,
					 max_count=> max_decimales,
					 max_tick => max_1s,
					 counter  => decimales);
					 
		Contador_unidades: ENTITY work.univ_bit_counter_5bits
		PORT MAP( clk      => clk,
					 rst      => rst,
					 ena      => max_unidades_s,
					 syn_clr  => syn_clr,
					 max_count=> max_unidades,
					 max_tick => max_2s,
					 counter  => unidades);
					 
		Contador_decenas: ENTITY work.univ_bit_counter_5bits
		PORT MAP( clk      => clk,
					 rst      => rst,
					 ena      => max_decenas_s,
					 syn_clr  => syn_clr,
					 max_count=> max_decenas,
					 max_tick => max_3s,
					 counter  => decenas);		 
	END ARCHITECTURE;