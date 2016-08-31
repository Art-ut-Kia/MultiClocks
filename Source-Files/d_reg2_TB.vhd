--------------------------------------------------------------------------------
-- d_reg32 test bench
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity d_reg2_TB is
end d_reg2_TB;

architecture behavior of d_reg2_TB is
   -- Component Declaration for the Unit Under Test (UUT)
   component d_reg32
   port(
      clk : IN  std_logic;
      en : IN  std_logic;
      d : IN  std_logic_vector(31 downto 0);
      q : OUT  std_logic_vector(31 downto 0)
   );
   end component;
   -- Inputs
   signal clk : std_logic := '0';
   signal en : std_logic := '0';
   signal d : std_logic_vector(31 downto 0) := x"aaaa5555";
   -- Outputs
   signal q : std_logic_vector(31 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
begin
   -- Instantiate the Unit Under Test (UUT)
   uut: d_reg32 PORT MAP (
      clk => clk,
      en => en,
      d => d,
      q => q
   );
   -- Clock process definitions
   clk_process :process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin
      wait for 107 ns;
      en <= '1';
      wait;
   end process;
end;
