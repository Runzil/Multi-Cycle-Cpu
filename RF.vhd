library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.arraypack.all;

entity RF is
    Port( Ard1 : in STD_LOGIC_VECTOR(4 downto 0);
            Ard2 : in STD_LOGIC_VECTOR(4 downto 0);
            Awr : in STD_LOGIC_VECTOR(4 downto 0);
            Dout1 : out STD_LOGIC_VECTOR(31 downto 0);
            Dout2 : out STD_LOGIC_VECTOR(31 downto 0);
            Din : in STD_LOGIC_VECTOR(31 downto 0);
            WrEn : in STD_LOGIC ;
            Clk : in STD_LOGIC;
            Rst : in STD_LOGIC);
end RF;

architecture Behavioral of RF is
signal DecoderOutSignal :STD_LOGIC_VECTOR (31 downto 0);
signal WERegisterSignal :STD_LOGIC_VECTOR (31 downto 1);
signal RegisterDataOutSignal : InArray;

------------------------COMPONENTS---------------------------------
Component Register32bit is 
    Port (  CLK : in STD_LOGIC;
              RST : in STD_LOGIC;
           Datain : in STD_LOGIC_VECTOR (31 downto 0);
              WE : in STD_LOGIC;
              Dataout : out STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component Decoder5to32 is 
    Port( DataInDec  : in STD_LOGIC_VECTOR(4 downto 0); 
            DataOutDec : out STD_LOGIC_VECTOR(31 downto 0));
end Component;

Component MUX32bit is 
Port( DataInMux : in inArray;
         SEL : in STD_LOGIC_VECTOR(4 downto 0);
         DataOutMux : out STD_LOGIC_VECTOR(31 downto 0));
end Component;
----------------------------------------------------------------------------



begin
------------------------DECODER----------------------------------------
 Decoder :
    Decoder5to32 Port MAP(DataInDec => Awr,
                                 DataOutDec => DecoderOutSignal);
                                 
------------------------REGISTERS----------------------------------------                                
 Registers:

    
  for I     in 1 to 31 generate
        WERegisterSignal(I) <= (DecoderOutSignal(I) AND WrEn) after 2 ns; --2ns delay for AND gate 
  
  RegisterI:
      Register32bit Port Map(CLK => Clk,
                                     RST => Rst,
                                     Datain => Din,
                                     WE => WERegisterSignal(I),
                                     Dataout => RegisterDataOutSignal(I));
  end generate;    
     
    Register0:                                            --register0 must always be 0 so reset is always 1
       Register32bit Port Map(CLK => Clk,
                                     RST => '1',
                                     Datain => Din,
                                     WE => '0',
                                     Dataout => RegisterDataOutSignal(0));    
      
------------------------MULTIPLEXERS----------------------------------------
 MUX1:
 MUX32bit Port MAP( DataInMux  => RegisterDataOutSignal,
                          SEL          => Ard1,
                          DataOutMux => Dout1);
    
 MUX2:
 MUX32bit Port MAP( DataInMux  => RegisterDataOutSignal,
                          SEL          => Ard2,
                          DataOutMux => Dout2);

    
end Behavioral;