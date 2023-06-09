LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Structural_HDU IS 
	PORT ( clk,rst,DE_MemRead_en_out,EM_MemRead_en_out,DE_MemWrite_en_out,EM_MemWrite_en_out : IN  std_logic;
			en_structural : OUT std_logic);
END Structural_HDU;


ARCHITECTURE Structural_HDU_arch OF Structural_HDU is
	BEGIN
	main_loop : PROCESS (clk,rst)
    BEGIN
		IF rst = '1' THEN 
			en_structural <= '0'; 
        ELSIF rising_edge(clk) THEN
			en_structural <= (((DE_MemWrite_en_out and EM_MemWrite_en_out) or (DE_MemWrite_en_out and EM_MemRead_en_out)) or ((DE_MemRead_en_out and EM_MemWrite_en_out) or (DE_MemRead_en_out and EM_MemRead_en_out)));
        END IF;
    END PROCESS;

END Structural_HDU_arch;