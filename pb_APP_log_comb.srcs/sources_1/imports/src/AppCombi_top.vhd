---------------------------------------------------------------------------------------------
-- Universit� de Sherbrooke - D�partement de GEGI
-- Version     : 3.0
-- Nomenclature  : GRAMS
-- Date      : 21 Avril 2020
-- Auteur(s)     : R�jean Fontaine, Daniel Dalle, Marc-Andr� T�trault
-- Technologies  : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--           peripheriques: Pmod8LD PmodSSD
--
-- Outils      : vivado 2019.1 64 bits
---------------------------------------------------------------------------------------------
-- Description:
-- Circuit utilitaire pour le laboratoire et la probl�matique de logique combinatoire
--
---------------------------------------------------------------------------------------------
-- � faire :
-- Voir le guide de l'APP
--  Ins�rer les modules additionneurs ("components" et "instances")
--
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity AppCombi_top is port (
  i_btn     : in  std_logic_vector (3 downto 0); -- Boutons de la carte Zybo
  i_sw      : in  std_logic_vector (3 downto 0); -- Interrupteurs de la carte Zybo
  sysclk    : in  std_logic;           -- horloge systeme
  o_SSD     : out std_logic_vector (7 downto 0); -- vers cnnecteur pmod afficheur 7 segments
  o_led     : out std_logic_vector (3 downto 0); -- vers DELs de la carte Zybo
  o_led6_r  : out std_logic;           -- vers DEL rouge de la carte Zybo
  o_pmodled : out std_logic_vector (7 downto 0);  -- vers connecteur pmod 8 DELs
  ADCth     : in std_logic_vector (11 downto 0);     -- Connecteur ADCth thermometrique
  DEL2      : out std_logic;                         -- Carte thermometrique
  DEL3      : out std_logic;                         -- Carte thermometrique
  S1        : in std_logic;                          -- Carte thermometrique
  S2        : in std_logic                           -- Carte thermometrique
);
end AppCombi_top;

architecture BEHAVIORAL of AppCombi_top is

  constant nbreboutons   : integer := 4;  -- Carte Zybo Z7
  constant freq_sys_MHz  : integer := 125;  -- 125 MHz

  signal d_s_1Hz       : std_logic;
  signal clk_5MHz      : std_logic;
  --
  signal led_test_btn: std_logic_vector (2 downto 0):= "000";
  signal d_opa       : std_logic_vector (3 downto 0):= "0000";   -- operande A
  signal d_opb       : std_logic_vector (3 downto 0):= "0000";   -- operande B
  signal d_cin       : std_logic := '0';             -- retenue entree
  signal d_sum       : std_logic_vector (4 downto 0):= "00000";   -- somme
  signal d_cout      : std_logic := '0';             -- retenue sortie
  --
  signal d_AFF0      : std_logic_vector (3 downto 0):= "0000";
  signal d_AFF1      : std_logic_vector (3 downto 0):= "0000";
  --
  signal ADCbin      : std_logic_vector (3 downto 0) := "0000";
  signal error       : std_logic := '0';
  -- PMOD
  signal A2_3        : std_logic_vector (2 downto 0) := "000";
  --
  signal parite_out  : std_logic := '0';
  --
  signal Dizaines    : std_logic_vector (3 downto 0) := "0000";
  signal Unite_ns     : std_logic_vector (3 downto 0) := "0000";
  signal Code_signe  : std_logic_vector (3 downto 0) := "0000";
  signal Unite_s      : std_logic_vector (3 downto 0) := "0000";

  component Bin2DualBCD is Port ( 
    ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
    Dizaines : out STD_LOGIC_VECTOR (3 downto 0);
    Unite_ns : out STD_LOGIC_VECTOR (3 downto 0);
    Code_signe : out STD_LOGIC_VECTOR (3 downto 0);
    Unite_s : out STD_LOGIC_VECTOR (3 downto 0));
  end component;

  component parity_check is Port ( 
    ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
    S1 : in STD_LOGIC;
    Parite : out STD_LOGIC);
  end component;

  component Fct_2_3 is Port ( 
    ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
    A2_3 : out STD_LOGIC_VECTOR (2 downto 0));
  end component;

  component Decodeur_3_8 is Port (
    control_bits : in STD_LOGIC_VECTOR (2 downto 0);
    bus_out : out STD_LOGIC_VECTOR (7 downto 0));
  end component;

  component Thermo2Bin is Port ( 
    thermo_bus : in STD_LOGIC_VECTOR (11 downto 0);
    binary_out : out STD_LOGIC_VECTOR (3 downto 0);
    error : out STD_LOGIC);
   end component;

  component Add4Bits is Port (
    A : in STD_LOGIC_VECTOR (3 downto 0);
    B : in STD_LOGIC_VECTOR (3 downto 0);
    C : in STD_LOGIC;
    R : out STD_LOGIC_VECTOR (3 downto 0);
    Rc : out STD_LOGIC
  );
  end component;

  component synchro_module_v2 is generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
  Port (
    clkm        : in  STD_LOGIC;  -- Entr�e  horloge maitre
    o_CLK_5MHz  : out STD_LOGIC;  -- horloge divise utilise pour le circuit
    o_S_1Hz     : out  STD_LOGIC  -- Signal temoin 1 Hz
  );
  end component;

  component septSegments_Top is Port (
    clk          : in   STD_LOGIC;                      -- horloge systeme, typique 100 MHz (preciser par le constante)
    i_AFF0       : in   STD_LOGIC_VECTOR (3 downto 0);  -- donnee a afficher sur 8 bits : chiffre hexa position 1 et 0
    i_AFF1       : in   STD_LOGIC_VECTOR (3 downto 0);  -- donnee a afficher sur 8 bits : chiffre hexa position 1 et 0
    o_AFFSSD_Sim : out string(1 to 2);
    o_AFFSSD     : out  STD_LOGIC_VECTOR (7 downto 0)
  );
  end component;
  
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

