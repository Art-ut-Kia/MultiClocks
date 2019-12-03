----------------------------------------------------------------------------------
-- count32.vhd: 32-bit counter with enable
--              counts from 0 to maxcount-1 and then rollover
-- author : JPP
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity count32 is
   port(
      clk      : in  std_logic;
      enable   : in  std_logic;
      maxcount : in  std_logic_vector(31 downto 0);
      count    : out std_logic_vector(31 downto 0)
   );
end count32;

architecture behavioral of count32 is
   signal icnt: std_logic_vector(31 downto 0) := (others => '0');
begin
   process(clk) begin
      if rising_edge(clk) then
         if enable = '1' then 
            if (icnt >= maxcount) then
               icnt <= (others => '0');
            else
               icnt <= icnt + "1";
            end if;
         end if;
      end if;
   end process;
   count <= icnt;
end behavioral;
