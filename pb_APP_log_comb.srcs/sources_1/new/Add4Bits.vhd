----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/30/2025 03:19:19 PM
-- Design Name:
-- Module Name: Add4Bits - Behavioral
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

entity Add4Bits is
    Port ( A : in STD_LOGIC_VECTOR (0 to 3);
           B : in STD_LOGIC_VECTOR (0 to 3);
           C : in STD_LOGIC;
           R : out STD_LOGIC_VECTOR (0 to 3);
           Rc : out STD_LOGIC);
end Add4Bits;

architecture Behavioral of Add4Bits is

  signal bufA : STD_LOGIC;
  signal bufB : STD_LOGIC;
  signal bufC : STD_LOGIC;

  component Add1BitA is
    Port (
     X : in STD_LOGIC;
     Y : in STD_LOGIC;
     Ci: in STD_LOGIC;
     O : out STD_LOGIC;
     Co: out STD_LOGIC
  );
  end component;

  component Add1BitB is
    Port (
     X : in STD_LOGIC;
     Y : in STD_LOGIC;
     Ci: in STD_LOGIC;
     O : out STD_LOGIC;
     Co: out STD_LOGIC
  );
  end component;

begin

  first : Add1BitA port map (
    X  => A(0),
    Y  => B(0),
    Ci => C,
    O => R(0),
    Co => bufA
  );

  sec : Add1BitA port map (
    X  => A(1),
    Y  => B(1),
    Ci => bufA,
    O => R(1),
    Co => bufB
  );

  third : Add1BitB port map (
    X  => A(2),
    Y  => B(2),
    Ci => bufB,
    O => R(2),
    Co => bufC
  );

  fourth : Add1BitB port map (
    X  => A(3),
    Y  => B(3),
    Ci => bufC,
    O => R(3),
    Co => Rc
  );

end Behavioral;
