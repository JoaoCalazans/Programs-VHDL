entity turbo is
  port (
    clock, reset: in bit;
    button: in bit_vector(7 downto 0);
	sensib: in bit_vector(3 downto 0);
    cmd: out bit_vector(7 downto 0)
  );
end entity;

architecture structural of turbo is
  component turboFD is
    port (
      -- (obs.: reset omitido porque não precisamos dele)
		clock:		 					in bit;	 -- sinais de controle globais 
		SelOut, LoadR, ResetC, EnableC: in bit;	 -- sinais de controle da UC
		Push, ReqB, CgteS: 				out bit; -- sinais de condição para UC
		button: in  bit_vector(7 downto 0);	 -- Entrada de dados: botão
		sensib: in  bit_vector(3 downto 0);	 -- Entrada de dados: sensibilidade
		cmd:    out bit_vector(7 downto 0)	 -- Saída de dados: valor do comando
    );
  end component;
  
  
  component turboUC is
    port (
		clock, reset: in bit;					-- sinais de controle globais
		Push, ReqB, CgteS: in bit;  			-- sinais de condição do FD
		SelOut, LoadR, ResetC, EnableC: out bit	-- sinais de controle para FD
	);
  end component;
  
  signal SelOut, LoadR, ResetC, EnableC: bit; -- sinais de controle
  signal Push, ReqB, CgteS: bit; -- sinais de condição
  signal clock_n: bit; --clock negado: sincronismo com borda de descida
begin
  clock_n <= not(clock);
  
  fd: turboFD
    port map(clock_n, 
			SelOut, LoadR, ResetC, EnableC,
			Push, ReqB, CgteS,
			button,
			sensib,
			cmd);
  
  uc: turboUC
    port map(clock, reset,
			Push, ReqB, CgteS,
			SelOut, LoadR, ResetC, EnableC);
end architecture;
