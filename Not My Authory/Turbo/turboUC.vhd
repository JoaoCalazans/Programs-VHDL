library ieee;
use ieee.numeric_bit.rising_edge;

entity turboUC is
  port (
    clock, reset: in bit;					-- sinais de controle globais
    Push, ReqB, CgteS: in bit;  			-- sinais de condição do FD
    SelOut, LoadR, ResetC, EnableC: out bit	-- sinais de controle para FD
  );
end entity;

architecture fsm of turboUC is
  type state_t is (idle_s, pushed_s, hold_s, turbo_s);	-- lista de estados da UC
  signal next_state, current_state: state_t;			-- variáveis de estado: atual e próximo
begin
  fsm: process(clock, reset)
  begin
    if reset='1' then				-- reset assíncrono (para inicialização do circuito)
      current_state <= idle_s;		
    elsif rising_edge(clock) then	-- atuazalição síncrona do estado
      current_state <= next_state;
    end if;
  end process;

  -- Lógica de próximo estado
  next_state <=
	-- Estado Idle
    idle_s		when (current_state = idle_s) and (Push = '0') else
	pushed_s 	when (current_state = idle_s) and (Push = '1') else
	-- Estado Pushed
	idle_s		when (current_state = pushed_s) and (ReqB = '0') and (Push = '0') else
	pushed_s	when (current_state = pushed_s) and (ReqB = '0') and (Push = '1') else
	hold_s 		when (current_state = pushed_s) and (ReqB = '1') else
	-- Estado Hold
	idle_s		when (current_state = hold_s) and (ReqB = '0') and (Push = '0') else
	pushed_s	when (current_state = hold_s) and (ReqB = '0') and (Push = '1') else
	hold_s		when (current_state = hold_s) and (ReqB = '1') and (CgteS = '0') else
	turbo_s		when (current_state = hold_s) and (ReqB = '1') and (CgteS = '1') else
	-- Estado Turbo
	idle_s		when (current_state = turbo_s) and (ReqB = '0') and (Push = '0') else
	pushed_s	when (current_state = turbo_s) and (ReqB = '0') and (Push = '1') else
	turbo_s		when (current_state = turbo_s) and (ReqB = '1');
	
	  
  -- Decodifica o estado para gerar sinais de controle
  SelOut  <= '1' when (current_state = pushed_s or current_state = turbo_s) else '0';
  LoadR	  <= '1' when current_state = pushed_s else '0';
  ResetC  <= '1' when current_state = pushed_s else '0';
  EnableC <= '1' when current_state = hold_s   else '0';
  
end architecture;
