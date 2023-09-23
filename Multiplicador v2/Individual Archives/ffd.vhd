------------------------------------------------------------
--! @file ffd.vhd
--! @brief D-Type Flip-Flop
--! @author Edson S. Gomi (gomi@usp.br)
--! @date 2020-05-12
------------------------------------------------------------

entity ffd is
  port (
    RESET : in bit;
    CLOCK : in bit;
    D : in bit;
    Q : out bit;
    Q_L : out bit
    );
end entity ffd;

architecture behavioral of ffd is
  signal qi : bit;  
begin
    FF: process(RESET,CLOCK)
  begin
    if (RESET = '1') then
      qi <= '0';
    elsif (CLOCK'event) and (CLOCK = '1') then
      qi <= D;
    end if;
  end process FF;

  Q <= qi;
  Q_L <= not(qi);  
end architecture behavioral;
