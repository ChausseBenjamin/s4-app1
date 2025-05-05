---------------------------------------------------------------------------------------------
-- labo_adder4b_sol_tb.vhd
---------------------------------------------------------------------------------------------
-- Université de Sherbrooke - Département de GEGI
-- Version         : 3.0
-- Nomenclature    : GRAMS
-- Date Révision   : 21 Avril 2020
-- Auteur(s)       : Réjean Fontaine, Daniel Dalle, Marc-André Tétrault
-- Technologies    : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--                   peripheriques: carte Thermo12, Pmod8LD PmodSSD
--
-- Outils          : vivado 2019.1 64 bits
---------------------------------------------------------------------------------------------
-- Description:
-- Banc d'essai pour circuit combinatoire Laboratoire logique combinatoire
-- Version avec entrées toutes combinatoires CIRCUIT COMPLET (TOP)
--
-- Revision v1 12 novembre 2018, 3 décembre 2018 D. Dalle
-- Revision 30 Avril 2021, M-A Tetrault
--
---------------------------------------------------------------------------------------------
-- Notes :
-- L'entrée retenue (i_cin) est générée par l'interrupteur S1 de la carte Thermobin
--
---------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- requis pour enoncés de type mem_valeurs_tests(to_integer( unsigned(table_valeurs_adr(9 downto 6) )));
use ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity AppCombi_top_tb is
end AppCombi_top_tb;

architecture Behavioral of AppCombi_top_tb is

  component verif_show_affhex is
  end component;

  component AppCombi_top port (
    i_btn     : in  std_logic_vector (3 downto 0);
    i_sw      : in  std_logic_vector (3 downto 0);
    sysclk    : in  std_logic;
    o_SSD     : out std_logic_vector (7 downto 0);
    o_led     : out std_logic_vector (3 downto 0);
    o_led6_r  : out std_logic;
    o_pmodled : out std_logic_vector (7 downto 0);
    ADCth     : out std_logic_vector (11 downto 0);     -- Connecteur ADCth thermometrique
    DEL2      : out std_logic;                         -- Carte thermometrique
    DEL3      : out std_logic;                         -- Carte thermometrique
    S1        : in std_logic;                          -- Carte thermometrique
    S2        : in std_logic);                           -- Carte thermometrique
  end component;

  signal clk_sim     : STD_LOGIC := '0';
  signal pmodled_sim : STD_LOGIC_VECTOR (7 downto 0);
  signal led_sim     : STD_LOGIC_VECTOR (3 downto 0);
  signal led6_r_sim  : STD_LOGIC := '0';
  signal SSD_sim     : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
  signal sw_sim      : STD_LOGIC_VECTOR (3 downto 0) := "0000";
  signal btn_sim     : STD_LOGIC_VECTOR (3 downto 0) := "0000";
  signal cin_sim     : STD_LOGIC := '0';
  signal ADCth_sim   : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";
  signal DEL2_sim    : STD_LOGIC := '0';
  signal DEL3_sim    : STD_LOGIC := '0';
  signal button_s1_sim : STD_LOGIC := '0';
  signal button_s2_sim : STD_LOGIC := '0';

  signal vecteur_test_sim : STD_LOGIC_VECTOR (13 downto 0) := (others => '0');
  signal resultat_attendu : STD_LOGIC_VECTOR (4 downto 0)  := "00000";

  component Add4Bits port (
    A  : in  STD_LOGIC_VECTOR(3 downto 0);
    B  : in  STD_LOGIC_VECTOR(3 downto 0);
    C  : in  STD_LOGIC;
    R  : out STD_LOGIC_VECTOR(3 downto 0);
    Rc : out STD_LOGIC);
  end component;

  signal add_a_sim      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
  signal add_b_sim      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
  signal add_cin_sim    : STD_LOGIC                    := '0';
  signal add_result_sim : STD_LOGIC_VECTOR(3 downto 0);
  signal add_cout_sim   : STD_LOGIC;

  constant sysclk_Period  : time := 8 ns;

  constant char_0   : std_logic_vector(3 downto 0) := "0000";
  constant char_1   : std_logic_vector(3 downto 0) := "0001";
  constant char_2   : std_logic_vector(3 downto 0) := "0010";
  constant char_3   : std_logic_vector(3 downto 0) := "0011";
  constant char_4   : std_logic_vector(3 downto 0) := "0100";
  constant char_5   : std_logic_vector(3 downto 0) := "0101";
  constant char_6   : std_logic_vector(3 downto 0) := "0110";
  constant char_7   : std_logic_vector(3 downto 0) := "0111";
  constant char_8   : std_logic_vector(3 downto 0) := "1000";
  constant char_9   : std_logic_vector(3 downto 0) := "1001";
  constant char_a   : std_logic_vector(3 downto 0) := "1010";
  constant char_b   : std_logic_vector(3 downto 0) := "1011";
  constant char_c   : std_logic_vector(3 downto 0) := "1100";
  constant char_neg : std_logic_vector(3 downto 0) := "1101";
  constant char_e   : std_logic_vector(3 downto 0) := "1110";
  constant char_r   : std_logic_vector(3 downto 0) := "1111";

  ----------------------------------------------------------------------------
  -- declaration d'un tableau pour soumettre un vecteur de test
  ----------------------------------------------------------------------------
  type table_valeurs_tests is array (integer range 0 to 63) of std_logic_vector(13 downto 0);
  constant mem_valeurs_tests : table_valeurs_tests := (
    --  vecteur de test è modifier selon les besoins

    -- ADCth input, expected PMOD, expected 7 segments, expected DEL
    "00000" & "0000" & "0000" & '0',  --   0 +  0
    "00001" & "0000" & "0001" & '0',  --   0 +  1

    -- modifez et/ou ajoutez vos valeurs
    "00001" & "0000" & "0000" & '1',  --   carry in
    "01111" & "0000" & "1111" & '0',  --   0 +  F
    "01111" & "1111" & "0000" & '0',  --   F +  0
    "01111" & "0000" & "1111" & '0',  --   0 +  F
    "01111" & "1010" & "0101" & '0',  --
    "01111" & "0101" & "1010" & '0',  --
    "10010" & "1001" & "1001" & '0',  --

    -- conserver la ligne ci-bas.
    others => "00000" & "0000" & "0000" & '0'  --  0 + 0
  );

