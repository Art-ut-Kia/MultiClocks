----------------------------------------------------------------------------------
-- decod16_TB.vhd: test bench for decod16.vhd (4 to 16 decoder)
--                 generates one test vector at a time
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY decod16_TB IS
END decod16_TB;
 
ARCHITECTURE behavior OF decod16_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT decod16
       PORT(
          Code : IN  std_logic_vector(3 downto 0);
          Clk : IN  std_logic;
          nSS : IN  std_logic;
          Dout : OUT  std_logic_vector(15 downto 0)
       );
    END COMPONENT;

   --Inputs
   signal Code : std_logic_vector(3 downto 0) := "0001";
   signal Clk : std_logic := '0';
   signal nSS : std_logic := '0';

 	--Outputs
   signal Dout : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns; -- 100MHz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decod16 PORT MAP (
           Code => Code,
           Clk => Clk,
           nSS => nSS,
           Dout => Dout
        );

   -- Clock process
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      wait for Clk_period*10;
      nSS <= '1'; 
      wait;
   end process;
END;
