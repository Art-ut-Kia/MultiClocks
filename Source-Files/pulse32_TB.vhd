----------------------------------------------------------------------------------
-- pulse32_TB.vhd: 32-bit pulser test bench
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY pulse32_TB IS
END pulse32_TB;

ARCHITECTURE behavior OF pulse32_TB IS 
   -- Component Declaration for the Unit Under Test (UUT)
   COMPONENT pulse32
      PORT(
         clk : IN  std_logic;
         count : IN  std_logic_vector(31 downto 0);
         threshold : IN  std_logic_vector(31 downto 0);
         pulse : OUT  std_logic
      );
    END COMPONENT;
   --Inputs
   signal clk : std_logic := '0';
   signal count : std_logic_vector(31 downto 0) := (others => '0');
   signal threshold : std_logic_vector(31 downto 0) := "00000000000000000000000000001111";
   --Outputs
   signal pulse : std_logic;
   -- Clock period definitions
   constant clk_period : time := 10 ns; -- 100 MHz
 
BEGIN
   -- Instantiate the Unit Under Test (UUT)
   uut: pulse32 PORT MAP (
      clk => clk,
      count => count,
      threshold => threshold,
      pulse => pulse
   );
   -- Clock process definitions
   clk_process: process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin
      wait for clk_period*10;
      for i in 0 to 20 loop
         count <= count + '1';
         wait for 23 ns;
      end loop;
      wait;
   end process;
END;
