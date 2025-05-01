----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/30/2025 03:19:19 PM
-- Design Name:
-- Module Name: Add1BitA - Behavioral
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

entity Add1BitA is
    Port ( X : in STD_LOGIC;
           Y : in STD_LOGIC;
           Ci : in STD_LOGIC;
           O : out STD_LOGIC;
           Co : out STD_LOGIC);
end Add1BitA;

architecture Behavioral of Add1BitA is

begin

  O <= (X xor Y) xor Ci;
  Co <= ((X xor Y) and Ci) or (X and Y);

end;
