LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------
ENTITY matrix IS
	PORT( pos_x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			pos_y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			poss  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			negg  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ENTITY;
------------------------------------------
ARCHITECTURE behaviour OF matrix IS
BEGIN
	POSITIVO :ENTITY work.Led_pos
		PORT MAP(bin      => pos_x,
					position => poss);
	NEGATIVO :ENTITY work.Led_neg
		PORT MAP(bin      => pos_y,
					position => negg);	

END ARCHITECTURE;