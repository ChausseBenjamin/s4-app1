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

entity Thermo2Bin_tb is
--  Port ( );
end Thermo2Bin_tb;

architecture Behavioral of Thermo2Bin_tb is

    component Thermo2Bin is
        Port ( thermo_bus : in STD_LOGIC_VECTOR (11 downto 0);
               binary_out : out STD_LOGIC_VECTOR (3 downto 0);
               error : out STD_LOGIC);
    end component;

    signal input_sim        : STD_LOGIC_VECTOR(11 downto 0) := "000000000000";
    signal output_sim       : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal error_sim        : STD_LOGIC := '0';
    signal expected         : STD_LOGIC_VECTOR (3 downto 0);
    signal expected_error   : STD_LOGIC := '0';

    ----------------------------------------------------------------------------
    -- Test bench usage signals
    ----------------------------------------------------------------------------
    constant sysclk_Period  : time := 8 ns;
    signal clk_sim          : STD_LOGIC := '0';
    signal vecteur_test_sim : STD_LOGIC_VECTOR(16 downto 0) := "00000000000000000";

    ----------------------------------------------------------------------------
    -- declaration d'un tableau pour soumettre un vecteur de test  
    ---------------------------------------------------------------------------- 
    constant amount_of_tests: integer := 26;
    type table_valeurs_tests is array (integer range 0 to amount_of_tests) of std_logic_vector(16 downto 0);
        constant mem_valeurs_tests : table_valeurs_tests := ( 
            --  therm0       output   err
            "000000000000" & "0000" & "0", -- 0
            
            "000000000001" & "0001" & "0", -- 1
            "000000000011" & "0010" & "0", -- 2
            "000000000111" & "0011" & "0", -- 3
            "000000001111" & "0100" & "0", -- 4
            
            "000000011111" & "0101" & "0", -- 5
            "000000111111" & "0110" & "0", -- 6
            "000001111111" & "0111" & "0", -- 7
            "000011111111" & "1000" & "0", -- 8
            
            "000111111111" & "1001" & "0", -- 9
            "001111111111" & "1010" & "0", -- 10
            "011111111111" & "1011" & "0", -- 11
            "111111111111" & "1100" & "0", -- 12
            
            "100011111111" & "1100" & "1", -- error
            "010011111111" & "1100" & "1", -- error
            "001011111111" & "1100" & "1", -- error
            "101011111111" & "1100" & "1", -- error
            
            "111101001111" & "1100" & "1", -- error
            "111101011111" & "1100" & "1", -- error
            "111110001111" & "1100" & "1", -- error
            "111100001111" & "1100" & "1", -- error
            
            "111111110000" & "1100" & "1", -- error
            "111111111000" & "1100" & "1", -- error
            "111111110100" & "1100" & "1", -- error
            "111111110010" & "1100" & "1", -- error
            
            "000000010000" & "1100" & "1", -- error
            -- conserver la ligne ci-bas.
            others => "000000000000" & "0000" & "0"  --  0 + 0
        );

begin

    uut: Thermo2Bin
        port map (
            thermo_bus  => input_sim,
            binary_out  => output_sim,
            error => error_sim
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
                
			    input_sim <= vecteur_test_sim(16 downto 5);
			    expected <= vecteur_test_sim(4 downto 1);
			    expected_error <= vecteur_test_sim(0);
			    
			    ----------------------------------------
                wait for delai_sim;

                -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
                assert (expected(3 downto 0) = output_sim)
                    report "Thermo: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_sim))) &
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