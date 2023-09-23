-------------------------------------------------------
--! @file multiplicador_uc.vhd
--! @brief control unit of the synchronous multiplier
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2020-06-15
-------------------------------------------------------
library ieee;
--use ieee.numeric_bit.rising_edge;

entity multiplicador_uc is
  port (
    clock:    in bit;
    reset:    in bit;
    start:    in  bit;
    Zrb:      in  bit;
    RSTa,CEa: out bit;
    RSTb,CEb: out bit;
    RSTr,CEr: out bit;
    DCb:      out bit;
    ready:    out bit
  );
end entity;

architecture fsm of multiplicador_uc is
  type state_t is (wait0, x1, x2, fins);
  signal next_state, current_state: state_t;
begin
  fsm: process(clock, reset)
  begin
    if reset='1' then
      current_state <= wait0;
--    elsif (rising_edge(clock)) then
    elsif (clock'event and clock='1') then
      current_state <= next_state;
    end if;
  end process;

  -- Logica de proximo estado
  next_state <=
    wait0 when (current_state = wait0) and (start = '0') else
    x1    when (current_state = wait0) and (start = '1') else
    x2    when (current_state = x1)    and (zrb = '0') else
    fins  when (current_state = x1)    and (zrb = '1') else
    x2    when (current_state = x2)    and (zrb = '0') else
    fins  when (current_state = x2)    and (zrb = '1') else
    wait0 when (current_state = fins) else
    wait0;
	  
  -- Decodifica o estado para gerar sinais de controle
  CEa  <= '1' when current_state=x1 else '0';
  RSTa <= '1' when current_state=wait0 else '0';
  CEb  <= '1' when current_state=x1 or current_state=x2 else '0';
  RSTb <= '1' when current_state=wait0 else '0';
  CEr  <= '1' when current_state=x1 or current_state=x2 else '0';
  RSTr <= '1' when current_state=x1 else '0';
  DCb  <= '1' when current_state=x2 else '0';

  -- Decodifica o estado para gerar as saídas da UC
  Ready <= '1' when current_state=fins else '0';

end architecture;
