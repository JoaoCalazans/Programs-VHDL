library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port (
      -- 4 bits de endereço:
      address: in std_logic_vector(3 downto 0);
      -- 8 bits de tamanho de palavra de dados:
      data: out std_logic_vector(7 downto 0)
   );
end rom;

architecture rom_arch of rom is
  type mem_tipo is array (0 to 15) of std_logic_vector(7 downto 0);
  constant mem: mem_tipo :=
    ( 0  => "00000000",
      1  => "00000001",
      2  => "00000010",
      3  => "00000011",
      4  => "00000100",
      5  => "11110000",
      6  => "00001111",
      7  => "11110000",
      8  => "11110000",
      9  => "11110000",
      10 => "11111111",
      11 => "11111111",
      12 => "11110000",
      13 => "01010101",
      14 => "10101010",
      15 => "11111111");
begin
   data <= mem(to_integer(unsigned(address)));
end rom_arch;