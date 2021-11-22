LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------------------
ENTITY Reset IS	
	PORT (R_button		: IN   STD_LOGIC;
			Round_end 	: IN   STD_LOGIC;
			T_rst 		: OUT  STD_LOGIC;
			N_rst    	: OUT   STD_LOGIC);		
END ENTITY;
ARCHITECTURE gate_level OF Reset IS
BEGIN
	T_rst <= R_button;
	N_rst <= Round_end;
END ARCHITECTURE;