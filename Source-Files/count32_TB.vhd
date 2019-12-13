----------------------------------------------------------------------------------
-- count32_TB.vhd: Test Bench for 32-bit counter
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity count32_TB is
end count32_TB;
 
architecture behavior of count32_TB is 

   -- Component Declaration for the Unit Under Test (UUT)
 
   component count32
      port(
         clk : IN  std_logic;
         enable : IN  std_logic;
         maxcount : IN  std_logic_vector(31 downto 0);
         count : OUT  std_logic_vector(31 downto 0)
      );
   end component;
    

   --Inputs
   signal clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal maxcount : std_logic_vector(31 downto 0) := "00000000000000000000000000001111";

   --Outputs
   signal count : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;  -- 100MHz
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: count32 port map (
      clk => clk,
		enable => enable,
      maxcount => maxcount,
      count => count
   );

   -- Clock process definitions
   clk_process :process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;

   -- Enable signal generation process
   stim_proc: process
   begin		
      wait for clk_period*10.25;
      enable <= '1';		
      wait;
   end process;

end;