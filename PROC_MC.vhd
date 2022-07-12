library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PROC_MC is
Port( CLK: in STD_LOGIC;
		RESET: in STD_LOGIC;

		inst_addr_RS : out std_logic_vector(31 downto 0);
		inst_dout_RS : in std_logic_vector(31 downto 0);
		data_we_RS : out std_logic;
		data_addr_RS : out std_logic_vector(31 downto 0);
		data_din_RS : out std_logic_vector(31 downto 0);
		data_dout_RS : in std_logic_vector(31 downto 0));
end PROC_MC;

architecture Behavioral of PROC_MC is

------------------------COMPONENTS-----------------------------------------
Component DATAPATH_MC is 
Port( 	Clk: in STD_LOGIC;
		Reset : in STD_LOGIC;
		--Registers
		InstrWr_reg : in STD_LOGIC;
		busAWr_reg : in STD_LOGIC;
		busBWr_reg : in STD_LOGIC;
		ALU_out_SigWr_reg : in STD_LOGIC;
		MEM_out_SigWr_reg : in STD_LOGIC;
		
		--IFSTAGE
		nPC_sel : in STD_LOGIC;
		PC_LdEn : in STD_LOGIC;
		Instruction: in STD_LOGIC_VECTOR(31 downto 0);
		PC_out:out STD_LOGIC_VECTOR(31 downto 0);
		--DECSTAGE
		MemtoReg: in STD_LOGIC;
		RegDst : in STD_LOGIC;
		RegWr: in STD_LOGIC;
		ExtOp : in STD_LOGIC_VECTOR(1 downto 0);
		--EXSTAGE
		ALUsrc:in STD_LOGIC;
		ALUctr:in STD_LOGIC_VECTOR(3 downto 0);
		ALU_ovf:out STD_LOGIC;
		ALU_cout:out STD_LOGIC;
		ALU_zero:out STD_LOGIC;
		--MEMSTAGE
		MemWr: in STD_LOGIC;
		ByteOp: in STD_LOGIC;
		--MEMSTAGE ->RAM
		MM_WrEn   :out STD_LOGIC;
		MM_Addr   :out STD_LOGIC_VECTOR(31 downto 0);
		MM_WrData :out STD_LOGIC_VECTOR(31 downto 0);
		MM_RdData :in STD_LOGIC_VECTOR(31 downto 0));
		
		
end Component;


Component CONTROL_MC is 
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
end Component;
----------------------------------------------------------------------------

Signal nPC_sel_Signal : STD_LOGIC:='0';
Signal PC_LdEn_Signal : STD_LOGIC:='0';
Signal Instruction_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MemtoReg_Signal : STD_LOGIC:='0';
Signal RegDst_Signal : STD_LOGIC:='0';
Signal RegWr_Signal : STD_LOGIC:='0';
Signal ExtOp_Signal : STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
Signal ALUsrc_Signal : STD_LOGIC:='0';
Signal ALUctr_Signal : STD_LOGIC_VECTOR(3 downto 0):= (others => '0');
Signal MemWr_Signal : STD_LOGIC:='0';
Signal ByteOp_Signal : STD_LOGIC:='0';
Signal ALU_zero_Signal: STD_LOGIC:='0';

--MC REGISTER SIGNALS
Signal InstrWr_reg_Signal : STD_LOGIC:='0';
Signal busAWr_reg_Signal : STD_LOGIC:='0';
Signal busBWr_reg_Signal : STD_LOGIC:='0';
Signal ALU_out_SigWr_reg_Signal : STD_LOGIC:='0';
Signal MEM_out_SigWr_reg_Signal : STD_LOGIC:='0';


begin
-----------------------------DATAPATH-------------------------------------------
DATAPATH_MODULE:
 DATAPATH_MC Port MAP( 	Clk => CLK,
							Reset=> RESET, 
							--Registers
							InstrWr_reg => InstrWr_reg_Signal,
							busAWr_reg => busAWr_reg_Signal,
							busBWr_reg => busBWr_reg_Signal,
							ALU_out_SigWr_reg => ALU_out_SigWr_reg_Signal,
							MEM_out_SigWr_reg =>MEM_out_SigWr_reg_Signal ,
	

							--IFSTAGE
							nPC_sel=> nPC_sel_Signal, 
							PC_LdEn=> PC_LdEn_Signal, 
							Instruction=> inst_dout_RS, 
							PC_out=> inst_addr_RS, 
							--DECSTAGE
							MemtoReg => MemtoReg_Signal,
							RegDst => RegDst_Signal,
							RegWr => RegWr_Signal,
							ExtOp => ExtOp_Signal,
							--EXSTAGE
							ALUsrc => ALUsrc_Signal,
							ALUctr => ALUctr_Signal,
							ALU_ovf => open,	--open
							ALU_cout => open, --open
							ALU_zero => ALU_zero_Signal,
							--MEMSTAGE
							MemWr=> MemWr_Signal,
							ByteOp=> ByteOp_Signal,
							--MEMSTAGE ->RAM
							MM_WrEn => data_we_RS, 
							MM_Addr => data_addr_RS, 
							MM_WrData => data_din_RS, 
							MM_RdData => data_dout_RS); 

		
-----------------------------CONTROL-------------------------------------------

 CONTROL_MODULE:
  CONTROL_MC Port MAP(
						 		Clk	=> Clk,
								Reset => RESET,
						 
						 Instruction=> inst_dout_RS, 
						 Zero => ALU_zero_Signal,
						 nPC_sel=> nPC_sel_Signal,
						 PC_LdEn=> PC_LdEn_Signal,
						 MemtoReg=> MemtoReg_Signal,
						 RegDst=> RegDst_Signal,
					 	 RegWr=> RegWr_Signal,
						 ExtOp=> ExtOp_Signal,
					 	 ALUsrc=> ALUsrc_Signal,
					 	 ALUctr=> ALUctr_Signal,
					 	 MemWr=> MemWr_Signal,
					 	 ByteOp=> ByteOp_Signal,
						 
						 
						InstrWr_reg =>InstrWr_reg_Signal,
						busAWr_reg =>busAWr_reg_Signal ,
						busBWr_reg =>busBWr_reg_Signal,
						ALU_out_SigWr_reg =>ALU_out_SigWr_reg_Signal ,
						MEM_out_SigWr_reg =>MEM_out_SigWr_reg_Signal );
end Behavioral;