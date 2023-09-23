library ieee;
use ieee.numeric_bit.all;

entity testbench is
end entity;

architecture tb of testbench is
  
  -- Componente a ser testado (Device Under Test -- DUT)
  component log2 is
    port (
      clock, reset: in bit;
	  start: in bit;
      ready: out bit;
      N: in bit_vector(7 downto 0);
      logval: out bit_vector(3 downto 0)
    );
  end component;
  
  -- Declaração de sinais para conectar a componente
  signal clk_in: bit := '0';
  signal rst_in, start_in, ready_out: bit := '0';
  signal N_in: bit_vector(7 downto 0);
  signal logval_out: bit_vector(3 downto 0);

  -- Configurações do clock
  signal keep_simulating: bit := '0'; -- delimita o tempo de geração do clock
  constant clockPeriod : time := 1 ns;
  
begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período
  -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
  -- simulação de eventos
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  
  ---- O código abaixo, sem o "keep_simulating", faria com que o clock executasse
  ---- indefinidamente, de modo que a simulação teria que ser interrompida manualmente
  -- clk_in <= (not clk_in) after clockPeriod/2; 
  
  -- Conecta DUT (Device Under Test)
  dut: log2
    port map(clk_in,rst_in,
			 start_in,
			 ready_out,
			 N_in,
			 logval_out);


  stimulus: process is
  begin
  
    assert false report "simulation start" severity note;
    keep_simulating <= '1';
    
    ------------------- Por simplicidade: não vamos fazer um record array ----------------
    N_in <= "00100011" ; --Alternativa: N_in <= bit_vector(to_signed(35,8));
    rst_in <= '1'; start_in <= '0';
    wait for clockPeriod;
    rst_in <= '0';
    wait until rising_edge(clk_in);
    start_in <= '1';
    wait until rising_edge(clk_in);
    start_in <= '0';
    wait until rising_edge(clk_in);
    while ready_out /= '1' loop  -- executa até o sistema dizer que a saída está pronta
        wait until rising_edge(clk_in);
    end loop;

	assert (logval_out/="0101") report "OK: 00100011 (35)" severity note;
    
    wait for clockPeriod;
    
    -----------------------------------------------------------------------------
    N_in <= "00000000" ; --Alternativa: N_in <= bit_vector(to_signed(0,8));
    rst_in <= '1'; start_in <= '0';
    wait for clockPeriod;
    rst_in <= '0';
    wait until rising_edge(clk_in);
    start_in <= '1';
    wait until rising_edge(clk_in);
    start_in <= '0';
    wait until rising_edge(clk_in);
    while ready_out /= '1' loop  -- executa até o sistema dizer que a saída está pronta
        wait until rising_edge(clk_in);
    end loop;

	assert (logval_out/="1111") report "OK: 00000000 (0)" severity note;
    
    wait for clockPeriod;
    
    -----------------------------------------------------------------------------
    N_in <= "10000000" ; --Alternativa: N_in <= bit_vector(to_signed(256,8));
    rst_in <= '1'; start_in <= '0';
    wait for clockPeriod;
    rst_in <= '0';
    wait until rising_edge(clk_in);
    start_in <= '1';
    wait until rising_edge(clk_in);
    start_in <= '0';
    wait until rising_edge(clk_in);
    while ready_out /= '1' loop  -- executa até o sistema dizer que a saída está pronta
        wait until rising_edge(clk_in);
    end loop;

	assert (logval_out/="0111") report "OK: 10000000 (128)" severity note;
	
    
    
    assert false report "simulation end" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulação: aguarda indefinidamente
  end process;


end architecture;
