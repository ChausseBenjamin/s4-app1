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

entity Bin2DualBCD_S_tb is
--  Port ( );
end Bin2DualBCD_S_tb;

architecture Behavioral of Bin2DualBCD_S_tb is

    component Bin2DualBCD_S is port ( 
       signed_in : in STD_LOGIC_VECTOR (3 downto 0);
       signed_code : out STD_LOGIC_VECTOR (3 downto 0);
       signed_units : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal input_sim           : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_signed_sim     : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_code_sim  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal expected_signed       : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal expected_code    : STD_LOGIC_VECTOR (3 downto 0) := "0000";

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
          -- input    signed   code
            "0000" & "0000" & "0000", -- 0
            "0001" & "0000" & "0001", -- 1
            "0010" & "0000" & "0010", -- 2
            "0011" & "0000" & "0011", -- 3
            "0100" & "0000" & "0100", -- 4
            "0101" & "0000" & "0101", -- 5
            "0110" & "0000" & "0110", -- 6
            "0111" & "0000" & "0111", -- 7
            "1000" & "1101" & "0000", -- 8
            "1001" & "1101" & "0001", -- 9
            "1010" & "1101" & "0010", -- 10
            "1011" & "1101" & "0011", -- 11
            "1100" & "1101" & "0100", -- 12
            "1101" & "1101" & "0101", -- 13
            "1110" & "1101" & "0110", -- 14
            "1111" & "1101" & "0111", -- 15
            -- conserver la ligne ci-bas.
            others => "0000" & "0000" & "0000" --  0 + 0
        );

begin

    uut: Bin2DualBCD_S
        port map (
            signed_in => input_sim,
            signed_code => output_code_sim,
            signed_units => output_signed_sim
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
			    expected_signed <= vecteur_test_sim(7 downto 4);
			    expected_code <= vecteur_test_sim(3 downto 0);

			    ----------------------------------------
                wait for delai_sim;

                -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
                assert (expected_signed(3 downto 0) = output_signed_sim)
                    report "BCD SIGNED VAL: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_signed_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_signed))) &
                        ", FROM = " &
                        integer'image(to_integer(unsigned(input_sim)))
                    severity warning;

                assert (expected_code(3 downto 0) = output_code_sim)
                    report "BCD CODE S: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_code_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_code))) &
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
