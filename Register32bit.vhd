library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register32bit is
Port (       CLK : in STD_LOGIC;
             RST : in STD_LOGIC;
				 Datain : in STD_LOGIC_VECTOR (31 downto 0);
             WE : in STD_LOGIC;
             Dataout : out STD_LOGIC_VECTOR (31 downto 0));
end Register32bit;

architecture Behavioral of Register32bit is
signal DataoutSignal :STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
begin
    process(CLK,RST,Datain,DataoutSignal)
    begin

     if(rising_edge(CLK)) then
		 if(RST = '1') then --reset if rst is 1
			DataoutSignal <= "00000000000000000000000000000000";
       elsif(WE = '1') then-- write if we is 1
           DataoutSignal <= Datain; 
        end if;
     end if;
    Dataout <= DataoutSignal after 10 ns ;
    end process;
end Behavioral;