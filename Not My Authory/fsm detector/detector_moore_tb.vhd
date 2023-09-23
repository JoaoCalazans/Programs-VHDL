-------------------------------------------------------
--! @file detector_moore_tb.vhd
--! @brief Testbench para o detector Modelo Moore
--! @author Edson S. Gomi (gomi@usp.br)
--! @date 2020-05-12
-------------------------------------------------------

--  A testbench has no ports.
entity detector_moore_tb is
end entity detector_moore_tb;

architecture testbench of detector_moore_tb is

  --  Declaration of the component to be tested.  
  component detector_moore
    port (
      RESET : in bit;
      CLOCK : in bit;
      X : in bit;
      Z : out bit
      );
  end component detector_moore;
  
  -- Declaration of signals
  signal reset : bit;
  signal clock : bit;  
  signal x : bit;
  signal z : bit;

begin
  -- Component instantiation
  -- DUT = Device Under Test 
  DUT: entity work.detector_moore port map (reset,clock,x,z);

  -- Clock generator
  clk: process is
  begin
    clock <= '0';
    wait for 0.5 ns;
    clock <= '1';
    wait for 0.5 ns;
  end process clk;  

  --  This process does the real job.
  stimulus_process: process is
    type pattern_type is record
      --  The inputs of the circuit.
      reset : bit;
      x : bit;
      
      --  The expected outputs of the circuit.
      z : bit;
    end record;

    --  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (
        ('1','0','0'),
        ('0','0','0'),
        ('0','1','0'),
        ('0','0','0'),
        ('0','1','0'),
        ('0','1','0'),
        ('0','0','1'),
        ('0','0','0'),
        ('0','1','0'),
        ('0','1','0'),
        ('0','1','0'),
        ('0','0','1'),
        ('0','1','0'),
        ('0','0','0'),
        ('0','0','0'),
        ('0','0','0'));
        
  begin
    --  Check each pattern.
    for k in patterns'range loop
      --  Set the inputs.      
      reset <= patterns(k).reset;
      x <= patterns(k).x;
      
      --  Wait for the results.
      wait for 1 ns;
      
      --  Check the outputs.
      assert z = patterns(k).z
        report "bad z" severity error;
    end loop;
    
    assert false report "end of test" severity note;
    
  --  Wait forever; this will finish the simulation.
    wait;
  end process;
  
end architecture testbench;
  

