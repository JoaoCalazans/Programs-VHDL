--Atividade 01
entity JogoDaVelha is --conforme fornecido no enunciado
port (
	a1, a2, a3: in bit_vector (1 downto 0);
	b1, b2, b3: in bit_vector (1 downto 0);
	c1, c2, c3: in bit_vector (1 downto 0);
	z: out bit_vector (1 downto 0));
end JogoDaVelha;

architecture winner of JogoDaVelha is --vetores auxiliares
    signal linA, linB, linC: bit_vector (1 downto 0);
    signal col1, col2, col3: bit_vector (1 downto 0);
    signal diaPri, diaSec: bit_vector (1 downto 0);
begin --os vetores inteiros verificam SE e as coordenadas QUEM [GANHOU]
	linA <= a1 and a2 and a3; --linhas A, B e C
    linB <= b1 and b2 and b3;
    linC <= c1 and c2 and c3;
    col1 <= a1 and b1 and c1; --colunas 1, 2 e 3
    col2 <= a2 and b2 and c2;
    col3 <= a3 and b3 and c3;
    diaPri <= a1 and b2 and c3; --diagonais principal e secundaria
    diaSec <= c1 and b2 and a3;
    z(0) <= linA(0) or linB(0) or linC(0) or col1(0) or col2(0) or col3(0) or diaPri(0) or diaSec(0);
    z(1) <= linA(1) or linB(1) or linC(1) or col1(1) or col2(1) or col3(1) or diaPri(1) or diaSec(1);
end winner;

--Atividade 02
entity Ajuda is --conforme fornecido no enunciado
port (
	dica, jogador : in bit;
	a1, a2, a3: in bit_vector (1 downto 0);
	b1, b2, b3: in bit_vector (1 downto 0);
	c1, c2, c3: in bit_vector (1 downto 0);
	La1, La2, La3: out bit;
	Lb1, Lb2, Lb3: out bit;
	Lc1, Lc2, Lc3: out bit);
end Ajuda;


architecture beatles of Ajuda is --Help from Beatles, got it?
    signal a1win, a2win, a3win: bit_vector (1 downto 0);
    signal b1win, b2win, b3win: bit_vector (1 downto 0);
    signal c1win, c2win, c3win: bit_vector (1 downto 0);
    signal zwin, z1, z2, z3, z4, z5, z6, z7, z8, z9: bit_vector (1 downto 0);
    component JogoDaVelha is
    	port (a1, a2, a3: in bit_vector (1 downto 0);
        	  b1, b2, b3: in bit_vector (1 downto 0);
              c1, c2, c3: in bit_vector (1 downto 0);
    		  z: out bit_vector (1 downto 0));
    end component;
begin
--verifica se ainda nao ha ganhadores
	win: JogoDaVelha port map (a1, a2, a3, b1, b2, b3, c1, c2, c3, zwin);

--jogadas possiveis
	a1win(1) <= jogador; a1win(0) <= not jogador;
    a2win(1) <= jogador; a2win(0) <= not jogador;
    a3win(1) <= jogador; a3win(0) <= not jogador;
    b1win(1) <= jogador; b1win(0) <= not jogador;
    b2win(1) <= jogador; b2win(0) <= not jogador;
    b3win(1) <= jogador; b3win(0) <= not jogador;
    c1win(1) <= jogador; c1win(0) <= not jogador;
    c2win(1) <= jogador; c2win(0) <= not jogador;
    c3win(1) <= jogador; c3win(0) <= not jogador;

--testando as jogadas possiveis
    w1: JogoDaVelha port map (a1win, a2, a3, b1, b2, b3, c1, c2, c3, z1);
    w2: JogoDaVelha port map (a1, a2win, a3, b1, b2, b3, c1, c2, c3, z2);
    w3: JogoDaVelha port map (a1, a2, a3win, b1, b2, b3, c1, c2, c3, z3);
    w4: JogoDaVelha port map (a1, a2, a3, b1win, b2, b3, c1, c2, c3, z4);
    w5: JogoDaVelha port map (a1, a2, a3, b1, b2win, b3, c1, c2, c3, z5);
    w6: JogoDaVelha port map (a1, a2, a3, b1, b2, b3win, c1, c2, c3, z6);
    w7: JogoDaVelha port map (a1, a2, a3, b1, b2, b3, c1win, c2, c3, z7);
    w8: JogoDaVelha port map (a1, a2, a3, b1, b2, b3, c1, c2win, c3, z8);
    w9: JogoDaVelha port map (a1, a2, a3, b1, b2, b3, c1, c2, c3win, z9);

--ligando os leds
    La1 <= '1' when z1 = a1win and a1 = "00" and zwin = "00" and dica = '1' else '0';
    La2 <= '1' when z2 = a2win and a2 = "00" and zwin = "00" and dica = '1' else '0';
    La3 <= '1' when z3 = a3win and a3 = "00" and zwin = "00" and dica = '1' else '0';
    Lb1 <= '1' when z4 = b1win and b1 = "00" and zwin = "00" and dica = '1' else '0';
    Lb2 <= '1' when z5 = b2win and b2 = "00" and zwin = "00" and dica = '1' else '0';
    Lb3 <= '1' when z6 = b3win and b3 = "00" and zwin = "00" and dica = '1' else '0';
    Lc1 <= '1' when z7 = c1win and c1 = "00" and zwin = "00" and dica = '1' else '0';
    Lc2 <= '1' when z8 = c2win and c2 = "00" and zwin = "00" and dica = '1' else '0';
    Lc3 <= '1' when z9 = c3win and c3 = "00" and zwin = "00" and dica = '1' else '0';
end beatles;

--Atividade 03
entity hamming is
    port (
        entrada: in bit_vector (13 downto 1);
        dados: out bit_vector (8 downto 0));
    end hamming;
    
    architecture correction of hamming is
        signal error: bit_vector(3 downto 0);
    begin --posicao do erro
        error(0) <= entrada(3) xor entrada(5) xor entrada(7) xor entrada(9) xor entrada(11) xor entrada(13) xor entrada(1);
        error(1) <= entrada(3) xor entrada(6) xor entrada(7) xor entrada(10) xor entrada(11) xor entrada(2);
        error(2) <= entrada(5) xor entrada(6) xor entrada(7) xor entrada(12) xor entrada(13) xor entrada(4);
        error(3) <= entrada(9) xor entrada(10) xor entrada(11) xor entrada(12) xor entrada(13) xor entrada(8);
        
    --corrigindo
        dados(8) <= not entrada(13) when error = "1101" else entrada(13);
        dados(7) <= not entrada(12) when error = "1100" else entrada(12);
        dados(6) <= not entrada(11) when error = "1011" else entrada(11);
        dados(5) <= not entrada(10) when error = "1010" else entrada(10);
        dados(4) <= not entrada(9) when error = "1001" else entrada(9);
        dados(3) <= not entrada(7) when error = "0111" else entrada(7);
        dados(2) <= not entrada(6) when error = "0110" else entrada(6);
        dados(1) <= not entrada(5) when error = "0101" else entrada(5);
        dados(0) <= not entrada(3) when error = "0011" else entrada(3);
    end correction;