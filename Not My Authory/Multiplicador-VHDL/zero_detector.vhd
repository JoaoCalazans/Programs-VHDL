-------------------------------------------------------
--! @file zero_detector.vhd
--! @brief zero value detector
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2020-06-15
-------------------------------------------------------
 
entity zero_detector is
  port (
    A    : in  bit_vector(3 downto 0);
    zero : out bit
    );
end entity;

architecture dataflow of zero_detector is
-- solution using a NOR gate
begin

  ZERO <= not(A(0) or A(1) or A(2) or A(3));
  
end architecture;

architecture when_else_arch of zero_detector is
-- solution using when else command
begin

  ZERO <= '1' when A = "0000" else
          '0';

end architecture;
  
architecture with_select_arch of zero_detector is
-- solution using with select command
begin

  with A select ZERO <=
    '1' when "0000",
    '0' when others;

end architecture;

