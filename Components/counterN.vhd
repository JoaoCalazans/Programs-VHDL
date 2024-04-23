-------------------------------------------------------
--! @file counterN.vhd
--! @brief N-bit counter (0 to N-1)
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-09-23
-- avaiable on EDA throw: https://www.edaplayground.com/x/s38W
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity counterN is
  generic (
    constant N : integer  := 2 -- where N represents the component module
);
  port (
    clock, reset: in bit;
	count:        in bit;
	rco:          out bit;
	cval:         out bit_vector(N-1 downto 0)
  );
end entity;

architecture simple of counterN is
  signal internal: unsigned(N-1 downto 0);
  signal s_end: unsigned(N-1 downto 0) := (others => '1');
  -- s_end can also be exchanged by an predeterminade end value
begin
  process(clock, reset)
  begin
    if (rising_edge(clock)) then
      if reset = '1' then
        internal <= (others => '0');
        rco <= '0';
      elsif count = '1' then
		    if (internal = s_end) then
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
