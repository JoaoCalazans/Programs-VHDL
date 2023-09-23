-------------------------------------------------------
--! @file mux1_2to1.vhd
--! @brief 2-to-1 1-bit multiplexer
--! @original author Edson S. Gomi (gomi@usp.br)
--! @adapted by João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-08
-------------------------------------------------------

entity mux1_2to1 is
  port (
    SEL : in bit;    
    A,B : in bit;
    Y :   out bit
    );
end entity mux1_2to1;

architecture with_select of mux1_2to1 is
begin
  with SEL select
    Y <= A when '0',
         B when '1',
         '0' when others;
end architecture with_select;