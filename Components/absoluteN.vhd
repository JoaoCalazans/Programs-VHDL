-------------------------------------------------------
--! @file absoluteN.vhd
--! @brief N-bit binary number absolute conversor
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-09-27
-- i actually never tested, 'cause as u can see this code is stupid and unnecessary
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity absN is
  generic (
    constant N : integer  := 4 -- where N represents the component module
);
  port (
    v_in  : in  bit_vector(N-1 downto 0);
	v_out : out bit_vector(N-1 downto 0)
  );
end entity;

-----------------------------------------------------------------------------------
-- comportamental
architecture comportamental of absN is
  signal internal: signed(N-1 downto 0) := v_in;
begin
  v_out <= abs(internal);
end architecture;

-----------------------------------------------------------------------------------
-- instrumental
architecture instrumental of absN is
    signal internal: signed(N-1 downto 0) := v_in;
begin
  internal <= not(v_in) when v_in(N-1) = '1' else
              internal - 1;
  internal <= internal + 1;
  v_out <= internal;
end architecture;