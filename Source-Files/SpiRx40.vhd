----------------------------------------------------------------------------------
-- SpiRx40.vhd: 40-bit SPI receiveer
--              receives 5 bytes (1 control + 4 data) from an SPI bus
--              acts as an SPI slave
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all, ieee.std_logic_unsigned.all;

entity SpiRx40 is
   port(
      sck :     in  std_logic;
      mosi :    in  std_logic;
      ctrlout : out std_logic_vector( 7 downto 0);
      dataout : out std_logic_vector(31 downto 0)
   );
end spirx40;

architecture behavioral of spirx40 is
   signal msg : std_logic_vector(39 downto 0);
begin
   process(sck) begin
      if (sck = '1' and sck'event) then
         msg <= msg(38 downto 0) & mosi;
      end if;
   end process;
   ctrlout <= msg(39 downto 32);
   dataout <= msg(31 downto 0);
end behavioral;