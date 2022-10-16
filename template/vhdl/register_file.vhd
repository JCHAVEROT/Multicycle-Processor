library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port(
        clk    : in  std_logic;
        aa     : in  std_logic_vector(4 downto 0);
        ab     : in  std_logic_vector(4 downto 0);
        aw     : in  std_logic_vector(4 downto 0);
        wren   : in  std_logic;
        wrdata : in  std_logic_vector(31 downto 0);
        a      : out std_logic_vector(31 downto 0);
        b      : out std_logic_vector(31 downto 0)
    );
end register_file;

architecture synth of register_file is

    type reg_type is array(0 to 31) of std_logic_vector(31 downto 0);
    signal reg: reg_type := (0 => (others => '0'), others => (others => 'U')); -- because register 0 has fixed value 0

begin
    -- asynchronous read process
    a <= reg(to_integer(unsigned(aa)));
    b <= reg(to_integer(unsigned(ab)));
    
    -- synchronous write process
    write : process(clk)
    variable address : natural range 0 to 31 := 0;
    begin
        if (rising_edge(clk)) then
            if (wren = '1') then
                address := to_integer(unsigned(aw));
                if (address /= 0) then
                    reg(address) <= wrdata;
                end if;
            end if;
        end if;

    end process;

end synth;
