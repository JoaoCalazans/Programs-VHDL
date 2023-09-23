-------------------------------------------------------
--! @file multiplicador.vhd
--! @brief synchronous multiplier
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2020-06-15
-------------------------------------------------------
--library ieee;
--use ieee.numeric_bit.rising_edge;

entity multiplicador_fd is
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
end entity;

architecture structural of multiplicador_fd is

  component reg4
    port (
      clock, reset, enable: in bit;
      D: in  bit_vector(3 downto 0);
      Q: out bit_vector(3 downto 0)
    );
  end component;

  component reg8
    port (
      clock, reset, enable: in bit;
      D: in  bit_vector(7 downto 0);
      Q: out bit_vector(7 downto 0)
    );
  end component;

  component mux4_2to1
    port (
      SEL : in bit;    
      A :   in bit_vector  (3 downto 0);
      B :   in bit_vector  (3 downto 0);
      Y :   out bit_vector (3 downto 0)
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

  component fa_8bit
    port (
      A,B  : in  bit_vector(7 downto 0);
      CIN  : in  bit;
      SUM  : out bit_vector(7 downto 0);
      COUT : out bit
      );
  end component;

  component zero_detector
    port (
      A    : in bit_vector(3 downto 0);
      zero : out bit
    );
  end component;

  signal s_ra, s_rb:         bit_vector(3 downto 0);
  signal s_bmenos1, s_muxb:  bit_vector(3 downto 0);
  signal s_a8, s_soma, s_rr: bit_vector(7 downto 0);

begin
  
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
      D=>      s_muxb,
      Q=>      s_rb
     );
  
  RR: reg8 port map (
      clock=>  clock, 
      reset=>  RSTr, 
      enable=> CEr,
      D=>      s_soma,
      Q=>      s_rr
     );  
  
  SOMA: fa_8bit port map (
        A=>   s_a8,
        B=>   s_rr,
        CIN=> '0',
        SUM=> s_soma,
        COUT=> open
        );

  SUB1: fa_4bit port map (
        A=>   s_rb,
        B=>   "1111",  -- (-1)
        CIN=> '0',
        SUM=> s_bmenos1,
        COUT=> open
        );
  
  MUXB: mux4_2to1 port map (
        SEL=> DCb,    
        A=>   Vb,
        B=>   s_bmenos1,
        Y=>   s_muxb
        );

  ZERO: zero_detector port map (
        A=>    s_rb,
        zero=> Zrb
        );

  s_a8 <= "0000" & s_ra;
  Vresult <= s_rr;
  
end architecture;

