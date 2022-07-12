library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_MC is
Port (Instruction : in  STD_LOGIC_VECTOR (31 downto 0);
		Zero : in STD_LOGIC;
		Clk	:in STD_LOGIC;
		Reset :in STD_LOGIC;

		
		nPC_sel: out STD_LOGIC; 
		PC_LdEn: out STD_LOGIC;
		
		MemtoReg: out STD_LOGIC; 
		RegDst: out STD_LOGIC; 
		RegWr: out STD_LOGIC; 	
		ExtOp: out STD_LOGIC_VECTOR(1 downto 0);
		
		ALUsrc:out STD_LOGIC; 
		ALUctr:out STD_LOGIC_VECTOR(3 downto 0);
		
		MemWr:out STD_LOGIC;	
		ByteOp:out STD_LOGIC;
		
		InstrWr_reg : out STD_LOGIC;
		busAWr_reg : out STD_LOGIC;
		busBWr_reg : out STD_LOGIC;
		ALU_out_SigWr_reg : out STD_LOGIC;
		MEM_out_SigWr_reg : out STD_LOGIC); 
		
end CONTROL_MC;

architecture Behavioral of CONTROL_MC is

type state is (S_Reset,S_InstrFetch,S_InstrDec,S_RtypeALUExec1,S_RtypeALUExec2,S_RtypeEnd,S_AluImmedExec1,S_AluImmedExec2,S_ImmedEnd,S_BranchInstrExec1,S_BranchInstrExec2
,S_BranchInstrEND,S_LoadInstrExec1,S_LoadInstrExec2,S_LoadInstrExec3,S_LoadInstrExecEND,S_StoreInstrExec1,S_StoreInstrExec2,S_StoreInstrExecEND);

Signal OPCode_signal : STD_LOGIC_VECTOR(5 downto 0):= (others => '0');
Signal FUNC_singal : STD_LOGIC_VECTOR(5 downto 0):= (others => '0');

SIGNAL currentS , nextS : state;

begin

FUNC_singal<= Instruction(5 downto 0);
OPCode_signal<= Instruction(31 downto 26);

  process(currentS , Instruction ) 
	BEGIN
	CASE currentS is 
----------------------------------------------------RESET_STAGE--------------------------------------------------------------
			when S_Reset => 
						nPC_sel<= '0';
						ALUsrc<='0';
						PC_LdEn<='0';
						RegDst<='0';
						RegWr<='0';
						ALUctr<= "0000";
						MemWr<='0';
						ExtOp<="00" ;
						MemtoReg<= '0';
						ByteOp<='0';
						
						InstrWr_reg <='0';
						busAWr_reg<='0';
						busBWr_reg <='0';
						ALU_out_SigWr_reg <='0';
						MEM_out_SigWr_reg <='0';
						
				nextS <= S_InstrFetch;
-------------------------------------------------INSTRUCTION_FETCHER-----------------------------------------------------------------
			WHEN S_InstrFetch =>
							InstrWr_reg<= '1';
							nPC_sel<= '0';
							PC_LdEn<= '0';
							ALU_out_SigWr_reg<= '0';
							RegWr<= '0'; --RF_WrEn
							MemWr<= '0';
							nextS <= S_InstrDec;							
-------------------------------------------------INSTRUCTION_DECODER-----------------------------------------------------------------			
			WHEN S_InstrDec =>	
			
						InstrWr_reg<= '0';
					
						IF(OPCode_signal = "100000") THEN									--funcs - alu operations
						  RegDst <= '0';					 	 --RF_B_Sel
						  nextS <= S_RtypeALUExec1;
						ELSIF (OPCode_signal(5 downto 4)= "11" AND OPCode_signal(2) = '0') THEN  -- alu operations with immediate
						  RegDst <= '1';					 	 --RF_B_Sel
						  nextS <= S_AluImmedExec1;
						ELSIF (OPCode_signal="111111" OR OPCode_signal="000000" OR OPCode_signal="000001" ) THEN -- branch instructions
						 RegDst <= '1';					 	 	--RF_B_Sel
						 nextS <= S_BranchInstrExec1;
						ELSIF (OPCode_signal="000011" OR OPCode_signal="001111") THEN -- lb / lw instructions
						  RegDst <= '1';  --RF_B_Sel
						  nextS <= S_LoadInstrExec1;
						ELSIF (OPCode_signal="000111" OR OPCode_signal="011111") THEN -- sb / sw instructions
						  RegDst <= '1';	--RF_B_Sel
						  nextS <= S_StoreInstrExec1;
						END IF;
			
