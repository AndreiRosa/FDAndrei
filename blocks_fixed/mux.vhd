library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;

entity mux is
generic(
  address_size : integer
);
port (
 i_SEL	: in std_logic;
 i_A		: in std_logic_vector(address_size-1 downto 0);
 i_B 		: in std_logic_vector(address_size-1 downto 0);
 o_S 		: out std_logic_vector(address_size-1 downto 0)
);
end entity mux;

architecture arch_1 of mux is
  begin
    u0: process(i_A, i_B, i_SEL)
    begin
      if (i_SEL = '0') then
        o_S <= i_A;
      else
        o_S <= i_B;
      end if;
    end process u0;
end arch_1;
