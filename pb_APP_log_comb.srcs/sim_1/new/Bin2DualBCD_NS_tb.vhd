----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2025 09:44:44 PM
-- Design Name: 
-- Module Name: Bin2DualBCD_NS_tb - Behavioral
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

entity Bin2DualBCD_NS_tb is
--  Port ( );
end Bin2DualBCD_NS_tb;

architecture Behavioral of Bin2DualBCD_NS_tb is

    component Bin2DualBCD_NS is port ( 
        binary_4bit_in : in STD_LOGIC_VECTOR (3 downto 0);
        units_out : out STD_LOGIC_VECTOR (3 downto 0);
        dizaines_out : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal input_sim           : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_unit_sim     : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_dizaine_sim  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal expected_unit       : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal expected_dizaine    : STD_LOGIC_VECTOR (3 downto 0) := "0000";

    ----------------------------------------------------------------------------
    -- Test bench usage signals
    ----------------------------------------------------------------------------
    constant sysclk_Period  : time := 8 ns;
    signal clk_sim          : STD_LOGIC := '0';
    signal vecteur_test_sim : STD_LOGIC_VECTOR(11 downto 0) := "000000000000";

    ----------------------------------------------------------------------------
    -- declaration d'un tableau pour soumettre un vecteur de test  
    ---------------------------------------------------------------------------- 
    constant amount_of_tests: integer := 16;
    type table_valeurs_tests is array (integer range 0 to amount_of_tests) of std_logic_vector(11 downto 0);
        constant mem_valeurs_tests : table_valeurs_tests := ( 
          -- input    unit    dizaine
            "0000" & "0000" & "0000", -- 0
            "0001" & "0001" & "0000", -- 1
            "0010" & "0010" & "0000", -- 2
            "0011" & "0011" & "0000", -- 3
            "0100" & "0100" & "0000", -- 4
            "0101" & "0101" & "0000", -- 5
            "0110" & "0110" & "0000", -- 6
            "0111" & "0111" & "0000", -- 7
            "1000" & "1000" & "0000", -- 8
            "1001" & "1001" & "0000", -- 9
            "1010" & "0000" & "0001", -- 10
            "1011" & "0001" & "0001", -- 11
            "1100" & "0010" & "0001", -- 12
            "1101" & "0011" & "0001", -- 13
            "1110" & "0100" & "0001", -- 14
            "1111" & "0101" & "0001", -- 15
            -- conserver la ligne ci-bas.
            others => "0000" & "0000" & "0000" --  0 + 0
        );

begin

    uut: Bin2DualBCD_NS
        port map (
            binary_4bit_in  => input_sim,
            units_out  => output_unit_sim,
            dizaines_out => output_dizaine_sim
        );

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
        variable table_valeurs_adr : integer range 0 to amount_of_tests;

        begin

            table_valeurs_adr := 0;
            for index in 0 to   mem_valeurs_tests'length-1 loop
                vecteur_test_sim <= mem_valeurs_tests(table_valeurs_adr);
                ----------------------------------------
                -- Assignation des signals de tests aux valeurs fetched de la table.
                ----------------------------------------

			    input_sim <= vecteur_test_sim(11 downto 8);
			    expected_unit <= vecteur_test_sim(7 downto 4);
			    expected_dizaine <= vecteur_test_sim(3 downto 0);

			    ----------------------------------------
                wait for delai_sim;

                -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
                assert (expected_unit(3 downto 0) = output_unit_sim)
                    report "BCD UNITS NS: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_unit_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_unit))) &
                        ", FROM = " &
                        integer'image(to_integer(unsigned(input_sim)))
                    severity warning;

                assert (expected_dizaine(3 downto 0) = output_dizaine_sim)
                    report "BCD DIZAINE NS: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_dizaine_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_dizaine))) &
                        ", FROM = " &
                        integer'image(to_integer(unsigned(input_sim)))
                    severity warning;

                if(table_valeurs_adr = amount_of_tests) then
                    exit;
                end if;
                table_valeurs_adr := table_valeurs_adr + 1;
            end loop;
         wait;
      end process;
end Behavioral;
