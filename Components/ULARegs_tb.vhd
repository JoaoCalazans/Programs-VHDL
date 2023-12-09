-------------------------------------------------------
--! @file ULARegs_tb.vhd
--! @brief testbench for ULARegs
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-12-06
-- program on EDA Playground: https://www.edaplayground.com/x/G4Cc
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_bit.all;

entity testbench is
end entity;

architecture tb of testbench is

  component ULARegs
      port (
      y    : out std_logic_vector (63 downto 0); -- saida da ULA
      op   : in  std_logic_vector (3 downto 0);  -- operacao a realizar
      zero : out std_logic ;                     -- indica o resultado zero
      Rd   : in  std_logic_vector (4 downto 0);  -- indice do registrador a escrever
      Rm   : in  std_logic_vector (4 downto 0);  -- indice do registrador 1 (ler)
      Rn   : in  std_logic_vector (4 downto 0);  -- indice do registrador 2 (ler)
      we   : in  std_logic ;                     -- habilitacao de escrita
      clk  : in  std_logic                       -- sinal de clock
      );
  end component;

  signal clk_in, we_in, zero_out : std_logic := '0';
  signal op_in : std_logic_vector (3 downto 0);
  signal Rd_in, Rm_in, Rn_in : std_logic_vector (4 downto 0);
  signal y_out : std_logic_vector (63 downto 0);

  signal keep_simulating : std_logic := '0';
  constant clockPeriod   : time := 1 ns;
  
begin
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

  dut: ULARegs
       port map(y    => y_out,
                op   => op_in,
                zero => zero_out,
                Rd   => Rd_in,
                Rm   => Rm_in,
                Rn   => Rn_in,
                we   => we_in,
                clk  => clk_in
      );

  stimulus: process is
  
         type pattern_type is record
          pos1: std_logic; -- we
          pos2: std_logic; -- zero
          pos3: std_logic_vector (3 downto 0);  -- op
          pos4: std_logic_vector (4 downto 0);  -- Rd
          pos5: std_logic_vector (4 downto 0);  -- Rm
          pos6: std_logic_vector (4 downto 0);  -- Rn
          pos7: std_logic_vector (63 downto 0); -- y
       end record;
       
       type pattern_array is array (natural range <>) of pattern_type;
       
       constant patterns: pattern_array :=
--        (we(1), zero(1), op(4), Rd(5), Rm(5), Rn(5), y(x16))
          -- testes gerais, de escrita, X31=0 e zero_out...
          (('1', '0', "0011", "00100", "00010", "00000", x"000000000000AAAA"), -- t1
          ('0', '0', "0010", "00100", "00100", "11111", x"000000000000AAAA"),  -- t2
          ('0', '0', "0010", "00001", "11111", "00001", x"0000000000005555"),  -- t3
          ('0', '1', "0001", "11011", "11111", "11111", x"0000000000000000"),  -- t4
          ------------------------------------------------------------------
          -- testanto todas as instruções (x1 OPERAÇÂO x2 -> x3)...
          ('0', '0', "0000", "00011", "00001", "00010", x"0000000000001111"),  -- t5
          ('0', '0', "0001", "00011", "00001", "00010", x"0000000000007777"),  -- t6
          ('0', '0', "0010", "00011", "00001", "00010", x"0000000000008888"),  -- t7
          ('0', '0', "0110", "00011", "00001", "00010", x"0000000000002222"),  -- t8
          ('0', '0', "0011", "00011", "00001", "00010", x"0000000000003333"),  -- t9
          ('0', '0', "1100", "00011", "00001", "00010", x"FFFFFFFFFFFF8888")); -- t10
  
  begin
  
    assert false report "simulation start" severity note;
    keep_simulating <= '1';

       for i in patterns'range loop
       
          we_in <= patterns(i).pos1;
          op_in <= patterns(i).pos3;
          Rd_in <= patterns(i).pos4;
          Rm_in <= patterns(i).pos5;
          Rn_in <= patterns(i).pos6;
          wait for clockPeriod;
          
          assert y_out = patterns(i).pos7 report "Teste " & integer'image(i+1) & ": Erro" severity error;
          assert y_out /= patterns(i).pos7 report "Teste " & integer'image(i+1) & ": Confere" severity note;
          assert zero_out = patterns(i).pos2 report "        Erro no zero" severity error;
          assert zero_out /= patterns(i).pos2 report "        Zero confere" severity note;
       end loop;
    
    assert false report "simulation end" severity note;
    keep_simulating <= '0';
    wait; 
  end process;

end architecture;