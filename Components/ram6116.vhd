library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram6116 is
    port (
        -- 11 bits de endereço:
        A: in std_logic_vector(10 downto 0);
        -- 8 bits de tamanho de palavra:
        IO: inout std_logic_vector(7 downto 0) ;
        -- Entradas de controle:
        WE_b: in std_logic; -- Write Enable  (ativo baixo)
        CS_b: in std_logic; -- Chip Select   (ativo baixo)
        OE_b: in std_logic  -- Output Enable (ativo baixo)
    );
end ram6116;

architecture ram6116_arch of ram6116 is
    -- Tipo do vetor com tamanho 2Ki (2^11 - 1 = 2047):
    type mem_tipo is array (0 to 2047) of std_logic_vector(7 downto 0);
    -- Vetor de palavras:
    signal mem: mem_tipo;
begin
    process (A, WE_b, CS_b, OE_b) is
    begin
        IO <= "ZZZZZZZZ";
        if CS_b = '0' then -- Chip Select ativo?
            if WE_b = '0' then
                -- Write Enable ativo: escrita.
                mem(to_integer (unsigned (A))) <= IO; 
            end if;
            if (WE_b = '1') and (OE_b = '0') then
                -- Write Enable inativo e Output Enable ativo: leitura 
                IO <= mem(to_integer (unsigned (A)));
            else
                IO <= "ZZZZZZZZ";
            end if;
        end if;
    end process;
end ram6116_arch;