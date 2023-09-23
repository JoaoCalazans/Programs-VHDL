library ieee;
use ieee.numeric_bit.rising_edge;

entity regshift8 is
  port (
    clock, shiftRight, load_sync: in bit;
    parallel_in:  in  bit_vector(7 downto 0);	-- entrada a ser registrada
    parallel_out: out bit_vector(7 downto 0)	-- dados registrados
  );
begin
end entity;

architecture arch_reg8 of regshift8 is
  signal internal: bit_vector(7 downto 0);
begin
  process(clock)
  begin
    if (rising_edge(clock)) then
      if load_sync='1'then
        internal <= parallel_in;
      elsif shiftRight='1' then
        internal<= '0' & internal(7 downto 1);
      end if;
    end if;
  end process;
  parallel_out <= internal;
end architecture;

------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity counter4 is
  port (
    clock: 	in bit;
	set: 	in bit;		-- set síncrono
	count: 	in bit;		-- habilita contagem
	cval: 	out bit_vector(3 downto 0)
  );
begin
end entity;

architecture simple of counter4 is
  signal internal: unsigned(3 downto 0);
begin
  process(clock)
  begin
    if (rising_edge(clock)) then
	  if set='1' then
         internal <= (others=>'1'); -- "1111" = "-1"
	  elsif count='1'then
        internal <= internal + 1;
      end if;
    end if;
  end process;
  cval <= bit_vector(internal);
  
end architecture;


---------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity log2FD is
  port (
    clock: in bit;							-- Sinais de controle globais
	LoadR, ResetL, Shift, EnableL: in bit;	-- Sinais de controle da UC
    reg0: out bit;							-- Sinais de condição para UC
    N   : in  bit_vector(7 downto 0);		-- Dados de entrada
    logval: out bit_vector(3 downto 0)		-- Dados de saída
  );
end entity;

architecture dataflow of log2FD is
    
  component regshift8 is
    port (
      clock, shiftRight, load_sync: in bit;
	  parallel_in:  in  bit_vector(7 downto 0);	-- entrada a ser registrada
      parallel_out: out bit_vector(7 downto 0)	-- dados registrados
    );
  end component;
  
  component counter4 is
    port (
	  clock: 	in bit;
	  set: 		in bit;		-- set síncrono
	  count: 	in bit;		-- habilita contagem
	  cval: 	out bit_vector(3 downto 0)
    );
  end component;
  
  signal reg8out: bit_vector(7 downto 0);
begin
  reg8: regshift8
    port map(clock, Shift, LoadR, 
			 N, 
			 reg8out);
  log4: counter4
    port map(clock, 
			 ResetL,
			 EnableL, 
			 logval);

  reg0 <= not(reg8out(7) or reg8out(6) or reg8out(5) or reg8out(4) or
			  reg8out(3) or reg8out(2) or reg8out(1) or reg8out(0));

end architecture;
