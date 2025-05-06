----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2025 02:21:36 PM
-- Design Name: 
-- Module Name: Bin2DualBCD_S - Behavioral
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

entity Bin2DualBCD_S is
    Port ( signed_in : in STD_LOGIC_VECTOR (3 downto 0);
           signed_code : out STD_LOGIC_VECTOR (3 downto 0);
           signed_units : out STD_LOGIC_VECTOR (3 downto 0));
end Bin2DualBCD_S;

architecture Behavioral of Bin2DualBCD_S is

begin

    process (signed_in)
    begin
        case (signed_in) is
            when "0000" =>
                signed_units <= "0000";
                signed_code <= "0000";
            when "0001" =>
                signed_units <= "0001";
                signed_code <= "0000";
            when "0010" =>
                signed_units <= "0010";
                signed_code <= "0000";
            when "0011" =>
                signed_units <= "0011";
                signed_code <= "0000";
            when "0100" =>
                signed_units <= "0100";
                signed_code <= "0000";
            when "0101" =>
                signed_units <= "0101";
                signed_code <= "0000";
            when "0110" =>
                signed_units <= "0110";
                signed_code <= "0000";
            when "0111" =>
                signed_units <= "0111";
                signed_code <= "0000";
            when "1000" =>
                signed_units <= "1000";
                signed_code <= "1101";
            when "1001" =>
                signed_units <= "0111";
                signed_code <= "1101";
            when "1010" =>
                signed_units <= "0110";
                signed_code <= "1101";
            when "1011" =>
                signed_units <= "0101";
                signed_code <= "1101";
            when "1100" =>
                signed_units <= "0100";
                signed_code <= "1101";
            when "1101" =>
                signed_units <= "0011";
                signed_code <= "1101";
            when "1110" =>
                signed_units <= "0010";
                signed_code <= "1101";
            when "1111" =>
                signed_units <= "0001";
                signed_code <= "1101";
            when others =>
                signed_units <= "1111";
                signed_code <= "1110";
        end case;
    end process;

end Behavioral;
