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

entity Bin2DualBCD_tb is
--  Port ( );
end Bin2DualBCD_tb;

architecture Behavioral of Bin2DualBCD_tb is

    component Bin2DualBCD is Port (
        ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
        Dizaines : out STD_LOGIC_VECTOR (3 downto 0);
        Unite_ns : out STD_LOGIC_VECTOR (3 downto 0);
        Code_signe : out STD_LOGIC_VECTOR (3 downto 0);
        Unite_s : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal test_number           : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal input_sim             : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_unite_ns_sim   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_unite_s_sim    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_dizaines_sim   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_code_signe     : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal expected_unite_ns_sim : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal expected_unite_s_sim  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal expected_dizaines_sim : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal expected_code         : STD_LOGIC_VECTOR (3 downto 0) := "0000";

    ----------------------------------------------------------------------------
    -- Test bench usage signals
    ----------------------------------------------------------------------------
    constant sysclk_Period  : time := 8 ns;
    signal clk_sim          : STD_LOGIC := '0';
    signal vecteur_test_sim : STD_LOGIC_VECTOR(23 downto 0) := "UUUU00000000000000000000";

    ----------------------------------------------------------------------------
    -- declaration d'un tableau pour soumettre un vecteur de test  
    ---------------------------------------------------------------------------- 
    constant amount_of_tests: integer := 19;
    type table_valeurs_tests is array (integer range 0 to amount_of_tests) of std_logic_vector(23 downto 0);
        constant mem_valeurs_tests : table_valeurs_tests := ( 
          -- test_nb  input    signed   code    u_ns    dizaine
            "0000" & "0000" & "0101" & "1101" & "0000" & "0000", -- 0
            "0001" & "0001" & "0100" & "1101" & "0001" & "0000", -- 1
            "0010" & "0010" & "0011" & "1101" & "0010" & "0000", -- 2
            "0011" & "0011" & "0010" & "1101" & "0011" & "0000", -- 3
            "0100" & "0100" & "0001" & "1101" & "0100" & "0000", -- 4
            "0101" & "0101" & "0000" & "0000" & "0101" & "0000", -- 5
            "0110" & "0110" & "0001" & "0000" & "0110" & "0000", -- 6
            "0111" & "0111" & "0010" & "0000" & "0111" & "0000", -- 7
            "1000" & "1000" & "0011" & "0000" & "1000" & "0000", -- 8
            "1001" & "1001" & "0100" & "0000" & "1001" & "0000", -- 9
            "1010" & "1010" & "0101" & "0000" & "0000" & "0001", -- 10
            "1011" & "1011" & "0110" & "0000" & "0001" & "0001", -- 11
            "1100" & "1100" & "0111" & "0000" & "0010" & "0001", -- 12
            "1101" & "1101" & "1000" & "1101" & "0011" & "0001", -- 13
            "1110" & "1110" & "0111" & "1101" & "0100" & "0001", -- 14
            "1111" & "1111" & "0110" & "1101" & "0101" & "0001", -- 15
            -- conserver la ligne ci-bas.
            others => "0000" & "0101" & "1101" & "1101" & "0000" & "0000" --  0 + 0
        );

begin

    uut: Bin2DualBCD
        port map (
            ADCbin => input_sim,
            Dizaines => output_dizaines_sim,
            Unite_ns => output_unite_ns_sim,
            Code_signe => output_code_signe,
            Unite_s => output_unite_s_sim
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

                test_number <= vecteur_test_sim(23 downto 20);
			    input_sim <= vecteur_test_sim(19 downto 16);
			    expected_unite_s_sim <= vecteur_test_sim(15 downto 12);
			    expected_code <= vecteur_test_sim(11 downto 8);
			    expected_unite_ns_sim <= vecteur_test_sim(7 downto 4);
			    expected_dizaines_sim <= vecteur_test_sim(3 downto 0);

			    ----------------------------------------
                wait for delai_sim;

                -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
                assert (expected_unite_s_sim(3 downto 0) = output_unite_s_sim)
                    report "BCD SIGNED VAL: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_unite_s_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_unite_s_sim))) &
                        ", FROM = " &
                        integer'image(to_integer(unsigned(input_sim))) &
                        ", TEST = " &
                        integer'image(to_integer(unsigned(test_number)))
                    severity warning;

                assert (expected_unite_ns_sim(3 downto 0) = output_unite_ns_sim)
                    report "BCD UNSIGNED VAL: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_unite_ns_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_unite_ns_sim))) &
                        ", FROM = " &
                        integer'image(to_integer(unsigned(input_sim))) &
                        ", TEST = " &
                        integer'image(to_integer(unsigned(test_number)))
                    severity warning;
                    
                assert (expected_dizaines_sim(3 downto 0) = output_dizaines_sim)
                    report "BCD DIZAINE VAL: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_dizaines_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_dizaines_sim))) &
                        ", FROM = " &
                        integer'image(to_integer(unsigned(input_sim))) &
                        ", TEST = " &
                        integer'image(to_integer(unsigned(test_number)))
                    severity warning;
                    
                assert (expected_code(3 downto 0) = output_code_signe)
                    report "BCD CODE VAL: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_code_signe))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_code))) &
                        ", FROM = " &
                        integer'image(to_integer(unsigned(input_sim))) &
                        ", TEST = " &
                        integer'image(to_integer(unsigned(test_number)))
                    severity warning;

                if(table_valeurs_adr = amount_of_tests) then
                    exit;
                end if;
                table_valeurs_adr := table_valeurs_adr + 1;
            end loop;
         wait;
      end process;
end Behavioral;
