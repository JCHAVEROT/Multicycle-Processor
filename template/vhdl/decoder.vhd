library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port(
        address    : in  std_logic_vector(15 downto 0);
        cs_LEDS    : out std_logic;
        cs_RAM     : out std_logic;
        cs_ROM     : out std_logic;
        cs_buttons : out std_logic
    );
end decoder;

architecture synth of decoder is
    signal rom_down : std_logic_vector(15 downto 0) := X"0000";
    signal rom_up : std_logic_vector(15 downto 0) := X"0FFC";
    signal ram_down : std_logic_vector(15 downto 0) := X"1000";
    signal ram_up : std_logic_vector(15 downto 0) := X"1FFC";
    signal led_down : std_logic_vector(15 downto 0) := X"2000";
    signal led_up : std_logic_vector(15 downto 0) := X"200C";
    signal buttons_down : std_logic_vector(15 downto 0) := X"2030";
    signal buttons_up : std_logic_vector(15 downto 0) := X"2034";
begin

    process(address)
    begin
        if rom_down <= address and address <= rom_up then
            cs_ROM <= '1';
            cs_RAM <= '0';
            cs_LEDS <= '0';
            cs_buttons <= '0';
        elsif ram_down <= address and address <= ram_up then
            cs_ROM <= '0';
            cs_RAM <= '1';
            cs_LEDS <= '0';
            cs_buttons <= '0';
        elsif led_down <= address and address <= led_up then
            cs_ROM <= '0';
            cs_RAM <= '0';
            cs_LEDS <= '1';
            cs_buttons <= '0';
        elsif buttons_down <= address and address <= buttons_up then
            cs_ROM <= '0';
            cs_RAM <= '0';
            cs_LEDS <= '0';
            cs_buttons <= '1';
        else 
            cs_ROM <= '0';
            cs_RAM <= '0';
            cs_LEDS <= '0';
            cs_buttons <= '0';
        end if;    
    end process;

end synth;
