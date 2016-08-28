--------------------------------------------------------------------------------
-- VHDL Test Bench Created by ISE for SpiRx40 module
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;

entity SpiRx40_TB IS
end SpiRx40_TB;
 
architecture behavior OF SpiRx40_TB IS 
   -- Component Declaration for the Unit Under Test (UUT)
   component SpiRx40
   port(
      sck : in  std_logic;
      mosi : in  std_logic;
      ctrlout : out  std_logic_vector(7 downto 0);
      dataout : out  std_logic_vector(31 downto 0)
   );
   end component;
   --Inputs
   signal sck : std_logic := '0';
   signal mosi : std_logic := 'Z';
   --Outputs
   signal ctrlout : std_logic_vector(7 downto 0);
   signal dataout : std_logic_vector(31 downto 0);

begin
   -- Instantiate the Unit Under Test (UUT)
   uut: SpiRx40 port MAP (
      sck => sck,
      mosi => mosi,
      ctrlout => ctrlout,
      dataout => dataout
   );

   -- Stimulus process
   stim_proc: process
      type Msg_T is array (0 to 4) of std_logic_vector(7 downto 0);
      variable msg : Msg_T := (
         x"01",
         x"02",
         x"03",
         x"04",
         x"05"
      );
   begin		
      wait for 50 ns;
      for bytecount in 0 to 4 loop
         for bitcount in 7 downto 0 loop
            mosi <= msg(bytecount)(bitcount);
            wait for 50 ns;
            sck <= '1';
            wait for 50 ns;
            sck <= '0';
         end loop;
      end loop;
         mosi <= 'Z';
      wait;
   end process;
end;
