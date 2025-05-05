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
           A2_3 : out STD_LOGIC_VECTOR (2 downto 0));
end Fct_2_3;

architecture Behavioral of Fct_2_3 is
    signal shifted_once : STD_LOGIC_VECTOR(3 downto 0);
    signal shifted_twice : STD_LOGIC_VECTOR(3 downto 0);
    signal shifted_thrice : STD_LOGIC_VECTOR(3 downto 0);
    signal carry_in : STD_LOGIC;
    signal carry_out : STD_LOGIC;
    signal added : STD_LOGIC_VECTOR(3 downto 0);
    
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
    
    -- If we shifted 4 times... There's cases where the decimal point would cause a carry in to exist!
    -- If we don't take that into account... the number 4 will NEVER show up!
    -- Here's how to figure out if there can be a carry in
    -- 1001 -> 0100,1, so index 0 is when it's shifted once
    -- 1100 -> 0001,1  so index 2 is the deecimal when shifted 3 times.
    -- If both are true, the addition should've made a carry in!
    carry_in <= ADCbin(0) AND ADCbin(2);
    
    -- Both are then added to give the result of the 2/3 multiplication (0.625)
    result : Add4Bits port map (
        A  => shifted_once,
        B  => shifted_thrice,
        C => carry_in,
        R => added,
        Rc => carry_out
    );
    
    -- The functional specifications require an output of 2 downto 0. MSB would never be 1 anyways.
    A2_3 <= added(2 downto 0);
end Behavioral;
