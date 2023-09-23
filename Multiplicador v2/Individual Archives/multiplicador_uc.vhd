-------------------------------------------------------
--! @file multiplicador_uc.vhd
--! @brief control unit of the synchronous multiplier
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-08
-- based on preview project by Edson Midorikawa
-------------------------------------------------------

library ieee;
--use ieee.numeric_bit.rising_edge;

entity multiplicador_uc is
  port (
      clock:    in  bit;
      reset:    in  bit;
      start:    in  bit;
      rco, Bj:  in  bit;
      SELff:    out bit;
      count:    out bit;
      RSTcount: out bit;
      ready:    out bit;
      CEa, CEb: out bit;
      RSTa, RSTb: out bit;
      RSTr, shiftRight, load_sync: out bit
    );
end entity;

architecture fsm of multiplicador_uc is
  type state_t is (idle, go, adder, shift, fins);
  signal next_state, current_state: state_t;
begin
  fsm: process(clock, reset)
  begin
    if reset='1' then
      current_state <= idle;
--    elsif (rising_edge(clock)) then
    elsif (clock'event and clock='1') then
      current_state <= next_state;
    end if;
  end process;

  -- Logica de proximo estado
  next_state <=
    go    when (current_state = idle)  and (start = '1') else
    fins  when (current_state = go) and (rco = '1') else
    shift when (current_state = go) and (Bj = '0') else
    adder when (current_state = go) and (Bj = '1') else
    shift when (current_state = adder) else
    fins  when (current_state = shift) and (rco = '1') else
    shift when (current_state = shift) and (Bj = '0') else
    adder when (current_state = shift) and (Bj = '1') else
    idle;
	  
  -- Decodifica o estado para gerar sinais de controle
  CEa        <= '1' when current_state=go else '0';
  CEb        <= '1' when current_state=go else '0';
  RSTa       <= '1' when current_state=idle else '0';
  RSTb       <= '1' when current_state=idle else '0';
  RSTr       <= '1' when current_state=go else '0';
  SELff      <= '1' when current_state=adder else '0';
  count      <= '1' when current_state=shift else '0';
  RSTcount   <= '1' when current_state=go else '0';
  shiftRight <= '1' when current_state=shift else '0';
  load_sync  <= '1' when current_state=adder else '0';

  -- Decodifica o estado para gerar as saídas da UC
  Ready <= '1' when current_state=fins else '0';

end architecture;