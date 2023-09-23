library ieee;
use ieee.numeric_bit.rising_edge;

entity register8 is
  port (
    clock, reset: in bit;
	load: 		  in bit;
    parallel_in:  in  bit_vector(7 downto 0);
    parallel_out: out bit_vector(7 downto 0)
  );
begin
end entity;

architecture arch_reg8 of register8 is
  signal internal: bit_vector(7 downto 0);
begin
  process(clock, reset)
  begin
    if reset='1' then				--reset assíncrono
      internal <= (others=>'0'); 	-- "00000000"
    elsif (rising_edge(clock)) then
	  if load='1'then				--load síncrono
        internal <= parallel_in;
      end if;
    end if;
  end process;
  parallel_out <= internal;
end architecture;

---------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity counter4 is
  port (
    clock, reset: in bit;
	count: 		  in bit;
	rco: 	out bit; -- não vamos usar, mas incluído por completude
	cval: 	out bit_vector(3 downto 0)
  );
begin
end entity;

architecture simple of counter4 is
  signal internal: unsigned(3 downto 0);
begin
  process(clock, reset)
  begin
    if reset='1' then
      internal <= (others=>'0'); -- "0000"
    elsif (rising_edge(clock)) then
      if count='1'then
		if (internal = "1111") then
			rco <= '1';
		else 
			rco <= '0';
		end if;
		
        internal <= internal + 1;
      end if;
    end if;
  end process;
  cval <= bit_vector(internal);
  
end architecture;


---------------------------------------------------------------------

entity turboFD is
  port (
    -- (obs.: reset omitido porque não precisamos dele)
    clock:		 					in bit;	 -- sinais de controle globais 
    SelOut, LoadR, ResetC, EnableC: in bit;	 -- sinais de controle da UC
	Push, ReqB, CgteS: 				out bit; -- sinais de condição para UC
    button: in  bit_vector(7 downto 0);	 -- Entrada de dados: botão
	sensib: in  bit_vector(3 downto 0);	 -- Entrada de dados: sensibilidade
    cmd:    out bit_vector(7 downto 0)	 -- Saída de dados: valor do comando
  );
end entity;


architecture dataflow of turboFD is

  ------ Componentes utilizados  ------
  component register8 is
    port (
		  clock, reset: in bit;
		  load: 		  in bit;
		  parallel_in:  in  bit_vector(7 downto 0);
		  parallel_out: out bit_vector(7 downto 0)
    );
  end component;
  
  component counter4 is
    port (
		  clock, reset: in bit;
		  count: 		in bit;
		  rco: 	out bit;
		  cval: out bit_vector(3 downto 0)
    );
  end component;
  -------------------------------------
   
  ---------- Sinais internos ----------
  signal reg8out: bit_vector(7 downto 0);
  signal counter4out: bit_vector(3 downto 0);
  -------------------------------------

begin
  -- Ligando os componentes
  reg: register8
    port map(clock, '0', 
			 LoadR, 
			 button,
			 reg8out);
			 	 
  count: counter4
    port map(clock => clock, reset => ResetC, 
			 count => EnableC, 
			 rco => open, --porta não utilizada: podemos deixar em aberto
			 cval => counter4out);

  
  -- Sinais de condição para UC
  Push <= button(7) or button(6) or button (5) or button(4) or
		  button(3) or button(2) or button (1) or button(0); -- OR de 8 bits
		  
  ReqB <= '1' when (reg8out = button) else '0';			-- Comparador: igualdade
  
  CgteS <= '1' when (counter4out >= sensib) else '0';						-- Comparador: maior ou igual

  -- Sinais de saída do circuito
  cmd <= "00000000" when SelOut = '0' else reg8out;		-- MUX
  

end architecture;
