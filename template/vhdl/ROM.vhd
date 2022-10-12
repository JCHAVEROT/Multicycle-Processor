library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is
    
    signal address_s : std_logic_vector(9 downto 0);
    signal cs_s      : std_logic;
    signal read_s    : std_logic;
    signal data_s    : std_logic_vector(31 downto 0);

begin

    save_signals : process(clk)
    begin
        if rising_edge(clk) then
            address_s <= address;
            cs_s <= cs;
            read_s <= read;
        end if;
    end process;

    rom_block : entity work.ROM_Block
	port map(address => address_s,
		     clock => clk,
		     q => data_s);

    -- tristate buffer to enhance rom_block component
    read_from_rom : process(cs_s, read_s, data_s)
    begin
        rddata <= (others => 'Z');
        if (cs_s = '1' and read_s = '1') then
            rddata <= data_s;
        end if;
    end process;
    
end synth;