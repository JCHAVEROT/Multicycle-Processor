library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
    type controllerState is (FETCH1, FETCH2, DECODE, R_OP, STORE, BREAK, LOAD1, LOAD2, I_OP);
    signal state : controllerState;
    signal next_state : controllerState;
    
    -- all the possibilities for OP and OPX
    constant r_type : std_logic_vector(7 downto 0) := X"3A";   -- R-type command
    constant do_and : std_logic_vector(7 downto 0) := X"0E";   -- R-type bitwise logical and
    constant do_srl : std_logic_vector(7 downto 0) := X"1B";   -- R-type shift right logical
    constant do_addi : std_logic_vector(7 downto 0) := X"04";  -- I-type addition
    constant do_ldw : std_logic_vector(7 downto 0) := X"17";   -- I-type load word from memory to register
    constant do_stw : std_logic_vector(7 downto 0) := X"15";   -- I-type store word to memory from register
    constant do_break : std_logic_vector(7 downto 0) := X"34"; -- R-type break, stops the program execution 
    
    -- op and opx appended with "00" in the front
    signal op_ext : std_logic_vector(7 downto 0);
    signal opx_ext : std_logic_vector(7 downto 0);

begin
    op_ext <= "00" & op;
    opx_ext <= "00" & opx;
    
    -- synchronous process in charge of the state transition with asynchronous and active low reset process
    process(clk, reset_n)
    begin
        if (reset_n = '1') then
            state <= FETCH1;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- process in charge of the behavior of controller depending on the current state
    process(state, op_ext, opx_ext)
    begin
        
        case (state) is
            when FETCH1 =>
                branch_op <= '0';
                imm_signed <= '0';
                ir_en <= '0';
                pc_add_imm <= '0';
                pc_en <= '0';
                pc_sel_a <= '0';
                pc_sel_imm <= '0';
                rf_wren <= '0';
                sel_addr <= '0';
                sel_b <= '0';
                sel_mem <= '0';
                sel_pc <= '0';
                sel_ra <= '0';
                sel_rC <= '0';
                write <= '0';
                read <= '1';
                next_state <= FETCH2;

            when FETCH2 =>
                read <= '0';
                pc_en <= '1';
                ir_en <= '1';
                next_state <= DECODE;

            when DECODE =>
                pc_en <= '0';
                ir_en <= '0';

                case op_ext is
                    when r_type =>
                        case opx_ext is
                            when do_and | do_srl =>
                                next_state <= R_OP;
                            when others => -- also when opx_ext = do_break
                                next_state <= BREAK;
                        end case;
                    when do_addi =>
                        next_state <= I_OP;
                    when do_ldw =>
                        next_state <= LOAD1;
                    when do_stw =>
                        next_state <= STORE;
                    when others =>
                        next_state <= BREAK;
                end case;
                        
            when R_OP =>
                rf_wren <= '1';
                sel_b <= '1';
                sel_rC <= '1';
                next_state <= FETCH1;

            when STORE =>
                sel_addr <= '1';
                sel_b <= '1';
                write <= '1';
                imm_signed <= '1';
                next_state <= FETCH1;

            when BREAK =>
                next_state <= FETCH1;

            when LOAD1 =>
                sel_addr <= '1';
                read <= '1';
                imm_signed <= '1';
                next_state <= FETCH1;

            when LOAD2 =>
                rf_wren <= '1';
                sel_mem <= '1';
                next_state <= FETCH1;

            when I_OP =>
                rf_wren <= '1';
                imm_signed <= '1';
                next_state <= FETCH1;

            when others => 
                next_state <= FETCH1;
        end case; 

    end process;

    -- independent process that generates op_alu since stateless
    process(op_ext, opx_ext)
    begin
        case op_ext is
            when r_type =>
                case opx_ext is
                    when do_and =>
                        op_alu(5 downto 4) <= "10";
                        op_alu(1 downto 0) <= "01";
                    when do_srl =>
                        op_alu(5 downto 4) <= "11";
                        op_alu(2 downto 0) <= "011";
                    when others => 
                        op_alu <= (others => 'Z'); -- à changer surement
                end case;
            when do_addi | do_ldw | do_stw => 
                op_alu(5 downto 3) <= "000";
            when others =>
                op_alu <= (others => 'Z'); -- à changer surement
        end case;
    end process;
    
end synth;
