----------------------------------------------------------------------------------
-- Company:
-- Engineer: BenTheMan
--
-- Create Date: 04/30/2025 01:11:03 PM
-- Design Name:
-- Module Name: full_adder - Behavioral
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

entity full_adder is
    Port ( c_in : in STD_LOGIC;
           a : in STD_LOGIC;
           b : in STD_LOGIC;
           o : out STD_LOGIC;
           c_o : out STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is

  signal aXb : STD_LOGIC;

begin

  aXb <= a xor b;

  o <= aXb xor c_in;
  c_o <= (aXb and c_in) or (a and b);


end Behavioral;
