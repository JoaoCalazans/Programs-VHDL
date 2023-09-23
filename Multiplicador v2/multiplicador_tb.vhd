-------------------------------------------------------
--! @file multiplicador_tb.vhd
--! @brief testbench for synchronous multiplier
--! @author Edson Midorikawa (emidorik@usp.br)
--! @adapted by João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-08
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity multiplicador_tb is
end entity;

architecture tb of multiplicador_tb is
  
  -- Componente a ser testado (Device Under Test -- DUT)
  component multiplicador_modificado
    port (
      Clock:    in  bit;
      Reset:    in  bit;
      Start:    in  bit;
      Va,Vb:    in  bit_vector(3 downto 0);
      Vresult:  out bit_vector(7 downto 0);
      Ready:    out bit
    );
  end component;
  
  -- Declaração de sinais para conectar a componente
  signal clk_in: bit := '0';
  signal rst_in, start_in, ready_out: bit := '0';
  signal va_in, vb_in: bit_vector(3 downto 0);
  signal result_out: bit_vector(7 downto 0);

  -- Configurações do clock
  signal keep_simulating: bit := '0'; -- delimita o tempo de geração do clock
  constant clockPeriod : time := 1 ns;
  
begin
  assert false report "simulation start" severity note;
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período
  -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
  -- simulação de eventos
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  
  ---- O código abaixo, sem o "keep_simulating", faria com que o clock executasse
  ---- indefinidamente, de modo que a simulação teria que ser interrompida manualmente
  -- clk_in <= (not clk_in) after clockPeriod/2; 
  
  -- Conecta DUT (Device Under Test)
  dut: multiplicador_modificado
       port map(Clock=>   clk_in,
                Reset=>   rst_in,
                Start=>   start_in,
                Va=>      va_in,
                Vb=>      vb_in,
                Vresult=> result_out,
                Ready=>   ready_out
      );

  ---- Gera sinais de estimulo
  stimulus: process is
  begin
  
    assert false report "simulation start" severity note;
    keep_simulating <= '1';
    
    ---- Caso de teste 1: A=3, B=6
    Va_in <= "0011"; 
    Vb_in <= "0110"; 
    -- Reset inicial (1 periodo de clock) - não precisa repetir
    rst_in <= '1'; start_in <= '0';
    wait for clockPeriod;
    rst_in <= '0';
    wait until falling_edge(clk_in);
    -- pulso do sinal de Start
    start_in <= '1';
    wait until falling_edge(clk_in);
    start_in <= '0';
    -- espera pelo termino da multiplicacao
    wait until ready_out='1';
    -- verifica resultado
    assert (result_out/="00010010") report "1.OK: 3x6=00010010 (18)" severity note;
    
    wait for clockPeriod;

    ----------------------------------------------------------------------------------

    ---- Caso de teste 2: A=15, B=15
    Va_in <= "1111"; 
    Vb_in <= "1111"; 
    -- pulso do sinal de Start
    wait until falling_edge(clk_in);
    start_in <= '1';
    wait until falling_edge(clk_in);
    start_in <= '0';
    -- espera pelo termino da multiplicacao
    wait until ready_out='1';
    -- verifica resultado
    assert (result_out/="11100001") report "2.OK: 15x15=11100001 (225)" severity note;
    
    wait for clockPeriod;    

    ----------------------------------------------------------------------------------

    ---- Caso de teste 3: A=0, B=0
    Va_in <= "0000"; 
    Vb_in <= "0000"; 
    -- pulso do sinal de Start
    wait until falling_edge(clk_in);
    start_in <= '1';
    wait until falling_edge(clk_in);
    start_in <= '0';
    -- espera pelo termino da multiplicacao
    wait until ready_out='1';
    -- verifica resultado
    assert (result_out/="00000000") report "3.OK: 0x0=00000000 (0)" severity note;
    
    wait for clockPeriod;    
 
    ----------------------------------------------------------------------------------

    ---- Caso de teste 4: A=1, B=11
    Va_in <= "0001"; 
    Vb_in <= "1011"; 
    -- pulso do sinal de Start
    wait until falling_edge(clk_in);
    start_in <= '1';
    wait until falling_edge(clk_in);
    start_in <= '0';
    -- espera pelo termino da multiplicacao
    wait until ready_out='1';
    -- verifica resultado
    assert (result_out/="00001011") report "4.OK: 1x11=00001011 (11)" severity note;
    
    wait for clockPeriod;
    
        ----------------------------------------------------------------------------------

    ---- Caso de teste 5: A=4, B=4
    Va_in <= "0100"; 
    Vb_in <= "0100"; 
    -- pulso do sinal de Start
    wait until falling_edge(clk_in);
    start_in <= '1';
    wait until falling_edge(clk_in);
    start_in <= '0';
    -- espera pelo termino da multiplicacao
    wait until ready_out='1';
    -- verifica resultado
    assert (result_out/="00010000") report "5.OK: 4x4=00010000 (16)" severity note;
    
    wait for clockPeriod;
    
    ----------------------------------------------------------------------------------

    ---- Caso de teste 6: A=9, B=0
    Va_in <= "1001"; 
    Vb_in <= "0000"; 
    -- pulso do sinal de Start
    wait until falling_edge(clk_in);
    start_in <= '1';
    wait until falling_edge(clk_in);
    start_in <= '0';
    -- espera pelo termino da multiplicacao
    wait until ready_out='1';
    -- verifica resultado
    assert (result_out/="00000000") report "6.OK: 9x0=00000000 (0)" severity note;
    
    wait for clockPeriod;
    
    ----------------------------------------------------------------------------------
    -- Mais casos de teste aqui
    ----------------------------------------------------------------------------------
 
    -- final do testbench
    assert false report "simulation end" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulação: aguarda indefinidamente
  end process;


end architecture;