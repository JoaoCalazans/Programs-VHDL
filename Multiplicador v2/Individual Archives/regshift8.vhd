-------------------------------------------------------
--! @file multiplicador.vhd
--! @brief synchronous multiplier
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-08
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.rising_edge;

entity regshift8 is
  port (
    clock, reset, shiftRight, load_sync, shiftBit: in bit;
    parallel_in:  in  bit_vector(3 downto 0);	-- entrada a ser registrada
    parallel_out: out bit_vector(7 downto 0)	-- dados registrados
  );
end entity;

architecture arch_reg8 of regshift8 is
  signal internal: bit_vector(7 downto 0);
begin
  process(clock)
  begin
    if (rising_edge(clock)) then
      if reset='1'then
        internal <= (others=>'0');
      elsif load_sync='1'then
        internal <= parallel_in & internal(3 downto 0);
      elsif shiftRight='1' then
        internal<= shiftBit & internal(7 downto 1);
      end if;
    end if;
  end process;
  parallel_out <= internal;
end architecture;