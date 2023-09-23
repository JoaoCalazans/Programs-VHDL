-------------------------------------------------------
--! @file contadorUmTestbench.vhd
--! @brief testbench for synchronous bits 1 counter
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-09-21
-- program on EDA Playground: https://www.edaplayground.com/x/AMn2
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity testbench is
end entity;

architecture tb of testbench is

  component onescounter
  port (
    clock   : in  bit;
    reset   : in  bit;
    start   : in  bit;
    inport  : in  bit_vector (14 downto 0);
    outport : out bit_vector (3 downto 0);
    done    : out bit
  );
  end component;

  signal clk_in, rst_in     : bit := '0';
  signal start_in, done_out : bit := '0';
  signal inport_in          : bit_vector(14 downto 0);
  signal outport_out        : bit_vector(3 downto 0);

  signal keep_simulating : bit := '0';
  constant clockPeriod   : time := 1 ns;
  
begin
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

  dut: onescounter
    port map (
      clock   => clk_in,
      reset   => rst_in,
      start   => start_in,
      inport  => inport_in,
      outport => outport_out,
      done    => done_out
    );

    stimulus: process is
      variable num : integer := 0;
  
      file tb_file : text open read_mode is "contadorUmTestbench.dat";
      variable tb_line : line;
      variable space   : character;
      variable op1     : bit_vector(14 downto 0);
      variable op2     : bit_vector(3 downto 0);
         
   begin
      assert false report "simulation start" severity note;
      keep_simulating <= '1';
  
      while not endfile(tb_file) loop
        readline(tb_file, tb_line);
        read(tb_line, op1);
        read(tb_line, space);
        read(tb_line, op2);
  
        inport_in <= op1;
        rst_in <= '1'; start_in <= '0';
        wait for clockPeriod;
        rst_in <= '0';
        wait until falling_edge(clk_in);
        start_in <= '1';
        wait until falling_edge(clk_in);
        start_in <= '0';
        wait until done_out = '1';
        num := num + 1;
        
        assert outport_out /= op2 report "Teste OK" severity note;
        assert outport_out = op2 report "Erro no teste " & integer'image(num) & ". Valor obtido: " & integer'image(to_integer(unsigned(outport_out))) severity note;
      end loop;

      assert false report "simulation end" severity note;
      keep_simulating <= '0';
    
    wait;
  end process;

end architecture;