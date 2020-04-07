library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity countsync is
generic (
	p_INITVALUE	: integer;
	p_STEP			: integer
);
port (
	i_CLK  :  in  std_logic;
	i_RST  :  in  std_logic;
	i_ENA  :  in  std_logic ;
	i_CLR  :  in  std_logic;
	o_Q    :  out integer
);
end countsync;

architecture arch of countsync is

signal w_Q : integer := p_INITVALUE;

begin
process (i_CLK, i_RST, i_CLR)
	begin
    if (rising_edge(i_CLK)) then
      if (i_RST = '1') or (i_CLR = '1') then
        w_Q <= 0;
			elsif (i_ENA = '1') then
				w_Q <= w_Q + p_STEP ;
			else
				w_Q <= w_Q ;
			end if ;
	end if ;
end process ;

	o_Q <= w_Q;

end arch;
