library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder5to32 is
    Port( DataInDec  : in STD_LOGIC_VECTOR(4 downto 0); 
            DataOutDec : out STD_LOGIC_VECTOR(31 downto 0));
end Decoder5to32;

architecture Behavioral of Decoder5to32 is
signal DataOutDecSignal :STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
    DataOutDecSignal <= 		"00000000000000000000000000000001" when DataInDec = "00000" else 
                              "00000000000000000000000000000010" when DataInDec = "00001" else
                              "00000000000000000000000000000100" when DataInDec = "00010" else
                              "00000000000000000000000000001000" when DataInDec = "00011" else
                              "00000000000000000000000000010000" when DataInDec = "00100" else
										"00000000000000000000000000100000" when DataInDec = "00101" else
                              "00000000000000000000000001000000" when DataInDec = "00110" else
                              "00000000000000000000000010000000" when DataInDec = "00111" else
                              "00000000000000000000000100000000" when DataInDec = "01000" else
                              "00000000000000000000001000000000" when DataInDec = "01001" else
                              "00000000000000000000010000000000" when DataInDec = "01010" else
                              "00000000000000000000100000000000" when DataInDec = "01011" else
                              "00000000000000000001000000000000" when DataInDec = "01100" else
                              "00000000000000000010000000000000" when DataInDec = "01101" else
                              "00000000000000000100000000000000" when DataInDec = "01110" else
                              "00000000000000001000000000000000" when DataInDec = "01111" else
                              "00000000000000010000000000000000" when DataInDec = "10000" else
                              "00000000000000100000000000000000" when DataInDec = "10001" else
                              "00000000000001000000000000000000" when DataInDec = "10010" else
                              "00000000000010000000000000000000" when DataInDec = "10011" else
                              "00000000000100000000000000000000" when DataInDec = "10100" else
                              "00000000001000000000000000000000" when DataInDec = "10101" else
                              "00000000010000000000000000000000" when DataInDec = "10110" else
                              "00000000100000000000000000000000" when DataInDec = "10111" else
                              "00000001000000000000000000000000" when DataInDec = "11000" else
                              "00000010000000000000000000000000" when DataInDec = "11001" else
                              "00000100000000000000000000000000" when DataInDec = "11010" else
                              "00001000000000000000000000000000" when DataInDec = "11011" else
                              "00010000000000000000000000000000" when DataInDec = "11100" else
                              "00100000000000000000000000000000" when DataInDec = "11101" else
                              "01000000000000000000000000000000" when DataInDec = "11110" else
                              "10000000000000000000000000000000" when DataInDec = "11111"; 
        DataOutDec <= DataOutDecSignal after 10ns;
end Behavioral;