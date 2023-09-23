-------------------------------------------------------
--! @file multiplicador.vhd
--! @brief synchronous multiplier
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-08-09
-- based on previews projects by both Edson Midorikawa & Edson S. Gomi
-- program on EDA Playground: https://www.edaplayground.com/x/EvsQ
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity counter4 is
  port (
    clock, reset: in bit;
	  count: 		    in bit;
	  rco: 	        out bit;
	  cval: 	      out bit_vector(1 downto 0)
  );
end entity;

architecture simple of counter4 is
  signal internal: unsigned(1 downto 0);
begin
  process(clock, reset)
  begin
    if reset='1' then
      internal <= (others=>'0');
      rco <= '0';
    elsif (rising_edge(clock)) then
      if count='1'then
		    if (internal = "11") then
			    rco <= '1';
		    else 
			    rco <= '0';
		    end if;
		
        internal <= internal + 1;
      end if;
    end if;
  end process;
  cval <= bit_vector(internal);
  
end architecture;

-------------------------------------------------------
-------------------------------------------------------

entity fa_1bit is
  port (
    A,B : in bit;
    CIN : in bit;
    SUM : out bit;
    COUT : out bit
    );
end entity fa_1bit;

architecture wakerly of fa_1bit is
-- Solution Wakerly's Book (4th Edition, page 475)
begin
  SUM <= (A xor B) xor CIN;
  COUT <= (A and B) or (CIN and A) or (CIN and B);
end architecture wakerly;

-------------------------------------------------------

entity fa_4bit is
  port (
    A,B :  in bit_vector(3 downto 0);
    CIN :  in bit;
    SUM :  out bit_vector(3 downto 0);
    COUT : out bit
    );
end entity fa_4bit;

architecture ripple of fa_4bit is
-- Ripple adder solution
  --  Declaration of the 1 bit adder.  
  component fa_1bit
    port (
      A,B :  in bit;
      CIN :  in bit;
      SUM :  out bit;
      COUT : out bit
    );
  end component fa_1bit;

  signal x,y :   bit_vector(3 downto 0);
  signal s :     bit_vector(3 downto 0);
  signal cin0 :  bit;
  signal cin1 :  bit;
  signal cin2 :  bit;
  signal cin3 :  bit;
  signal cout0 : bit;
  signal cout1 : bit;
  signal cout2 : bit;
  signal cout3 : bit;
  
begin
  -- Components instantiation
  ADDER0: entity work.fa_1bit(wakerly) port map (
    A =>    x(0),
    B =>    y(0),
    CIN =>  cin0,
    SUM =>  s(0),
    COUT => cout0
    );

  ADDER1: entity work.fa_1bit(wakerly) port map (
    A =>    x(1),
    B =>    y(1),
    CIN =>  cout0,
    SUM =>  s(1),
    COUT => cout1
    );

  ADDER2: entity work.fa_1bit(wakerly) port map (
    A =>    x(2),
    B =>    y(2),
    CIN =>  cout1,
    SUM =>  s(2),
    COUT => cout2
    );  

  ADDER3: entity work.fa_1bit(wakerly) port map (
    A =>    x(3),
    B =>    y(3),
    CIN =>  cout2,
    SUM =>  s(3),
    COUT => cout3
    );

  x <=    A;
  y <=    B;
  cin0 <= CIN;
  SUM <=  s;
  COUT <= cout3;
  
end architecture ripple;

--------------------------------------------------
--------------------------------------------------

entity ffd is
  port (
    RESET : in bit;
    CLOCK : in bit;
    D :     in bit;
    Q :     out bit;
    Q_L :   out bit
    );
end entity ffd;

architecture behavioral of ffd is
  signal qi : bit;  
