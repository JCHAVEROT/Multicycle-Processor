library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
    signal curr_addr : std_logic_vector(15 downto 0);
    signal next_addr : std_logic_vector(15 downto 0);
begin

    next_addr <= std_logic_vector(unsigned(curr_addr) + unsigned(imm)) when add_imm = '1' else
                 imm(13 downto 0) & "00" when sel_imm = '1' else
                 a when sel_a = '1' else 
                 std_logic_vector(unsigned(curr_addr) + to_unsigned(4, 16));

    -- synchronous process to go to the next address with asynchronous reset
    process(clk, reset_n, next_addr)
    begin
        if (reset_n = '0') then
            curr_addr <= (others => '0');
            addr <= (others => '0');
        elsif rising_edge(clk) then
            if (en = '1') then
                curr_addr <= next_addr;
                addr <= X"0000" & next_addr;
                addr(1 downto 0) <= "00";
            end if;
        end if;
    end process;
    
end synth;
