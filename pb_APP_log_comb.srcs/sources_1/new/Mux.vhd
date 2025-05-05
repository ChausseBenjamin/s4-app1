-------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/03/2025 08:02:39 PM
-- Design Name:
-- Module Name: Mux - Behavioral
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
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux is port (
    ADCbin     : in  STD_LOGIC_VECTOR (3 downto 0);
    Dizaines   : in  STD_LOGIC_VECTOR (3 downto 0);
    Unites_ns  : in  STD_LOGIC_VECTOR (3 downto 0);
    Code_signe : in  STD_LOGIC_VECTOR (3 downto 0);
    Unite_s    : in  STD_LOGIC_VECTOR (3 downto 0);
    BTN        : in  STD_LOGIC_VECTOR (2 downto 0);
    erreur     : in  STD_LOGIC;
    S1         : in  STD_LOGIC;
    S2         : in  STD_LOGIC;
    DAFF0      : out STD_LOGIC_VECTOR (3 downto 0);
    DAFF1      : out STD_LOGIC_VECTOR (3 downto 0));
end Mux;

architecture Behavioral of Mux is

  constant pressed : STD_LOGIC := '1';

  constant msg_Err   : STD_LOGIC_VECTOR(9 downto 0)   := "01110" & "10001";
  -- constant char_neg  : STD_LOGIC_VECTOR(4 downto 0) := "10000";
  -- constant char_ndef : STD_LOGIC_VECTOR(4 downto 0) := "10010";

  signal break : BOOLEAN := FALSE;

  signal unit_input_buf  : STD_LOGIC_VECTOR(4 downto 0);
  signal tens_input_buf  : STD_LOGIC_VECTOR(4 downto 0);

  signal unit_sim_sink : string(1 to 1);
  signal tens_sim_sink : string(1 to 1);

  component septSegments_encodeur is Port(
    i_AFF : in  STD_LOGIC_VECTOR(3 downto 0);  -- caractère à afficher
    o_Seg : out STD_LOGIC_VECTOR(6 downto 0);  -- encodage 7-segments
    o_CharacterePourSim : out string(1 to 1)); -- pour simulation seulement
  end component;

begin

  unit_converter : septSegments_encodeur port map (
    i_AFF => unit_input_buf,
    o_Seg => DAFF0,
    o_CharacterePourSim => unit_sim_sink);

  tens_converter : septSegments_encodeur port map (
    i_AFF => tens_input_buf,
    o_Seg => DAFF1,
    o_CharacterePourSim => tens_sim_sink);

  decide : process
    begin
      -- HANDLE SWITCHES {{{
      if S2 = pressed then
        break <= TRUE; -- Avoids double printing on 7seg
        unit_input_buf <= msg_Err(9 downto 5);
        tens_input_buf <= msg_Err(4 downto 0);
      else
        if S1 = pressed then
          -- TODO: parité paire sur LD0 (Zybo) et DEL2 (carte thermo)
        else
          -- TODO: parité impaire sur LD0 (Zybo) et DEL2 (carte thermo)
        end if;
      end if;
      -- }}}
      -- HANDLE BUTTONS {{{
      if break = FALSE then
        case (BTN) is
          when "00" =>
             -- TODO: BCD sur 7Seg.
          when "01" =>
             -- TODO: Hex sur 7Seg.
          when "10" =>
             -- TODO: (BCD-5) sur 7Seg.
          when "11" =>
            unit_input_buf <= msg_Err(9 downto 5);
            tens_input_buf <= msg_Err(4 downto 0);
          when others =>
            unit_input_buf <= msg_Err(9 downto 5);
            tens_input_buf <= msg_Err(4 downto 0);
       end case;
      end if;
      -- }}}

  end process;

end Behavioral;
