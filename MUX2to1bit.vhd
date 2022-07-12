library IEEE;
use IEEE.STD_LOGIC_1164.all;

package Mux2to1bit_package is		--declaring a package
    type MUX2to1bitArray is array (1 downto 0) of STD_LOGIC_VECTOR(31 downto 0);	--create a 2x32bit array as an input for the mux
end Mux2to1bit_package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Mux2to1bit_package.all;

entity MUX2to1bit is
	Port( MUX2In : in MUX2to1bitArray;
			Pc_Sel : in STD_LOGIC;
			MUX2Out: out STD_LOGIC_VECTOR(31 downto 0));
end MUX2to1bit;

architecture Behavioral of MUX2to1bit is
signal Muxout : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
	
	Muxout<= MUX2In(0) when Pc_Sel = '0' else --choosing output according to sel
				MUX2In(1) when Pc_Sel= '1';
	
	MUX2Out <= Muxout after 10 ns;
	
end Behavioral;

