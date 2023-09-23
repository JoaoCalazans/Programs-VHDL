-- Se for executar no EDA Playground, use o flag --std=08
-- como opções no import, no make e no run, mas *não* no simulator
library ieee;
use ieee.numeric_bit.all;

entity testbench is
end entity;

architecture tb of testbench is

  -- Component to be tested
  component turbo is
    port (
      clock, reset: in bit;
	  button: in bit_vector(7 downto 0);
	  sensib: in bit_vector(3 downto 0);
      cmd: out bit_vector(7 downto 0)
    );
  end component;

  -- Declaration of signals
  signal clk_in, rst_in: bit := '0';
  signal button_in: bit_vector(7 downto 0);
  signal sensib_in: bit_vector(3 downto 0);
  signal cmd_out: bit_vector(7 downto 0);

  constant clockPeriod : time := 1 ns; -- clock period
  signal   keep_simulating: bit := '0'; --

begin
  -- Clock generator: clock runs while 'keep_simulating', with given
  -- period. When keep_simulating=0, clock stops and so do the event
  -- simulation
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

  -- Connect DUT (Device Under Test)
  dut: turbo
    port map(clk_in,rst_in,
			 button_in,
			 sensib_in,
			 cmd_out);


  stimulus: process is

	---------------- Como são vários testes, vamos fazer um record array --------------
	type pattern_type is record
      --  The inputs of the circuit.
      reset : bit;
      button: bit_vector(7 downto 0);
	  sensib: bit_vector(3 downto 0);
      --  The expected outputs of the circuit.
      cmd: bit_vector(7 downto 0);
    end record;


	--  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (
		('0',"00000000","0001","00000000"), -- 0. ainda sem botões pressionados
		('0',"00000000","0001","00000000"), -- ainda sem botões pressionados
		-------- Sensibilidade 1 --------
		('0',"00000011","0001","00000011"), -- dois botões pressionados
		('0',"00000011","0001","00000000"), -- mantendo botões pressionados: controle de sensibilidade ativado
		('0',"00000011","0001","00000011"), -- mantendo botões pressionados: vamos ao turbo
		('0',"00000011","0001","00000011"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00000011","0001","00000011"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0001","00100010"), -- botões mudaram
		('0',"00100010","0001","00000000"), -- mantendo botões pressionados: controle de sensibilidade ativado
		('0',"00100010","0001","00100010"), -- mantendo botões pressionados: vamos ao turbo
		('0',"00100010","0001","00100010"), -- 10. mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0001","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0001","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0001","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0001","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00000000","0001","00000000"), -- soltando botões
		('0',"11111111","0001","11111111"), -- pressionando todos os botões
		('0',"11111111","0001","00000000"), -- pressionando todos os botões: controle de sensibilidade ativado
		('0',"11111111","0001","11111111"), -- pressionando todos os botões: vamos ao turbo
		('0',"10000000","0001","10000000"), -- pressionando um só botão
		('0',"00000000","0001","00000000"), -- 20. soltando botões
		('0',"10000000","0001","10000000"), -- pressionando um só botão
		('0',"10000000","0001","00000000"), -- pressionando um só botão: controle de sensibilidade ativado
		('0',"00000000","0001","00000000"), -- soltando botões
		('0',"10000000","0001","10000000"), -- pressionando um só botão
		('0',"10000000","0001","00000000"), -- pressionando um só botão: controle de sensibilidade ativado
		('0',"10000000","0001","10000000"), -- pressionando um só botão: vamos ao turbo
		('0',"10000000","0001","10000000"), -- pressionando um só botão: vamos ao turbo
		('0',"00000000","0001","00000000"), -- soltando botões
		-------- Sensibilidade 2 --------
		('0',"00000011","0010","00000011"), -- dois botões pressionados
		('0',"00000011","0010","00000000"), -- 30. mantendo botões pressionados: controle de sensibilidade ativado
		('0',"00000011","0010","00000000"), -- mantendo botões pressionados: ainda em controle de sensibilidade
		('0',"00000011","0010","00000011"), -- mantendo botões pressionados: vamos ao turbo
		('0',"00000011","0010","00000011"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0010","00100010"), -- botões mudaram
		('0',"00100010","0010","00000000"), -- mantendo botões pressionados: controle de sensibilidade ativado
		('0',"00100010","0010","00000000"), -- mantendo botões pressionados: ainda em controle de sensibilidade
		('0',"00100010","0010","00100010"), -- mantendo botões pressionados: vamos ao turbo
		('0',"00100010","0010","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0010","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0010","00100010"), -- 40. mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0010","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00000000","0010","00000000"), -- soltando botões
		('0',"11111111","0010","11111111"), -- pressionando todos os botões
		('0',"11111111","0010","00000000"), -- pressionando todos os botões: controle de sensibilidade ativado
		('0',"11111111","0010","00000000"), -- pressionando todos os botões: ainda em controle de sensibilidade
		('0',"10000000","0010","10000000"), -- pressionando um só botão
		('0',"00000000","0010","00000000"), -- soltando botões
		('0',"10000000","0010","10000000"), -- pressionando um só botão
		('0',"10000000","0010","00000000"), -- pressionando um só botão: controle de sensibilidade ativado
		('0',"00000000","0010","00000000"), -- 50. soltando botões
		('0',"10000000","0010","10000000"), -- pressionando um só botão
		('0',"10000000","0010","00000000"), -- pressionando um só botão: controle de sensibilidade ativado
		('0',"10000000","0010","00000000"), -- pressionando um só botão: ainda em controle de sensibilidade
		('0',"10000000","0010","10000000"), -- pressionando um só botão: vamos ao turbo
		('0',"00000000","0010","00000000"), -- soltando botões
		-------- Sensibilidade 4 --------
		('0',"00000011","0100","00000011"), -- dois botões pressionados
		('0',"00000011","0100","00000000"), -- mantendo botões pressionados: controle de sensibilidade ativado
		('0',"00000011","0100","00000000"), -- mantendo botões pressionados: ainda em controle de sensibilidade
		('0',"00000011","0100","00000000"), -- mantendo botões pressionados: ainda em controle de sensibilidade
		('0',"00000011","0100","00000000"), -- 60. mantendo botões pressionados: ainda em controle de sensibilidade
		('0',"00000011","0100","00000011"), -- mantendo botões pressionados: vamos ao turbo
		('0',"00100010","0100","00100010"), -- botões mudaram
		('0',"00100010","0100","00000000"), -- mantendo botões pressionados: controle de sensibilidade ativado
		('0',"00100010","0100","00000000"), -- mantendo botões pressionados: ainda em controle de sensibilidade
		('0',"00100010","0100","00000000"), -- mantendo botões pressionados: ainda em controle de sensibilidade
		('0',"00100010","0100","00000000"), -- mantendo botões pressionados: ainda em controle de sensibilidade
		('0',"00100010","0100","00100010"), -- mantendo botões pressionados: vamos ao turbo
		('0',"00100010","0100","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00100010","0100","00100010"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00000000","0100","00000000"), -- 70. soltando botões
		('0',"11111111","0100","11111111"), -- pressionando todos os botões
		('0',"11111111","0100","00000000"), -- pressionando todos os botões: controle de sensibilidade ativado
		('0',"11111111","0100","00000000"), -- pressionando todos os botões: ainda em controle de sensibilidade
		('0',"11111111","0100","00000000"), -- pressionando todos os botões: ainda em controle de sensibilidade
		('0',"11111111","0100","00000000"), -- pressionando todos os botões: ainda em controle de sensibilidade
		('0',"10000000","0100","10000000"), -- pressionando um só botão
		('0',"00000000","0100","00000000"), -- soltando botões
		('0',"10000000","0100","10000000"), -- pressionando um só botão
		('0',"10000000","0100","00000000"), -- pressionando um só botão: controle de sensibilidade ativado
		('0',"10000000","0100","00000000"), -- 80. pressionando um só botão: ainda em controle de sensibilidade
		('0',"00000000","0100","00000000"), -- soltando botões
		('0',"10000000","0100","10000000"), -- pressionando um só botão
		('0',"10000000","0100","00000000"), -- pressionando um só botão: controle de sensibilidade ativado
		('0',"10000000","0100","00000000"), -- pressionando um só botão: ainda em controle de sensibilidade
		('0',"10000000","0100","00000000"), -- pressionando um só botão: ainda em controle de sensibilidade
		('0',"10000000","0100","00000000"), -- pressionando um só botão: ainda em controle de sensibilidade
		('0',"10000000","0100","10000000"), -- pressionando um só botão: vamos ao turbo
		('0',"10000000","0100","10000000"), -- mantendo botões pressionados: continuamos no turbo
		('0',"00000000","0100","00000000"), -- soltando botões
        ('0',"00000000","0100","00000000")  -- 90. sem botões pressionados
		-------- Sensibilidade 8: fica por sua conta testar ;) --------
	);

	begin

    assert false report "Simulation start" severity note;
    keep_simulating <= '1';

	-- Inicialização: reset, sem botões pressionados
	rst_in <= '1';
	button_in <= "00000000";
	sensib_in <= "0001";
	wait until rising_edge(clk_in);

	--  Verifica cada pattern
    for k in patterns'range loop

      --  Fornece as entrada
	  rst_in <= patterns(k).reset;
	  button_in <= patterns(k).button;
	  sensib_in <= patterns(k).sensib;

	  --  Espera até a atualização da UC
	  wait until rising_edge(clk_in);

	  --  Espera até a atualização da FD
	  wait until falling_edge(clk_in);
      wait for clockPeriod/4;

	  --  Verifica as saídas.
      assert cmd_out = patterns(k).cmd
			report "Teste " & to_string(k) & ": "
            		& to_string(cmd_out) & " (obtido), "
                   & to_string(patterns(k).cmd) & " (esperado)"
            --report "Erro "
			severity error;

    end loop;

    assert false report "Simulation end" severity note;
    keep_simulating <= '0';

    wait; -- end of simulation
  end process;


end architecture;
