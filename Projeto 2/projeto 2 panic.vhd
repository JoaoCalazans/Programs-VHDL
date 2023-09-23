------------------------------------------------------------
--! @file Projeto 2.vhd
--! @brief Star Trek PANIC
--! @author João Pedro Dionizio Calazans (13673086)
--! @date 2023-06-23
------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity StartTrekAssault is
	port (
		clock, reset: in bit; -- sinais de controle globais
		damage: in bit_vector(7 downto 0); -- Entrada de dados: dano
		shield: out bit_vector(7 downto 0); -- Saída: shield atual
		health: out bit_vector(7 downto 0); -- Saída: health atual
		turn: out bit_vector(4 downto 0); -- Saída: rodada atual
		WL: out bit_vector(1 downto 0) -- Saída: vitória e/ou derrota
	);
end entity;

architecture behavioral of StartTrekAssault is
  -------------------------------------------------------------------------------------------------------
  -- Sequencial block Data Flow

  component StartTrekFD is
    port (
      clock, reset: in bit;
      SRS, SRH, RRS, RRH, EAS, EAH: in bit;
      s_adder, h_adder: in bit_vector(8 downto 0);
      shield, health: out bit_vector(7 downto 0);
      endGame: out bit
    ); 
  end component;

  -------------------------------------------------------------------------------------------------------
  -- Sequencial block Control Unit

  component StartTrekUC is
    port (
    clock, reset: in bit;	                      -- Sinais de controle globais
    damage, shield: in bit_vector(7 downto 0);    -- Sinais de controle externo
    endGame: in bit;	              -- Sinais de controle FD
    WL: out bit_vector(1 downto 0);               -- Sinais de controle externo
    TURN: out bit_vector(4 downto 0);             -- Sinal de saída externo: CURRENT TURN
    SRS, SRH, RRS, RRH, EAS, EAH: out bit;	      -- Sinais de controle para FD
    s_adder, h_adder: out bit_vector(8 downto 0) -- Sinais de controle para FD
  );
  end component;

  -------------------------------------------------------------------------------------------------------
  -- aux variables

  signal clock_n, endGame: bit;
  signal SRS, SRH, RRS, RRH, EAS, EAH: bit;
  signal s_adder, h_adder: bit_vector(8 downto 0);

  -------------------------------------------------------------------------------------------------------

begin
  clock_n <= not(clock);
  fd: StartTrekFD
    port map (clock_n, reset, SRS, SRH, RRS, RRH, EAS, EAH, s_adder, h_adder, shield, health, endGame);
  uc: StartTrekUC
    port map (clock, reset, damage, shield, endGame, WL, TURN, SRS, SRH, RRS, RRH, EAS, EAH, s_adder, h_adder);

  --shield <= "01000101";

end architecture behavioral;