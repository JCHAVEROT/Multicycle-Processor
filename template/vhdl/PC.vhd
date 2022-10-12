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

    next_addr <= std_logic_vector(unsigned(curr_addr) + to_unsigned(4, 16));

    -- synchronous process to go to the next address with asynchronous reset
    process(clk, reset_n)
    begin
        if (reset_n = '1') then
            curr_addr <= (others => '0');
            addr <= (others => '0');
        elsif rising_edge(clk) then
            if (en = '1') then
                curr_addr <= next_addr;
                addr(15 downto 0) <= next_addr;
            end if;
        end if;
    end process;
    
end synth;
