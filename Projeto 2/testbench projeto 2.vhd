---------------------------------------------------------------------
------------------------------ TESTBENCH ----------------------------
---------------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity testbench is
end entity;

architecture tb of testbench is

  -- Component to be tested
  component StartTrekAssault is
  port (
    clock, reset: 	in  bit;					-- sinais de controle globais 
    damage: 		in  bit_vector(7 downto 0);	-- Entrada de dados: dano
	shield:			out bit_vector(7 downto 0); -- Saída: shield atual
	health:			out bit_vector(7 downto 0);  -- Saída: health atual
    turn:			out bit_vector(4 downto 0);  -- Saída: rodada atual
    WL:             out bit_vector(1 downto 0)  -- Saída: vitória e/ou derrota
  );
  end component;

  -- Declaration of signals
  signal clk_in, rst_in: bit := '0';	
  signal damage_in:  bit_vector(7 downto 0);
  signal shield_out: bit_vector(7 downto 0);
  signal health_out: bit_vector(7 downto 0);
  signal turn_out:   bit_vector(4 downto 0);
  signal WL_out:     bit_vector(1 downto 0);
      

  constant clockPeriod : time := 1 ns;  -- clock period
  signal   keep_simulating: bit := '0'; -- ao colocar em '0': interrompe simulação

begin
  -- Clock generator: clock runs while 'keep_simulating', with given
  -- period. When keep_simulating = '0', clock stops and so do the event
  -- simulation
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

  -- Connect DUT (Device Under Test)
  dut: StartTrekAssault
  port map(
    clk_in, rst_in,
    damage_in,
	shield_out,
	health_out,
    turn_out,
    WL_out
  );
  

  stimulus: process is
	---------------- Como são vários testes, vamos fazer um record array --------------
	type pattern_type is record
      --  The inputs of the circuit.
      reset:  bit;
      damage: bit_vector(7 downto 0);
	  --  The expected outputs of the circuit.
	  shield:	bit_vector(7 downto 0);
	  health:	bit_vector(7 downto 0);
      turn:	bit_vector(4 downto 0);
      WL:     bit_vector(1 downto 0);
    end record;


	--  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (
      
      ------------------ 0 ------------------
		('1', bit_vector(to_unsigned(20,damage_in'length)),		-- Reset inicial
			  bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(0,health_out'length)), 
              bit_vector(to_unsigned(0,turn_out'length)), 
              "00"), 
		----- Inicio: permanecendo no full
		('0', bit_vector(to_unsigned(0,damage_in'length)),		-- Início: dano ignorado;
			  bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(1,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(31,damage_in'length)),		-- dano de 31 < 32
			  bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(2,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(55,damage_in'length)),
			  bit_vector(to_unsigned(216,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(3,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(16,damage_in'length)),
              bit_vector(to_unsigned(216,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(4,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(0,damage_in'length)),
              bit_vector(to_unsigned(232,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(5,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(120,damage_in'length)),
			  bit_vector(to_unsigned(128,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(6,turn_out'length)), 
              "00"), 
		----- regen <= 2
		('0', bit_vector(to_unsigned(17,damage_in'length)),
			  bit_vector(to_unsigned(127,shield_out'length)),
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(7,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),
			  bit_vector(to_unsigned(129,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(8,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(231,damage_in'length)),
			  bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(155,health_out'length)), 
              bit_vector(to_unsigned(9,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(1,damage_in'length)),
			  bit_vector(to_unsigned(1,shield_out'length)), 
              bit_vector(to_unsigned(155,health_out'length)), 
              bit_vector(to_unsigned(10,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(4,damage_in'length)),
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(154,health_out'length)), 
              bit_vector(to_unsigned(11,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(200,damage_in'length)),
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(0,health_out'length)), 
              bit_vector(to_unsigned(12,turn_out'length)), 
              "00"),
        ('0', bit_vector(to_unsigned(69,damage_in'length)), -- damage dont care
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(0,health_out'length)), 
              bit_vector(to_unsigned(12,turn_out'length)), 
              "10")
    );

	begin

    assert false report "Simulation start" severity note;
    keep_simulating <= '1';


	--  Verifica cada pattern
    for k in patterns'range loop
 	  
     
      --  Fornece as entradas
	  rst_in <= patterns(k).reset;
      damage_in <= patterns(k).damage;
      
	  --  Espera até a atualização da UC
	  wait until rising_edge(clk_in);

	  --  Espera até a atualização da FD
	  wait until falling_edge(clk_in);
      wait for clockPeriod/4;

	  --  Verifica as saídas.
      assert (shield_out = patterns(k).shield) and 
			 (health_out = patterns(k).health) and
             (turn_out = patterns(k).turn) and
             (WL_out = patterns(k).WL)
			report "Teste " & integer'image(k) & " > "
					& "Shield: " & integer'image(to_integer(unsigned(shield_out))) & " (obtido), "
					& integer'image(to_integer(unsigned(patterns(k).shield))) & " (esperado); "
                    & "Health: " & integer'image(to_integer(unsigned(health_out))) & " (obtido), "
					& integer'image(to_integer(unsigned(patterns(k).health))) & " (esperado); "
                    & "Turn: " & integer'image(to_integer(unsigned(turn_out))) & " (obtido), "
					& integer'image(to_integer(unsigned(patterns(k).turn))) & " (esperado); "
                    & "WL: " & integer'image(to_integer(unsigned(WL_out))) & " (obtido), "
					& integer'image(to_integer(unsigned(patterns(k).WL))) & " (esperado); "                    
			severity error;
    end loop;
	

    assert false report "Simulation end" severity note;
    keep_simulating <= '0';

    wait; -- end of simulation
  end process;
  
end architecture;