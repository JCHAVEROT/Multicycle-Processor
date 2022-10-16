library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is

    type reg_type is array(0 to 1023) of std_logic_vector(31 downto 0);
    signal reg       : reg_type;
    signal address_s : std_logic_vector(9 downto 0);
    signal cs_s      : std_logic;
    signal read_s    : std_logic;

begin

    save_signals : process(clk)
    begin
        if rising_edge(clk) then
            address_s <= address;
            cs_s <= cs;
            read_s <= read;
        end if;
    end process;
    
    write_to_ram : process(cs, write, address, wrdata)
    begin
        if (cs = '1' and write = '1') then
            reg(to_integer(unsigned(address))) <= wrdata;
        end if;
    end process;

    -- tristate buffer for read process
    read_from_ram : process(cs_s, read_s, address_s)
    begin
        rddata <= (others => 'Z');
        if (cs_s = '1' and read_s = '1') then
            rddata <= reg(to_integer(unsigned(address_s)));
        end if;
    end process;

end synth;
