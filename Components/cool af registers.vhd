library ieee;
use ieee.numeric_bit.all;

-- Registrador de 8 bits capaz de somar seu conteúdo à entrada. Satura-se em 0-255
entity adderSaturated8 is
  port (
    clock, set, reset: in bit;					-- Controle global: clock, set e reset (síncrono)
	enableAdd: 	  in bit;						-- Se 1, conteúdo do registrador é somado a parallel_add (síncrono)
    parallel_add: in  bit_vector(8 downto 0);   -- Entrada a ser somada (inteiro COM sinal): -256 a +255
    parallel_out: out bit_vector(7 downto 0)	-- Conteúdo do registrador: 8 bits, representando 0 a 255
  );
end entity;

architecture arch of adderSaturated8 is
  signal internal: signed(9 downto 0); -- 10 bits com sinal: captura valores entre -512 e 511 na soma
  signal extIn: signed(9 downto 0); -- entrada convertida para 10 bits
  signal preOut: bit_vector(9 downto 0);  -- pré-saida: internal convertido para bit_vector
begin
  extIn <= signed(parallel_add(8) & parallel_add); -- extensão de sinal
  
  process(clock, reset)
  begin
    if (rising_edge(clock)) then
      if set = '1' then						  -- set síncrono
         internal <= (9|8 => '0', others=>'1'); -- Carrega 255 no registrador
	  elsif reset = '1' then				 -- reset síncrono
		 internal <= (others=>'0'); 		 -- Carrega 0s no registrador
	  elsif enableAdd = '1' then			 -- add síncrono
         -- Resultado fica na faixa entre -256 (se parallel_add = -256 e internal = 0) 
         -- e 510 (se parallel_add = 255 e internal = 255)
         if    (internal + extIn < 0)   then internal <= "0000000000"; -- negativo: satura em 0
         elsif (internal + extIn > 255) then internal <= "0011111111"; -- positivo 255+: satura em 255
         else                                internal <= internal + extIn; -- entre 0 e 255
         end if; 
      end if;
    end if;
  end process;
  
  preOut <= bit_vector(internal);
  parallel_out <= preOut(7 downto 0);
end architecture;

---------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

-- Registrador de 8 bits capaz de subtrair a entrada de seu conteúdo. Satura-se em 0
entity decrementerSaturated8 is
  port (
    clock, set, reset: in bit;					-- Controle global: clock, set e reset (síncrono)
	enableSub: 	  in bit;						-- Se 1, conteúdo do registrador é subtraído de parallel_sub (síncrono)
    parallel_sub: in  bit_vector(7 downto 0);   -- Entrada a ser substraida (inteiro SEM sinal): 0 a 255
    parallel_out: out bit_vector(7 downto 0)	-- Conteúdo do registrador: 8 bits, representando 0 a 255
  );
end entity;

architecture arch of decrementerSaturated8 is
  signal internal: signed(8 downto 0); -- 9 bits com sinal: captura valores entre -256 e 255 na substração
  signal convertedIn: signed(8 downto 0); -- entrada convertida para 9 bits
  signal preOut: bit_vector(8 downto 0);  -- pré-saida: internal convertido para bit_vector
begin
  convertedIn <= signed('0' & parallel_sub); -- extensão de sinal: número positivo
  
  process(clock, reset)
  begin
    if (rising_edge(clock)) then
      if set = '1' then						  -- set síncrono
         internal <= (8 => '0', others=>'1'); -- Carrega 255 no registrador
	  elsif reset = '1' then				  -- reset síncrono
		 internal <= (others=>'0'); 		  -- Carrega 0s no registrador
	  elsif enableSub = '1' then			  -- sub síncrono
         internal <= internal - convertedIn;
      end if;
    end if;
  end process;
  
  preOut <= bit_vector(internal);
  parallel_out <= "00000000" when preOut(8) = '1' else --valores negativos: saturar em 0
  				  preout(7 downto 0);
end architecture;