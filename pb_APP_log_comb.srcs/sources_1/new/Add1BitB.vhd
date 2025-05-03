----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/30/2025 03:19:19 PM
-- Design Name:
-- Module Name: Add1BitB - Behavioral
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

entity Add1BitB is
    Port ( X : in STD_LOGIC;
           Y : in STD_LOGIC;
           Ci : in STD_LOGIC;
           O : out STD_LOGIC;
           Co : out STD_LOGIC);
end Add1BitB;

architecture Behavioral of Add1BitB is

begin

Adder: process(X, Y, Ci) is
  variable buf: STD_LOGIC_VECTOR(2 downto 0);
begin
  buf(0) := X;
  buf(1) := Y;
  buf(2) := Ci;

     case (buf) is
      when "000" =>
         O <= '0';
         Co <= '0';
      when "001" =>
         O <= '1';
         Co <= '0';
      when "010" =>
         O <= '1';
         Co <= '0';
      when "011" =>
         O <= '0';
         Co <= '1';
      when "100" =>
         O <= '1';
         Co <= '0';
      when "101" =>
         O <= '0';
         Co <= '1';
      when "110" =>
         O <= '0';
         Co <= '1';
      when "111" =>
         O <= '1';
         Co <= '1';
      when others =>
         O <= '0';
         Co <= '0';
   end case;

end process Adder;



end Behavioral;
