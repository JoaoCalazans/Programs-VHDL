-------------------------------------------------------
--! @file detector_mealy.vhd
--! @brief Detecta o primeiro 0 após dois ou mais 1s
--! @brief Máquina de Estado no Modelo Mealy
--! @author Edson S. Gomi (gomi@usp.br)
--! @date 2020-05-12
-------------------------------------------------------

entity detector_mealy is
  port (
    RESET : in bit;
    CLOCK : in bit;    
    X : in bit;
    Z : out bit
    );
end entity detector_mealy;

architecture dataflow of detector_mealy is

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
  signal y1_l : bit;
  signal y0 : bit;
  signal xi : bit;

begin

  FF1: entity work.ffd port map (
    RESET => RESET,
    CLOCK => CLOCK,
    D => d1,
    Q => y1,
    Q_L => y1_l
    );

  FF0: entity work.ffd port map (RESET,CLOCK,d0,y0,open);

  xi <= X;
  d1 <= xi and y0;
  d0 <= (xi and y1_l) or (xi and y0);
  Z <= y1 and y0 and not(xi);
  
end architecture dataflow;
  

