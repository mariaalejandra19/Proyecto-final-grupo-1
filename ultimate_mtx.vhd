LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------------------------------------
ENTITY ultimate_mtx IS
	PORT (	Pos_x			  :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
				Pos_y			  :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
				Pos_mtx1		  :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				Pos_mtx2		  :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				Neg_mtx1		  :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				Neg_mtx2		  :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;
-------------------------------------
ARCHITECTURE behaviour OF ultimate_mtx IS
	SIGNAL Pos_x_1, Pos_x_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Pos_y_1, Pos_y_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	BEGIN
	Pos_x_1 <= "0000" WHEN Pos_x > "1000" ELSE
	           "0000" WHEN pos_x = "0000" ELSE
				  Pos_x;
	Pos_x_2 <= "0000" WHEN Pos_x < "1001" AND Pos_x > "0000" ELSE
	           "1000" WHEN pos_x = "0000" ELSE
				  STD_LOGIC_VECTOR(UNSIGNED(Pos_x)-8);
	Pos_y_1 <= "0000" WHEN Pos_x > "1000" ELSE
				  "0000" WHEN pos_x = "0000" ELSE
				  Pos_y;
	Pos_y_2 <= "0000" WHEN Pos_x < "1001" AND Pos_x > "0000" ELSE
				  Pos_y;					  
	Matrix_1: ENTITY work.matrix
		PORT MAP(	pos_x => Pos_x_1,
						pos_y => Pos_y_1,
						poss => Pos_mtx1,
						negg => Neg_mtx1);
	Matrix_2: ENTITY work.matrix
		PORT MAP(	pos_x => Pos_x_2,
						pos_y => Pos_y_2,
						poss => Pos_mtx2,
						negg => Neg_mtx2);
	END ARCHITECTURE;