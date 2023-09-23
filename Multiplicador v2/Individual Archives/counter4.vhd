-------------------------------------------------------
--! @file counter4.vhd
--! @brief 2-bit counter (0 to 3)
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-09
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity counter4 is
  port (
    clock, reset: in bit;
	  count:        in bit;
	  rco: 	        out bit;
	  cval:         out bit_vector(1 downto 0)
  );
end entity;

architecture simple of counter4 is
  signal internal: unsigned(1 downto 0);
begin
  process(clock, reset)
  begin
    if reset='1' then
      internal <= (others=>'0');
      rco <= '0';
    elsif (rising_edge(clock)) then
      if count='1'then
		    if (internal = "11") then
			    rco <= '1';
		    else 
			    rco <= '0';
		    end if;
		
        internal <= internal + 1;
      end if;
    end if;
  end process;
  cval <= bit_vector(internal);
  
end architecture;