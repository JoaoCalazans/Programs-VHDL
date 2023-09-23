library ieee;
use ieee.numeric_bit.rising_edge;

entity log2UC is
  port (
    clock, reset: in bit;	-- Sinais de controle globais
    start: in bit;			-- Sinal de condicão externo
    ready: out bit;			-- Sinal de saída: execução finalizada
    reg0: in bit;			-- Sinal de condição da FD
    LoadR, ResetL, Shift, EnableL: out bit	-- Sinais de controle para FD
  );
end entity;

architecture fsm of log2UC is
  type state_t is (idle_s, init_s, update_s);
  signal next_state, current_state: state_t;
begin
  fsm: process(clock, reset)
  begin
    if reset='1' then
      current_state <= idle_s;
    elsif rising_edge(clock) then
      current_state <= next_state;
    end if;
  end process;

  -- Lógica de próximo estado
  next_state <=
    idle_s   when (current_state = idle_s) and (start = '0') else
	init_s   when (current_state = idle_s) and (start = '1') else
	update_s when (current_state = init_s) and (reg0 = '0') else
	idle_s   when (current_state = init_s) and (reg0 = '1') else
	update_s when (current_state = update_s) and (reg0 = '0') else
	idle_s 	 when (current_state = update_s) and (reg0 = '1');
	  
  -- Decodifica o estado para gerar sinais de controle
  LoadR   <= '1' when current_state=init_s   else '0';
  ResetL  <= '1' when current_state=init_s   else '0';
  Shift   <= '1' when current_state=update_s else '0';
  EnableL <= '1' when current_state=update_s else '0';

  -- Decodifica o estado para gerar as saídas da UC
  Ready <= '1' when current_state=idle_s else '0';

end architecture;
