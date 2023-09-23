-------------------------------------------------------
--! @file fa_8bit.vhd
--! @brief 8-bit full adder
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2020-06-15
-------------------------------------------------------
-- baseado em fa_4bit.vhd (gomi@usp.br)
-------------------------------------------------------
 
entity fa_8bit is
  port (
    A,B  : in  bit_vector(7 downto 0);
    CIN  : in  bit;
    SUM  : out bit_vector(7 downto 0);
    COUT : out bit
    );
end entity;

architecture ripple of fa_8bit is
-- Ripple adder solution

  --  Declaration of the 1-bit adder.  
  component fa_1bit
    port (
      A, B : in  bit;   -- adends
      CIN  : in  bit;   -- carry-in
      SUM  : out bit;   -- sum
      COUT : out bit    -- carry-out
    );
  end component fa_1bit;

  signal x,y :   bit_vector(7 downto 0);
  signal s :     bit_vector(7 downto 0);
  signal cin0 :  bit;
  signal cout0 : bit;  
  signal cout1 : bit;
  signal cout2 : bit;
  signal cout3 : bit;
  signal cout4 : bit;  
  signal cout5 : bit;
  signal cout6 : bit;
  signal cout7 : bit;
  
begin
  
  -- Components instantiation
  ADDER0: entity work.fa_1bit(wakerly) port map (
    A => x(0),
    B => y(0),
    CIN => cin0,
    SUM => s(0),
    COUT => cout0
    );

  ADDER1: entity work.fa_1bit(wakerly) port map (
    A => x(1),
    B => y(1),
    CIN => cout0,
    SUM => s(1),
    COUT => cout1
    );

  ADDER2: entity work.fa_1bit(wakerly) port map (
    A => x(2),
    B => y(2),
    CIN => cout1,
    SUM => s(2),
    COUT => cout2
    );  

  ADDER3: entity work.fa_1bit(wakerly) port map (
    A => x(3),
    B => y(3),
    CIN => cout2,
    SUM => s(3),
    COUT => cout3
    );

  ADDER4: entity work.fa_1bit(wakerly) port map (
    A => x(4),
    B => y(4),
    CIN => cout3,
    SUM => s(4),
    COUT => cout4
    );

  ADDER5: entity work.fa_1bit(wakerly) port map (
    A => x(5),
    B => y(5),
    CIN => cout4,
    SUM => s(5),
    COUT => cout5
    );

  ADDER6: entity work.fa_1bit(wakerly) port map (
    A => x(6),
    B => y(6),
    CIN => cout5,
    SUM => s(6),
    COUT => cout6
    );  

  ADDER7: entity work.fa_1bit(wakerly) port map (
    A => x(7),
    B => y(7),
    CIN => cout6,
    SUM => s(7),
    COUT => cout7
    );

  x <= A;
  y <= B;
  cin0 <= CIN;
  SUM <= s;
  COUT <= cout7;
  
end architecture ripple;

