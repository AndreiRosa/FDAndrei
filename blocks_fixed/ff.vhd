library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ff is
port(
	i_CLK   : in  std_logic;                   	-- clock
	i_RST   : in  std_logic;							-- reset
	i_ENA   : in  std_logic;               		-- enable
	i_CLR   : in  std_logic;               		-- clear
	i_DIN   : in  std_logic;  							-- input data
	o_OUT   : out std_logic
	);
end ff;

architecture arch_1 of ff is
signal r_DATA : std_logic;
begin
	process(i_CLK, i_RST, i_CLR)
	begin
		if ((i_RST = '1') or (i_CLR = '1')) then
			r_DATA <= '0';
		elsif (rising_edge(i_CLK)) then
			if (i_ENA = '1') then
				r_DATA <= i_DIN;
			end if;
		end if;
	end process;
	o_OUT <= r_DATA;
end arch_1;
