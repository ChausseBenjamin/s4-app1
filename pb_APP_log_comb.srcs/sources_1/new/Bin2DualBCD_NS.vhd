----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2025 09:17:59 PM
-- Design Name: 
-- Module Name: Bin2DualBCD_NS - Behavioral
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

entity Bin2DualBCD_NS is
    Port ( binary_4bit_in : in STD_LOGIC_VECTOR (3 downto 0);
           units_out : out STD_LOGIC_VECTOR (3 downto 0);
           dizaines_out : out STD_LOGIC_VECTOR (3 downto 0));
end Bin2DualBCD_NS;

architecture Behavioral of Bin2DualBCD_NS is

begin
    -- Demander de le faire avec une structure CASE
    process (binary_4bit_in)
    begin
        case (binary_4bit_in) is
            when "0000" =>
                units_out <= "0000";
                dizaines_out <= "0000";
            when "0001" =>
                units_out <= "0001";
                dizaines_out <= "0000";
            when "0010" =>
                units_out <= "0010";
                dizaines_out <= "0000";
            when "0011" =>
                units_out <= "0011";
                dizaines_out <= "0000";
            when "0100" =>
                units_out <= "0100";
                dizaines_out <= "0000";
            when "0101" =>
                units_out <= "0101";
                dizaines_out <= "0000";
            when "0110" =>
                units_out <= "0110";
                dizaines_out <= "0000";
            when "0111" =>
                units_out <= "0111";
                dizaines_out <= "0000";
            when "1000" =>
                units_out <= "1000";
                dizaines_out <= "0000";
            when "1001" =>
                units_out <= "1001";
                dizaines_out <= "0000";
            when "1010" =>
                units_out <= "0000";
                dizaines_out <= "0001";
            when "1011" =>
                units_out <= "0001";
                dizaines_out <= "0001";
            when "1100" =>
                units_out <= "0010";
                dizaines_out <= "0001";
            when "1101" =>
                units_out <= "0011";
                dizaines_out <= "0001";
            when "1110" =>
                units_out <= "0100";
                dizaines_out <= "0001";
            when "1111" =>
                units_out <= "0101";
                dizaines_out <= "0001";
            when others =>
                units_out <= "0000";
                dizaines_out <= "0000";
        end case;
    end process;

end Behavioral;
