-------------------------------------------------------
--! @file romMult.vhd
--! @brief the address AB (4bits & 4bits) gives back a A*B (8bits) answer
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-23
-- avaiable on EDA throw: https://www.edaplayground.com/x/wxJW
-------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity rom is
   port (
      address: in bit_vector(7 downto 0);
      data: out bit_vector(7 downto 0)
   );
end rom;

architecture rom_arch of rom is
  type mem_tipo is array (0 to 255) of bit_vector(7 downto 0);
  constant mem: mem_tipo :=
    (0 => "00000000",
     1 => "00000000",
     2 => "00000000",
     3 => "00000000",
     4 => "00000000",
     5 => "00000000",
     6 => "00000000",
     7 => "00000000",
     8 => "00000000",
     9 => "00000000",
     10 => "00000000",
     11 => "00000000",
     12 => "00000000",
     13 => "00000000",
     14 => "00000000",
     15 => "00000000",
     16 => "00000000",
     17 => "00000001",
     18 => "00000010",
     19 => "00000011",
     20 => "00000100",
     21 => "00000101",
     22 => "00000110",
     23 => "00000111",
     24 => "00001000",
     25 => "00001001",
     26 => "00001010",
     27 => "00001011",
     28 => "00001100",
     29 => "00001101",
     30 => "00001110",
     31 => "00001111",
     32 => "00000000",
     33 => "00000010",
     34 => "00000100",
     35 => "00000110",
     36 => "00001000",
     37 => "00001010",
     38 => "00001100",
     39 => "00001110",
     40 => "00010000",
     41 => "00010010",
     42 => "00010100",
     43 => "00010110",
     44 => "00011000",
     45 => "00011010",
     46 => "00011100",
     47 => "00011110",
     48 => "00000000",
     49 => "00000011",
     50 => "00000110",
     51 => "00001001",
     52 => "00001100",
     53 => "00001111",
     54 => "00010010",
     55 => "00010101",
     56 => "00011000",
     57 => "00011011",
     58 => "00011110",
     59 => "00100001",
     60 => "00100100",
     61 => "00100111",
     62 => "00101010",
     63 => "00101101",
     64 => "00000000",
     65 => "00000100",
     66 => "00001000",
     67 => "00001100",
     68 => "00010000",
     69 => "00010100",
     70 => "00011000",
     71 => "00011100",
     72 => "00100000",
     73 => "00100100",
     74 => "00101000",
     75 => "00101100",
     76 => "00110000",
     77 => "00110100",
     78 => "00111000",
     79 => "00111100",
     80 => "00000000",
     81 => "00000101",
     82 => "00001010",
     83 => "00001111",
     84 => "00010100",
     85 => "00011001",
     86 => "00011110",
     87 => "00100011",
     88 => "00101000",
     89 => "00101101",
     90 => "00110010",
     91 => "00110111",
     92 => "00111100",
     93 => "01000001",
     94 => "01000110",
     95 => "01001011",
     96 => "00000000",
     97 => "00000110",
     98 => "00001100",
     99 => "00010010",
     100 => "00011000",
     101 => "00011110",
     102 => "00100100",
     103 => "00101010",
     104 => "00110000",
     105 => "00110110",
     106 => "00111100",
     107 => "01000010",
     108 => "01001000",
     109 => "01001110",
     110 => "01010100",
     111 => "01011010",
     112 => "00000000",
     113 => "00000111",
     114 => "00001110",
     115 => "00010101",
     116 => "00011100",
     117 => "00100011",
     118 => "00101010",
     119 => "00110001",
     120 => "00111000",
     121 => "00111111",
     122 => "01000110",
     123 => "01001101",
     124 => "01010100",
     125 => "01011011",
     126 => "01100010",
     127 => "01101001",
     128 => "00000000",
     129 => "00001000",
     130 => "00010000",
     131 => "00011000",
     132 => "00100000",
     133 => "00101000",
     134 => "00110000",
     135 => "00111000",
     136 => "01000000",
     137 => "01001000",
     138 => "01010000",
     139 => "01011000",
     140 => "01100000",
     141 => "01101000",
     142 => "01110000",
     143 => "01111000",
     144 => "00000000",
     145 => "00001001",
     146 => "00010010",
     147 => "00011011",
     148 => "00100100",
     149 => "00101101",
     150 => "00110110",
     151 => "00111111",
     152 => "01001000",
     153 => "01010001",
     154 => "01011010",
     155 => "01100011",
     156 => "01101100",
     157 => "01110101",
     158 => "01111110",
     159 => "10000111",
     160 => "00000000",
     161 => "00001010",
     162 => "00010100",
     163 => "00011110",
     164 => "00101000",
     165 => "00110010",
     166 => "00111100",
     167 => "01000110",
     168 => "01010000",
     169 => "01011010",
     170 => "01100100",
     171 => "01101110",
     172 => "01111000",
     173 => "10000010",
     174 => "10001100",
     175 => "10010110",
     176 => "00000000",
     177 => "00001011",
     178 => "00010110",
     179 => "00100001",
     180 => "00101100",
     181 => "00110111",
     182 => "01000010",
     183 => "01001101",
     184 => "01011000",
     185 => "01100011",
     186 => "01101110",
     187 => "01111001",
     188 => "10000100",
     189 => "10001111",
     190 => "10011010",
     191 => "10100101",
     192 => "00000000",
     193 => "00001100",
     194 => "00011000",
     195 => "00100100",
     196 => "00110000",
     197 => "00111100",
     198 => "01001000",
     199 => "01010100",
     200 => "01100000",
     201 => "01101100",
     202 => "01111000",
     203 => "10000100",
     204 => "10010000",
     205 => "10011100",
     206 => "10101000",
     207 => "10110100",
     208 => "00000000",
     209 => "00001101",
     210 => "00011010",
     211 => "00100111",
     212 => "00110100",
     213 => "01000001",
     214 => "01001110",
     215 => "01011011",
     216 => "01101000",
     217 => "01110101",
     218 => "10000010",
     219 => "10001111",
     220 => "10011100",
     221 => "10101001",
     222 => "10110110",
     223 => "11000011",
     224 => "00000000",
     225 => "00001110",
     226 => "00011100",
     227 => "00101010",
     228 => "00111000",
     229 => "01000110",
     230 => "01010100",
     231 => "01100010",
     232 => "01110000",
     233 => "01111110",
     234 => "10001100",
     235 => "10011010",
     236 => "10101000",
     237 => "10110110",
     238 => "11000100",
     239 => "11010010",
     240 => "00000000",
     241 => "00001111",
     242 => "00011110",
     243 => "00101101",
     244 => "00111100",
     245 => "01001011",
     246 => "01011010",
     247 => "01101001",
     248 => "01111000",
     249 => "10000111",
     250 => "10010110",
     251 => "10100101",
     252 => "10110100",
     253 => "11000011",
     254 => "11010010",
     255 => "11100001");
begin
   data <= mem(to_integer(unsigned(address)));
end rom_arch;
