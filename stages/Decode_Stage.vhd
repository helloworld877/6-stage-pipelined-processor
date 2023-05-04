LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decode_Stage IS
    PORT (
        --INPUT PORTS    
        clk, Reg_File_rst : IN STD_LOGIC;
        FD_Inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        FD_Read_Address,
        FD_IN_PORT,
        --Phase 2:
        DE_Read_Data1_out,
        MW_Read_Data_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        --
        MW_Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MW_Write_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MW_RegWrite_en,
        -- Phase 2:
        MW_RET_en_out,
        DE_JZ_en_out,
        DE_JC_en_out,
        MW_PC_or_addrs1_en_out,
        MW_RTI_en_out,
        ZF_OUT,
        CF_OUT : IN STD_LOGIC;

        -- OUTPUT PORTS
        IN_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_en : OUT STD_LOGIC;
        FD_IN_PORT_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Write_address_RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        RegWrite_en : OUT STD_LOGIC;
        Carry_en : OUT STD_LOGIC;
        ALU_en : OUT STD_LOGIC;
        OPCODE : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        Read_Data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Read_Data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Mem_to_Reg_en : OUT STD_LOGIC;
        MemWrite_en : OUT STD_LOGIC;
        MemRead_en : OUT STD_LOGIC;
        -- Phase 2:
        SETC_en,
        CLRC_en,
        JZ_en,
        JC_en,
        SP_en,
        SP_inc_en,
        RET_en,
        OUT_en,
        RTI_en,
        CALL_en,
        JMP_en,
        Immediate_en : OUT STD_LOGIC;
        Interrupt_en : OUT STD_LOGIC;
        FLAGS_en : OUT STD_LOGIC;
        PC_or_addrs1_en : OUT STD_LOGIC

    );
END Decode_Stage;

