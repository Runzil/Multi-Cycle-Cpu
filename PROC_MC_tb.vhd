library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity PROC_MC_tb is
end;

architecture bench of PROC_MC_tb is

  component PROC_MC
  Port( CLK: in STD_LOGIC;
		  RESET: in STD_LOGIC;
		  
		inst_addr_RS : out std_logic_vector(31 downto 0);
		inst_dout_RS : in std_logic_vector(31 downto 0);
		data_we_RS : out std_logic;
		data_addr_RS : out std_logic_vector(31 downto 0);
		data_din_RS : out std_logic_vector(31 downto 0);
		data_dout_RS : in std_logic_vector(31 downto 0));
  end component;
  
  Component RAM is
	port (clk : in std_logic;
		inst_addr : in std_logic_vector(10 downto 0);
		inst_dout : out std_logic_vector(31 downto 0);
		data_we : in std_logic;
		data_addr : in std_logic_vector(10 downto 0);
		data_din : in std_logic_vector(31 downto 0);
		data_dout : out std_logic_vector(31 downto 0));
	end Component; 
  
  
--Inputs
signal CLK : std_logic := '0';
signal RESET : std_logic := '0';

Signal Instruction_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal PC_out_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MM_WrEn_Signal : STD_LOGIC:='0';
Signal MM_Addr_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MM_WrData_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MM_RdData_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');


  constant clock_period: time := 100 ns;

  signal stop_the_clock: boolean;
  
begin

  uut: PROC_MC port map ( CLK   => CLK,
                          RESET => RESET, 
								  
								  
								  inst_addr_RS => PC_out_Signal,--PC_out_Signal
								  inst_dout_RS => Instruction_Signal,--Instruction_Signal
								  data_we_RS => MM_WrEn_Signal,
								  data_addr_RS =>MM_Addr_Signal,
								  data_din_RS => MM_WrData_Signal,
								  data_dout_RS => MM_RdData_Signal);

	
 RAM_MODULE:
	RAM Port MAP(clk => CLK,
					 inst_addr=> PC_out_Signal(12 downto 2),
					 inst_dout => Instruction_Signal,
					 data_we =>MM_WrEn_Signal,
					 data_addr => MM_Addr_Signal(10 downto 0),
					 data_din => MM_WrData_Signal,
					 data_dout => MM_RdData_Signal);
					 
					 

  stimulus: process
  begin
  
  
		RESET<= '1';
		wait for clock_period*3;
		RESET<= '0';
		wait for clock_period*150;
		
		
		stop_the_clock <= true;
    wait;
  end process;

clocking: process
  begin
    while not stop_the_clock loop
      Clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;