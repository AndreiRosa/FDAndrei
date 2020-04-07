library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

package fda_package is

  ------------------- Constants ------------------
  constant MEM_WIDTH     : integer := 100;
  constant MEM_HEIGHT    : integer := 100;
  constant ITERATIONS    : integer := 3;
  constant PROC_NUMBER   : integer := 20;

  -- Constants that hardly ever will change
  constant MSB 		       : integer := 8;
  constant LSB 		       : integer := 8;
  constant KERNEL_HEIGHT : integer := 3;
  constant KERNEL_WIDTH  : integer := 3;

    -- MEM
  constant c_COUNT_IMG_DONE : integer := MEM_HEIGHT * (MEM_WIDTH/PROC_NUMBER);
  constant c_MEM_SIZE				: integer := integer((ceil(log2(real(c_COUNT_IMG_DONE)))));

  -- CALC
  constant CALCQX				 : std_logic_vector(MSB+LSB-1 downto 0) := x"001F"; -- 0.122320
  constant CALCQC			   : std_logic_vector(MSB+LSB-1 downto 0) := x"0005"; -- 1 - 8*CALCQX

  -- FDA
  constant c_MEM_WIDTH        : integer := (MEM_WIDTH/PROC_NUMBER) + 2; -- image width + VB
  constant c_MEM_HEIGHT       : integer := MEM_HEIGHT + 2; -- image height + VB
  constant c_OUT_IMG_WIDTH    : integer := c_MEM_WIDTH - (KERNEL_WIDTH - 1);
  constant c_OUT_IMG_HEIGHT   : integer := c_MEM_HEIGHT - (KERNEL_HEIGHT - 1);
  constant c_ROW_BUF_SIZE     : integer := c_MEM_WIDTH - KERNEL_WIDTH ;
  constant c_KERNEL_SIZE      : integer := KERNEL_WIDTH  * KERNEL_HEIGHT;
  constant c_BUF_FIL          : integer := (c_MEM_WIDTH * (KERNEL_HEIGHT - 1) + KERNEL_WIDTH );
  constant c_WIN_TOT          : integer := c_OUT_IMG_HEIGHT * c_OUT_IMG_WIDTH;
  constant c_WIN_ROW          : integer := c_OUT_IMG_WIDTH;
  constant c_INV_WIN          : integer := KERNEL_WIDTH - 1;

  ------------------- Types ----------------------
	type t_SIZE is array(integer range<>) of std_logic_vector(MSB+LSB-1 downto 0);
  type t_ADDR is array(integer range<>) of std_logic_vector(c_MEM_SIZE-1 downto 0);
  type t_MATRIX is array (PROC_NUMBER-1 downto 0) of t_SIZE(c_COUNT_IMG_DONE-1 downto 0);

  ------------------ Components ------------------
  component Calc_newC
  port (
    i_CLK         : in  std_logic;
    i_RST         : in  std_logic;
    i_ENA         : in  std_logic;
    i_VALID_PIXEL : in  std_logic;
    i_Pixel       : in  t_SIZE(8 downto 0);
    o_PIX_RDY     : out std_logic;
    o_Calc_newC   : out std_logic_vector(MSB+LSB-1 downto 0)
  );
  end component Calc_newC;

  component count
  generic (
    p_INITVALUE : integer;
    p_STEP      : integer
  );
  port (
    i_CLK : in  std_logic;
    i_RST : in  std_logic;
    i_ENA : in  std_logic;
    i_CLR : in  std_logic;
    o_Q   : out integer
  );
  end component count;

  component countsync
  generic (
    p_INITVALUE : integer;
    p_STEP      : integer
  );
  port (
    i_CLK : in  std_logic;
    i_RST : in  std_logic;
    i_ENA : in  std_logic;
    i_CLR : in  std_logic;
    o_Q   : out integer
  );
  end component countsync;

  component ctrl
  port (
    i_CLK             : in  std_logic;
    i_RST             : in  std_logic;
    i_START           : in  std_logic;
    i_QEMPTY          : in  std_logic;
    i_VALID_PIXEL     : in  std_logic;
    i_MAX_KER_TOT     : in  std_logic;
    i_MAX_KER_ROW     : in  std_logic;
    i_MAX_INV_KER     : in  std_logic;
    i_BUFFER_FILLED   : in  std_logic;
    i_ITERATE         : in  std_logic;
    o_CLR_KER_TOT     : out std_logic;
    o_CLR_KER_ROW     : out std_logic;
    o_CLR_INV_KER     : out std_logic;
    o_CLR_BUF_FIL     : out std_logic;
    o_EN_KER_TOT      : out std_logic;
    o_EN_KER_ROW      : out std_logic;
    o_EN_INV_KER      : out std_logic;
    o_EN_BUF_FIL      : out std_logic;
    o_EN_IT           : out std_logic;
    o_EN_CALC         : out std_logic;
    o_EN_WRITE_KERNEL : out std_logic;
    o_PROC_DONE       : out std_logic;
    o_DONE            : out std_logic
  );
  end component ctrl;

  component ctrlmem
  port (
    i_CLK                  : in  std_logic;
    i_RST                  : in  std_logic;
    i_START                : in  std_logic;
    i_END_VB_INC           : in  std_logic;
    i_IMG_DONE             : in  std_logic;
    i_END_R                : in  std_logic;
    i_END_VB_INC_END       : in  std_logic;
    i_PROC_DONE            : in  std_logic;
    i_ITERATE_END          : in  std_logic;
    i_MEM_FULL             : in  std_logic;
    i_Q_EMPTY              : in  std_logic;
    o_CLR_CNT_ADDRA        : out std_logic;
    o_INC_CNT_ADDRA        : out std_logic;
    o_INC_CNT_ADDRA2       : out std_logic;
    o_CLR_CNT_ADDRVB_P0_M1 : out std_logic;
    o_INC_CNT_ADDRVB_P0_M1 : out std_logic;
    o_INC_CNT_ADDRVB_P2_M1 : out std_logic;
    o_SEL_MUX_P0           : out std_logic;
    o_SEL_MUX_P1           : out std_logic_vector (1 downto 0);
    o_SEL_MUX_P2           : out std_logic;
    o_SEL_MUX_M0           : out std_logic_vector (1 downto 0);
    o_SEL_MUX_M1           : out std_logic_vector (1 downto 0);
    o_SEL_MUX_M2           : out std_logic_vector (1 downto 0);
    o_SEL_MUX_ADDRA        : out std_logic;
    o_SEL_MUX_ADDRA1       : out std_logic_vector (1 downto 0);
    -- o_INC_PIXEL_MEM        : out std_logic;
    -- o_CLR_PIXEL_MEM        : out std_logic;
    o_INC_CNT_ADDRVB       : out std_logic;
    o_CLR_CNT_ADDRVB       : out std_logic;
    o_INC_CNT_ADDRVB2      : out std_logic;
    o_INC_CNT_COLUMN       : out std_logic;
    o_CLR_CNT_COLUMN       : out std_logic;
    o_RREQ                 : out std_logic;
    o_VALID_PIXEL          : out std_logic;
    o_SEL_MUX_PIXEL_IN     : out std_logic;
    o_CLR_CNT_ADDRB        : out std_logic;
    o_WRREN                : out std_logic;
    o_START                : out std_logic;
    o_ITDONE               : out std_logic;
    o_DONE                 : out std_logic
  );
  end component ctrlmem;

  component datapath
  port (
    i_CLK             : in  std_logic;
    i_RST             : in  std_logic;
    i_INPUT_PIXEL     : in  std_logic_vector (MSB+LSB-1 downto 0);
    i_VALID_PIXEL     : in  std_logic;
    i_CLR_KER_TOT     : in  std_logic;
    i_CLR_KER_ROW     : in  std_logic;
    i_CLR_INV_KER     : in  std_logic;
    i_CLR_BUF_FIL     : in  std_logic;
    i_EN_KER_TOT      : in  std_logic;
    i_EN_KER_ROW      : in  std_logic;
    i_EN_INV_KER      : in  std_logic;
    i_EN_BUF_FIL      : in  std_logic;
    i_EN_IT           : in  std_logic;
    i_EN_CALC         : in  std_logic;
    i_EN_WRITE_KERNEL : in  std_logic;
    o_MAX_KER_TOT     : out std_logic;
    o_MAX_KER_ROW     : out std_logic;
    o_MAX_INV_KER     : out std_logic;
    o_BUFFER_FILLED   : out std_logic;
    o_ITERATE         : out std_logic;
    o_PIXEL_READY     : out std_logic;
    o_OUT_PIXEL       : out std_logic_vector(MSB+LSB-1 downto 0)
  );
  end component datapath;

  component datapathmem
  port (
    i_CLK                  : in  std_logic;
    i_RST                  : in  std_logic;
    i_INPUTPIXELB_M0       : in  std_logic_vector(MSB+LSB-1 downto 0);
    i_INPUTPIXELB_M1       : in  t_SIZE (PROC_NUMBER-3 downto 0);
    i_INPUTPIXELB_M2       : in  std_logic_vector(MSB+LSB-1 downto 0);
    i_CLR_CNT_ADDRB_M0     : in  std_logic;
    i_CLR_CNT_ADDRA_M0     : in  std_logic;
    i_INC_CNT_ADDRA_M0     : in  std_logic;
    i_SEL_MUX_P0           : in  std_logic;
    i_SEL_MUX_M0           : in  std_logic_vector (1 downto 0);
    i_SEL_MUX_ADDRA_M0     : in  std_logic;
    i_WRENB_M0             : in  std_logic;
    i_INC_CNT_ADDRVB_M0    : in  std_logic;
    i_CLR_CNT_ADDRVB_M0    : in  std_logic;
    i_INC_CNT_COLUMN_M0    : in  std_logic;
    i_CLR_CNT_COLUMN_M0    : in  std_logic;
    i_CLR_CNT_ADDRVB_P0_M1 : in  std_logic;
    i_INC_CNT_ADDRVB_P0_M1 : in  std_logic;
    i_INC_CNT_ADDRVB_P2_M1 : in  std_logic;
    i_SEL_MUX_P1           : in  std_logic_vector (1 downto 0);
    i_SEL_MUX_M1           : in  std_logic_vector (1 downto 0);
    i_SEL_MUX_ADDRA_M1     : in  std_logic_vector (1 downto 0);
    i_INC_CNT_ADDRA_M2     : in  std_logic;
    i_SEL_MUX_P2           : in  std_logic;
    i_SEL_MUX_M2           : in  std_logic_vector (1 downto 0);
    i_INC_CNT_ADDRVB_M2    : in  std_logic;
    -- i_INC_PIXEL_MEM        : in  std_logic;
    -- i_CLR_PIXEL_MEM        : in  std_logic;
    o_P                    : out t_SIZE (PROC_NUMBER-1 downto 0);
    o_END_VB_INC_M0        : out std_logic;
    o_IMG_DONE_M0          : out std_logic;
    o_END_R                : out std_logic;
    o_END_VB_INC_END_M0    : out std_logic;
    o_MEM_FULL             : out std_logic
  );
  end component datapathmem;

	component DRA is
	port(
		 i_CLK 				  : in std_logic;
		 i_RST 			    : in std_logic;
		 i_INPUT_PIXEL 	: in std_logic_vector(MSB+LSB-1 downto 0);
		 i_ENA_WRI_KER 	: in std_logic;
		 o_OUT_KERNEL  	: out t_SIZE(0 to c_KERNEL_SIZE-1)
	);
	end component;

  component FIFO_16
  port (
    clock : in  std_logic;
    data  : in  std_logic_vector(MSB+LSB-1 downto 0);
    rdreq : in  std_logic;
    wrreq : in  std_logic;
    empty : out std_logic;
    q     : out std_logic_vector(MSB+LSB-1 downto 0)
  );
  end component FIFO_16;

	component ff is
	port(
		i_CLK   : in  std_logic;
		i_RST   : in  std_logic;
		i_ENA   : in  std_logic;
		i_CLR   : in  std_logic;
		i_DIN   : in  std_logic;
		o_OUT   : out std_logic
		);
	end component;

  component mux
  generic (
    address_size : integer
  );
  port (
    i_SEL : in  std_logic;
    i_A   : in  std_logic_vector(address_size-1 downto 0);
    i_B   : in  std_logic_vector(address_size-1 downto 0);
    o_S   : out std_logic_vector(address_size-1 downto 0)
  );
  end component mux;

  component mux4_1
  generic (
    address_size : integer
  );
  port (
    i_SEL : in  std_logic_vector(1 downto 0);
    i_A   : in  std_logic_vector(address_size-1 downto 0);
    i_B   : in  std_logic_vector(address_size-1 downto 0);
    i_C   : in  std_logic_vector(address_size-1 downto 0);
    i_D   : in  std_logic_vector(address_size-1 downto 0);
    o_S   : out std_logic_vector(address_size-1 downto 0)
  );
  end component mux4_1;

  component ram_1
  port (
    address	: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    clock		: IN STD_LOGIC  := '1';
    data		: IN STD_LOGIC_VECTOR (MSB+LSB-1 DOWNTO 0);
    wren		: IN STD_LOGIC ;
    q	    	: OUT STD_LOGIC_VECTOR (MSB+LSB-1 DOWNTO 0)
  );
  end component ram_1;

  component ram_2
  generic (
    address_size : integer;
    data_size    : integer
  );
  port (
    i_ADD_A       : in  std_logic_vector(address_size-1 downto 0);
    i_ADD_B       : in  std_logic_vector(address_size-1 downto 0);
    i_CLK 		 		: in  std_logic;
    i_DATA_B      : in  std_logic_vector(data_size-1 downto 0);
    i_WREN_B      : in  std_logic;
    o_READ_DATA_A : out std_logic_vector(data_size-1 downto 0);
    o_READ_DATA_B : out std_logic_vector(data_size-1 downto 0)
  );
  end component ram_2;

  component rom
  port(
    i_CLK			: in  std_logic;
  	i_RST			: in  std_logic;
    i_ENA_RD  : in  std_logic;
    i_CONTENT : in  t_SIZE(c_COUNT_IMG_DONE-1 downto 0);
    i_ADDR 	  : in  std_logic_vector(c_MEM_SIZE-1 downto 0);
  	o_DATA 	  : out std_logic_vector(MSB+LSB-1 downto 0)
  );
  end component rom;

	component reg is
	generic(
		p_SIZE : integer := MSB+LSB
	);
	port(
		i_CLK   : in  std_logic;
		i_RST   : in  std_logic;
		i_ENA   : in  std_logic;
		i_CLR   : in  std_logic;
		i_DIN   : in  std_logic_vector (p_SIZE-1 downto 0);
		o_OUT   : out std_logic_vector (p_SIZE-1 downto 0)
	);
	end component;

  component regint
  port (
    i_CLK : in  std_logic;
    i_RST : in  std_logic;
    i_ENA : in  std_logic;
    i_CLR : in  std_logic;
    i_DIN : in  integer;
    o_OUT : out integer
  );
  end component regint;

	component row_buffer is
	generic (
		c_SIZE 	: integer;
		c_WIDTH  : integer
	);
	port(
		i_CLK 			  : in  std_logic;
		i_RST 			  : in  std_logic;
		i_ENA 			  : in  std_logic;
		i_CLR   			: in  std_logic;
		i_DATA_IN 		: in  std_logic_vector(MSB+LSB-1 downto 0);
		o_DATA_OUT		: out std_logic_vector(MSB+LSB-1 downto 0)
	);
	end component;

  component topmem
  port (
    i_CLK             : in  std_logic;
    i_RST             : in  std_logic;
    i_START           : in  std_logic;
    i_INPUTPIXEL_ARM  : in  t_SIZE (PROC_NUMBER-1 downto 0);
    i_INPUTPIXEL_PROC : in  t_SIZE (PROC_NUMBER-1 downto 0);
    i_VALIDPIXEL      : in  std_logic;
    i_PROC_DONE       : in  std_logic;
    i_ITERATE_END     : in  std_logic;
    o_VALID_PIXEL     : out std_logic;
    o_START           : out std_logic;
    o_QEMPTY          : out std_logic;
    o_ITDONE          : out std_logic;
    o_CHANGEVP        : out std_logic;
    o_P               : out t_SIZE (PROC_NUMBER-1 downto 0)
  );
  end component topmem;

  component top
  port (
    i_CLK         : in  std_logic;
    i_RST         : in  std_logic;
    i_START       : in  std_logic;
    i_QEMPTY      : in  std_logic;
    i_INPUT_PIXEL : in  std_logic_vector (MSB+LSB-1 downto 0);
    i_VALID_PIXEL : in  std_logic;
    o_PIXEL_READY : out std_logic;
    o_PROC_DONE   : out std_logic;
    o_EN_IT       : out std_logic;
    o_ITERATE_END : out std_logic;
    o_OUT_PIXEL   : out std_logic_vector(MSB+LSB-1 downto 0);
    o_DONE        : out std_logic
  );
  end component top;

  component topperthantop
  port (
    i_CLK         : in  std_logic;
    i_RST         : in  std_logic;
    i_START       : in  std_logic;
    i_QEMPTY      : in  std_logic;
    i_INPUT_PIXEL : in  t_SIZE (PROC_NUMBER-1 downto 0);
    i_VALID_PIXEL : in  std_logic;
    o_PIXEL_READY : out std_logic_vector (PROC_NUMBER-1 downto 0);
    o_PROC_DONE   : out std_logic_vector (PROC_NUMBER-1 downto 0);
    o_EN_IT       : out std_logic_vector (PROC_NUMBER-1 downto 0);
    o_ITERATE_END : out std_logic_vector (PROC_NUMBER-1 downto 0);
    o_OUT_PIXEL   : out t_SIZE (PROC_NUMBER-1 downto 0);
    o_DONE        : out std_logic_vector(PROC_NUMBER-1 downto 0)
  );
  end component topperthantop;

  component toppest
  port (
    i_CLK         : in  std_logic;
    i_RST         : in  std_logic;
    i_START       : in  std_logic;
    i_INPUT_PIXEL : in  t_SIZE (PROC_NUMBER-1 downto 0);
    i_VALID_PIXEL : in  std_logic;
    o_VALID_PIXEL : out std_logic_vector (PROC_NUMBER-1 downto 0);
    o_OUT_PIXEL   : out t_SIZE (PROC_NUMBER-1 downto 0);
    o_DONE        : out std_logic_vector(PROC_NUMBER-1 downto 0)
  );
  end component toppest;

end fda_package;

package body fda_package is

end fda_package;
