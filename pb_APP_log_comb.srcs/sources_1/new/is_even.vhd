----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/03/2025 12:04:25 PM
-- Design Name:
-- Module Name: is_even - Behavioral
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

entity is_even is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           o : out STD_LOGIC);
end is_even;

architecture Behavioral of is_even is

  signal y : STD_LOGIC_VECTOR (0 to 1);

begin

  y(0) <= x(0) xor x(1);
  y(1) <= x(2) xor x(3);
  o <= y(0) xor y(1);

end Behavioral;
