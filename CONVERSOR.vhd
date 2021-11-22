LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------------------
ENTITY CONVERSOR IS	
	PORT (A_bin			: IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
			B_bin 	   : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
			Hex0	    	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Hex1	    	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Hex2	    	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Hex3	    	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));		
END ENTITY;
---------------------------------------------------------------------
ARCHITECTURE structure OF CONVERSOR IS
--DEFINITION OF SIGNALS 
	SIGNAL Hex1_s, Hex3_s   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL A_bin_s, B_bin_s : UNSIGNED(6 DOWNTO 0);
	
	BEGIN 
			Hex1_s <= "1001" WHEN A_bin > "1011001" 							  ELSE
					    "1000" WHEN A_bin < "1011010" AND A_bin > "1001111" ELSE
						 "0111" WHEN A_bin < "1010000" AND A_bin > "1000101" ELSE
						 "0110" WHEN A_bin < "1000110" AND A_bin > "0111011" ELSE
						 "0101" WHEN A_bin < "0111100" AND A_bin > "0110001" ELSE
						 "0100" WHEN A_bin < "0110010" AND A_bin > "0100111" ELSE
						 "0011" WHEN A_bin < "0101000" AND A_bin > "0011101" ELSE
					    "0010" WHEN A_bin < "0011110" AND A_bin > "0010011" ELSE
					    "0001" WHEN A_bin < "0010100" AND A_bin > "0001001" ELSE
					    "0000"; 
			Hex3_s <= "1001" WHEN B_bin > "1011001" 							  ELSE
						 "1000" WHEN B_bin < "1011010" AND B_bin > "1001111" ELSE
						 "0111" WHEN B_bin < "1010000" AND B_bin > "1000101" ELSE
						 "0110" WHEN B_bin < "1000110" AND B_bin > "0111011" ELSE
						 "0101" WHEN B_bin < "0111100" AND B_bin > "0110001" ELSE
						 "0100" WHEN B_bin < "0110010" AND B_bin > "0100111" ELSE
					    "0011" WHEN B_bin < "0101000" AND B_bin > "0011101" ELSE
					    "0010" WHEN B_bin < "0011110" AND B_bin > "0010011" ELSE
					    "0001" WHEN B_bin < "0010100" AND B_bin > "0001001" ELSE
					    "0000";	
		    A_bin_s <= UNSIGNED(A_bin) - 90 WHEN Hex1_s = "1001"	ELSE
							UNSIGNED(A_bin) - 80 WHEN Hex1_s = "1000"	ELSE
							UNSIGNED(A_bin) - 70 WHEN Hex1_s = "0111"	ELSE
							UNSIGNED(A_bin) - 60 WHEN Hex1_s = "0110"	ELSE
							UNSIGNED(A_bin) - 50 WHEN Hex1_s = "0101"	ELSE
							UNSIGNED(A_bin) - 40 WHEN Hex1_s = "0100"	ELSE
							UNSIGNED(A_bin) - 30 WHEN Hex1_s = "0011"	ELSE
							UNSIGNED(A_bin) - 20 WHEN Hex1_s = "0010"	ELSE
							UNSIGNED(A_bin) - 10 WHEN Hex1_s = "0001"	ELSE
							UNSIGNED(A_bin);
			 B_bin_s <= UNSIGNED(B_bin) - 90 WHEN Hex3_s = "1001"	ELSE
							UNSIGNED(B_bin) - 80 WHEN Hex3_s = "1000"	ELSE
							UNSIGNED(B_bin) - 70 WHEN Hex3_s = "0111"	ELSE
							UNSIGNED(B_bin) - 60 WHEN Hex3_s = "0110"	ELSE
							UNSIGNED(B_bin) - 50 WHEN Hex3_s = "0101"	ELSE
							UNSIGNED(B_bin) - 40 WHEN Hex3_s = "0100"	ELSE
							UNSIGNED(B_bin) - 30 WHEN Hex3_s = "0011"	ELSE
							UNSIGNED(B_bin) - 20 WHEN Hex3_s = "0010"	ELSE
							UNSIGNED(B_bin) - 10 WHEN Hex3_s = "0001"	ELSE
							UNSIGNED(B_bin);
			  Hex0   <= STD_LOGIC_VECTOR(A_bin_s)(3 DOWNTO 0);
			  Hex1   <= Hex1_s;
			  Hex2   <= STD_LOGIC_VECTOR(B_bin_s)(3 DOWNTO 0);
			  Hex3   <= Hex3_s;
	END ARCHITECTURE;