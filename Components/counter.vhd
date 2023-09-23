library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter5bits is
    port ( Clock, Reset : in std_logic;
           Count: out std_logic_vector (4 downto 0);
           RCO: out std_logic);
end entity counter5bits;

architecture arch of counter5bits is
begin
    p0: process (Clock, Reset) is
        variable counter : unsigned (4 downto 0); -- variável
    begin
        if (Reset = '1') then
            counter := "00000"; -- valor inicial
            RCO <= '0'; -- precisa? -----------------------------------------------------------
        elsif rising_edge(Clock) then
            counter := counter + 1;
            if (counter = "10000") then RCO <= '1'; else RCO <= '0';
            end if;
        end if;
        Count <= std_logic_vector(counter); -- “cast” de variable
    end process p0;
end architecture arch;