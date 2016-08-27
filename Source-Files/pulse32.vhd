----------------------------------------------------------------------------------
-- pulse32.vhd: 32-bit pulser
--              output is high as long as (count < threshold)
--              note: output is clocked
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all, ieee.std_logic_unsigned.all;

entity pulse32 is
   Port(
      clk       : in  std_logic;
      count     : in  std_logic_vector(31 downto 0);
      threshold : in  std_logic_vector(31 downto 0);
      pulse     : out std_logic
   );
end pulse32;

architecture behavioral of pulse32 is
   signal lower: std_logic;
begin
   lower <= '1' when (count<threshold) else '0';
   process (clk) begin
      if (clk = '1' and clk'event) then
         pulse <= lower; 
      end if;
   end process;
end behavioral;
