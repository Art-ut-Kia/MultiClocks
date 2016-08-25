----------------------------------------------------------------------------------
-- decod16.vhd: 4 to 16 decoder
--              generates a pulse of 1 clock duration on nSS rising edge on the
--              output designated by Code(3..0)
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decod16 is
   port(
      Code : in  std_logic_vector(3 downto 0);
      Clk  : in  std_logic;
      nSS  : in  std_logic;
      Dout : out std_logic_vector(15 downto 0)
   );
end decod16;

architecture Behavioral of decod16 is
signal PnSS:  std_logic := '0';
signal PPnSS: std_logic := '0';
signal EoRx:  std_logic; -- End of SPI Reception
begin
   -- generates the EoRx synchronous pulse on nSS rising edge
   process(Clk) begin
      if (clk = '1' and clk'event) then
         PnSS <= nSS;
         PPnSS <= PnSS;
      end if;
   end process;
   EoRx <= PnSS and not PPnSS;

   -- generates the outputs
   Dout <= "0000000000000001" when EoRx = '1' and Code = "0000" else
           "0000000000000010" when EoRx = '1' and Code = "0001" else
           "0000000000000100" when EoRx = '1' and Code = "0010" else
           "0000000000001000" when EoRx = '1' and Code = "0011" else
           "0000000000010000" when EoRx = '1' and Code = "0100" else
           "0000000000100000" when EoRx = '1' and Code = "0101" else
           "0000000001000000" when EoRx = '1' and Code = "0110" else
           "0000000010000000" when EoRx = '1' and Code = "0111" else
           "0000000100000000" when EoRx = '1' and Code = "1000" else
           "0000001000000000" when EoRx = '1' and Code = "1001" else
           "0000010000000000" when EoRx = '1' and Code = "1010" else
           "0000100000000000" when EoRx = '1' and Code = "1011" else
           "0001000000000000" when EoRx = '1' and Code = "1100" else
           "0010000000000000" when EoRx = '1' and Code = "1101" else
           "0100000000000000" when EoRx = '1' and Code = "1110" else
           "1000000000000000" when EoRx = '1' and Code = "1111" else "0000000000000000";
end Behavioral;