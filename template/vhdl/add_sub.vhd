library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is

    constant all_zeros : std_logic_vector(31 downto 0) := (others => '0');
    signal sub_mode_replicated : std_logic_vector(31 downto 0);
    signal b_xored : std_logic_vector(31 downto 0);
    signal result_extended : std_logic_vector(32 downto 0);
    
begin

    -- before operation
    sub_mode_replicated <= (others => sub_mode);
    b_xored <= b xor sub_mode_replicated;

    -- operation
    result_extended <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b_xored) + unsigned(all_zeros & sub_mode)); 

    -- after operation
    carry <= result_extended(32);
    zero <= '1' when (result_extended(31 downto 0) = all_zeros) else '0';
    r <= (result_extended(31 downto 0));

end synth;
