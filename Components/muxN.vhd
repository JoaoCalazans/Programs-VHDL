-------------------------------------------------------
--! @file muxN.vhd
--! @brief a cool as fuck N-bit multiplexer
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-09-23
-- Available on EDA Playground: https://www.edaplayground.com/x/TZj4
-------------------------------------------------------
-- A SERIOUS BRIEF: this mux has N as it total bits capacity,
-- You have two IN-BITS (A and B) and two OUT-SIGNALS (X and Y),
-- where all of them are N bit module -> X = {xN-1, xN-2, xN-3, ..., x1, x0}
-- (lowercase X stands for vector coordenate).
-- They are controlled by the signal SEL:
 
-- |  when SEL = 0    |    when SEL = 1  |
-- |     X = A        |       X = B      |
-- |     Y = A        |       Y = B      |

entity muxN is
  generic (
      constant N : integer  := 15 -- where N represents the component module
  );
  port (
    SEL : in bit;    
    A :   in bit_vector  (N-1 downto 0);
    B :   in bit_vector  (N-1 downto 0);
    X :   out bit_vector (N-1 downto 0);
    Y :   out bit_vector (N-1 downto 0)
  );
end entity;

architecture with_select of muxN is
begin
  with SEL select
    X <= A when '0',
         B when '1',
         (others => '0') when others;
         
with SEL select
    Y <= B when '0',
         A when '1',
         (others => '0') when others;
end architecture with_select;