begin

  ----------------------------------------
  -- Module Synchro
  ----------------------------------------
  inst_synch : synchro_module_v2
  generic map (const_CLK_syst_MHz => freq_sys_MHz) port map (
    clkm     => sysclk,
    o_CLK_5MHz   => clk_5MHz,
    o_S_1Hz    => d_S_1Hz
  );
  
  DEL3 <= d_S_1Hz;

  ----------------------------------------
  -- Thermo2Bin converts to ADCbin
  ----------------------------------------
  thermo_2_bin : Thermo2Bin port map (
    thermo_bus => ADCth,
    binary_out => ADCbin,
    error => error
  );
  
  ----------------------------------------
  -- PMOD DELs
  ----------------------------------------
  before_decoder : Fct_2_3 port map (
    ADCbin => ADCbin,
    A2_3 => A2_3
  );
  
  to_pmod : Decodeur_3_8 port map (
    control_bits => A2_3,
    bus_out => o_pmodled
  );
  
  ----------------------------------------
  -- Parite
  ----------------------------------------
  parity : parity_check port map (
    ADCbin => ADCbin,
    S1 => S1,
    Parite => parite_out 
  );
  
  DEL2 <= parite_out; -- marche pas encore
  o_led(0) <= parite_out;
  
  ----------------------------------------
  -- Afficheur 7 segments
  ----------------------------------------
  manageBCD : Bin2DualBCD port map (
    ADCBin => ADCBin,
    Dizaines => Dizaines,
    Unite_ns => Unite_ns,
    Code_signe => Code_signe,
    Unite_s => Unite_s
  );
  
  mux_avant_7_segments :  Mux port map (
    ADCbin     => ADCBin,
    Dizaines   => Dizaines,
    Unites_ns  => Unite_ns,
    Code_signe => Code_signe,
    Unite_s    => Unite_s,
    BTN        => i_btn(1 downto 0),
    erreur     => error,
    S2         => S2,
    DAFF0      => d_AFF0,
    DAFF1      => d_AFF1
  );
  
  inst_aff :  septSegments_Top port map (
    clk  => clk_5MHz,
    -- donnee a afficher definies sur 8 bits : chiffre hexa position 1 et 0
    i_AFF1  => d_AFF1,
    i_AFF0  => d_AFF0,
    o_AFFSSD_Sim   => open, -- ne pas modifier le "open". Ligne pour simulations seulement.
    o_AFFSSD     => o_SSD   -- sorties directement adaptees au connecteur PmodSSD
  );
  
  -- Vas dans le MUX.
  --led_test_btn <= i_btn(2 downto 0);

  --d_opa         <=  i_sw;  -- operande A sur interrupteurs
  --d_opb         <=  i_btn; -- operande B sur boutons
  --d_cin         <=  '0';   -- la retenue d'entr�e alterne 0 1 a 1 Hz

  --d_AFF0        <=  ADCth(11 downto 7);--d_sum(4 downto 0);        -- Le resultat de votre additionneur affich� sur PmodSSD(0)
  --d_AFF1        <=  ADCth(6 downto 2); --'0' & '0' & '0' & '0' & d_Cout; -- La retenue de sortie affich�e sur PmodSSD(1) (0 ou 1)
  --o_led6_r      <=  d_Cout;                   -- La led couleur repr�sente aussi la retenue en sortie  Cout
  --o_pmodled       <=  d_opa & d_opb;          -- Les op�randes d'entr�s reproduits combin�s sur Pmod8LD
  --o_led (3 downto 0)  <=  '0' & '0' & '0' & d_S_1Hz;   -- La LED0 sur la carte repr�sente la retenue d'entr�e

end BEHAVIORAL;


