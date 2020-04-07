library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;

entity mock is
port(
	i_CLK          : in  std_logic;
  i_RST          : in  std_logic;
  i_START        : in  std_logic;
  i_VALID_PIXEL  : in  std_logic;
	i_INPUT_PIXEL  : in  std_logic_vector(MSB+LSB-1 downto 0);
  o_VALID_PIXEL  : out std_logic_vector(PROC_NUMBER-1 downto 0);
	o_OUTPUT_PIXEL : out std_logic_vector(MSB+LSB-1 downto 0);
  o_DONE         : out std_logic_vector(PROC_NUMBER-1 downto 0)
);
end mock;

architecture arch of mock is
signal w_INPUT_PIXEL  : t_SIZE (PROC_NUMBER-1 downto 0);
signal w_OUT_PIXEL    : t_SIZE (PROC_NUMBER-1 downto 0);
begin

	w_INPUT_PIXEL(0) <= i_INPUT_PIXEL;

  toppest_i : toppest
  port map (
    i_CLK         => i_CLK,
    i_RST         => i_RST,
    i_START       => i_START,
    i_INPUT_PIXEL => w_INPUT_PIXEL,
    i_VALID_PIXEL => i_VALID_PIXEL,
    o_VALID_PIXEL => o_VALID_PIXEL,
    o_OUT_PIXEL   => w_OUT_PIXEL,
    o_DONE        => o_DONE
  );

	o_OUTPUT_PIXEL <= w_OUT_PIXEL(0);

end architecture;
