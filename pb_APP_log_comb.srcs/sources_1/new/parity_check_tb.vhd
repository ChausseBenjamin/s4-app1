----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/03/2025 07:14:35 PM
-- Design Name:
-- Module Name: Decodeur_3_8_tb - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Parity_check_tb is
end Parity_check_tb;

architecture Behavioral of Parity_check_tb is

  component parity_check port (
    ADCbin : in  STD_LOGIC_VECTOR (3 downto 0);
    S1     : in  STD_LOGIC;
    Parite : out STD_LOGIC);
  end component;

  signal input_bits_sim : STD_LOGIC_VECTOR (3 downto 0);
  signal input_cfg_sim  : STD_LOGIC;
  signal output_buffer  : STD_LOGIC;
  signal expected       : STD_LOGIC;

  ----------------------------------------------------------------------------
  -- Test bench usage signals
  ----------------------------------------------------------------------------
  constant sysclk_Period    : time := 8 ns;
  signal   clk_sim          : STD_LOGIC := '0';
  signal   vecteur_test_sim : STD_LOGIC_VECTOR(5 downto 0) := "000000" ;

  ----------------------------------------------------------------------------
  -- declaration d'un tableau pour soumettre un vecteur de test
  ----------------------------------------------------------------------------
  constant parity_test_count: integer := 16;
  type parity_test_table is array (integer range 0 to parity_test_count) of STD_LOGIC_VECTOR(5 downto 0);
      constant parity_test_values : parity_test_table := (
        -- IN defines the input data
        -- RHS is the bit that must be "appended" to make the 1-sum even/uneven

        -- IN   even  uneven
        "0000" & "0" & "1",
        "0001" & "1" & "0",
        "0010" & "1" & "0",
        "0011" & "0" & "1",
        "0100" & "1" & "0",
        "0101" & "0" & "1",
        "0110" & "0" & "1",
        "0111" & "1" & "0",

        "1000" & "1" & "0",
        "1001" & "0" & "1",
        "1010" & "0" & "1",
        "1011" & "1" & "0",
        "1100" & "0" & "1",
        "1101" & "1" & "0",
        "1110" & "1" & "0",
        "1111" & "1" & "1",

        -- DO NOT DELETE
        others => "0000" & "0" & "1"
      );

begin

  parity_checker: parity_check port map (
    ADCbin => input_bits_sim,
    S1     => input_cfg_sim,
    Parite => output_buffer);

  -- Section banc de test
  ----------------------------------------
	-- generation horloge
	----------------------------------------
  process
  begin
      clk_sim <= '1';  -- init
      loop
          wait for sysclk_Period/2;
          clk_sim <= not clk_sim;    -- invert clock value
      end loop;
  end process;
  ----------------------------------------
  ----------------------------------------
  -- test bench
  tb : process
    variable delai_sim : time  := 50 ns;
    variable table_valeurs_adr : integer range 0 to parity_test_count;

 begin
    table_valeurs_adr := 0;

    -------------------------------------------------
    -- TEST EVEN PARITY (button pressed -> S1 = '1')
    -------------------------------------------------
    for index in 0 to   parity_test_values'length-1 loop
      vecteur_test_sim <= parity_test_values(table_valeurs_adr);

      ----------------------------------------
      -- Assignation des signals de tests aux valeurs fetched de la table.
      ----------------------------------------
	    input_bits_sim <= vecteur_test_sim(5 downto 2);
      input_cfg_sim <= '1'; -- PRESSED BUTTON: TEST EVEN PARITY
	    expected <= vecteur_test_sim(1);
	    ----------------------------------------
      wait for delai_sim;

        -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
        assert (expected = output_buffer)
        report "Parity_check: Incorrect even parity resolution = " &
         STD_LOGIC'image(output_buffer) &
         ", Expected = " & STD_LOGIC'image(expected) &
         ", Input = [" &
         STD_LOGIC'image(input_bits_sim(3))(2) & "," &
         STD_LOGIC'image(input_bits_sim(2))(2) & "," &
         STD_LOGIC'image(input_bits_sim(1))(2) & "," &
         STD_LOGIC'image(input_bits_sim(0))(2) &  "]"
  severity warning;


            if(table_valeurs_adr = parity_test_count) then
                exit;
            end if;
            table_valeurs_adr := table_valeurs_adr + 1;
    end loop;

    -------------------------------------------------
    -- TEST UNEVEN PARITY (button pressed -> S1 = '0')
    -------------------------------------------------
    for index in 0 to   parity_test_values'length-1 loop
      vecteur_test_sim <= parity_test_values(table_valeurs_adr);

      ----------------------------------------
      -- Assignation des signals de tests aux valeurs fetched de la table.
      ----------------------------------------
	    input_bits_sim <= vecteur_test_sim(5 downto 2);
      input_cfg_sim <= '0'; -- UNPRESSED BUTTON: TEST UNEVEN PARITY
	    expected <= vecteur_test_sim(0);
	    ----------------------------------------
      wait for delai_sim;

        -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
        assert (expected = output_buffer)
        report "Parity_check: Incorrect uneven parity resolution = " &
         STD_LOGIC'image(output_buffer) &
         ", Expected = " & STD_LOGIC'image(expected) &
         ", Input = [" &
         STD_LOGIC'image(input_bits_sim(3))(2) & "," &
         STD_LOGIC'image(input_bits_sim(2))(2) & "," &
         STD_LOGIC'image(input_bits_sim(1))(2) & "," &
         STD_LOGIC'image(input_bits_sim(0))(2) &  "]"
  severity warning;


            if(table_valeurs_adr = parity_test_count) then
                exit;
            end if;
            table_valeurs_adr := table_valeurs_adr + 1;
    end loop;

    wait;
  end process;
end Behavioral;
