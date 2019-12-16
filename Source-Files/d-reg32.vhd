----------------------------------------------------------------------------------
-- d_reg32.vhd: 32-bit D flip-flop
--              memorizes a 32-bit word on the rising edge of a clock
-- author : JPP
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity d_reg32 is
   generic(
	   -- default period : 100MHz/1M = 100Hz
	   q0 : integer := 1e6
	);
   port(
      clk : in  std_logic;
      en  : in  std_logic;
      d   : in  std_logic_vector(31 downto 0);
      q   : out std_logic_vector(31 downto 0)
   );
end d_reg32;

architecture behavioral of d_reg32 is
   signal iq: std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(q0, 32));
begin
   process(clk, en) begin
	   if rising_edge(clk) and en = '1' then
         iq <= d;
      end if;
   end process;
	q <= iq;
end behavioral;