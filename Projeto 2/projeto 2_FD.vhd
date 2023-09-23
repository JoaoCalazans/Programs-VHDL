library ieee;
use ieee.numeric_bit.all;

entity StartTrekFD is
    port (
      clock, reset: in bit;	                      -- Sinais de controle globais
      SRS, SRH, RRS, RRH, EAS, EAH: in bit;	      -- Sinais de controle da UC
      s_adder, h_adder: in bit_vector(8 downto 0); -- Sinais de controle da UC
      shield, health: out bit_vector(7 downto 0);  -- Sinais de controle externo
      endGame: out bit	              -- Sinais de controle para UC
    );
  end entity;

architecture dataflow of StartTrekFD is
    component adderSaturated8 is
        port (
          clock, set, reset: in bit;
          enableAdd: 	  in bit;
          parallel_add: in  bit_vector(8 downto 0);
          parallel_out: out bit_vector(7 downto 0)
        );
    end component;

  signal shield_register, health_register: bit_vector(7 downto 0);

begin
    ADD_SHIELD: adderSaturated8 port map (clock, SRS, RRS, EAS, s_adder, shield_register);
    ADD_HEALTH: adderSaturated8 port map (clock, SRH, RRH, EAH, h_adder, health_register);
    shield <= shield_register;
    health <= health_register;

    endGame <= '1' when health = "00000000" else '0';

end architecture;