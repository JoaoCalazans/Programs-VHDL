-------------------------------------------------------
--! @file fa_1bit.vhd
--! @brief 1-bit full adder
--! @author Edson S. Gomi (gomi@usp.br)
--! @date 2020-03-21
-------------------------------------------------------
 
entity fa_1bit is
  port (
    A,B : in bit;       -- adends
    CIN : in bit;       -- carry-in
    SUM : out bit;      -- sum
    COUT : out bit      -- carry-out
    );
end entity fa_1bit;

architecture sum_minterm of fa_1bit is
-- Canonical sum solution (sum of minterms)
begin
  -- SUM = m1 + m2 + m4 + m7
  SUM <= (not(CIN) and not(A) and B) or
         (not(CIN) and A and not(B)) or
         (CIN and not(A) and not(B)) or
         (CIN and A and B);
  -- COUT = m3 + m5 + m6 + m7
  COUT <= (not(CIN) and A and B) or
          (CIN and not(A) and B) or
          (CIN and A and not(B)) or
          (CIN and A and B);
end architecture sum_minterm;

architecture product_maxterm of fa_1bit is
-- Canonical product solution (product of maxterms)
begin
  -- SUM = M0 . M3 . M5 . M6
  SUM <= (CIN or A or B) and
         (CIN or not(A) or not(B)) and
         (not(CIN) or A or not(B)) and
         (not(CIN) or not(A) or B);

  -- COUT = M0 . M1 . M2 . M4
  COUT <= (CIN or A or B) and
         (CIN or A or not(B)) and
         (CIN or not(A) or B) and
         (not(CIN) or A or B);
end architecture product_maxterm;
  
architecture wakerly of fa_1bit is
-- Solution Wakerly's Book (4th Edition, page 475)
begin
  SUM <= (A xor B) xor CIN;
  COUT <= (A and B) or (CIN and A) or (CIN and B);
end architecture wakerly;

architecture bug1 of fa_1bit is
-- Canonical sum solution with bug
begin
  -- SUM = m1 + m2 + m4 + m7
  SUM <= (CIN and not(A) and B) or
         (not(CIN) and A and not(B)) or
         (CIN and not(A) and not(B)) or
         (CIN and A and B);
  -- COUT = m3 + m5 + m6 + m7
  COUT <= (not(CIN) and A and B) or
          (CIN and not(A) and B) or
          (CIN and A and not(B)) or
          (CIN and A and B);
end architecture bug1;

architecture bug2 of fa_1bit is
-- Canonical product solution with bug
begin
  -- SUM = M0 . M3 . M5 . M6
  SUM <= (CIN or A or B) and
         (CIN or not(A) or not(B)) and
         (not(CIN) or A or not(B)) and
         (not(CIN) or not(A) or B);

  -- COUT = M0 . M1 . M2 . M4
  COUT <= (CIN or A or B) and
         (CIN or A or not(B)) and
         (CIN or not(A) or not(B)) and
         (not(CIN) or A or B);
end architecture bug2;
