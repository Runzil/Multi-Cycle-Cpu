library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity MEMSTAGE is
	Port(	ByteOp : in STD_LOGIC;
			Mem_WrEn: in STD_LOGIC;
			ALU_MEM_Addr: in STD_LOGIC_VECTOR(31 downto 0);
			MEM_DataIn: in STD_LOGIC_VECTOR(31 downto 0);
			MEM_DataOut: out STD_LOGIC_VECTOR(31 downto 0);
			MM_WrEn: out STD_LOGIC;
			MM_Addr: out STD_LOGIC_VECTOR(31 downto 0);
			MM_WrData: out STD_LOGIC_VECTOR(31 downto 0);
			MM_RdData: in STD_LOGIC_VECTOR(31 downto 0));
end MEMSTAGE;

architecture Behavioral of MEMSTAGE is
signal MMSignal : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal BytesPosSignal : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

begin

MM_WrEn <= Mem_WrEn;


BytesPosSignal <= ALU_MEM_Addr(1) & ALU_MEM_Addr(0);

			  
MMSignal <= "00" & ALU_MEM_Addr(31 downto 2) ; 					
MM_Addr <= MMSignal + 256;--ALU memory +offset 0x400 bytes so 0x400=1024 = 1024/4= 256 memory address



MM_WrData <= MEM_DataIn when ByteOp = '0' else	--sw case
				  "000000000000000000000000" & MEM_DataIn(7 downto 0) when ByteOp = '1'; --sb case

MEM_Dataout<= MM_RdData when ByteOp = '0' else  --lw case
				  "000000000000000000000000" & MM_RdData(7 downto 0) when ByteOp = '1';  --lb case

end Behavioral;