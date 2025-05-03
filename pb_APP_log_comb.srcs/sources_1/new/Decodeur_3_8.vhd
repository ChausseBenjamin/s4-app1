----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2025 06:23:40 PM
-- Design Name: 
-- Module Name: Decodeur_3_8 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 3 to 8 decoder.
-- No enables given as they are not necessary for the use this will have in the APP.
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

entity Decodeur_3_8 is
    Port ( control_bits : in STD_LOGIC_VECTOR (2 downto 0);
           bus_out : out STD_LOGIC_VECTOR (7 downto 0));
end Decodeur_3_8;

architecture Behavioral of Decodeur_3_8 is
    signal AIs0 : STD_LOGIC;
    signal BIs0 : STD_LOGIC;
    signal CIs0 : STD_LOGIC;
    signal AIs1 : STD_LOGIC;
    signal BIs1 : STD_LOGIC;
    signal CIs1 : STD_LOGIC;
begin
    CIs1 <= control_bits(0);
    BIs1 <= control_bits(1);
    AIs1 <= control_bits(2);
    
    AIs0 <= NOT AIs1;
    BIs0 <= NOT BIs1;
    CIs0 <= NOT CIs1;

    bus_out(0) <= AIs0 AND BIs0 AND CIs0;
    bus_out(1) <= AIs0 AND BIs0 AND CIs1;
    bus_out(2) <= AIs0 AND BIs1 AND CIs0;
    bus_out(3) <= AIs0 AND BIs1 AND CIs1;
    bus_out(4) <= AIs1 AND BIs0 AND CIs0;
    bus_out(5) <= AIs1 AND BIs0 AND CIs1;
    bus_out(6) <= AIs1 AND BIs1 AND CIs0;
    bus_out(7) <= AIs1 AND BIs1 AND CIs1;

end Behavioral;
