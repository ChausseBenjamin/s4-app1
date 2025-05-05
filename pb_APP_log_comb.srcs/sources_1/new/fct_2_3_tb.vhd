----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2025 07:53:29 PM
-- Design Name: 
-- Module Name: fct_2_3_tb - Behavioral
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

entity fct_2_3_tb is
--  Port ( );
end fct_2_3_tb;

architecture Behavioral of fct_2_3_tb is
    component Fct_2_3 is port (
        ADCbin : in  STD_LOGIC_VECTOR (3 downto 0);
        A2_3   : out STD_LOGIC_VECTOR (2 downto 0));
    end component;

    signal input_sim        : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_sim       : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal expected         : STD_LOGIC_VECTOR (2 downto 0);

    ----------------------------------------------------------------------------
    -- Test bench usage signals
    ----------------------------------------------------------------------------
    constant sysclk_Period  : time := 8 ns;
    signal clk_sim          : STD_LOGIC := '0';
    signal vecteur_test_sim : STD_LOGIC_VECTOR(6 downto 0) := "0000000";

    ----------------------------------------------------------------------------
    -- declaration d'un tableau pour soumettre un vecteur de test  
    ---------------------------------------------------------------------------- 
    constant amount_of_tests: integer := 16;
    type table_valeurs_tests is array (integer range 0 to amount_of_tests) of std_logic_vector(6 downto 0);
        constant mem_valeurs_tests : table_valeurs_tests := ( 
            --  res   input
            "000" & "0000", -- 0
            "000" & "0001", -- 1
            "001" & "0010", 
            "001" & "0011",
            "010" & "0100", 
            "011" & "0101",
            "011" & "0110", -- 0011, 0000
            "100" & "0111", -- 0011, 0000
            "101" & "1000", -- 0100, 0001
            "101" & "1001", -- 0100, 0001
            "110" & "1010",
            "110" & "1011",
            "111" & "1100", -- 12
            "000" & "1101", -- IMPOSSIBLE
            "000" & "1110", -- IMPOSSIBLE
            "001" & "1111", -- IMPOSSIBLE
            -- conserver la ligne ci-bas.
            others => "000" & "0000"  --  0 + 0
        );

begin

    uut: Fct_2_3
        port map (
            ADCbin  => input_sim,
            A2_3  => output_sim
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


			    input_sim <= vecteur_test_sim(3 downto 0);
			    expected <= vecteur_test_sim(6 downto 4);
			    ----------------------------------------
                wait for delai_sim;

                -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
                assert (expected(2 downto 0) = output_sim)
                    report "FCT_2_3: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_sim(2 downto 0)))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected)))
                    severity warning;


                if(table_valeurs_adr = amount_of_tests) then
                    exit;
                end if;
                table_valeurs_adr := table_valeurs_adr + 1;
            end loop;
         wait;
      end process;
end Behavioral;