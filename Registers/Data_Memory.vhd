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
        END IF;
        -- write on rising edge
        IF rising_edge(clk) AND MemWrite_en = '1' THEN
            memory_data(to_integer(unsigned(Address_Write_Data))) <= Write_Data;
        END IF;
        --read on falling edge
        IF falling_edge(clk) AND MemRead_en = '1' THEN

            Read_Data <= memory_data(to_integer(unsigned(Address_Read_Data)));
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;