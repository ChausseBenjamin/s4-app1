----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/03/2025 07:14:35 PM
-- Design Name:
-- Module Name: Moins_5_tb - Behavioral
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

entity Moins_5_tb is
end Moins_5_tb;

architecture Behavioral of Moins_5_tb is

  component Moins_5 port (
    ADCbin : in  STD_LOGIC_VECTOR (3 downto 0);
    Moins5 : out STD_LOGIC_VECTOR (3 downto 0));
  end component;

  signal input_bits_sim : STD_LOGIC_VECTOR (3 downto 0) := "0000" ;
  signal output_buffer  : STD_LOGIC_VECTOR (3 downto 0) := "0000" ;
  signal expected       : STD_LOGIC_VECTOR (3 downto 0) := "0000" ;

  ----------------------------------------------------------------------------
  -- Test bench usage signals
  ----------------------------------------------------------------------------
  constant sysclk_Period    : time := 8 ns;
  signal   clk_sim          : STD_LOGIC := '0';
  signal   vecteur_test_sim : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

  ----------------------------------------------------------------------------
  -- declaration d'un tableau pour soumettre un vecteur de test
  ----------------------------------------------------------------------------
  constant test_count: integer := 16;
  type test_table is array (integer range 0 to test_count) of STD_LOGIC_VECTOR(7 downto 0);
      constant test_values : test_table := (
        -- IN defines the input data
        -- RHS is the bit that must be "appended" to make the 1-sum even/uneven

        -- IN    OUT
        "0000" & "1011",
        "0001" & "1100",
        "0010" & "1101",
        "0011" & "1110",
        "0100" & "1111",
        "0101" & "0000",
        "0110" & "0001",
        "0111" & "0010",

        "1000" & "0011",
        "1001" & "0100",
        "1010" & "0101",
        "1011" & "0110",
        "1100" & "0111",
        "1101" & "1000",
        "1110" & "1001",
        "1111" & "1010",

        -- DO NOT DELETE
        others => "0000" & "0000"
      );

begin

  substracter: Moins_5 port map (
    ADCbin => input_bits_sim,
    Moins5 => output_buffer);

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
    variable table_valeurs_adr : integer range 0 to test_count;

 begin
    table_valeurs_adr := 0;

    -------------------------------------------------
    -- TEST EVERY POSSIBLE INPUT (16)
    -------------------------------------------------
    for index in 0 to   test_values'length-1 loop
      vecteur_test_sim <= test_values(table_valeurs_adr);

      ----------------------------------------
      -- Assignation des signals de tests aux valeurs fetched de la table.
      ----------------------------------------
	    input_bits_sim <= vecteur_test_sim(7 downto 4);
	    expected <= vecteur_test_sim(3 downto 0);
	    ----------------------------------------
      wait for delai_sim;

        -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
      assert (expected = output_buffer)
      report "Test failed: Input    = [" &
        STD_LOGIC'image(input_bits_sim(3))(2) & "," &
        STD_LOGIC'image(input_bits_sim(2))(2) & "," &
        STD_LOGIC'image(input_bits_sim(1))(2) & "," &
        STD_LOGIC'image(input_bits_sim(0))(2) & "]" & LF &
        "             Expected = [" &
        STD_LOGIC'image(expected(3))(2) & "," &
        STD_LOGIC'image(expected(2))(2) & "," &
        STD_LOGIC'image(expected(1))(2) & "," &
        STD_LOGIC'image(expected(0))(2) & "]" & LF &
        "             Got      = [" &
        STD_LOGIC'image(output_buffer(3))(2) & "," &
        STD_LOGIC'image(output_buffer(2))(2) & "," &
        STD_LOGIC'image(output_buffer(1))(2) & "," &
        STD_LOGIC'image(output_buffer(0))(2) & "]"
      severity warning;






        if(table_valeurs_adr = test_count) then
            exit;
        end if;
        table_valeurs_adr := table_valeurs_adr + 1;
    end loop;
    wait;
  end process;
end Behavioral;
