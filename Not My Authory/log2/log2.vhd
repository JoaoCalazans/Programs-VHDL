entity log2 is
  port (
    clock, reset: in bit;				-- Sinais de controle globais
	start: in bit;						-- Sinal de condicão externo: inicialização
    ready: out bit;						-- Sinal de saída: execução finalizada
    N: in bit_vector(7 downto 0);		-- Dados de entrada
    logval: out bit_vector(3 downto 0)	-- Dados de saída
  );
end entity log2;

architecture structural of log2 is
  component log2FD is
    port (
		  clock: in bit;							-- Sinais de controle globais
		  LoadR, ResetL, Shift, EnableL: in bit;	-- Sinais de controle da UC
    	  reg0: out bit;							-- Sinais de condição para UC
    	  N   : in  bit_vector(7 downto 0);			-- Dados de entrada
    	  logval: out bit_vector(3 downto 0)		-- Dados de saída
		 );
  end component;
    
  component log2UC is
    port (
		  clock, reset: in bit;		-- Sinais de controle globais
		  start: in bit;			-- Sinal de condicão externo
		  ready: out bit;			-- Sinal de controle de saída
    	  reg0: in bit;				-- Sinal de condição da FD
    	  LoadR, ResetL, Shift, EnableL: out bit	-- Sinais de controle para FD
		  );
  end component;
  
  signal LoadR, ResetL, Shift, EnableL: bit; -- sinais de controle internos
  signal reg0: bit; -- sinais de condição internos
  signal clock_n: bit; --clock negado: sincronismo com borda de descida
begin
  clock_n <= not(clock);
  fd: log2FD
    port map(clock_n, LoadR, ResetL, Shift, EnableL, reg0, N, logval);
  uc: log2UC
    port map(clock, reset, start, ready, reg0, LoadR, ResetL, Shift, EnableL);
end architecture;
