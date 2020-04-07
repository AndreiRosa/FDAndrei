library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;	-- Package with project types

entity topperthantop is
port(
	i_CLK          : in  std_logic;
	i_RST          : in  std_logic;
  i_START        : in  std_logic;
	i_QEMPTY       : in  std_logic;
	i_INPUT_PIXEL  : in t_SIZE (PROC_NUMBER-1 downto 0);
	i_VALID_PIXEL  : in  std_logic;

  o_PIXEL_READY  : out std_logic_vector (PROC_NUMBER-1 downto 0);
  o_PROC_DONE    : out std_logic_vector (PROC_NUMBER-1 downto 0);

	o_EN_IT        : out std_logic_vector (PROC_NUMBER-1 downto 0);
	o_ITERATE_END  : out std_logic_vector (PROC_NUMBER-1 downto 0);

	o_OUT_PIXEL    : out t_SIZE (PROC_NUMBER-1 downto 0);
  o_DONE         : out std_logic_vector(PROC_NUMBER-1 downto 0)
);
end topperthantop;

architecture arch of topperthantop is

begin

  g_FDA :  for i in 0 to PROC_NUMBER-1 generate
    topfda_i : top
    port map (
      i_CLK         => i_CLK,
      i_RST         => i_RST,
      i_START       => i_START,
			i_QEMPTY      => i_QEMPTY,
      i_INPUT_PIXEL => i_INPUT_PIXEL(i),
      i_VALID_PIXEL => i_VALID_PIXEL,
      o_PIXEL_READY => o_PIXEL_READY(i),
      o_PROC_DONE   => o_PROC_DONE(i),
      o_EN_IT       => o_EN_IT(i),
			o_ITERATE_END => o_ITERATE_END(i),
      o_OUT_PIXEL   => o_OUT_PIXEL(i),
      o_DONE        => o_DONE(i)
    );
  end generate;

end architecture;
