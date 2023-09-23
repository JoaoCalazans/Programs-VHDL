-------------------------------------------------------
--! @file multiplicador.vhd
--! @brief synchronous multiplier
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-08
-- based on previews projects by both Edson Midorikawa & Edson S. Gomi
-------------------------------------------------------

library ieee;
--use ieee.numeric_bit.rising_edge;

entity multiplicador_modificado is
  port (
    Clock:    in  bit;
    Reset:    in  bit;
    Start:    in  bit;
    Va,Vb:    in  bit_vector(3 downto 0);
    Vresult:  out bit_vector(7 downto 0);
    Ready:    out bit
  );
end entity;

architecture structural of multiplicador_modificado is

  component multiplicador_uc
    port (
      clock:    in  bit;
      reset:    in  bit;
      start:    in  bit;
      rco, Bj:  in  bit;
      SELff:    out bit;
      count:    out bit;
      RSTcount: out bit;
      ready:    out bit;
      CEa, CEb: out bit;
      RSTa, RSTb: out bit;
      RSTr, shiftRight, load_sync: out bit
    );
  end component;

  component multiplicador_fd
    port (
      clock:    in  bit;
      Va,Vb:    in  bit_vector(3 downto 0);
      SELff:    in  bit;
      count:    in  bit;
      RSTcount: in  bit;
      CEa, CEb: in  bit;
      RSTa, RSTb: in bit;
      RSTr, shiftRight, load_sync: in bit;
      rco, Bj:  out bit;
      Vresult:  out bit_vector(7 downto 0)
    );
  end component;

  signal s_rco, s_Bj:    bit;
  signal s_cea, s_ceb, s_rsta, s_rstb:      bit;
  signal s_rstr, s_shiftRight, s_load_sync: bit;
  signal s_SELff, s_count, s_RSTcount:      bit;

  signal s_clock_n:      bit;

begin
  
  s_clock_n <= not Clock;

  MULT_UC: multiplicador_uc port map (
      clock=> Clock,
      reset=> Reset,
      start=> Start,
      CEa=>   s_cea,
      CEb=>   s_ceb,
      RSTa=>  s_rsta,
      RSTb=>  s_rstb,
      RSTr=>  s_rstr,
      shiftRight=>  s_shiftRight,
      load_sync=>   s_load_sync,
      rco=>   s_rco,
      Bj=>    s_Bj,
      SELff=> s_SELff,
      count=> s_count,
      RSTcount=>    s_RSTcount,
      ready=> Ready
    );

  MULT_FD: multiplicador_fd port map (
      clock=>    s_clock_n,
      Va=>       Va,
      Vb=>       Vb,
      CEa=>      s_cea,
      CEb=>      s_ceb,
      RSTa=>      s_rsta,
      RSTb=>      s_rstb,
      RSTr=>     s_rstr,
      shiftRight=>  s_shiftRight,
      load_sync=>   s_load_sync,
      rco=>      s_rco,
      Bj=>       s_Bj,
      SELff=>    s_SELff,
      count=>    s_count,
      RSTcount=> s_RSTcount,
      Vresult => Vresult
    );
  
end architecture;