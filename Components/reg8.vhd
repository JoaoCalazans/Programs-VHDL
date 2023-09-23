-------------------------------------------------------
--! @file reg8.vhd
--! @brief 8-bit register with asynchronous reset
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2020-06-15
-------------------------------------------------------

library ieee;
--use ieee.numeric_bit.rising_edge;

entity reg8 is
  port (
    clock, reset, enable: in bit;
    D: in  bit_vector(7 downto 0);
    Q: out bit_vector(7 downto 0)
  );
end entity;

architecture arch_reg8 of reg8 is
  signal dado: bit_vector(7 downto 0);
begin
  process(clock, reset)
  begin
    if reset = '1' then
      dado <= (others=>'0');
--    elsif (rising_edge(clock)) then
    elsif (clock'event and clock='1') then
      if enable='1' then
        dado <= D;
      end if;
    end if;
  end process;
  Q <= dado;
end architecture;