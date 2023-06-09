LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Fetch_Stage IS
    PORT (
        -- Inputs:
        clk,
        pc_rst,
        -- Phase 2:
        DE_JMP_en_out,
        DE_CALL_en_out,
        MW_RTI_en_out,
        MW_RET_en_out,
        DE_PC_disable_out,
        en_load_use ,
        en_structural ,
        DE_JZ_en_out ,
        ZF_OUT,
        DE_JC_en_out,
        CF_OUT : IN STD_LOGIC;
        --
        IN_PC, IN_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        
        -- Outputs:
        Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        EM_PC_or_addrs1_en_out, MM_PC_or_addrs1_en_out, MW_PC_or_addrs1_en_out : IN STD_LOGIC
    );
END Fetch_Stage;

ARCHITECTURE arch OF Fetch_Stage IS

    SIGNAL Internal_Read_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --PC component (Edited in Phase 2)
    COMPONENT PC IS
    PORT (
        clk, rst, DE_JMP_en_out, DE_CALL_en_out, MW_RTI_en_out, MW_RET_en_out, DE_PC_disable_out, en_load_use, en_structural, DE_JZ_en_out, ZF_OUT, DE_JC_en_out, CF_OUT : IN STD_LOGIC;
        IN_PC, IN_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        EM_PC_or_addrs1_en_out, MM_PC_or_addrs1_en_out, MW_PC_or_addrs1_en_out : IN STD_LOGIC
    );
    END COMPONENT;
    --Instruction Memory component
    COMPONENT Instruction_Memory IS
        PORT (
            -- clk: IN STD_LOGIC;
            Read_Address : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --input read address

            Inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    Internal_PC : PC PORT MAP(
        clk => clk,
        rst => pc_rst,
        DE_JMP_en_out => DE_JMP_en_out,
        DE_CALL_en_out => DE_CALL_en_out,
        MW_RTI_en_out => MW_RTI_en_out,
        MW_RET_en_out => MW_RET_en_out ,
        DE_PC_disable_out => DE_PC_disable_out ,
        en_load_use => en_load_use ,
        en_structural => en_structural ,
        DE_JZ_en_out => DE_JZ_en_out ,
        ZF_OUT => ZF_OUT ,
        DE_JC_en_out => DE_JC_en_out ,
        CF_OUT => CF_OUT ,
        IN_PC => IN_PC,
        IN_DATA => IN_DATA,
        Read_Address => Internal_Read_Address,
        EM_PC_or_addrs1_en_out => EM_PC_or_addrs1_en_out, 
        MM_PC_or_addrs1_en_out => MM_PC_or_addrs1_en_out, 
        MW_PC_or_addrs1_en_out => MW_PC_or_addrs1_en_out
    );

    Internal_Instruction_Memory : Instruction_Memory PORT MAP(
        Read_Address => Internal_Read_Address,
        Inst => Inst
    );
    Read_Address <= Internal_Read_Address;

END ARCHITECTURE;