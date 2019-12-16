--------------------------------------------------------------------------------
-- d_reg32 test bench
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY d_reg2_TB IS
END d_reg2_TB;
 
ARCHITECTURE behavior OF d_reg2_TB IS 
   -- Component Declaration for the Unit Under Test (UUT)
   COMPONENT d_reg32
	GENERIC(
	   q0 : integer
	);
   PORT(
      clk : IN  std_logic;
      en : IN  std_logic;
      d : IN  std_logic_vector(31 downto 0);
      q : OUT  std_logic_vector(31 downto 0)
   );
   END COMPONENT;

   -- Inputs
   signal clk : std_logic := '0';
   signal en : std_logic := '0';
   signal d : std_logic_vector(31 downto 0) := x"aaaa5555";

   -- Outputs
   signal q : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
   -- Instantiate the Unit Under Test (UUT)
   uut: d_reg32
   GENERIC MAP (q0 => 15)
	PORT MAP (
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
      -- hold reset state for 100 ns.
      wait for 107 ns;
      en <= '1';
      wait;
   end process;
END;
