-------
-- PCS-3225 - Sistemas Digitais II
-- Testbench do somador de 4 bits com vetor de testes
--
-- Author: Prof. Sergio R. M. Canovas
-- Date: 23-Aug-2021
-------

library ieee;
use ieee.numeric_bit.all;

entity testbench_vetor is
end testbench_vetor;

architecture adder4bits_tb_vetor_arch of testbench_vetor is

   -- Declara o componente do DUT
   component adder4bits is
      port (
         a:         in  bit_vector(3 downto 0);
	     b:         in  bit_vector(3 downto 0);
	     sum:       out bit_vector(3 downto 0);
	     carry_out: out bit
      );
   end component;

   signal a_in, b_in, s_out: bit_vector(3 downto 0);
   signal c_out: bit;

begin
  
   DUT: adder4bits port map (a => a_in, b => b_in, sum => s_out, carry_out => c_out);
   
   gerador_estimulos: process is
      
	  type pattern_type is record
	     -- Entradas
		 op1: bit_vector(3 downto 0);
		 op2: bit_vector(3 downto 0);
		 -- Saídas
		 soma_esperada: bit_vector(3 downto 0);
		 carry_esperado: bit;
	  end record;
	  
	  type pattern_array is array (natural range <>) of pattern_type;
	  
	  constant patterns: pattern_array :=
	     --                                op1  op2     carry_esperado  soma_esperada
		 (("0000","0000","0000",'0'),   --   0 +  0  =               0              0
		  ("0001","0001","0010",'0'),   --   1 +  1  =               0              2
		  ("1000","1000","0000",'1'),   --   8 +  8  =               1              0
		  ("1111","0001","0000",'1'),   --   F +  1  =               1              0
		  ("1110","0111","0101",'1'),   --   E +  7  =               1              5
		  ("0111","0011","1010",'0'),   --   7 +  3  =               0              A
		  ("1100","0101","0001",'1'));  --   C +  5  =               1              1
   
   begin
      
	  -- Para cada padrao de teste no vetor
      for i in patterns'range loop
         -- Injeta as entradas
         a_in <= patterns(i).op1;
		 b_in <= patterns(i).op2;
         -- Aguarda que o modulo produza a saida
         wait for 10 ns;
         --  Verifica as saidas
         assert s_out = patterns(i).soma_esperada report "Erro na soma " & integer'image(to_integer(unsigned(patterns(i).op1))) & " + " & integer'image(to_integer(unsigned(patterns(i).op2))) severity error;
         assert c_out = patterns(i).carry_esperado report "Erro no carry para " & integer'image(to_integer(unsigned(patterns(i).op1))) & " + " & integer'image(to_integer(unsigned(patterns(i).op2))) severity error;
      end loop;

	  -- Informa fim do teste
	  assert false report "Teste concluido." severity note;	  
	  wait;  -- pára a execução do simulador, caso contrário este process é reexecutado indefinidamente.
   end process;
   

end adder4bits_tb_vetor_arch;