begin
    FF: process(RESET,CLOCK)
  begin
    if (RESET = '1') then
      qi <= '0';
    elsif (CLOCK'event) and (CLOCK = '1') then
      qi <= D;
    end if;
  end process FF;

  Q <= qi;
  Q_L <= not(qi);  
end architecture behavioral;

--------------------------------------------------
--------------------------------------------------

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

--------------------------------------------------
--------------------------------------------------

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

--------------------------------------------------
--------------------------------------------------

library ieee;

entity reg4 is
  port (
    clock, reset, enable: in bit;
    D: in  bit_vector(3 downto 0);
    Q: out bit_vector(3 downto 0)
  );
end entity;

architecture arch_reg4 of reg4 is
  signal dado: bit_vector(3 downto 0);
begin
  process(clock, reset)
  begin
    if reset = '1' then
      dado <= (others=>'0');
    elsif (clock'event and clock='1') then
      if enable='1' then
        dado <= D;
      end if;
    end if;
  end process;
  Q <= dado;
end architecture;

--------------------------------------------------
--------------------------------------------------

library ieee;
use ieee.numeric_bit.rising_edge;

entity regshift8 is
  port (
    clock, reset, shiftRight, load_sync, shiftBit: in bit;
    parallel_in:  in  bit_vector(3 downto 0);
    parallel_out: out bit_vector(7 downto 0)
  );
end entity;

architecture arch_reg8 of regshift8 is
  signal internal: bit_vector(7 downto 0);
begin
  process(clock)
  begin
    if (rising_edge(clock)) then
      if reset='1'then
        internal <= (others=>'0');
      elsif load_sync='1'then
        internal <= parallel_in & internal(3 downto 0);
      elsif shiftRight='1' then
        internal<= shiftBit & internal(7 downto 1);
      end if;
    end if;
  end process;
  parallel_out <= internal;
end architecture;

--------------------------------------------------
--------------------------------------------------

library ieee;
use ieee.numeric_bit.rising_edge;

entity multiplicador_fd is
  port (
    clock:      in  bit;
    Va,Vb:      in  bit_vector(3 downto 0);
    SELff:      in  bit;
    count:      in  bit;
    RSTcount:   in  bit;
    CEa, CEb:   in  bit;
    RSTa, RSTb: in bit;
    RSTr, shiftRight, load_sync: in bit;
    rco, Bj:    out bit;
    Vresult:    out bit_vector(7 downto 0)
  );
end entity;

architecture structural of multiplicador_fd is

  component reg4
    port (
      clock, reset, enable: in bit;
      D: in  bit_vector(3 downto 0);
      Q: out bit_vector(3 downto 0)
    );
  end component;

  component regshift8
    port (
      clock, reset, shiftRight, load_sync, shiftBit: in bit;
      parallel_in:  in  bit_vector(3 downto 0);
      parallel_out: out bit_vector(7 downto 0)
    );
  end component;

  component mux1_2to1
    port (
      SEL : in bit;    
      A,B : in bit;
      Y :   out bit
    );
  end component;

  component mux1_4to1
    port (
      SEL : in bit_vector(1 downto 0);    
      B :   in bit_vector(3 downto 0);
      Y :   out bit
    );
end component;

  component fa_4bit
    port (
      A,B  : in  bit_vector(3 downto 0);
      CIN  : in  bit;
      SUM  : out bit_vector(3 downto 0);
      COUT : out bit
    );
  end component;

  component ffd
    port (
      RESET : in bit;
      CLOCK : in bit;
      D :     in bit;
      Q :     out bit;
      Q_L :   out bit
    );
  end component;

  component counter4
    port (
      clock, reset: in bit;
	    count: 		    in bit;
	    rco: 	        out bit;
	    cval: 	      out bit_vector(1 downto 0)
    );
  end component;

  signal s_vaium, s_D, s_Q: bit;
  signal s_ra, s_rb, s_soma: bit_vector(3 downto 0);
  signal s_count:  bit_vector(1 downto 0);
  signal s_rr: bit_vector(7 downto 0);

begin

  RR: regshift8 port map (
      clock=>        clock, 
      reset=>        RSTr,
      shiftRight=>   shiftRight,
      load_sync=>    load_sync,
      shiftBit=>     s_Q,
      parallel_in=>  s_soma,
      parallel_out=> s_rr
     );  

  RA: reg4 port map (
      clock=>  clock, 
      reset=>  RSTa, 
      enable=> CEa,
      D=>      Va,
      Q=>      s_ra
    );

  RB: reg4 port map (
      clock=>  clock, 
      reset=>  RSTb, 
      enable=> CEb,
      D=>      Vb,
      Q=>      s_rb
    );

  SOMA: fa_4bit port map (
      A=>    s_ra,
      B=>    s_rr(7 downto 4),
      CIN=>  '0',
      SUM=>  s_soma,
      COUT=> s_vaium
    );

  MUXa: mux1_2to1 port map (
      SEL=> SELff,
      A=>   '0',
      B=>   s_vaium,
      Y=>   s_D
    );

  MUXb: mux1_4to1 port map (
      SEL=> s_count,
      B=>   s_rb,
      Y=>   Bj
    );
  
  FF: ffd port map (
      clock=>  clock, 
      reset=>  '0', 
      D=>      s_D,
      Q=>      s_Q,
      Q_L=>    open
    );

  COUNTER: counter4 port map (
      clock=>  clock, 
      reset=>  RSTcount, 
      count=>  count,
      rco=>    rco,
      cval=>   s_count
    );

  Vresult <= s_rr;
  
end architecture;

---------------------------------------------------------
---------------------------------------------------------

library ieee;

entity multiplicador_uc is
  port (
      clock:      in  bit;
      reset:      in  bit;
      start:      in  bit;
      rco, Bj:    in  bit;
      SELff:      out bit;
      count:      out bit;
      RSTcount:   out bit;
      ready:      out bit;
      CEa, CEb:   out bit;
      RSTa, RSTb: out bit;
      RSTr, shiftRight, load_sync: out bit
    );
end entity;

architecture fsm of multiplicador_uc is
  type state_t is (idle, go, adder, shift, fins);
  signal next_state, current_state: state_t;
begin
  fsm: process(clock, reset)
  begin
    if reset='1' then
      current_state <= idle;
    elsif (clock'event and clock='1') then
      current_state <= next_state;
    end if;
  end process;

  -- Logica de proximo estado
  next_state <=
    go    when (current_state = idle)  and (start = '1') else
    fins  when (current_state = go)    and (rco = '1')   else
    shift when (current_state = go)    and (Bj = '0')    else
    adder when (current_state = go)    and (Bj = '1')    else
    shift when (current_state = adder)                   else
    fins  when (current_state = shift) and (rco = '1')   else
    shift when (current_state = shift) and (Bj = '0')    else
    adder when (current_state = shift) and (Bj = '1')    else
    idle;
	  
  -- Decodifica o estado para gerar sinais de controle
  CEa        <= '1' when current_state=go    else '0';
  CEb        <= '1' when current_state=go    else '0';
  RSTa       <= '1' when current_state=idle  else '0';
  RSTb       <= '1' when current_state=idle  else '0';
  RSTr       <= '1' when current_state=go    else '0';
  SELff      <= '1' when current_state=adder else '0';
  count      <= '1' when current_state=shift else '0';
  RSTcount   <= '1' when current_state=go    else '0';
  shiftRight <= '1' when current_state=shift else '0';
  load_sync  <= '1' when current_state=adder else '0';

  -- Decodifica o estado para gerar as saídas da UC
  Ready <= '1' when current_state=fins else '0';

end architecture;

---------------------------------------------------------
---------------------------------------------------------

library ieee;
--use ieee.numeric_bit.rising_edge;

entity multiplicador_modificado is
  port (
    Clock:    in  bit;
    Reset:    in  bit;
    Start:    in  bit;
    Va,Vb:    in  bit_vector(3 downto 0);
    Vresult:  out bit_vector(7 downto 0);
    Ready:    out bit
  );
end entity;

architecture structural of multiplicador_modificado is

  component multiplicador_uc
    port (
      clock:      in  bit;
      reset:      in  bit;
      start:      in  bit;
      rco, Bj:    in  bit;
      SELff:      out bit;
      count:      out bit;
      RSTcount:   out bit;
      ready:      out bit;
      CEa, CEb:   out bit;
      RSTa, RSTb: out bit;
      RSTr, shiftRight, load_sync: out bit
    );
  end component;

  component multiplicador_fd
    port (
      clock:      in  bit;
      Va,Vb:      in  bit_vector(3 downto 0);
      SELff:      in  bit;
      count:      in  bit;
      RSTcount:   in  bit;
      CEa, CEb:   in  bit;
      RSTa, RSTb: in bit;
      RSTr, shiftRight, load_sync: in bit;
      rco, Bj:    out bit;
      Vresult:    out bit_vector(7 downto 0)
    );
  end component;

  signal s_rco, s_Bj:    bit;
  signal s_cea, s_ceb, s_rsta, s_rstb:      bit;
  signal s_rstr, s_shiftRight, s_load_sync: bit;
  signal s_SELff, s_count, s_RSTcount:      bit;

  signal s_clock_n:      bit;

begin
  
  s_clock_n <= not Clock;

  MULT_UC: multiplicador_uc port map (
      clock=>       Clock,
      reset=>       Reset,
      start=>       Start,
      CEa=>         s_cea,
      CEb=>         s_ceb,
      RSTa=>        s_rsta,
      RSTb=>        s_rstb,
      RSTr=>        s_rstr,
      shiftRight=>  s_shiftRight,
      load_sync=>   s_load_sync,
      rco=>         s_rco,
      Bj=>          s_Bj,
      SELff=>       s_SELff,
      count=>       s_count,
      RSTcount=>    s_RSTcount,
      ready=>       Ready
    );

  MULT_FD: multiplicador_fd port map (
      clock=>       s_clock_n,
      Va=>          Va,
      Vb=>          Vb,
      CEa=>         s_cea,
      CEb=>         s_ceb,
      RSTa=>        s_rsta,
      RSTb=>        s_rstb,
      RSTr=>        s_rstr,
      shiftRight=>  s_shiftRight,
      load_sync=>   s_load_sync,
      rco=>         s_rco,
      Bj=>          s_Bj,
      SELff=>       s_SELff,
      count=>       s_count,
      RSTcount=>    s_RSTcount,
      Vresult =>    Vresult
    );
  
end architecture;
