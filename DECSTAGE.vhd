----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:33:31 03/29/2022 
-- Design Name: 
-- Module Name:    DECSTAGE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.arraypack.all; --For MUX 32to1 32bitwide
use work.Mux2to1bit_package.all; --For MUX 2to1 32bitwide
use work.MUX2to1_5bit_package.all; --For MUX 2to1 5bitwide


entity DECSTAGE is
	Port( Instr : in STD_LOGIC_VECTOR(31 downto 0);
			RF_WrEn: in STD_LOGIC;
			ALU_out : in STD_LOGIC_VECTOR(31 downto 0);
			MEM_out : in STD_LOGIC_VECTOR(31 downto 0);
			RF_WrData_sel : in STD_LOGIC;
			RF_B_sel :in STD_LOGIC;
			ImmExt :in STD_LOGIC_VECTOR(1 downto 0);
			Clk :in STD_LOGIC;
			Immed: out STD_LOGIC_VECTOR(31 downto 0);
			RF_A: out STD_LOGIC_VECTOR(31 downto 0);
			RF_B: out STD_LOGIC_VECTOR(31 downto 0);
			Reset : in STD_LOGIC);
	end DECSTAGE;


architecture Behavioral of DECSTAGE is
signal MUX2to1_5bitIn : Matrix5x2bit;
signal MUX2to1_5bitOut : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

signal MUX2to1_32bitIn : MUX2to1bitArray;
signal MUX2to1_32bitOut : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');



------------------------COMPONENTS---------------------------------
Component RF is 
		Port( 	Ard1 : in STD_LOGIC_VECTOR(4 downto 0);
					Ard2 : in STD_LOGIC_VECTOR(4 downto 0);
					Awr : in STD_LOGIC_VECTOR(4 downto 0);
					Dout1 : out STD_LOGIC_VECTOR(31 downto 0);
					Dout2 : out STD_LOGIC_VECTOR(31 downto 0);
					Din : in STD_LOGIC_VECTOR(31 downto 0);
					WrEn : in STD_LOGIC ;
					Clk : in STD_LOGIC;
					Rst : in STD_LOGIC);
end Component;

Component MUX2to1bit is 
	Port( MUX2In : in MUX2to1bitArray;
			Pc_Sel : in STD_LOGIC;
			MUX2Out: out STD_LOGIC_VECTOR(31 downto 0));
end Component;

Component ImmedSelect is 
Port ( InstrIn : in STD_LOGIC_VECTOR(15 downto 0);
		 ISelect : in STD_LOGIC_VECTOR(1 downto 0);
		 InstrOut : out STD_LOGIC_VECTOR(31 downto 0));
end Component;

Component MUX2to1_5bit is 
	PORT( Instr15_11 : in Matrix5x2bit;
			RF_B_SEL	  : in STD_LOGIC;
			MUX2to1_5bitOut: out STD_LOGIC_VECTOR(4 downto 0));
end Component;

----------------------------------------------------------------------------

begin

------------------------MUX2to1_5bits----------------------------------------
	MUX2to1_5bitIn(0) <= Instr(15 downto 11);
	MUX2to1_5bitIn(1) <= Instr(20 downto 16);
	
	MUX2to1_5bit_Module:
		MUX2to1_5bit Port MAP( Instr15_11 => MUX2to1_5bitIn,
									  RF_B_SEL => RF_B_sel, 
									  MUX2to1_5bitOut => MUX2to1_5bitOut);
								 
------------------------MUX2to1_32bits----------------------------------------
MUX2to1_32bitIn(0) <= ALU_out;
MUX2to1_32bitIn(1) <= MEM_out;

	
	
	MUX2to1_32bits_Module:
		MUX2to1bit	Port MAP( MUX2In => MUX2to1_32bitIn,
									 Pc_Sel => RF_WrData_sel,
									 MUX2Out => MUX2to1_32bitOut);

------------------------Immed----------------------------------------
	Immedselector_Module:
		ImmedSelect Port MAP( InstrIn => Instr(15 downto 0),
									 ISelect => ImmExt,
									 InstrOut => Immed);
									 
------------------------RF----------------------------------------
	RF_module:
	  RF Port MAP( Ard1 => Instr(25 downto 21),
						Ard2 => MUX2to1_5bitOut,
						Awr => Instr(20 downto 16),
						Dout1 => RF_A,
						Dout2 => RF_B,
						Din => MUX2to1_32bitOut,
						WrEn => RF_WrEn,
						Clk => Clk,
						Rst => Reset);
						
end Behavioral;

