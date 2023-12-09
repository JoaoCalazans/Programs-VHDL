-------------------------------------------------------
--! @file ULARegs.vhd
--! @brief eu não aguento mais
--! @author João P. Calazans (joao.calazans@usp.br)
--! @date 2023-12-06
-- program on EDA Playground: https://www.edaplayground.com/x/G4Cc
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------------------------------------------
-- Agrupamento da ULA e Banco de Registradores
entity ULARegs is
    port (
        y    : out std_logic_vector (63 downto 0); -- saida da ULA
        op   : in  std_logic_vector (3 downto 0);  -- operacao a realizar
        zero : out std_logic;                      -- indica o resultado zero
        Rd   : in  std_logic_vector (4 downto 0);  -- indice do registrador a escrever
        Rm   : in  std_logic_vector (4 downto 0);  -- indice do registrador 1 (ler)
        Rn   : in  std_logic_vector (4 downto 0);  -- indice do registrador 2 (ler)
        we   : in  std_logic;                      -- habilitacao de escrita
        clk  : in  std_logic                       -- sinal de clock
    );
end entity;

architecture arch_ULARegs of ULARegs is

    component banco
        port (
            W   : in  std_logic_vector (63 downto 0);
            Ra  : out std_logic_vector (63 downto 0);
            Rb  : out std_logic_vector (63 downto 0);
            Rd  : in  std_logic_vector (4 downto 0);
            Rm  : in  std_logic_vector (4 downto 0);
            Rn  : in  std_logic_vector (4 downto 0);
            we  : in  std_logic;
            clk : in  std_logic
        );
    end component;

    component ULA
        port (
            y      : out std_logic_vector (63 downto 0);
            x1, x2 : in  std_logic_vector (63 downto 0);
            op     : in  std_logic_vector (3 downto 0);
            zero   : out std_logic
        );
    end component;
    
    signal x1_s, x2_s: std_logic_vector (63 downto 0);

begin
     
    OPERATORS: banco port map (y, x2_s, x1_s, Rd, Rm, Rn, we, clk);

    OPERATION: ULA   port map (y, x1_s, x2_s, op, zero);

end architecture;

----------------------------------------------------------------------
-- banco de registradores
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Banco de 32 Registradores de 64 bits
entity banco is
    port (
        W   : in  std_logic_vector (63 downto 0); -- valor de entrada
        Ra  : out std_logic_vector (63 downto 0); -- primeira saida
        Rb  : out std_logic_vector (63 downto 0); -- segunda saida
        Rd  : in  std_logic_vector (4 downto 0);  -- indice do registrador a escrever
        Rm  : in  std_logic_vector (4 downto 0);  -- indice do registrador 1 (ler)
        Rn  : in  std_logic_vector (4 downto 0);  -- indice do registrador 2 (ler)
        we  : in  std_logic;                      -- habilitacao de escrita
        clk : in  std_logic                       -- sinal de clock
    );
end entity;

architecture behavior of banco is

    type REGS is array (0 to 31) of std_logic_vector (63 downto 0);

    signal r: REGS := (
    -- alguns valores iniciais para teste :
        0 => x"000000000000AAAA", -- X0
        1 => x"0000000000005555", -- X1
        2 => x"0000000000003333", -- X2
        3 => x"0000000000000001", -- X3 , etc
        others => (others => '0')
    );

begin

-- saidas
    Ra <= (others => '0') when Rn = "11111" else r(to_integer(unsigned (Rn)));
    Rb <= (others => '0') when Rm = "11111" else r(to_integer(unsigned (Rm)));
-- entrada
    r(to_integer(unsigned(Rd))) <= W when (we = '1') and rising_edge (clk);

end architecture;

----------------------------------------------------------------------
-- ULA
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ULA para o LegV8
entity ULA is
    port (
        y      : out std_logic_vector (63 downto 0); -- saida
        x1, x2 : in  std_logic_vector (63 downto 0); -- entradas
        op     : in  std_logic_vector (3 downto 0);  -- operacao a realizar
        zero   : out std_logic                       -- indica o resultado zero
        );
    end entity;

architecture behavior of ULA is

    signal op_and, op_or, op_soma,
           op_sub, op_nor : std_logic_vector (63 downto 0);

begin

-- Operacoes
    op_and  <= x1 and x2;
    op_or   <= x1 or  x2;
    op_soma <= std_logic_vector (unsigned(x1) + unsigned (x2));
    op_sub  <= std_logic_vector (unsigned(x1) - unsigned (x2));
    op_nor  <= x1 nor x2;

-- selecao da saida
    with op select y <=
            op_and  when "0000", -- and
            op_or   when "0001", -- or
            op_soma when "0010", -- soma
            op_sub  when "0110", -- subtracao
            x2      when "0011", -- passa x2
            op_nor  when "1100", -- nor
            (others => '0') when others; -- outros casos

-- Verifica resultado igual a zero
    --zero <= nor y;

-- outra opcao
	zero <= '1' when unsigned (y) = 0 else '0';

end architecture;