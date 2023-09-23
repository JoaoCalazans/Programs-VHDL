-------------------------------------------------------
--! @file mux1_4to1.vhd
--! @brief 4-to-1 1-bit multiplexer
--! @original author Edson S. Gomi (gomi@usp.br)
--! @adapted by João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-08
-------------------------------------------------------

entity mux1_4to1 is
  port (
    SEL : in bit_vector(1 downto 0);    
    B :   in bit_vector(3 downto 0);
    Y :   out bit
    );
end entity mux1_4to1;

architecture with_select of mux1_4to1 is
begin
  with SEL select
    Y <= B(0) when "00",
         B(1) when "01",
         B(2) when "10",
         B(3) when "11",
         '0' when others;
end architecture with_select;

