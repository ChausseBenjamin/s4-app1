----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2025 03:20:07 PM
-- Design Name: 
-- Module Name: Fct_2_3 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Multiply a 4 bit number and get an approximation.
-- Works for 0 to 12, it's off above.
-- 12 is the highest good input value because of thermometric 12 bits encoding.
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

entity Fct_2_3 is
    Port ( ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
           A2_3 : out STD_LOGIC_VECTOR (3 downto 0));
end Fct_2_3;

architecture Behavioral of Fct_2_3 is
    signal shifted_once : STD_LOGIC_VECTOR(3 downto 0);
    signal shifted_twice : STD_LOGIC_VECTOR(3 downto 0);
    signal shifted_thrice : STD_LOGIC_VECTOR(3 downto 0);
    signal carry_out : STD_LOGIC;
    
    component Add4Bits is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C : in STD_LOGIC;
           R : out STD_LOGIC_VECTOR (3 downto 0);
           Rc : out STD_LOGIC);
    end component;
begin
    -- N x 2^-1 : shifted once
    shifted_once <= '0' & ADCbin(3 downto 1);

    -- N x 2^-3 : shifted thrice
    shifted_twice <= '0' & shifted_once(3 downto 1);
    shifted_thrice <= '0' & shifted_twice(3 downto 1);
    
    -- Both are then added to give the result of the 2/3 multiplication (0.625)
    result : Add4Bits port map (
        A  => "0110",
        B  => "0001",
        C => '0',
        R => A2_3,
        Rc => carry_out
    );
end Behavioral;