ARCHITECTURE arch OF Decode_Stage IS

    -------------------COMPONENTS----------------
    -- adder for PC (Edited in Phase 2)
    COMPONENT adder IS
        PORT (
            FD_Read_Address_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Add_Value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            PC_Added : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END COMPONENT;

    --Control Unit (Edited in Phase 2)
    COMPONENT Control_Unit2 IS
        PORT (
            OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            IN_en, Carry_en, ALU_en, RegWrite_en, Mem_to_Reg_en, MemWrite_en, MemRead_en, SETC_en, CLRC_en, JZ_en, JC_en, JMP_en, CALL_en, Immediate_en, SP_en, SP_inc_en,
            RET_en, OUT_en, RTI_en : OUT STD_LOGIC;
            Interrupt_en : OUT STD_LOGIC;
            FLAGS_en : OUT STD_LOGIC;
            PC_or_addrs1_en : OUT STD_LOGIC

        );
    END COMPONENT;

    --Register File
    COMPONENT Reg_file IS
        PORT (
            clk, Rst, write_en : IN STD_LOGIC;
            Read_Address1, Read_Address2, Write_Addesss : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Read_Data1, Read_Data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Phase 2:
    -- MUX 4X1 to choose PC
    COMPONENT MUX_DEC_PC IS
        PORT (
            PC_Added, DE_Read_Data1_out, Read_Data1, MW_Read_Data_out : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            MW_RET_en_out, JMP_en, CALL_en, DE_JZ_en_out, ZF_OUT, DE_JC_en_out, CF_OUT, MW_PC_or_addrs1_en_out, MW_RTI_en_out : IN STD_LOGIC;
            IN_PC : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
    END COMPONENT;

    -- MUX 2X1 to choose Add value
    COMPONENT MUX_DEC_ADD IS
        PORT (
            Immediate_en : IN STD_LOGIC;
            Add_Value : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
    END COMPONENT;

    COMPONENT MUX_DEC_Read_data2 IS
        PORT (
            Read_Data2_RF, PC_Added, Imm_Value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Read_Data2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            Immediate_en, CALL_en : IN STD_LOGIC);
    END COMPONENT;

    -------------------SIGNALS----------------
    -- Phase 2:
    SIGNAL Immediate_en_sig, CALL_en_sig, JMP_en_sig : STD_LOGIC;
    SIGNAL Add_Value_sig : STD_LOGIC;
    SIGNAL PC_Added_sig : STD_LOGIC;
    SIGNAL Read_Data1_sig, Read_Data2_sig : STD_LOGIC;

BEGIN

    --adder initialization (Edited in Phase 2)
    Adder_MAP : adder PORT MAP(
        FD_Read_Address_out => FD_Read_Address,
        Add_Value => Add_Value_sig,
        PC_Added => PC_Added_sig
    );

    -- control unit initalization (Edited in Phase 2)
    Control_Unit_MAP : Control_Unit2 PORT MAP(
        OPCODE => FD_Inst(31 DOWNTO 27),
        IN_en => IN_en,
        Carry_en => Carry_en,
        ALU_en => ALU_en,
        RegWrite_en => RegWrite_en,
        Mem_to_Reg_en => Mem_to_Reg_en,
        MemWrite_en => MemWrite_en,
        MemRead_en => MemRead_en,
        SETC_en => SETC_en,
        CLRC_en => CLRC_en,
        JZ_en => JZ_en,
        JC_en => JC_en,
        JMP_en => JMP_en_sig,
        CALL_en => CALL_en_sig,
        Immediate_en => Immediate_en_sig,
        SP_en => SP_en,
        SP_inc_en => SP_inc_en,
        RET_en => RET_en,
        OUT_en => OUT_en,
        RTI_en => RTI_en,
        Interrupt_en => Interrupt_en,
        FLAGS_en => FLAGS_en,
        PC_or_addrs1_en => PC_or_addrs1_en

    );

    --Register File Initialization (Edited in phase 2)
    Internal_Register_File : Reg_file PORT MAP(
        clk => clk,
        rst => Reg_File_rst,
        write_en => MW_RegWrite_en,
        Read_Address1 => FD_Inst(26 DOWNTO 24),
        Read_Address2 => FD_Inst(23 DOWNTO 21),
        Write_Addesss => MW_Write_Address,
        Write_Data => MW_Write_Data,
        Read_Data1 => Read_Data1_sig, -- Phase 2
        Read_Data2 => Read_Data2_sig --Phase 2

    );

    --Remaining Output Signals
    OPCODE <= FD_Inst(31 DOWNTO 27);
    FD_IN_PORT_out <= FD_IN_PORT;
    Write_address_RD <= FD_Inst(20 DOWNTO 18);

    -- Phase 2
    MUX_DEC_ADD_MAP : MUX_DEC_ADD PORT MAP(
        Immediate_en => Immediate_en_sig,
        Add_Value => Add_Value_sig
    );

    MUX_DEC_Read_data2_MAP : MUX_DEC_Read_data2 PORT MAP(
        Read_Data2_RF => Read_Data2_sig,
        PC_Added => PC_Added_sig,
        Imm_Value => FD_Inst(15 DOWNTO 0),
        Read_Data2 => Read_Data2,
        Immediate_en => Immediate_en_sig,
        CALL_en => CALL_en_sig
    );

    MUX_DEC_PC_MAP : MUX_DEC_PC PORT MAP(
        PC_Added => PC_Added_sig,
        DE_Read_Data1_out => DE_Read_Data1_out,
        Read_Data1 => Read_Data1_sig,
        MW_Read_Data_out => MW_Read_Data_out,
        MW_RET_en_out => MW_RET_en_out,
        JMP_en => JMP_en_sig,
        CALL_en => CALL_en_sig,
        DE_JZ_en_out => DE_JZ_en_out,
        ZF_OUT => ZF_OUT,
        DE_JC_en_out => DE_JC_en_out,
        CF_OUT => CF_OUT,
        MW_PC_or_addrs1_en_out => MW_PC_or_addrs1_en_out,
        MW_RTI_en_out => MW_RTI_en_out,
        IN_PC => IN_PC
    );

    Read_Data1 <= Read_Data1_sig;
    CALL_en <= CALL_en_sig;
    JMP_en <= JMP_en_sig;
    Immediate_en <= Immediate_en_sig;

END ARCHITECTURE;