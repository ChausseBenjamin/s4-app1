library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AppCombi_top_tb is
end AppCombi_top_tb;

architecture Behavioral of AppCombi_top_tb is

  component AppCombi_top port (
    i_btn     : in  std_logic_vector (3 downto 0);
    i_sw      : in  std_logic_vector (3 downto 0);
    sysclk    : in  std_logic;
    o_SSD     : out std_logic_vector (7 downto 0);
    o_led     : out std_logic_vector (3 downto 0);
    o_led6_r  : out std_logic;
    o_pmodled : out std_logic_vector (7 downto 0);
    ADCth     : out std_logic_vector (11 downto 0);
    DEL2      : out std_logic;
    DEL3      : out std_logic;
    S1        : in  std_logic;
    S2        : in  std_logic
  );
  end component;

  -- Clock period
  constant sysclk_Period : time := 8 ns;

  -- Input signals
  signal clk_sim         : std_logic := '1';
  signal sw_sim          : std_logic_vector(3 downto 0) := (others => '0');
  signal btn_sim         : std_logic_vector(3 downto 0) := (others => '0');
  signal button_s1_sim   : std_logic := '0';
  signal button_s2_sim   : std_logic := '0';

  -- Output signals
  signal SSD_sim         : std_logic_vector(7 downto 0) := "00000000";
  signal led_sim         : std_logic_vector(3 downto 0) := "0000";
  signal led6_r_sim      : std_logic := '0';
  signal pmodled_sim     : std_logic_vector(7 downto 0) := "00000000";
  signal ADCth_sim       : std_logic_vector(11 downto 0) := "000000000000";
  signal DEL2_sim        : std_logic := '0';
  signal DEL3_sim        : std_logic := '0';
  
  signal expected_DEL2   : std_logic := '0';
  signal expected_DEL3   : std_logic := '0';
  signal expected_led6_r_sim  : std_logic := '0';
  signal expected_ssd_sim  : std_logic_vector(7 downto 0) := "00000000";
  signal expected_led_sim : std_logic_vector(3 downto 0) := "0000";

  -- Test vector: btn & sw & S1 & S2 & led & SSD & led6_r & pmodled & ADCth & DEL2 & DEL3
  -- bit widths:  4   + 4 +  1  +  1  +  4  +  8  +   1     +   8     +  12   +  1   +  1  = 55 bits
  type table_valeurs_tests is array (integer range 0 to 4) of std_logic_vector(44 downto 0);
  constant mem_valeurs_tests : table_valeurs_tests := (
    -- btn  sw     s1s2    led      SSD   led6_r           pmod      ADCth   DEL2 DEL3
    "0000"&"0000"&"0"&"0"&"0001"&"00000000"&"0"&"00000001"&"000000000000"&"1"&"0", -- pmoled
    "0000"&"0000"&"0"&"0"&"0001"&"00000000"&"0"&"10000000"&"111111111111"&"1"&"0",
    
    "0000"&"0000"&"1"&"0"&"0000"&"00000000"&"0"&"00000001"&"000000000000"&"0"&"0", -- parite inverse avec bouton
    "0000"&"0000"&"1"&"0"&"0000"&"00000000"&"0"&"10000000"&"111111111111"&"0"&"0",
    "0000"&"0000"&"0"&"0"&"0000"&"00000000"&"0"&"01000000"&"011111111111"&"0"&"0",
    
    others => "0000"&"0000"&"0"&"0"&"0000"&"00000000"&"0"&"00000000"&"000000000000"&"0"&"0"
  );

begin

  -- Instantiate DUT
  uut: AppCombi_top port map (
    i_btn       => btn_sim,
    i_sw        => sw_sim,
    sysclk      => clk_sim,
    o_SSD       => SSD_sim,
    o_led       => led_sim,
    o_led6_r    => led6_r_sim,
    o_pmodled   => pmodled_sim,
    ADCth       => ADCth_sim,
    DEL2        => DEL2_sim,
    DEL3        => DEL3_sim,
    S1          => button_s1_sim,
    S2          => button_s2_sim
  );

  -- Clock generation
  clk_process : process
  begin
    clk_sim <= '1';
    loop
      wait for sysclk_Period / 2;
      clk_sim <= not clk_sim;
    end loop;
  end process;

  -- Test bench logic
  tb : process
    variable delai_sim : time := 50 ns;
    variable v : std_logic_vector(44 downto 0);
  begin
    for i in 0 to mem_valeurs_tests'length - 1 loop
      v := mem_valeurs_tests(i);

      -- Inputs
      btn_sim        <= v(44 downto 41);
      sw_sim         <= v(40 downto 37);
      button_s1_sim  <= v(36);
      button_s2_sim  <= v(35);
      ADCth_sim      <= v(13 downto 2);
      expected_DEL2  <= v(1);
      expected_DEL3  <= v(0);
      expected_led6_r_sim <= v(22);
      expected_ssd_sim <= v(30 downto 23);
      expected_led_sim <= v(34 downto 31);

      -- Expected outputs
      wait for delai_sim;
        
        assert led_sim(0) = expected_led_sim(0)
            report "Test " & integer'image(i) &
                " - LED mismatch. Got: '" & std_logic'image(led_sim(0)) &
                "', Expected: '" & std_logic'image(expected_led_sim(0)) & "'"
        severity warning;

        --assert SSD_sim = expected_ssd_sim
        --    report "Test " & integer'image(i) &
        --        " - SSD mismatch. Got: " & integer'image(to_integer(unsigned(SSD_sim))) &
        --        ", Expected: " & integer'image(to_integer(unsigned(expected_ssd_sim)))
        --severity warning;

       --assert led6_r_sim = expected_led6_r_sim
       --     report "Test " & integer'image(i) &
       --         " - LED6_R mismatch. Got: '" & std_logic'image(led6_r_sim) &
       --         "', Expected: '" & std_logic'image(v(22)) & "'"
       --severity warning;

        assert pmodled_sim = v(21 downto 14)
            report "Test " & integer'image(i) &
                " - PMOD LED mismatch. Got: " & integer'image(to_integer(unsigned(pmodled_sim))) &
                ", Expected: " & integer'image(to_integer(unsigned(v(21 downto 14)))) &
                ", FROM ADC: " & integer'image(to_integer(unsigned(ADCth_sim)))
        severity warning;

        assert DEL2_sim = expected_DEL2
            report "Test " & integer'image(i) &
                " - DEL2 mismatch. Got: '" & std_logic'image(DEL2_sim) &
                "', Expected: '" & std_logic'image(v(1)) & "'"
        severity warning;

        assert DEL3_sim = expected_DEL3
            report "Test " & integer'image(i) &
                " - DEL3 mismatch. Got: '" & std_logic'image(DEL3_sim) &
                "', Expected: '" & std_logic'image(v(0)) & "'"
        severity warning;
    end loop;
    wait;
  end process;

end Behavioral;
