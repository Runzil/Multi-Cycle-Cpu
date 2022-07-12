library IEEE;
use IEEE.STD_LOGIC_1164.all;

package MUX2to1_5bit_package is --declaring a package
    type Matrix5x2bit is array (1 downto 0) of STD_LOGIC_VECTOR(4 downto 0); --create a 2x5bit array as an input for the mux
end MUX2to1_5bit_package;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MUX2to1_5bit_package.all;

entity MUX2to1_5bit is
	PORT( Instr15_11 : in Matrix5x2bit;
			RF_B_SEL	  : in STD_LOGIC;
			MUX2to1_5bitOut: out STD_LOGIC_VECTOR(4 downto 0));
end MUX2to1_5bit;


architecture Behavioral of MUX2to1_5bit is
signal MuxoutSignal : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

begin
	MuxoutSignal<= Instr15_11(0) when RF_B_SEL = '0' else  --choosing output according to sel
						Instr15_11(1) when RF_B_SEL = '1';

		MUX2to1_5bitOut <= MuxoutSignal after 10 ns;
end Behavioral;

