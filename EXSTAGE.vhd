library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Mux2to1bit_package.all;

entity EXSTAGE is
	Port(RF_A : in STD_LOGIC_VECTOR(31 downto 0);
		  RF_B : in STD_LOGIC_VECTOR(31 downto 0);
		  Immed: in STD_LOGIC_VECTOR(31 downto 0);
		  ALU_Bin_sel: in STD_LOGIC;
		  ALU_func: in STD_LOGIC_VECTOR(3 downto 0);
		  ALU_out: out STD_LOGIC_VECTOR(31 downto 0);
		  ALU_zero: out STD_LOGIC;
		  Ex_Ovf:out STD_LOGIC;
		  Ex_Cout: out STD_LOGIC);
end EXSTAGE;

architecture Behavioral of EXSTAGE is
signal MUX2to1_32bitIn : MUX2to1bitArray;
signal MUX2to1_32bitOut : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

------------------------COMPONENTS------------------------------------------
Component ALU
	 Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           Op : in STD_LOGIC_VECTOR (3 downto 0);
           Dout : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC;
           Cout : out STD_LOGIC;
           Ovf : out STD_LOGIC);
end Component;

Component MUX2to1bit
	Port( MUX2In : in MUX2to1bitArray;
			Pc_Sel : in STD_LOGIC;
			MUX2Out: out STD_LOGIC_VECTOR(31 downto 0));
end Component;
----------------------------------------------------------------------------

begin

---------------------------------MUX----------------------------------------
MUX2to1_32bitIn(0) <= RF_B;
MUX2to1_32bitIn(1) <= Immed;
	
MUX2to1_32bits_EX_Module:
		MUX2to1bit	Port MAP( MUX2In => MUX2to1_32bitIn,
									 Pc_Sel => ALU_Bin_sel,
									 MUX2Out => MUX2to1_32bitOut);
---------------------------------ALU----------------------------------------
ALU_EX_Module:
		ALU Port MAP( A  => RF_A,
									B => MUX2to1_32bitOut,
									Op => ALU_func,
									Dout => ALU_out,
									Zero => ALU_zero,
									Cout => Ex_Cout,
									Ovf => Ex_Ovf );



end Behavioral;

