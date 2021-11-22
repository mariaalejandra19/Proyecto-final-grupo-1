LIBRARY IEEE; -- IEEE library is included
USE IEEE.STD_LOGIC_1164.ALL; -- the std_logic_1164 package from the IEEE library is used
--------------------------------------------------------
ENTITY BALL_clk_tb IS 
END ENTITY BALL_clk_tb; 
--------------------------------------------------------
ARCHITECTURE testbench_BALL_clk OF BALL_clk_tb IS 
    --SIGNALS
    SIGNAL clk_tb    		  :    STD_LOGIC:= '0';
    SIGNAL rst_tb    		  :    STD_LOGIC:= '1';
    SIGNAL Speed_C_tb    	  :    STD_LOGIC:= '0';
	 SIGNAL max_tick_tb    	  :    STD_LOGIC;
BEGIN
    --CLOCK GENERATION-----
	 clk_tb <= NOT clk_tb AFTER 10ns; --50 MHz CLOCK
	 --RESET GENERATION----
	 rst_tb            <= '0' 	 AFTER 100ns;
	 Speed_C_tb        <= '1' 	 AFTER 270ns, '0' AFTER 290ns, '1' AFTER 460ns, '0' AFTER 480ns;
	 
    DUT: ENTITY work.BALL_clk
	 
    PORT    MAP(    clk    	 		  =>    clk_tb,
                    rst    	 		  =>    rst_tb,
						  Speed_C	    	  =>    Speed_C_tb,
						  max_tick     	  =>    max_tick_tb); -- port mapping
						  
 
END ARCHITECTURE testbench_BALL_clk;