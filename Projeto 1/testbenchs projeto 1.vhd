--Atividade 01
entity testbench is
    end testbench;
        
architecture teste of testbench is
            
    component JogoDaVelha is
        port (
            a1, a2, a3 : in bit_vector (1 downto 0);
            b1, b2, b3 : in bit_vector (1 downto 0);
            c1, c2, c3 : in bit_vector (1 downto 0);
            z : out bit_vector (1 downto 0)
        );
    end component;
            
    signal a1_in, a2_in, a3_in : bit_vector (1 downto 0);
    signal b1_in, b2_in, b3_in : bit_vector (1 downto 0);
    signal c1_in, c2_in, c3_in : bit_vector (1 downto 0);
    signal z_out : bit_vector (1 downto 0);
        
begin
    t1 : JogoDaVelha
    port map (
        a1 => a1_in, a2 => a2_in, a3 => a3_in,
        b1 => b1_in, b2 => b2_in, b3 => b3_in,
        c1 => c1_in, c2 => c2_in, c3 => c3_in,
        z => z_out
    ); 

    stimulus: process
    begin
        a1_in <= "01";
        a2_in <= "01";
        a3_in <= "01";
        b1_in <= "01";
        b2_in <= "01";
        b3_in <= "01";
        c1_in <= "01";
        c2_in <= "01";            
        c3_in <= "01";
        wait;
    end process stimulus;

end architecture teste;

--Atividade 02
entity testbench is
    end testbench;
        
architecture teste of testbench is  
    component Ajuda is
        port (
            dica, jogador : in bit;
            a1, a2, a3 : in bit_vector (1 downto 0);
            b1, b2, b3 : in bit_vector (1 downto 0);
            c1, c2, c3 : in bit_vector (1 downto 0);
            La1, La2, La3 : out bit;
            Lb1, Lb2, Lb3 : out bit;
            Lc1, Lc2, Lc3 : out bit
        );
    end component;
            
    signal dica_in, jogador_in : bit;
    signal a1_in, a2_in, a3_in : bit_vector (1 downto 0);
    signal b1_in, b2_in, b3_in : bit_vector (1 downto 0);
    signal c1_in, c2_in, c3_in : bit_vector (1 downto 0);
    signal La1_out, La2_out, La3_out :  bit;
    signal Lb1_out, Lb2_out, Lb3_out :  bit;
    signal Lc1_out, Lc2_out, Lc3_out :  bit;
                        
begin
    t2 : Ajuda
    port map (
        dica => dica_in, jogador => jogador_in,
        a1 => a1_in, a2 => a2_in, a3 => a3_in,
        b1 => b1_in, b2 => b2_in, b3 => b3_in,
        c1 => c1_in, c2 => c2_in, c3 => c3_in,
        La1 => La1_out, La2 => La2_out, La3 => La3_out,
        Lb1 => Lb1_out, Lb2 => Lb2_out, Lb3 => Lb3_out,
        Lc1 => Lc1_out, Lc2 => Lc2_out, Lc3 => Lc3_out
    ); 

    stimulus: process
    begin
        dica_in <= '1';
        jogador_in <= '1';
        a1_in <= "10";
        a2_in <= "10";
        a3_in <= "00";
        b1_in <= "00";
        b2_in <= "00";
        b3_in <= "00";
        c1_in <= "00";
        c2_in <= "00";            
        c3_in <= "00";
        wait;
    end process stimulus;

end architecture teste;

--Atividade 03
entity testbench is
    end testbench;
        
    architecture teste of testbench is
            
        component hamming is
            port (
                entrada : in bit_vector (13 downto 1);
                dados : out bit_vector (8 downto 0)
            );
        end component;
            
        signal entrada_in: bit_vector (13 downto 1);
        signal dados_out: bit_vector (8 downto 0);
        
    begin
        t3 : hamming
        port map (
            entrada => entrada_in,
            dados => dados_out
        ); 
    
        stimulus: process
        begin
            entrada_in <= "1010100100101";
            wait;
        end process stimulus;
    
    end architecture teste;