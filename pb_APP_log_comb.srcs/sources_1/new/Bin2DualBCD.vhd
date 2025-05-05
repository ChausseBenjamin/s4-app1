----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2025 04:00:18 PM
-- Design Name: 
-- Module Name: Bin2DualBCD - Behavioral
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

entity Bin2DualBCD is
    Port ( ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
           Dizaines : out STD_LOGIC_VECTOR (3 downto 0);
           Unite_ns : out STD_LOGIC_VECTOR (3 downto 0);
           Code_signe : out STD_LOGIC_VECTOR (3 downto 0);
           Unite_s : out STD_LOGIC_VECTOR (3 downto 0));
end Bin2DualBCD;

architecture Behavioral of Bin2DualBCD is
    component Bin2DualBCD_S is Port ( 
        signed_in : in STD_LOGIC_VECTOR (3 downto 0);
        signed_code : out STD_LOGIC_VECTOR (3 downto 0);
        signed_units : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    component Bin2DualBCD_NS is Port (
        binary_4bit_in : in STD_LOGIC_VECTOR (3 downto 0);
        units_out : out STD_LOGIC_VECTOR (3 downto 0);
        dizaines_out : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
begin
    signed_output : Bin2DualBCD_S port map (
        signed_in => ADCBin,
        signed_code => Code_signe,
        signed_units => Unite_s
    );
    
    unsigned_ouput : Bin2DualBCD_NS port map (
        binary_4bit_in => ADCBin,
        units_out => Unite_ns,
        dizaines_out => Dizaines
    );

end Behavioral;
