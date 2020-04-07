library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;

entity toppest is
port(
	i_CLK          : in  std_logic;
	i_RST          : in  std_logic;
  i_START        : in  std_logic;

	i_INPUT_PIXEL  : in  t_SIZE (PROC_NUMBER-1 downto 0);
	i_VALID_PIXEL  : in  std_logic;

  o_VALID_PIXEL  : out std_logic_vector (PROC_NUMBER-1 downto 0);
	o_OUT_PIXEL    : out t_SIZE (PROC_NUMBER-1 downto 0);
  o_DONE         : out std_logic_vector(PROC_NUMBER-1 downto 0)
);
end toppest;

architecture arch of toppest is

signal w_INPUTPIXEL_PROC      : t_SIZE (PROC_NUMBER-1 downto 0);
signal w_VALIDPIXEL_MEM_IN    : std_logic;
signal w_START						    : std_logic;
signal w_CHANGEVP   			    : std_logic;
signal w_QEMPTY						    : std_logic;
signal w_ITDONE						    : std_logic;
signal w_ITERATE_END  		    : std_logic_vector (PROC_NUMBER-1 downto 0);
signal w_PROC_DONE            : std_logic_vector (PROC_NUMBER-1 downto 0);
signal w_EN_IT                : std_logic_vector (PROC_NUMBER-1 downto 0);
signal w_VALID_PIXEL_MEM_OUT  : std_logic;
signal w_TOP_MEM_OUT          : t_SIZE (PROC_NUMBER-1 downto 0);
signal w_PIXEL_READY          : std_logic_vector (PROC_NUMBER-1 downto 0);
signal w_OUT_PIXEL            : t_SIZE (PROC_NUMBER-1 downto 0);
signal w_DEMUX                : std_logic;
signal w_CNT_ITERATE          : integer := 0;
signal w_CNT_START            : integer := 0;

begin

  MEM : topmem
  port map (
    i_CLK             => i_CLK,
    i_RST             => i_RST,
    i_START           => i_START,
    i_INPUTPIXEL_ARM  => i_INPUT_PIXEL,
    i_INPUTPIXEL_PROC => w_INPUTPIXEL_PROC,
    i_VALIDPIXEL      => w_VALIDPIXEL_MEM_IN,
    i_PROC_DONE       => w_PROC_DONE(0),
    i_ITERATE_END     => w_ITERATE_END(0),
    o_VALID_PIXEL     => w_VALID_PIXEL_MEM_OUT,
		o_START           => w_START,
		o_QEMPTY					=> w_QEMPTY,
		o_ITDONE					=> w_ITDONE,
		o_CHANGEVP        => w_CHANGEVP,
    o_P               => w_TOP_MEM_OUT
  );

  FDA : topperthantop
  port map (
    i_CLK         => i_CLK,
    i_RST         => i_RST,
    i_START       => w_START,
		i_QEMPTY			=> w_QEMPTY,
    i_INPUT_PIXEL => w_TOP_MEM_OUT,
    i_VALID_PIXEL => w_VALID_PIXEL_MEM_OUT,
    o_PIXEL_READY => w_PIXEL_READY,
    o_PROC_DONE   => w_PROC_DONE,
    o_EN_IT       => w_EN_IT,
		o_ITERATE_END => w_ITERATE_END,
    o_OUT_PIXEL   => w_OUT_PIXEL,
    o_DONE        => o_DONE
  );

  COUNT_ITERATE : entity work.count
  generic map (
    p_INITVALUE => 0,
    p_STEP			=> 1
  )
	port map(
	  i_CLK => i_CLK,
	  i_RST => i_RST,
	  i_ENA => w_ITDONE,
	  i_CLR => '0',
	  o_Q   => w_CNT_ITERATE
	);
	w_DEMUX <= '1' when (w_CNT_ITERATE >= ITERATIONS) else '0';

  -- demuxes which choose if the pixel resulting from the fda goes to the memory or to the outside
  o_OUT_PIXEL 			  <= w_OUT_PIXEL 	 when (w_DEMUX = '1')    else (others => (others => '0'));
  o_VALID_PIXEL 		  <= w_PIXEL_READY when (w_DEMUX = '1')    else (others => '0');
	w_VALIDPIXEL_MEM_IN <= i_VALID_PIXEL when (w_CHANGEVP = '0') else w_PIXEL_READY(0);
  w_INPUTPIXEL_PROC   <= w_OUT_PIXEL;
end architecture;
