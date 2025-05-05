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

    process (signed_in(3))
        begin
            case (signed_in(3)) is
                when '0' =>
                    signed_code <= "0000";
                when '1' =>
                    signed_code <= "1101";
                when others =>
                    signed_code <= "1110"; -- E
            end case;
     end process;

    -- Units are the same regardless of sign.
    process (signed_in(2 downto 0))
    begin
        case (signed_in(2 downto 0)) is
            when "000" =>
                signed_units <= "0000";
            when "001" =>
                signed_units <= "0001";
            when "010" =>
                signed_units <= "0010";
            when "011" =>
                signed_units <= "0011";
            when "100" =>
                signed_units <= "0100";
            when "101" =>
                signed_units <= "0101";
            when "110" =>
                signed_units <= "0110";
            when "111" =>
                signed_units <= "0111";
            when others =>
                signed_units <= "1111"; -- r
        end case;
     end process;

end Behavioral;
