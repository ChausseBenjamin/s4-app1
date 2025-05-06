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
    BTN        : in  STD_LOGIC_VECTOR (1 downto 0);
    erreur     : in  STD_LOGIC;
    S2         : in  STD_LOGIC;
    DAFF0      : out STD_LOGIC_VECTOR (3 downto 0);
    DAFF1      : out STD_LOGIC_VECTOR (3 downto 0));
end Mux;

architecture Behavioral of Mux is

  constant pressed : STD_LOGIC := '1';

  constant char_E : STD_LOGIC_VECTOR(3 downto 0) := "1110";  -- E
  constant char_r : STD_LOGIC_VECTOR(3 downto 0) := "1111";  -- r (for "Er")

begin

  decide : process(ADCBin, Dizaines, Unites_ns, BTN, erreur, S2, Code_signe, Unite_s)
    begin
      -- HANDLE SWITCH {{{
      if ( (S2 = pressed) or (erreur = '1')) then
        DAFF1 <= char_E;
        DAFF0 <= char_r;
      -- }}}
      else
      -- HANDLE BUTTONS {{{
        case (BTN) is
          when "00" =>
            DAFF0 <= Unites_ns;
            DAFF1 <= Dizaines;
          when "01" =>
            -- impossible de buster "C" en hex
            -- encore moins avoir une deuxième décimale
            -- on mets donc les "Dizaines" à zéro
            DAFF0 <= ADCbin;
            DAFF1 <= "0000";
          when "10" =>
            DAFF0 <= Unite_s;
            DAFF1 <= Code_signe;
          when "11" =>
            DAFF1 <= char_E;
            DAFF0 <= char_r;
          when others =>
            DAFF1 <= char_E;
            DAFF0 <= char_r;
        end case;
        -- }}}
      end if;

  end process;

end Behavioral;
