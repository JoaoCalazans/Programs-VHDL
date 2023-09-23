-------------------------------------------------------
--! @file multiplicador.vhd
--! @brief synchronous multiplier
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2020-06-15
-------------------------------------------------------
library ieee;
--use ieee.numeric_bit.rising_edge;

entity multiplicador is
  port (
    Clock:    in  bit;
    Reset:    in  bit;
    Start:    in  bit;
    Va,Vb:    in  bit_vector(3 downto 0);
    Vresult:  out bit_vector(7 downto 0);
    Ready:    out bit
  );
end entity;

architecture structural of multiplicador is

  component multiplicador_uc
    port (
      clock:    in  bit;
      reset:    in  bit;
      start:    in  bit;
      Zrb:      in  bit;
      RSTa,CEa: out bit;
      RSTb,CEb: out bit;
      RSTr,CEr: out bit;
      DCb:      out bit;
      ready:    out bit
    );
  end component;

  component multiplicador_fd
    port (
      clock:    in  bit;
      Va,Vb:    in  bit_vector(3 downto 0);
      RSTa,CEa: in  bit;
      RSTb,CEb: in  bit;
      RSTr,CEr: in  bit;
      DCb:      in  bit;
      Zrb:      out bit;
      Vresult:  out bit_vector(7 downto 0)
    );
  end component;

  signal s_zrb:          bit;
  signal s_rsta, s_cea:  bit;
  signal s_rstb, s_ceb:  bit;
  signal s_rstr, s_cer:  bit;
  signal s_dcb:          bit;

  signal s_clock_n:      bit;

begin
  
  s_clock_n <= not Clock;

  MULT_UC: multiplicador_uc port map (
      clock=> Clock,
      reset=> Reset,
      start=> Start,
      Zrb =>  s_zrb,
      RSTa=>  s_rsta,
      CEa=>   s_cea,
      RSTb=>  s_rstb,
      CEb=>   s_ceb,
      RSTr=>  s_rstr,
      CEr=>   s_cer,
      DCb=>   s_dcb,
      ready=> Ready
    );

  -- FD usa sinal invertido
  MULT_FD: multiplicador_fd port map (
      clock=>    s_clock_n,
      Va=>       Va,
      Vb=>       Vb,
      RSTa=>     s_rsta,
      CEa=>      s_cea,
      RSTb=>     s_rstb,
      CEb=>      s_ceb,
      RSTr=>     s_rstr,
      CEr=>      s_cer,
      DCb=>      s_dcb,
      Zrb =>     s_zrb,
      Vresult => Vresult
    );
  
end architecture;

