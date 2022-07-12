library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ImmedSelect is
Port ( InstrIn : in STD_LOGIC_VECTOR(15 downto 0);
		 ISelect : in STD_LOGIC_VECTOR(1 downto 0);
		 InstrOut : out STD_LOGIC_VECTOR(31 downto 0));
end ImmedSelect;

architecture Behavioral of ImmedSelect is
Signal ImmedSignal : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
			
	ImmedSignal <=	"0000000000000000" & InstrIn 							  	   when ISelect = "00" else 		--zero padding	
						std_logic_vector(resize(signed(InstrIn), 32))  		   when ISelect = "01" else 		--sign extension
						InstrIn & "0000000000000000" 								   when ISelect = "10" else 		--zero padding after 16 shift to left
						std_logic_vector(resize(signed(InstrIn), 30)) & "00"  when ISelect = "11" else "00000000000000000000000000000000";	--sign extension and 2 shift to left

	InstrOut <=ImmedSignal after 10ns;
end Behavioral;

