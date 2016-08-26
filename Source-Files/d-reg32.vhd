----------------------------------------------------------------------------------
-- d_reg32.vhd: 32-bit D flip-flop
--              memorizes a 32-bit word on the rising edge of a clock
-- author: JPP
----------------------------------------------------------------------------------
library ieee;
use ieee.numeric_std.all, ieee.std_logic_1164.all, ieee.std_logic_unsigned.all;

entity d_reg32 is
   generic(
      q0  : integer := 1E6 -- init value (default = 1M to generate 100Hz from 100MHz)
   );
   port(
      clk : in  std_logic;
      en  : in  std_logic;
      d   : in  std_logic_vector(31 downto 0);
      q   : out std_logic_vector(31 downto 0)
   );
end d_reg32;

architecture behavioral of d_reg32 is
   signal iq: std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(q0,32));
begin
   process(clk) begin
      if clk = '1' and clk'event and en = '1' then
         iq <= d;
      end if;
   end process;
   q <= iq;
end behavioral;
