-------------------------------------------------------
--! @file RegShiftN.vhd
--! @brief https://www.youtube.com/watch?v=-62YbRZqxjs&ab
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-09-18
-- Avaiable on EDA PLayground throw: https://www.edaplayground.com/x/WpQN
-------------------------------------------------------
library ieee;
use ieee.numeric_bit.rising_edge;

entity regshiftN is
  generic (
    constant N : integer  := 15;
    constant M : integer  := 15
    -- where N represents in-signal module and M out-signal bits
    -- if N > M, then in-signal LSBs is selected for convenience
  );
  port (
    clock, reset, shiftRight, load_sync, shiftBit: in bit;
    parallel_in:  in  bit_vector(N-1 downto 0);
    parallel_out: out bit_vector(M-1 downto 0)
  );
end entity;

architecture arch_reg of regshiftN is
  signal internal: bit_vector(M-1 downto 0);
begin
  process(clock)
  begin
    if reset = '1' then
      internal <= (others=>'0');
    elsif rising_edge(clock) then
        if (load_sync = '1') then
            if (M > N) then
                internal <= internal(M-1 downto N) & parallel_in(N-1 downto 0);
            elsif (N > M) then
                internal <= parallel_in(M-1 downto 0); -- LSBs
            else
                internal <= parallel_in;
            end if;
         elsif shiftRight = '1' then -- notice it only shift when load = 0
             internal <= shiftBit & internal(M-1 downto 1);
         end if;
    end if;
  end process;
  parallel_out <= internal;
end architecture;
