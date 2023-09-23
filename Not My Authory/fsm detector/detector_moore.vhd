-------------------------------------------------------
--! @file detector_moore.vhd
--! @brief Detecta o primeiro 0 após dois ou mais 1s
--! @brief Máquina de Estado no Modelo Moore
--! @author Edson S. Gomi (gomi@usp.br)
--! @date 2020-05-12
-------------------------------------------------------

entity detector_moore is
  port (
    RESET : in bit;
    CLOCK : in bit;    
    X : in bit;
    Z : out bit
    );
end entity detector_moore;

architecture dataflow of detector_moore is

  component ffd is
    port (
      RESET : in bit;
      CLOCK : in bit;
      D : in bit;
      Q : out bit;
      Q_L : out bit
      );
  end component ffd;
  
  signal d1 : bit;
  signal d0 : bit;
  signal y1 : bit;  
  signal y0 : bit;
  signal y0_l : bit;

begin

  FF1: entity work.ffd port map (
    RESET => RESET,
    CLOCK => CLOCK,
    D => d1,
    Q => y1,
    Q_L => open
    );

  FF0: entity work.ffd port map (RESET,CLOCK,d0,y0,y0_l);

  d1 <= (X and y0) or (y1 and y0);
  d0 <= X;
  Z <= y1 and y0_l;
  
end architecture dataflow;