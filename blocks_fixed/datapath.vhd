library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;	-- Package with project types

entity datapath is
port(
	i_CLK             : in  std_logic;
	i_RST             : in  std_logic;
	i_INPUT_PIXEL     : in  std_logic_vector (MSB+LSB-1 downto 0);
	i_VALID_PIXEL     : in  std_logic;

	i_CLR_KER_TOT	    : in std_logic;
	i_CLR_KER_ROW	    : in std_logic;
	i_CLR_INV_KER	    : in std_logic;
	i_CLR_BUF_FIL	    : in std_logic;

	i_EN_KER_TOT	    : in std_logic;
	i_EN_KER_ROW	    : in std_logic;
	i_EN_INV_KER	    : in std_logic;
	i_EN_BUF_FIL	    : in std_logic;
	i_EN_IT 				  : in std_logic;

	i_EN_CALC         : in std_logic;
	i_EN_WRITE_KERNEL	: in std_logic;

	o_MAX_KER_TOT     : out std_logic;
  o_MAX_KER_ROW     : out std_logic;
  o_MAX_INV_KER     : out std_logic;
	o_BUFFER_FILLED	  : out std_logic;
	o_ITERATE		  	  : out std_logic;
  o_PIXEL_READY		  : out std_logic;

	o_OUT_PIXEL       : out std_logic_vector(MSB+LSB-1 downto 0)
);
end datapath;

architecture arch of datapath is

	 -- DRA signals
   signal w_DRA_OUT            	: t_SIZE(0 to c_KERNEL_SIZE-1); -- Output from kernel
   signal w_ENA_WRI_KER    	  	: std_logic;

   -- Count/comp signals
   signal w_CNT_BUFFER_FILLED   : integer := 0;
   signal w_CNT_IMG_DONE		 	  : integer := 0;
   signal w_CNT_MAX_ROW 			  : integer := 0;
   signal w_CNT_INV_PIX		 	    : integer := 0;
	 signal w_CNT_ITERATE			    : integer := 0;
	 signal w_BUFFER_FILLED       : std_logic;
	 signal w_IMG_DONE		 	      : std_logic;
	 signal w_MAX_ROW 			      : std_logic;
	 signal w_INV_PIX		 	        : std_logic;

	 -- Calc signals
	 signal w_Calx_qC							: std_logic_vector(MSB+LSB-1 downto 0);
	 signal w_Calc_qC_En			    : std_logic;
	 signal w_EN_CALC       	  	: std_logic;

begin

	w_ENA_WRI_KER <= i_VALID_PIXEL and i_EN_WRITE_KERNEL;
	w_EN_CALC     <= i_VALID_PIXEL and i_EN_CALC;

	-- DRA
	DRA : entity work.DRA
	port map (
	  i_CLK         => i_CLK,
	  i_RST         => i_RST,
	  i_INPUT_PIXEL => i_INPUT_PIXEL,
	  i_ENA_WRI_KER => w_ENA_WRI_KER,
	  o_OUT_KERNEL  => w_DRA_OUT
	);

	-- CALC_NEWC
	CALC_NEWC : entity work.Calc_newC
	port map(
		i_CLK				    => i_CLK,
		i_RST				    => i_RST,
		i_ENA				    => w_EN_CALC,
		i_VALID_PIXEL		=> i_VALID_PIXEL,
		i_Pixel			    => w_DRA_OUT,
		o_PIX_RDY       => o_PIXEL_READY,
		o_Calc_newC 	  => o_OUT_PIXEL
	);

	-- COUNTERS
	COUNT_BUFFER_FILLED : entity work.count
  generic map (
    p_INITVALUE => 0,
    p_STEP			=> 1
  )
	port map(
	  i_CLK => i_CLK,
	  i_RST => i_RST,
	  i_ENA => w_BUFFER_FILLED,
	  i_CLR => i_CLR_BUF_FIL,
	  o_Q   => w_CNT_BUFFER_FILLED
	);
	w_BUFFER_FILLED <= i_EN_BUF_FIL and i_VALID_PIXEL;
	o_BUFFER_FILLED <= '1' when (w_CNT_BUFFER_FILLED = c_BUF_FIL-1) else '0';

	COUNT_IMG_DONE : entity work.count
  generic map (
    p_INITVALUE => 0,
    p_STEP			=> 1
  )
	port map(
	  i_CLK => i_CLK,
	  i_RST => i_RST,
	  i_ENA => w_IMG_DONE,
	  i_CLR => i_CLR_KER_TOT,
	  o_Q   => w_CNT_IMG_DONE
	);
	w_IMG_DONE    <= i_EN_KER_TOT and i_VALID_PIXEL;
	o_MAX_KER_TOT <= '1' when (w_CNT_IMG_DONE >= c_WIN_TOT-1) else '0';

	COUNT_MAX_ROW : entity work.count
  generic map (
    p_INITVALUE => 0,
    p_STEP			=> 1
  )
	port map(
	  i_CLK => i_CLK,
	  i_RST => i_RST,
	  i_ENA => w_MAX_ROW,
	  i_CLR => i_CLR_KER_ROW,
	  o_Q   => w_CNT_MAX_ROW
	);
	w_MAX_ROW     <= i_EN_KER_ROW and i_VALID_PIXEL;
	o_MAX_KER_ROW <= '1' when (w_CNT_MAX_ROW = c_WIN_ROW-1) else '0';

	COUNT_INV_PIX : entity work.count
  generic map (
    p_INITVALUE => 0,
    p_STEP			=> 1
  )
	port map(
	  i_CLK => i_CLK,
	  i_RST => i_RST,
	  i_ENA => w_INV_PIX,
	  i_CLR => i_CLR_INV_KER,
	  o_Q   => w_CNT_INV_PIX
	);
	w_INV_PIX     <= i_EN_INV_KER and i_VALID_PIXEL;
	o_MAX_INV_KER <= '1' when (w_CNT_INV_PIX = c_INV_WIN-1) else '0';

	COUNT_ITERATE : entity work.count
  generic map (
    p_INITVALUE => 0,
    p_STEP			=> 1
  )
	port map(
	  i_CLK => i_CLK,
	  i_RST => i_RST,
	  i_ENA => i_EN_IT,
	  i_CLR => '0',
	  o_Q   => w_CNT_ITERATE
	);
	o_ITERATE <= '1' when (w_CNT_ITERATE >= ITERATIONS) else '0';

end architecture;
