library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.all;

entity ALU is
	 Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           Op : in STD_LOGIC_VECTOR (3 downto 0);
           Dout : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC;
           Cout : out STD_LOGIC;
           Ovf : out STD_LOGIC);
end ALU;


architecture Behavioral of ALU is
signal OutSignal :STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal CoutSignal : STD_LOGIC_VECTOR (32 downto 0) := (others => '0');
signal ZeroSignal : STD_LOGIC:= '0';
signal OvfSignal : STD_LOGIC:= '0';

begin
	
		OutSignal <= signed(A) + signed(B) 	 when Op = "0000" else --ADD
						 signed(A) - signed(B) 	 when Op="0001" else	  --SUBTRACT
						 A AND B				 		 when Op="0010" else	  --AND
						 A OR B 				 		 when Op="0011" else   --OR	
						 NOT A 					 	 when Op="0100" else   --INVERSE A
						 A NAND B 				 	 when Op="0101" else   --NAND
						 A NOR B 				 	 when Op="0110" else   --NOR
						 A(31) & A(31 downto 1)  when Op="1000" else   --ARITHMETIC SHIFT RIGHT
						 '0' & A(31 downto 1)    when Op="1001" else   --LOGIC SHIFT RIGHT
						 A(30 downto 0) & '0'    when Op="1010" else   --LOGIC SHIFT LEFT
						 A(30 downto 0) & A(31)  when Op="1100" else   --ROTATE LEFT
						 A(0) & A(31 downto 1)   when Op="1101";		  --ROTATE RIGHT


		CoutSignal <= ('0' & A) + ('0' & B) when (Op="0000" OR Op="0001") else --calculating carry out 
						   "000000000000000000000000000000000" when not (Op= "0000") ;
							
		Cout<=CoutSignal(32) after 10 ns;				


		ZeroSignal <= '1' when OutSignal = "00000000000000000000000000000000" else --calculating zero
						  '0';
		
		Zero <= ZeroSignal after 10 ns;
				  
		OvfSignal <= (A(31) XOR OutSignal(31)) when (((A(31) XNOR B(31)) = '1' ) AND Op = "0000") OR (((A(31) XOR B(31))= '1') AND Op = "0001") --calculating overflow
						  else '0';
		Ovf<= OvfSignal after 10 ns;

		Dout <= OutSignal after 10 ns;
end Behavioral;



