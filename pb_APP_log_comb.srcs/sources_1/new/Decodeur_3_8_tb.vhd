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

entity Decodeur_3_8_tb is
--  Port ( );
end Decodeur_3_8_tb;

architecture Behavioral of Decodeur_3_8_tb is

    component Decodeur_3_8
        Port ( control_bits : in STD_LOGIC_VECTOR (2 downto 0);
               bus_out : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal control_bits_sim : STD_LOGIC_VECTOR (2 downto 0);
    signal bus_out_sim : STD_LOGIC_VECTOR (7 downto 0);
    signal expected : STD_LOGIC_VECTOR (7 downto 0);

    ----------------------------------------------------------------------------
    -- Test bench usage signals
    ----------------------------------------------------------------------------
    constant sysclk_Period  : time := 8 ns;
    signal clk_sim          : STD_LOGIC := '0';
    signal vecteur_test_sim : STD_LOGIC_VECTOR(10 downto 0) := "0000000000";

    ----------------------------------------------------------------------------
    -- declaration d'un tableau pour soumettre un vecteur de test  
    ---------------------------------------------------------------------------- 
    constant amount_of_tests: integer := 8;
    type table_valeurs_tests is array (integer range 0 to amount_of_tests) of std_logic_vector(10 downto 0);
        constant mem_valeurs_tests : table_valeurs_tests := 
( 
            -- OUT      control
            "00000001" & "000",
            "00000010" & "001",
            "00000100" & "010",
            "00001000" & "011",
            "00010000" & "100",
            "00100000" & "101",
            "01000000" & "110",
            "10000000" & "111",
 
            -- conserver la ligne ci-bas.
            others => "00000000" & "000" 
        );

begin

    uut_decoder: Decodeur_3_8
        port map (
            control_bits  => control_bits_sim,
            bus_out  => bus_out_sim
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


			    control_bits_sim <= vecteur_test_sim(2 downto 0);
			    expected <= vecteur_test_sim(10 downto 3);
			    ----------------------------------------
                wait for delai_sim;

                -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
                assert (expected(7 downto 0) = bus_out_sim)
                    report "Decodeur_3_8: Incorrect decoded output = " &
                        integer'image(to_integer(unsigned(bus_out_sim))) &
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
