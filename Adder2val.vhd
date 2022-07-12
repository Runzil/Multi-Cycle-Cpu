library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Adder2val is
Port( Adder2valIn1 : in STD_LOGIC_VECTOR(31 downto 0);
		Adder2valIn2: in STD_LOGIC_VECTOR(31 downto 0);
		Adder2valOut: out STD_LOGIC_VECTOR(31 downto 0)
);

end Adder2val;

architecture Behavioral of Adder2val is


begin
Adder2valOut <= signed(Adder2valIn2) + signed(Adder2valIn1)  after 10 ns; --adding the 2 values

end Behavioral;

