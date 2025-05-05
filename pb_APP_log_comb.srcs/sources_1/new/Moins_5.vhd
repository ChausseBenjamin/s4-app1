----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/05/2025 09:51:29 AM
-- Design Name:
-- Module Name: Moins_5 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Moins_5 is Port (
  ADCbin : in  STD_LOGIC_VECTOR (3 downto 0);
  Moins5 : out STD_LOGIC_VECTOR (3 downto 0));
end Moins_5;


architecture Behavioral of Moins_5 is

  component Add4Bits is Port (
    A  : in  STD_LOGIC_VECTOR (3 downto 0);
    B  : in  STD_LOGIC_VECTOR (3 downto 0);
    C  : in  STD_LOGIC;
    R  : out STD_LOGIC_VECTOR (3 downto 0);
    Rc : out STD_LOGIC);
  end component;

  signal sink : STD_LOGIC;

  -- five = "0l01" -> not_five = "1010"
  -- neg_five = not_five ADD 1 = "1011"
  -- X-5 = X+( neg_five)
  constant neg_five : std_logic_vector(3 downto 0):= "1011";

begin

  adder : Add4Bits port map (
    A  => neg_five,
    B  => ADCbin,
    C  => '0',
    Rc => sink,
    R  => Moins5);

end Behavioral;