-------------------------------------------R_TYPE---------------------------------------------------------------------------------------	
			WHEN S_RtypeALUExec1 =>
					busAWr_reg <='1';
					busBWr_reg<='1';
					ExtOp<="00"; -- ImmExt
					nextS <= S_RtypeALUExec2;
				
			WHEN S_RtypeALUExec2 =>
					ALUctr <= Instruction(3 downto 0);	 --ALU_func
					ALUsrc <= '0';     					 --ALU_Bin_sel
					ALU_out_SigWr_reg<='1';
					nextS <= S_RtypeEnd;
					
			WHEN S_RtypeEnd =>
				busAWr_reg <='0';
				busBWr_reg<='0';
				RegWr<= '1'; --RF_WrEn
				MemtoReg<= '0'; --RF_WrData_sel
				nPC_sel<= '0'; --PC -> PC +4 for the next instruction
				PC_LdEn<= '1';
				nextS <= S_InstrFetch;
				
----------------------------------------IMMED------------------------------------------------------------------------------------------			
			WHEN S_AluImmedExec1=>
				IF(OPCode_signal= "110010" OR OPCode_signal = "110011") THEN 	--nandi/ori
					ExtOp<="00" ;--ImmExt
				ELSIF(OPCode_signal = "110000" OR OPCode_signal = "111000") THEN --addi/li
					ExtOp<="01" ;--ImmExt
				ELSIF(OPCode_signal = "111001") THEN 	--lui
					ExtOp<="10" ;--ImmExt
				END IF;
				busAWr_reg <='1';
				busBWr_reg<='1';
				nextS <= S_AluImmedExec2;
			
			
			WHEN S_AluImmedExec2=>
				IF(OPCode_signal= "110000") THEN
				 ALUctr <= "0000";
				ELSIF(OPCode_signal= "110010") THEN
				 ALUctr <= "0101";
				ELSIF(OPCode_signal= "110011") THEN
				 ALUctr <= "0011";
				ELSE 
				 ALUctr <= "0000";
				END IF; 
				ALUsrc <= '1';     					 --ALU_Bin_sel
				ALU_out_SigWr_reg<='1'; 
				nextS <= S_ImmedEnd;
				
				
			WHEN S_ImmedEnd	=>
				busAWr_reg <='0';
				busBWr_reg<='0';
				RegWr<= '1'; --RF_WrEn
				MemtoReg<= '0'; --RF_WrData_sel
				nPC_sel<= '0'; --PC -> PC +4 for the next instruction
				PC_LdEn<= '1';
				nextS <= S_InstrFetch;
----------------------------------------------------BRANCH---------------------------------------------------------------------------------
			WHEN S_BranchInstrExec1=>
				busAWr_reg <='1';
				busBWr_reg<='1';
				ExtOp<="11"; -- ImmExt
				IF(OPCode_signal="111111") then
				nextS <= S_BranchInstrEND;
				ELSE
				nextS <= S_BranchInstrExec2;
				END IF;
			
			WHEN S_BranchInstrExec2=>
				IF(OPCode_signal="000000") THEN	  --for beq
				 ALUctr <= "0001"; --ALU_func
				 ALUsrc<= '0'; --ALU_Bin_sel
				ELSIF(OPCode_signal="000001") THEN --for bne
				 ALUctr <= "0001"; --ALU_func
				 ALUsrc<= '0'; --ALU_Bin_sel	  
				END IF;
				 ALU_out_SigWr_reg<='1';
				nextS <= S_BranchInstrEND;
				
				
			WHEN S_BranchInstrEND=>	
				busAWr_reg <='0';
				busBWr_reg<='0';
				--RegWr<= '0'; --RF_WrEn
				--MemtoReg<= '0'; --RF_WrData_sel
				PC_LdEn<= '1';
           IF(OPCode_signal="111111" OR (OPCode_signal="000000" AND Zero ='1') OR (OPCode_signal="000001" AND Zero ='0')) THEN
			  nPC_sel<= '1';
			   ELSE 
			   nPC_sel<= '0';
            END IF;
            nextS <= S_InstrFetch;

