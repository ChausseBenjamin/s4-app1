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

entity mux_tb is
--  Port ( );
end mux_tb;

architecture Behavioral of mux_tb is
    component Mux is port (
        ADCbin     : in  STD_LOGIC_VECTOR (3 downto 0);
        Dizaines   : in  STD_LOGIC_VECTOR (3 downto 0);
        Unites_ns  : in  STD_LOGIC_VECTOR (3 downto 0);
        Code_signe : in  STD_LOGIC_VECTOR (3 downto 0);
        Unite_s    : in  STD_LOGIC_VECTOR (3 downto 0);
        BTN        : in  STD_LOGIC_VECTOR (1 downto 0);
        erreur     : in  STD_LOGIC;
        S2         : in  STD_LOGIC;
        DAFF0      : out STD_LOGIC_VECTOR (3 downto 0);
        DAFF1      : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal test_number          : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal input_sim            : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal input_dizaines_sim   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal input_units_ns_sim   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal input_units_s_sim    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal input_code_sim       : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal input_btn_sim        : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal input_error_sim      : STD_LOGIC := '0';
    signal input_s2_sim         : STD_LOGIC := '0';
    signal output_aff0_sim      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal output_aff1_sim      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal expected_aff1        : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal expected_aff0        : STD_LOGIC_VECTOR (3 downto 0) := "0000";

    ----------------------------------------------------------------------------
    -- Test bench usage signals
    ----------------------------------------------------------------------------
    constant sysclk_Period  : time := 8 ns;
    signal clk_sim          : STD_LOGIC := '0';
    signal vecteur_test_sim : STD_LOGIC_VECTOR(35 downto 0) := "000000000000000000000000000000000000";

    ----------------------------------------------------------------------------
    -- declaration d'un tableau pour soumettre un vecteur de test  
    ---------------------------------------------------------------------------- 
    constant amount_of_tests: integer := 8;
    type table_valeurs_tests is array (integer range 0 to amount_of_tests) of std_logic_vector(35 downto 0);
        constant mem_valeurs_tests : table_valeurs_tests := ( 
        --  test n    adc     dizaine  u ns      u s     btn    s2    code    error   aff1    aff0
            "0000" & "0000" & "0001" & "0010" & "0100" & "00" & "0" & "0000" & "0" & "0000" & "0000",  -- nothing

            "0001" & "0000" & "0001" & "0010" & "0100" & "00" & "0" & "0000" & "1" & "1110" & "1111",  -- error overwrite
            "0010" & "0000" & "0001" & "0010" & "0100" & "00" & "1" & "0000" & "0" & "1110" & "1111",  -- s2 pressed
            "0011" & "0000" & "0001" & "0010" & "0100" & "00" & "1" & "0000" & "1" & "1110" & "1111",  -- s2 and error input
            "0011" & "0000" & "0001" & "0010" & "0100" & "11" & "0" & "0000" & "0" & "1110" & "1111",  -- 2

            "0100" & "0000" & "0001" & "0010" & "0100" & "00" & "0" & "0000" & "0" & "0001" & "0010",  -- BCD non signe
            "0101" & "0110" & "0001" & "0010" & "0100" & "01" & "0" & "1000" & "0" & "0000" & "0110",  -- Hexadecimal
            "0110" & "0000" & "0001" & "0010" & "0100" & "10" & "0" & "0101" & "0" & "0101" & "0100",  -- BCD signe
            -- conserver la ligne ci-bas.
            others => "0000" & "0000" & "0000" & "0000" & "0000" & "00" & "0" & "0000" & "0" & "0000" & "0000"  --  0 + 0
        );

begin

    uut: Mux port map (
        ADCbin     => input_sim,
        Dizaines   => input_dizaines_sim,
        Unites_ns  => input_units_ns_sim,
        Code_signe => input_code_sim,
        Unite_s    => input_units_s_sim,
        BTN        => input_btn_sim,
        erreur     => input_error_sim,
        S2         => input_s2_sim,
        DAFF0      => output_aff0_sim,
        DAFF1      => output_aff1_sim
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

			    test_number <= vecteur_test_sim(35 downto 32);           -- test number
			    input_sim <= vecteur_test_sim(31 downto 28);             -- ADCBin
			    input_dizaines_sim <= vecteur_test_sim(27 downto 24);    -- dizaines
			    input_units_ns_sim <= vecteur_test_sim(23 downto 20);    -- unite non signer
			    input_units_s_sim <= vecteur_test_sim(19 downto 16);     -- unite signer
			    input_btn_sim <= vecteur_test_sim(15 downto 14);         -- buttons
			    input_s2_sim <= vecteur_test_sim(13);                    -- s2
			    input_code_sim <= vecteur_test_sim(12 downto 9);         -- code signe
			    input_error_sim <= vecteur_test_sim(8);                  -- error
			    expected_aff1 <= vecteur_test_sim(7 downto 4);
			    expected_aff0 <= vecteur_test_sim(3 downto 0);
			    
			    ----------------------------------------
                wait for delai_sim;

                -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
                assert (expected_aff1(3 downto 0) = output_aff1_sim)
                    report "AFF1: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_aff1_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_aff1))) &
                        ", Test number = " &
                        integer'image(to_integer(unsigned(test_number))) &
                        ", From = " &
                        integer'image(to_integer(unsigned(input_sim))) &
                        ", Dizaines = " &
                        integer'image(to_integer(unsigned(input_dizaines_sim))) &
                        ", u ns = " &
                        integer'image(to_integer(unsigned(input_units_ns_sim))) &
                        ", u n = " &
                        integer'image(to_integer(unsigned(input_units_s_sim))) &
                        ", buttons = " &
                        integer'image(to_integer(unsigned(input_btn_sim))) &
                        ", s2 = " & std_logic'image(input_s2_sim) &
                        ", code = " &
                        integer'image(to_integer(unsigned(input_code_sim))) &
                        ", error = " & std_logic'image(input_error_sim)
                    severity warning;
                    
                assert (expected_aff0(3 downto 0) = output_aff0_sim)
                    report "AFF0: Incorrect output = " &
                        integer'image(to_integer(unsigned(output_aff0_sim))) &
                        ", Expected = " &
                        integer'image(to_integer(unsigned(expected_aff0))) &
                        ", Test number = " &
                        integer'image(to_integer(unsigned(test_number))) &
                        ", From = " &
                        integer'image(to_integer(unsigned(input_sim))) &
                        ", Dizaines = " &
                        integer'image(to_integer(unsigned(input_dizaines_sim))) &
                        ", u ns = " &
                        integer'image(to_integer(unsigned(input_units_ns_sim))) &
                        ", u n = " &
                        integer'image(to_integer(unsigned(input_units_s_sim))) &
                        ", buttons = " &
                        integer'image(to_integer(unsigned(input_btn_sim))) &
                        ", s2 = " & std_logic'image(input_s2_sim) &
                        ", code = " &
                        integer'image(to_integer(unsigned(input_code_sim))) &
                        ", error = " & std_logic'image(input_error_sim)
                    severity warning;


                if(table_valeurs_adr = amount_of_tests) then
                    exit;
                end if;
                table_valeurs_adr := table_valeurs_adr + 1;
            end loop;
         wait;
      end process;
end Behavioral;