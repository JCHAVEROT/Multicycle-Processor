library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port(
        a_31    : in  std_logic;
        b_31    : in  std_logic;
        diff_31 : in  std_logic;
        carry   : in  std_logic;
        zero    : in  std_logic;
        op      : in  std_logic_vector(2 downto 0);
        r       : out std_logic
    );
end comparator;

architecture synth of comparator is
begin

    comp : process(a_31, b_31, diff_31, carry, zero, op)
    begin
        case op is
            when "001" => -- signed less or equal
                if ((a_31 = '1' and b_31 = '0') or ((a_31 = '1' xnor b_31 = '1') and (diff_31 = '1' or zero = '1'))) then
                    r <= '1';
                else r <= '0';
                end if;
            when "010" => -- signed greater than 
                if ((a_31 = '0' and b_31 = '1') or ((a_31 = '1' xnor b_31  = '1') and (diff_31 = '0' and zero = '0'))) then
                    r <= '1';
                else r <= '0';
                end if;
            when "011" => -- not equal
                if zero = '0' then
                    r <= '1';
                else r <= '0';
                end if;
            when "100" => -- equal
                if zero = '1' then
                    r <= '1';
                else r <= '0';
                end if;
            when "101" => -- unsigned less or equal
                if (carry = '0' or zero = '1') then
                    r <= '1';
                else r <= '0';
                end if;
            when "110" => -- unsigned greater than
                if (carry = '0' or zero = '1') then
                    r <= '0';
                else r <= '1';
                end if;
            when others => -- default operation: equal
                if zero = '1' then
                    r <= '1';
                else r <= '0';
                end if;

        end case;

    end process;
end synth;