----------------------------------------------------LOAD---------------------------------------------------------------------------------
			WHEN S_LoadInstrExec1=>
				busAWr_reg <='1';
				busBWr_reg<='1';
				ExtOp<="01"; -- ImmExt
				nextS <= S_LoadInstrExec2;
			
			
			WHEN S_LoadInstrExec2=>
			ALUctr <= "0000";	 --ALU_func
			ALUsrc <= '1';     	 --ALU_Bin_sel
			ALU_out_SigWr_reg<='1'; 
				IF(OPCode_signal = "001111") THEN -- lw
					ByteOp <= '0';
				ELSIF(OPCode_signal = "000011")THEN --lb
					ByteOp <= '1';
				END IF;
			nextS <= S_LoadInstrExec3;


			WHEN S_LoadInstrExec3 =>
			busAWr_reg <='0';
			busBWr_reg<='0';
			MEM_out_SigWr_reg<= '1';
			nextS <= S_LoadInstrExecEND;
			
			
			WHEN S_LoadInstrExecEND=>
			ALU_out_SigWr_reg<='0'; 
			RegWr<= '1'; --RF_WrEn
			MemtoReg<= '1'; --RF_WrData_sel
			nPC_sel<= '0'; --PC -> PC +4 for the next instruction
			PC_LdEn<= '1';
			nextS <= S_InstrFetch;
			

----------------------------------------------------STORE---------------------------------------------------------------------------------			
			WHEN S_StoreInstrExec1=>
			busAWr_reg <='1';
			busBWr_reg<='1';
			ExtOp<="01"; -- ImmExt
			nextS <= S_StoreInstrExec2;
			
			
			WHEN S_StoreInstrExec2=>
			ALUsrc<='1';--ALU_Bin_sel
			ALUctr <= "0000";	 --ALU_func
			ALU_out_SigWr_reg<='1'; 
			IF(OPCode_signal = "011111") THEN -- sw
				ByteOp <= '0';
			ELSIF(OPCode_signal = "000111")THEN --sb
				ByteOp <= '1';
			END IF;
			nextS <= S_StoreInstrExecEND;
			
			WHEN S_StoreInstrExecEND=>
			MemWr<='1';
			MEM_out_SigWr_reg <='0';
			ALU_out_SigWr_reg<='0'; 
			MemtoReg<= '1'; --RF_WrData_sel
			nPC_sel<= '0'; --PC -> PC +4 for the next instruction
			PC_LdEn<= '1';
			nextS <= S_InstrFetch;

	 END CASE;
   END PROCESS;	
	
	
	process(Clk,Reset)
	BEGIN
		IF(Reset = '1')THEN
			currentS <= S_Reset;
		ELSIF (rising_edge(Clk))THEN
		   currentS<= nextS;
		END IF;
	END PROCESS;
	
end Behavioral;


					--      MemtoReg<= '1'; --RF_WrData_sel
					--		PC_LdEn <= '1'; 							
					--		nPC_sel<= '0'; --PC_Sel
					--		ALUsrc<='1';--ALU_Bin_sel
					--		RegDst<= '0'; --RF_B_Sel
					--		RegWr<= '1'; --RF_WrEn
					--		ALUctr<= "0000" ;--ALU_func
					--		MemWr<= '0';
					--		ExtOp<="00" ;--ImmExt
							