----------------------------------------------------------------------------

begin

  uut_add4bits: Add4Bits port map (
    A  => add_a_sim,
    B  => add_b_sim,
    C  => add_cin_sim,
    R  => add_result_sim,
    Rc => add_cout_sim);

  -- Pattes du FPGA Zybo-Z7
  uut: AppCombi_top port map(
    i_btn       =>   btn_sim,
    i_sw        =>   sw_sim,
    sysclk      =>   clk_sim,
    o_SSD       =>   SSD_sim,
    o_led       =>   led_sim,
    o_pmodled   =>   pmodled_sim,
    o_led6_r    =>   led6_r_sim,
    ADCth       =>   ADCth_sim,
    DEL2        =>   DEL2_sim,
    DEL3        =>   DEL3_sim,
    S1   =>   button_s1_sim,
    S2   =>   button_s2_sim);


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
       variable table_valeurs_adr : integer range 0 to 63;
       variable fct_table_valeurs_adr : integer range 0 to 13;
       begin

         -- Phase 1
         table_valeurs_adr := 0;
         -- simuler une sequence de valeurs a l'entree
         for index in 0 to   mem_valeurs_tests'length-1 loop
           vecteur_test_sim <= mem_valeurs_tests(table_valeurs_adr);
           sw_sim  <= vecteur_test_sim (8 downto 5);
           btn_sim <= vecteur_test_sim (4 downto 1) ;
           cin_sim <= vecteur_test_sim (0);
           resultat_attendu <= vecteur_test_sim(13 downto 9);

           -- Assignation of variables to add4bit
           add_a_sim   <= vecteur_test_sim(8 downto 5);
           add_b_sim   <= vecteur_test_sim(4 downto 1);
           add_cin_sim <= vecteur_test_sim(0);

           wait for delai_sim;

           -- Compare results. Des impression dans le terminal sont fait uniquement lors d'erreurs.
           assert (resultat_attendu(3 downto 0) = add_result_sim)
             report "Add4Bits: Somme incorrecte. Attendu = " &
               integer'image(to_integer(unsigned(resultat_attendu(3 downto 0)))) &
               ", Obtenu = " &
               integer'image(to_integer(unsigned(add_result_sim))) &
               ", A = " &
               integer'image(to_integer(unsigned(add_a_sim(3 downto 0)))) &
               ", B = " &
               integer'image(to_integer(unsigned(add_b_sim(3 downto 0))))
             severity warning;

           assert (resultat_attendu(4) = add_cout_sim)
             report "Add4Bits: Retenue incorrecte. Attendu = '" &
               std_logic'image(resultat_attendu(4)) &
               "', Obtenu = '" &
               std_logic'image(add_cout_sim) & "'" &
               ", A = " &
               integer'image(to_integer(unsigned(add_a_sim(3 downto 0)))) &
               ", B = " &
               integer'image(to_integer(unsigned(add_b_sim(3 downto 0))))
             severity warning;

           table_valeurs_adr := table_valeurs_adr + 1;
           if(table_valeurs_adr = 63) then
             exit;
           end if;
         end loop;

          wait; -- will wait forever
        end process;

end Behavioral;
