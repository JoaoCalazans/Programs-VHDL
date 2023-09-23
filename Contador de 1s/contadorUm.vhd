-------------------------------------------------------
--! @file contadorUm.vhd
--! @brief bits 1 counter on 15 bit in-data
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-09-20
-- program on EDA Playground: https://www.edaplayground.com/x/AMn2
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity contador4 is
  port (
    clock : in  bit;
    zera  : in  bit;
	  conta : in  bit;
    Q     : out bit_vector(3 downto 0);
	  fim   : out bit
  );
end entity;

architecture simple of contador4 is
  signal internal: unsigned(3 downto 0);
begin
  process(clock, zera)
  begin
    if (rising_edge(clock)) then
        if zera = '1' then
          internal <= (others=>'0');
          fim  <= '0';
        elsif conta = '1' then
		    if (internal = "1111") then
			  fim  <= '1';
		    else
			  fim  <= '0';
		    end if;
          internal <= internal + 1;
        end if;
    end if;
  end process;
  Q <= bit_vector(internal);

end architecture;

----------------------------------------------------------------------

library ieee;
use ieee.numeric_bit.rising_edge;

entity deslocador15 is
  port (
    clock   : in  bit;
    limpa   : in  bit;
    carrega : in  bit;
    desloca : in  bit;
    entrada : in  bit;
    dados   : in  bit_vector(14 downto 0);
    saida   : out bit_vector(14 downto 0)
  );
end entity deslocador15;

architecture arch_reg15 of deslocador15 is
  signal internal: bit_vector(14 downto 0);
begin
    process(clock)
    begin
      if (rising_edge(clock)) then
        if limpa = '1' then
          internal <= (others=>'0');
        elsif carrega = '1' then
          internal <= dados;
        elsif desloca = '1' then
          internal <= entrada & internal(14 downto 1);
        end if;
      end if;
    end process;
  saida <= internal;
end architecture;

----------------------------------------------------------------------

library ieee;
use ieee.numeric_bit.rising_edge;

entity onescounter_fd is
  port (
    clock   : in  bit;
    reset   : in  bit;
    inport  : in  bit_vector(14 downto 0);
    zera    : in  bit;
    conta   : in  bit;
    carrega : in  bit;
    desloca : in  bit;
    outport : out bit_vector(3 downto 0);
    data0   : out bit;
    zero    : out bit
  );
end entity;

architecture structural of onescounter_fd is

  component contador4
    port (
      clock : in  bit;
      zera  : in  bit;
      conta : in  bit;
      Q     : out bit_vector(3 downto 0);
      fim   : out bit
    );
    end component;

  component deslocador15
    port (
      clock   : in  bit;
      limpa   : in  bit;
      carrega : in  bit;
      desloca : in  bit;
      entrada : in  bit;
      dados   : in  bit_vector(14 downto 0);
      saida   : out bit_vector(14 downto 0)
    );
    end component;

  signal s_reg: bit_vector(14 downto 0);

begin

  COUNTER: contador4 port map (
      clock  => clock,
      zera   => zera,
      conta  => conta,
      Q      => outport,
      fim    => open
    );

  SHIFT_REG: deslocador15 port map (
      clock   => clock, 
      limpa   => reset,
      carrega => carrega,
      desloca => desloca,
      entrada => '0',
      dados   => inport,
      saida   => s_reg
   );

  data0 <= s_reg(0);
  zero  <= '1' when s_reg = "000000000000000" else '0';
  
end architecture;

----------------------------------------------------------------------

library ieee;

entity onescounter_uc is
  port (
    clock   : in  bit;
    reset   : in  bit;
    start   : in  bit;
    data0   : in  bit;
    zero    : in  bit;
    zera    : out bit;
    conta   : out bit;
    carrega : out bit;
    desloca : out bit;
    done    : out bit
  );
end entity;

architecture fsm of onescounter_uc is
  type state_t is (idle, load, go, count, shift, fins);
  signal next_state, current_state: state_t;
begin
  fsm: process(clock, reset)
  begin
    if reset = '1' then
      current_state <= idle;
    elsif (clock'event and clock = '1') then
      current_state <= next_state;
    end if;
  end process;

  next_state <=
    load  when (current_state = idle)  and (start = '1') else
    go    when (current_state = load)                    else
    count when (current_state = go)    and (data0 = '1') else
    shift when (current_state = go)    and (data0 = '0') else
    shift when (current_state = count)                   else
    go    when (current_state = shift) and (zero = '0')  else
    fins  when (current_state = shift) and (zero = '1')  else
    idle;

  zera    <= '1' when current_state = load  else '0';
  carrega <= '1' when current_state = load  else '0';
  conta   <= '1' when current_state = count else '0';
  desloca <= '1' when current_state = shift else '0';

  done    <= '1' when current_state = fins  else '0';

end architecture;

----------------------------------------------------------------------

library ieee;
use ieee.numeric_bit.rising_edge;

entity onescounter is
  port (
    clock   : in  bit;
    reset   : in  bit;
    start   : in  bit;
    inport  : in  bit_vector (14 downto 0);
    outport : out bit_vector (3 downto 0);
    done    : out bit
  );
end entity;

architecture structural of onescounter is

  component onescounter_uc
  port (
    clock   : in  bit;
    reset   : in  bit;
    start   : in  bit;
    data0   : in  bit;
    zero    : in  bit;
    zera    : out bit;
    conta   : out bit;
    carrega : out bit;
    desloca : out bit;
    done    : out bit
  );
  end component;

  component onescounter_fd
  port (
    clock   : in  bit;
    reset   : in  bit;
    inport  : in  bit_vector(14 downto 0);
    zera    : in  bit;
    conta   : in  bit;
    carrega : in  bit;
    desloca : in  bit;
    outport : out bit_vector(3 downto 0);
    data0   : out bit;
    zero    : out bit
    );
  end component;

  signal s_data0   : bit;
  signal s_zero    : bit;
  signal s_zera    : bit;
  signal s_conta   : bit;
  signal s_carrega : bit;
  signal s_desloca : bit;
  signal s_clock_n : bit;

begin
  
  s_clock_n <= not Clock;

  COUNTER_UC: onescounter_uc port map (
    clock   => Clock,
    reset   => Reset,
    start   => start,
    data0   => s_data0,
    zero    => s_zero,
    zera    => s_zera,
    conta   => s_conta,
    carrega => s_carrega,
    desloca => s_desloca,
    done    => done
  );

  COUNTER_FD: onescounter_fd port map (
    clock   => s_clock_n,
    reset   => reset,
    inport  => inport,
    zera    => s_zera,
    conta   => s_conta,
    carrega => s_carrega,
    desloca => s_desloca,
    outport => outport,
    data0   => s_data0,
    zero    => s_zero
  );
  
end architecture;
