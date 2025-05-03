----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/03/2025 03:20:01 PM
-- Design Name:
-- Module Name: parity_check - Behavioral
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

entity parity_check is
    Port ( ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
           S1 : in STD_LOGIC;
           Parite : out STD_LOGIC);
end parity_check;

architecture Behavioral of parity_check is

  signal Y : STD_LOGIC_VECTOR (2 downto 0);
  signal PreFlip : STD_LOGIC;

begin

  Y(0) <= ADCbin(0) xor ADCbin(1);
  Y(1) <= ADCbin(2) xor ADCbin(3);
  Y(2) <= Y(0) xor Y(1);

  flipCheck : process(Y, S1)
  begin

    case (S1) is
      when '0' =>
         Parite <= Y(2);
      when '1' =>
         Parite <= not Y(2);
      when others =>
         Parite <= '0';
   end case;

  end process;


end Behavioral;
