-------------------------------------------------------
--! @file multiplicador.vhd
--! @brief synchronous multiplier
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-08
-- based on preview project by Edson Midorikawa
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.rising_edge;

entity multiplicador_fd is
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
end entity;

architecture structural of multiplicador_fd is

  component reg4
    port (
      clock, reset, enable: in bit;
      D: in  bit_vector(3 downto 0);
      Q: out bit_vector(3 downto 0)
    );
  end component;

  component regshift8
    port (
      clock, reset, shiftRight, load_sync, shiftBit: in bit;
      parallel_in:  in  bit_vector(3 downto 0);
      parallel_out: out bit_vector(7 downto 0)
    );
  end component;

  component mux1_2to1
    port (
      SEL : in bit;    
      A,B : in bit;
      Y :   out bit
    );
  end component;

  component mux1_4to1
    port (
      SEL : in bit_vector(1 downto 0);    
      B :   in bit_vector(3 downto 0);
      Y :   out bit
    );
end component;

  component fa_4bit
    port (
      A,B  : in  bit_vector(3 downto 0);
      CIN  : in  bit;
      SUM  : out bit_vector(3 downto 0);
      COUT : out bit
    );
  end component;

  component ffd
    port (
      RESET : in bit;
      CLOCK : in bit;
      D : in bit;
      Q : out bit;
      Q_L : out bit
    );
  end component;

  component counter4
    port (
      clock, reset: in bit;
	    count: 		  in bit;
	    rco: 	out bit;
	    cval: 	out bit_vector(1 downto 0)
    );
  end component;

  signal s_vaium, s_D, s_Q: bit;
  signal s_ra, s_rb, s_soma: bit_vector(3 downto 0);
  signal s_count:  bit_vector(1 downto 0);
  signal s_rr: bit_vector(7 downto 0);

begin

  RR: regshift8 port map (
      clock=>  clock, 
      reset=>  RSTr,
      shiftRight=> shiftRight,
      load_sync=> load_sync,
      shiftBit=> s_Q,
      parallel_in=> s_soma,
      parallel_out=> s_rr
     );  

  RA: reg4 port map (
      clock=>  clock, 
      reset=>  RSTa, 
      enable=> CEa,
      D=>      Va,
      Q=>      s_ra
    );

  RB: reg4 port map (
      clock=>  clock, 
      reset=>  RSTb, 
      enable=> CEb,
      D=>      Vb,
      Q=>      s_rb
    );

  SOMA: fa_4bit port map (
      A=>   s_ra,
      B=>   s_rr(7 downto 4),
      CIN=> '0',
      SUM=> s_soma,
      COUT=> s_vaium
    );

  MUXa: mux1_2to1 port map (
      SEL=> SELff,
      A=>   '0',
      B=>   s_vaium,
      Y=>   s_D
    );

  MUXb: mux1_4to1 port map (
      SEL=> s_count,
      B=>   s_rb,
      Y=>   Bj
    );
  
  FF: ffd port map (
      clock=>  clock, 
      reset=>  '0', 
      D=>      s_D,
      Q=>      s_Q,
      Q_L=>    open
    );

  COUNTER: counter4 port map (
      clock=>  clock, 
      reset=>  RSTcount, 
      count=>  count,
      rco=>    rco,
      cval=>   s_count
    );

  Vresult <= s_rr;
  
end architecture;