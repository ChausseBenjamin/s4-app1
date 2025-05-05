----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2025 09:48:51 AM
-- Design Name: 
-- Module Name: Thermo2Bin - Behavioral
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

entity Thermo2Bin is
    Port ( thermo_bus : in STD_LOGIC_VECTOR (11 downto 0);
           binary_out : out STD_LOGIC_VECTOR (3 downto 0);
           error : out STD_LOGIC);
end Thermo2Bin;

architecture Behavioral of Thermo2Bin is
    signal first_segment_of_four : STD_LOGIC_VECTOR(3 downto 0);
    signal second_segment_of_four : STD_LOGIC_VECTOR(3 downto 0);
    signal third_segment_of_four : STD_LOGIC_VECTOR(3 downto 0);
    
    component Add4Bits is
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
            B : in STD_LOGIC_VECTOR (3 downto 0);
            C : in STD_LOGIC;
            R : out STD_LOGIC_VECTOR (3 downto 0);
            Rc : out STD_LOGIC);
    end component;
    
    signal first_plus_second : STD_LOGIC_VECTOR(3 downto 0);
    signal carry_out_first_plus_second : STD_LOGIC;
    signal last_carry_out : STD_LOGIC;
    
begin 
    -- A, B, C, D
    -- 11, 10, 9, 8
    first_segment_of_four(3) <= '0';            -- E
    first_segment_of_four(2) <= thermo_bus(11); -- F = A
    first_segment_of_four(1) <= NOT thermo_bus(11) AND thermo_bus(9); -- G = A'C
    first_segment_of_four(0) <= NOT thermo_bus(11) AND ((NOT thermo_bus(9) AND thermo_bus(8)) OR (thermo_bus(10) AND thermo_bus(9))); -- H = A'(C'D+BC)
    --                    C                        AND D ( B OR NOT A)
    --error_first <= NOT (((thermo_bus(9) AND thermo_bus(8)) AND (thermo_bus(10) OR NOT thermo_bus(11))) OR ((NOT thermo_bus(11) AND NOT thermo_bus(10)) AND (thermo_bus(8) OR NOT thermo_bus(9))));
    
    -- 7, 6, 5, 4
    second_segment_of_four(3) <= '0';            -- E
    second_segment_of_four(2) <= thermo_bus(7); -- F = A
    second_segment_of_four(1) <= NOT thermo_bus(7) AND thermo_bus(5); -- G = A'C
    second_segment_of_four(0) <= NOT thermo_bus(7) AND ((NOT thermo_bus(5) AND thermo_bus(4)) OR (thermo_bus(6) AND thermo_bus(5))); -- H = A'(C'D+BC)
    --
    --error_second <= NOT (((thermo_bus(5) AND thermo_bus(4)) AND (thermo_bus(6) OR NOT thermo_bus(7))) OR ((NOT thermo_bus(7) AND NOT thermo_bus(6)) AND (thermo_bus(4) OR NOT thermo_bus(5))));
    
    -- 3, 2, 1, 0
    third_segment_of_four(3) <= '0';            -- E
    third_segment_of_four(2) <= thermo_bus(3); -- F = A
    third_segment_of_four(1) <= NOT thermo_bus(3) AND thermo_bus(1); -- G = A'C
    third_segment_of_four(0) <= NOT thermo_bus(3) AND ((NOT thermo_bus(1) AND thermo_bus(0)) OR (thermo_bus(2) AND thermo_bus(1))); -- H = A'(C'D+BC)
    --
    --error_third <= NOT (((thermo_bus(1) AND thermo_bus(0)) AND (thermo_bus(2) OR NOT thermo_bus(3))) OR ((NOT thermo_bus(3) AND NOT thermo_bus(2)) AND (thermo_bus(0) OR NOT thermo_bus(1))));
    
    -- Addition des 3 compte ensemble
    first_plus_second_adder : Add4Bits port map (
        A => first_segment_of_four,
        B => second_segment_of_four,
        R => first_plus_second,
        Rc => carry_out_first_plus_second,
        C => '0'
    );
    
    plus_third_adder : Add4Bits port map (
        A => first_plus_second,
        B => third_segment_of_four,
        R => binary_out,
        Rc => last_carry_out,
        C => carry_out_first_plus_second
    );
    
    error <= (
    (thermo_bus(11) AND NOT thermo_bus(10)) OR
    (thermo_bus(10) AND NOT thermo_bus(9)) OR
    (thermo_bus(9)  AND NOT thermo_bus(8)) OR
    (thermo_bus(8)  AND NOT thermo_bus(7)) OR
    (thermo_bus(7)  AND NOT thermo_bus(6)) OR
    (thermo_bus(6)  AND NOT thermo_bus(5)) OR
    (thermo_bus(5)  AND NOT thermo_bus(4)) OR
    (thermo_bus(4)  AND NOT thermo_bus(3)) OR
    (thermo_bus(3)  AND NOT thermo_bus(2)) OR
    (thermo_bus(2)  AND NOT thermo_bus(1)) OR
    (thermo_bus(1)  AND NOT thermo_bus(0))
    );
    
end Behavioral;
