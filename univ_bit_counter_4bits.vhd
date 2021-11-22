LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-----------------------------------------------------------
ENTITY univ_bit_counter_4bits IS
GENERIC ( N       : INTEGER := 4);
PORT (   clk      : IN STD_LOGIC;
			rst      : IN STD_LOGIC;
			ena      : IN STD_LOGIC;
			syn_clr  : IN STD_LOGIC;
			max_count: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
			max_tick : OUT STD_LOGIC;
			counter  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END ENTITY;
-----------------------------------------------------------
ARCHITECTURE rt1 OF univ_bit_counter_4bits IS

CONSTANT ONES     : UNSIGNED (N-1 DOWNTO 0) := (OTHERS => '1');
CONSTANT ZEROS    : UNSIGNED (N-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL count_s    : UNSIGNED (N-1 DOWNTO 0);
SIGNAL count_next : UNSIGNED (N-1 DOWNTO 0);
SIGNAL syn_clr_s  : STD_LOGIC;
SIGNAL max_tick_s : STD_LOGIC;

BEGIN
	count_next <= (OTHERS => '0') WHEN syn_clr_s = '1' ELSE
	count_s + 1 WHEN ena = '1' ELSE
	count_s;
	
PROCESS (clk,rst)
	VARIABLE temp : UNSIGNED(N-1 DOWNTO 0);
	BEGIN
		IF(rst = '1') THEN
			temp := (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (ena = '1') THEN
				temp := count_next;
			END IF;
		END IF;
	counter <= STD_LOGIC_VECTOR(temp);
	count_s <= temp;
END PROCESS;

--OUTPUT LOGIC
max_tick_s <= '1' WHEN count_s = UNSIGNED(max_count) ELSE '0';
max_tick <= max_tick_s;
syn_clr_s <= '1' WHEN max_tick_s = '1' ELSE '0';

END ARCHITECTURE;

