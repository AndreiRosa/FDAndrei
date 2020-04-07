library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;

entity mux4_1 is
generic(
  address_size : integer
);
port (
  i_SEL	  : in std_logic_vector(1 downto 0);
  i_A		  : in std_logic_vector(address_size-1 downto 0);
  i_B 		: in std_logic_vector(address_size-1 downto 0);
  i_C 		: in std_logic_vector(address_size-1 downto 0);
  i_D 		: in std_logic_vector(address_size-1 downto 0);
  o_S 		: out std_logic_vector(address_size-1 downto 0)
);
end entity mux4_1;

architecture arch_1 of mux4_1 is
  begin
    u0: process(i_A, i_B, i_C, i_D, i_SEL)
    begin
      if (i_SEL = "00") then
        o_S <= i_A;
      elsif (i_SEL = "01") then
        o_S <= i_B;
      elsif (i_SEL = "10") then
        o_S <= i_C;
      else
        o_S <= i_D;
      end if;
    end process u0;
end arch_1;
