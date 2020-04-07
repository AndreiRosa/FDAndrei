library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.fda_package.all;	-- Package with project types

entity rom is
generic(
  address_size : integer;
  data_size    : integer
);
port(
  i_CLK			: in  std_logic;
	i_RST			: in  std_logic;
  i_ENA_RD  : in  std_logic;
  i_CONTENT : in  t_SIZE(c_COUNT_IMG_DONE-1 downto 0);
  i_ADDR 	  : in  std_logic_vector(c_MEM_SIZE-1 downto 0);
	o_DATA 	  : out std_logic_vector(MSB+LSB-1 downto 0)
);
end entity rom;

architecture arch of rom is
begin

    u_READ : process(i_CLK, i_RST, i_CONTENT)
      begin
        if(i_RST = '1') then
          o_DATA <= (others=>'0');
        elsif (rising_edge(i_CLK)) then
          if(i_ENA_RD = '1') then
            o_DATA <= i_CONTENT(to_integer(unsigned(i_ADDR)));
          end if;
        end if;
    end process;

end architecture;
