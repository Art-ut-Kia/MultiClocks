--------------------------------------------------------------------------------
-- VHDL Test Bench Created by ISE for module: SpiRx40
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY SpiRx40_TB IS
END SpiRx40_TB;
 
ARCHITECTURE behavior OF SpiRx40_TB IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT SpiRx40
    PORT(
       clk : IN  std_logic;
       mosi : IN  std_logic;
       ctrlout : OUT  std_logic_vector(7 downto 0);
       dataout : OUT  std_logic_vector(31 downto 0)
    );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal mosi : std_logic := 'Z';

 	--Outputs
   signal ctrlout : std_logic_vector(7 downto 0);
   signal dataout : std_logic_vector(31 downto 0);

BEGIN
   -- Instantiate the Unit Under Test (UUT)
   uut: SpiRx40 PORT MAP (
      clk => clk,
      mosi => mosi,
      ctrlout => ctrlout,
      dataout => dataout
   );

   -- Stimulus process
   stim_proc: process
	type Msg_T is array (0 to 4) of std_logic_vector(7 downto 0);
	variable msg : Msg_T :=
      (x"01",
	    x"02",
		 x"03",
		 x"04",
		 x"05");
   begin		
      wait for 50 ns;
      for bytecount in 0 to 4 loop
         for bitcount in 7 downto 0 loop
			  mosi <= msg(bytecount)(bitcount);
			  wait for 50 ns;
			  clk <= '1';
			  wait for 50 ns;
			  clk <= '0';
         end loop;
      end loop;
		mosi <= 'Z';
      wait;
   end process;

END;
