library ieee;
use ieee.numeric_bit.all;

entity StartTrekUC is
  port (
    clock, reset: in bit;	                      -- Sinais de controle globais
    damage, shield: in bit_vector(7 downto 0);    -- Sinais de controle externo
    endGame: in bit;	              -- Sinais de controle FD
    WL: out bit_vector(1 downto 0);               -- Sinais de controle externo
    TURN: out bit_vector(4 downto 0);             -- Sinal de saída externo: CURRENT TURN
    SRS, SRH, RRS, RRH, EAS, EAH: out bit;	      -- Sinais de controle para FD
    s_adder, h_adder: out bit_vector(8 downto 0)  -- Sinais de controle para FD
  );
end entity;

architecture fsm of StartTrekUC is
    type state_type is (RESTART,START,GAME,ENTERPRISE); -- Control Unit states
    signal present_state, next_state : state_type; -- C. Unit signals
    signal turn_out : signed(4 downto 0); -- current turn calculos
    signal regen: bit_vector(7 downto 0); -- shields regeneration
    signal shield_adder, health_adder: signed(8 downto 0); -- shields regeneration

begin
ESTADO_ATUAL: process (RESET,CLOCK) is
    begin
      if (RESET = '1') then
        present_state <= RESTART;
        turn_out <= "00001";
        turn <= "00000";
      elsif (rising_edge(CLOCK)) then
        if (turn_out = "10000") then present_state <= ENTERPRISE; end if;
        if (next_state /= ENTERPRISE) then
        	turn <= bit_vector(turn_out);
        	turn_out <= turn_out + 1;
        end if;
        present_state <= next_state;
      end if;
    end process ESTADO_ATUAL;

  -------------------------------------------------------------------------------------------------------
  -- Comb function block Next State

  next_state <=
    START      when (present_state = RESTART) and (RESET = '0') else -- NEW MATCH
    START      when (present_state = START) and (damage < "00100000") else -- CONSIDERATE FIRST DAMAGE ONLY > 32
    GAME       when (present_state = START) else
    ENTERPRISE when (present_state = GAME) and (endGame = '1') else -- NO LIFE REMANING
    GAME       when (present_state = GAME) else -- ROUND HAPPENING
    ENTERPRISE when (present_state = ENTERPRISE) and (RESET = '0') else -- ENDGAME
    RESTART; -- WAITING FOR NEW MATCH

  -------------------------------------------------------------------------------------------------------
  -- Comb function block Out

    REGEN <= "00010000" when present_state = RESTART else
		     "00000010" when (present_state = GAME) and shield < "10000000";

    shield_adder <= signed('0' & regen) - signed('0' & damage);
    health_adder <= signed('0' & shield) + shield_adder when (shield_adder < "000000000") else "000000000";
    s_adder <= bit_vector(shield_adder);
    h_adder <=  bit_vector(health_adder);
    

    SRS <= '1' when present_state = START else '0'; -- NEW MATCH
    SRH <= '1' when present_state = START else '0'; -- NEW MATCH
    RRS <= '1' when present_state = RESTART else '0'; -- RESET WHILE WAITING FOR A NEW MATCH
    RRH <= '1' when present_state = RESTART else '0'; -- RESET WHILE WAITING FOR A NEW MATCH
    EAS <= '1' when present_state = GAME else '0';
    EAH <= '1' when present_state = GAME else '0'; --when (shield_adder < "000000000") else '0';
    WL(0) <= '1' when (turn = "10000") and present_state = ENTERPRISE else '0';
    WL(1) <= '1' when (endGame = '1') and present_state = ENTERPRISE else '0';
  ------------------------------------------------------------------------------------------------------

end architecture;