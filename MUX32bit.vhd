library IEEE;
use IEEE.STD_LOGIC_1164.all;

package arraypack is --package declaration
    type InArray is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0); --create a 32x32bit array as an input for the mux
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.arraypack.all;

entity MUX32bit is
 Port( DataInMux : in inArray;
         SEL : in STD_LOGIC_VECTOR(4 downto 0);
         DataOutMux : out STD_LOGIC_VECTOR(31 downto 0));
end MUX32bit;

architecture Behavioral of MUX32bit is

begin	
    DataOutMux <= 				DataInMux(0)  after 10 ns when SEL = "00000" else	--selecting dataout according to sel
                              DataInMux(1)  after 10 ns when SEL = "00001" else
                              DataInMux(2)  after 10 ns when SEL = "00010" else
                              DataInMux(3)  after 10 ns when SEL = "00011" else
                              DataInMux(4)  after 10 ns when SEL = "00100" else
                              DataInMux(5)  after 10 ns when SEL = "00101" else
                              DataInMux(6)  after 10 ns when SEL = "00110" else
                              DataInMux(7)  after 10 ns when SEL = "00111" else
                              DataInMux(8)  after 10 ns when SEL = "01000" else
                              DataInMux(9)  after 10 ns when SEL = "01001" else
                              DataInMux(10) after 10 ns when SEL = "01010" else
                              DataInMux(11) after 10 ns when SEL = "01011" else
                              DataInMux(12) after 10 ns when SEL = "01100" else
                              DataInMux(13) after 10 ns when SEL = "01101" else
                              DataInMux(14) after 10 ns when SEL = "01110" else
                              DataInMux(15) after 10 ns when SEL = "01111" else
                              DataInMux(16) after 10 ns when SEL = "10000" else
                              DataInMux(17) after 10 ns when SEL = "10001" else
                              DataInMux(18) after 10 ns when SEL = "10010" else
                              DataInMux(19) after 10 ns when SEL = "10011" else
                              DataInMux(20) after 10 ns when SEL = "10100" else
                              DataInMux(21) after 10 ns when SEL = "10101" else
                              DataInMux(22) after 10 ns when SEL = "10110" else
                              DataInMux(23) after 10 ns when SEL = "10111" else
                              DataInMux(24) after 10 ns when SEL = "11000" else
                              DataInMux(25) after 10 ns when SEL = "11001" else
                              DataInMux(26) after 10 ns when SEL = "11010" else
                              DataInMux(27) after 10 ns when SEL = "11011" else
                              DataInMux(28) after 10 ns when SEL = "11100" else
                              DataInMux(29) after 10 ns when SEL = "11101" else
                              DataInMux(30) after 10 ns when SEL = "11110" else
                              DataInMux(31) after 10 ns when SEL = "11111";
                              
end Behavioral;