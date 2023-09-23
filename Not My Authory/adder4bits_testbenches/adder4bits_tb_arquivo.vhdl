-------
-- PCS-3225 - Sistemas Digitais II
-- Testbench do somador de 4 bits com leitura de arquivo
--
-- Author: Prof. Sergio R. M. Canovas
-- Date: 23-Aug-2021
-------

library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity testbench_arquivo is
end testbench_arquivo;

architecture adder4bits_tb_arquivo_arch of testbench_arquivo is

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
      
	  file tb_file : text open read_mode is "adder4bits_tb_arquivo.dat";
	  variable tb_line: line;
	  variable space: character;
	  variable op1, op2, soma_esperada: bit_vector(3 downto 0);
	  variable carry_esperado: bit;
	     
   begin
      while not endfile(tb_file) loop  -- Enquanto não chegar no final do arquivo ...
         readline(tb_file, tb_line);  -- Lê a próxima linha
         read(tb_line, op1);   -- Da linha que foi lida, lê o primeiro parâmetro (op1)
         read(tb_line, space); -- Lê o espaço após o primeiro parâmetro (separador)
         read(tb_line, op2);   -- Da linha que foi lida, lê o segundo parâmetro (op2)
         read(tb_line, space); -- Lê o próximo espaço usado como separador
         read(tb_line, soma_esperada);  -- Da linha que foi lida, lê o terceiro parâmetro (soma_esperada)
         read(tb_line, space); -- Lê o próximo espaço usado como separador
         read(tb_line, carry_esperado); -- Da linha que foi lida, lê o quarto parâmetro (carry_esperado)
		 -- Agora que já lemos o caso de teste (par estímulo/saída esperada), vamos aplicar os sinais.
		 a_in <= op1;
		 b_in <= op2;
		 wait for 10 ns; -- Aguarda a produção das saídas
         --  Verifica as saidas
         assert s_out = soma_esperada report "Erro na soma " & integer'image(to_integer(unsigned(op1))) & " + " & integer'image(to_integer(unsigned(op2))) severity error;
         assert c_out = carry_esperado report "Erro no carry para " & integer'image(to_integer(unsigned(op1))) & " + " & integer'image(to_integer(unsigned(op2))) severity error;
      end loop;

	  -- Informa fim do teste
	  assert false report "Teste concluido." severity note;	  
	  wait;  -- pára a execução do simulador, caso contrário este process é reexecutado indefinidamente.
   end process;   

end adder4bits_tb_arquivo_arch;