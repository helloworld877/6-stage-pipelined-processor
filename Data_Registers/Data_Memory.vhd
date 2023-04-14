LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Data_Memory IS
    PORT (
        Address_Read_Data, Address_Write_Data, Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        clk, Rst, MemWrite_en, MemRead_en : IN STD_LOGIC;
        Read_Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Data_Memory;

ARCHITECTURE arch OF Data_Memory IS

    TYPE Mem_type IS ARRAY (0 TO 1024) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_data : Mem_type;

BEGIN

    main_loop : PROCESS (clk, Rst)
    BEGIN
        --async reset
        IF Rst = '1' THEN
            memory_data <= (OTHERS => (OTHERS => '0'));

        ELSIF rising_edge(clk) THEN
            IF MemWrite_en = '1' THEN --write data
                memory_data(to_integer(unsigned(Address_Write_Data))) <= Write_Data;
                Read_Data <= (OTHERS => '-');--read data is don't care
            ELSIF MemRead_en = '1' THEN --read data
                Read_Data <= memory_data(to_integer(unsigned(Address_Read_Data)));
            ELSE
                Read_Data <= (OTHERS => '-');--read data is don't care
            END IF;
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;