------------------------------------------------------------
--! @file detector.vhd
--! @brief Detecta o primeiro 0 após dois ou mais 1s 
--! @author Edson S. Gomi (gomi@usp.br)
--! @date 2020-05-11
------------------------------------------------------------

library ieee;
use ieee.numeric_bit.rising_edge;

entity detector is
  port (
    RESET : in bit;
    X : in bit;
    CLOCK : in bit;
    Z : out bit
    );
end entity detector;

architecture behavioral of detector is
  type state_type is (A,B,C,D);
  signal present_state, next_state : state_type;
begin

-- Bloco sequencial Estado Atual (Q)
  
  ESTADO_ATUAL: process (RESET,CLOCK) is
  begin
    if (RESET = '1') then
      present_state <= A;
    elsif (rising_edge(CLOCK)) then
      present_state <= next_state;
    end if;
  end process ESTADO_ATUAL;
  
-- Bloco função combinatória Próximo Estado (D)

  next_state <=
    A when (present_state = A) and (X = '0') else
    B when (present_state = A) and (X = '1') else
    A when (present_state = B) and (X = '0') else    
    C when (present_state = B) and (X = '1') else
    D when (present_state = C) and (X = '0') else
    C when (present_state = C) and (X = '1') else
    B when (present_state = D) and (X = '0') else
    A when (present_state = D) and (X = '1') else    
    A;

-- Bloco função combinatória Saída (Z)

  Z <=
    '0' when present_state = A else
    '0' when present_state = B else
    '0' when present_state = C else
    '1' when present_state = D else    
    '0';
  
end architecture behavioral;
