library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;	-- Package with project types

entity topmem is
port (
 i_CLK                     : in std_logic;
 i_RST                     : in std_logic;
 i_START                   : in std_logic;

 i_INPUTPIXEL_ARM         : in t_SIZE (PROC_NUMBER-1 downto 0);
 i_INPUTPIXEL_PROC				: in t_SIZE (PROC_NUMBER-1 downto 0);

 i_VALIDPIXEL   					: in std_logic;
 i_PROC_DONE              : in std_logic;
 i_ITERATE_END            : in std_logic;

 o_VALID_PIXEL     				: out std_logic;
 o_START           				: out std_logic;
 o_QEMPTY          				: out std_logic;

 o_ITDONE                 : out std_logic;
 o_CHANGEVP               : out std_logic;

 o_P       								: out t_SIZE (PROC_NUMBER-1 downto 0)
);
end topmem;

architecture arch of topmem is

signal w_INPUTPIXEL_M0      	: std_logic_vector(MSB+LSB-1 downto 0);
signal w_INPUTPIXEL_M1      	: t_SIZE (PROC_NUMBER-3 downto 0);
signal w_INPUTPIXEL_M2      	: std_logic_vector(MSB+LSB-1 downto 0);
signal w_OUT_FIFO_M0	      	: std_logic_vector(MSB+LSB-1 downto 0);
signal w_OUT_FIFO_M1	      	: t_SIZE (PROC_NUMBER-3 downto 0);
signal w_OUT_FIFO_M2	      	: std_logic_vector(MSB+LSB-1 downto 0);

-- coming from reading
signal w_RREQ_M0			        : std_logic;
signal w_WREQ_M0			        : std_logic;
signal w_CLR_CNT_ADDRB_M0    	: std_logic;
signal w_START_M0    					: std_logic;
signal w_CLR_CNT_ADDRA_M0    	: std_logic;
signal w_INC_CNT_ADDRA_M0    	: std_logic;
signal w_SEL_MUX_P0          	: std_logic;
signal w_SEL_MUX_M0          	: std_logic_vector (1 downto 0);
signal w_SEL_MUX_ADDRA_M0    	: std_logic;
signal w_WRREN_M0            	: std_logic;
signal w_INC_CNT_ADDRVB_M0   	: std_logic;
signal w_CLR_CNT_ADDRVB_M0   	: std_logic;
signal w_INC_CNT_COLUMN_M0   	: std_logic;
signal w_CLR_CNT_COLUMN_M0   	: std_logic;
signal w_CLR_CNT_ADDRVB_P0_M1	: std_logic;
signal w_INC_CNT_ADDRVB_P0_M1	: std_logic;
signal w_INC_CNT_ADDRVB_P2_M1	: std_logic;
signal w_SEL_MUX_P1          	: std_logic_vector (1 downto 0);
signal w_SEL_MUX_M1          	: std_logic_vector (1 downto 0);
signal w_SEL_MUX_ADDRA_M1    	: std_logic_vector (1 downto 0);
signal w_INC_CNT_ADDRA_M2    	: std_logic;
signal w_SEL_MUX_P2          	: std_logic;
signal w_SEL_MUX_M2          	: std_logic_vector (1 downto 0);
signal w_INC_CNT_ADDRVB_M2   	: std_logic;

-- coming from ctrl
-- signal w_INC_PIXEL_MEM       	: std_logic;
-- signal w_CLR_PIXEL_MEM       	: std_logic;

-- going to ctrls
signal w_END_VB_INC_M0       	: std_logic;
signal w_IMG_DONE_M0         	: std_logic;
signal w_END_R_M0            	: std_logic;
signal w_END_VB_INC_END_M0   	: std_logic;

-- going to ctrls
signal w_FIFO_M0_EMPTY		   	: std_logic;
signal w_FIFO_M1_EMPTY		  	: std_logic_vector (PROC_NUMBER-3 downto 0);
signal w_FIFO_M2_EMPTY	  	  : std_logic;
signal w_MEM_FULL			      	: std_logic;

-- ctrl signals
signal w_DONE_M0              : std_logic;
signal w_SEL_MUX_PIXEL_IN     : std_logic;

signal w_ITDONE							  : std_logic;

-- delay signals
signal w_DELAYM0 							: std_logic;

-- mux signals
signal w_OUTMUXM0							: std_logic;
signal w_FIFOMUXM0						: std_logic;

-- signal w_CNT_START            : integer := 0;
-- signal w_COUNT_START			    : std_logic;

begin

	-- selects which signal controls WRENB
	w_OUTMUXM0   <= w_WRREN_M0   when w_START_M0 = '0' else w_DELAYM0;
  w_WREQ_M0    <= '0'          when w_START_M0 = '0' else i_VALIDPIXEL;
	w_FIFOMUXM0	 <= w_RREQ_M0    when w_START_M0 = '0' else w_RREQ_M0 and not w_FIFO_M0_EMPTY;

	-- RREQ delayed
	u_DELAY : process (i_CLK)
	begin
		if (rising_edge(i_CLK)) then
		  w_DELAYM0 <= w_FIFOMUXM0;
		end if;
	end process;

	-- fifos for data_R
	FIFO_M0 : entity work.FIFO_16
	port map (
		clock	=> i_CLK,
		data	=> i_INPUTPIXEL_PROC(0),
		rdreq	=> w_FIFOMUXM0,
		wrreq	=> w_WREQ_M0, -- mudei aqui de i_validpixel
		empty	=> w_FIFO_M0_EMPTY,
		q	 		=> w_OUT_FIFO_M0
	);

	g_FIFO_M1 : for i in 0 to PROC_NUMBER-3 generate
		FIFO_M1 : entity work.FIFO_16
		port map(
			clock	=> i_CLK,
			data	=> i_INPUTPIXEL_PROC(i+1),
			rdreq	=> w_FIFOMUXM0,
			wrreq	=> w_WREQ_M0,
			empty	=> w_FIFO_M1_EMPTY(i),
			q	 		=> w_OUT_FIFO_M1(i)
		);
	end generate;

	FIFO_M2 : entity work.FIFO_16
	port map(
		clock	=> i_CLK,
		data	=> i_INPUTPIXEL_PROC(PROC_NUMBER-1),
		rdreq	=> w_FIFOMUXM0,
		wrreq	=> w_WREQ_M0,
		empty	=> w_FIFO_M2_EMPTY,
		q	 		=> w_OUT_FIFO_M2
	);

 -- mux that choose if the pixel comes from the ARM or from the processor
 MUX_PIXEL_IN_M0 : entity work.mux
 generic map (
	 address_size => MSB+LSB
 )
 port map (
   i_SEL	=> w_SEL_MUX_PIXEL_IN,
   i_A	  => i_INPUTPIXEL_ARM(0),
   i_B 	  => w_OUT_FIFO_M0,
   o_S 	  => w_INPUTPIXEL_M0
 );

 g_MUX_PIXEL_IN_M1 : for i in 0 to PROC_NUMBER-3 generate
	 MUX_PIXEL_IN_M1 : entity work.mux
	 generic map (
		 address_size => MSB+LSB
	 )
	 port map (
	   i_SEL	=> w_SEL_MUX_PIXEL_IN,
	   i_A	  => i_INPUTPIXEL_ARM(i+1),
	   i_B 		=> w_OUT_FIFO_M1(i),
	   o_S 		=> w_INPUTPIXEL_M1(i)
	 );
 end generate;

 MUX_PIXEL_IN_M2 : entity work.mux
 generic map (
	 address_size => MSB+LSB
 )
 port map (
   i_SEL	=> w_SEL_MUX_PIXEL_IN,
   i_A	  => i_INPUTPIXEL_ARM(PROC_NUMBER-1),
   i_B   	=> w_OUT_FIFO_M2,
   o_S   	=> w_INPUTPIXEL_M2
 );

 datapath : entity work.datapathmem
 port map (
   i_CLK                  => i_CLK,
   i_RST                  => i_RST,

   i_INPUTPIXELB_M0       => w_INPUTPIXEL_M0,
   i_INPUTPIXELB_M1       => w_INPUTPIXEL_M1,
   i_INPUTPIXELB_M2       => w_INPUTPIXEL_M2,

   i_CLR_CNT_ADDRB_M0     => w_CLR_CNT_ADDRB_M0,

   i_CLR_CNT_ADDRA_M0     => w_CLR_CNT_ADDRA_M0,
   i_INC_CNT_ADDRA_M0     => w_INC_CNT_ADDRA_M0,
   i_SEL_MUX_P0           => w_SEL_MUX_P0,
   i_SEL_MUX_M0           => w_SEL_MUX_M0,
   i_SEL_MUX_ADDRA_M0     => w_SEL_MUX_ADDRA_M0,
   i_WRENB_M0             => w_OUTMUXM0,
   i_INC_CNT_ADDRVB_M0    => w_INC_CNT_ADDRVB_M0,
   i_CLR_CNT_ADDRVB_M0    => w_CLR_CNT_ADDRVB_M0,
   i_INC_CNT_COLUMN_M0    => w_INC_CNT_COLUMN_M0,
   i_CLR_CNT_COLUMN_M0    => w_CLR_CNT_COLUMN_M0,
   i_CLR_CNT_ADDRVB_P0_M1 => w_CLR_CNT_ADDRVB_P0_M1,
   i_INC_CNT_ADDRVB_P0_M1 => w_INC_CNT_ADDRVB_P0_M1,
   i_INC_CNT_ADDRVB_P2_M1 => w_INC_CNT_ADDRVB_P2_M1,
   i_SEL_MUX_P1           => w_SEL_MUX_P1,
   i_SEL_MUX_M1           => w_SEL_MUX_M1,
   i_SEL_MUX_ADDRA_M1     => w_SEL_MUX_ADDRA_M1,
   i_INC_CNT_ADDRA_M2     => w_INC_CNT_ADDRA_M2,
   i_SEL_MUX_P2           => w_SEL_MUX_P2,
   i_SEL_MUX_M2           => w_SEL_MUX_M2,
   i_INC_CNT_ADDRVB_M2    => w_INC_CNT_ADDRVB_M2,

   -- i_INC_PIXEL_MEM        => w_INC_PIXEL_MEM,
   -- i_CLR_PIXEL_MEM        => w_CLR_PIXEL_MEM,

   o_P                    => o_P,

	 o_END_VB_INC_M0        => w_END_VB_INC_M0,
   o_IMG_DONE_M0          => w_IMG_DONE_M0,
   o_END_R                => w_END_R_M0,
	 o_END_VB_INC_END_M0    => w_END_VB_INC_END_M0,

   o_MEM_FULL             => w_MEM_FULL
 );

 ctrlmem_i : ctrlmem
 port map (
	 i_CLK                  => i_CLK,
	 i_RST                  => i_RST,
	 i_START                => i_START,
	 i_END_VB_INC           => w_END_VB_INC_M0,
	 i_IMG_DONE             => w_IMG_DONE_M0,
	 i_END_R                => w_END_R_M0,
	 i_END_VB_INC_END       => w_END_VB_INC_END_M0,
	 i_PROC_DONE            => i_PROC_DONE,
	 i_ITERATE_END          => i_ITERATE_END,
	 i_MEM_FULL             => w_MEM_FULL,
	 i_Q_EMPTY              => w_FIFO_M0_EMPTY,
	 o_CLR_CNT_ADDRA        => w_CLR_CNT_ADDRA_M0,
	 o_INC_CNT_ADDRA        => w_INC_CNT_ADDRA_M0,
	 o_INC_CNT_ADDRA2       => w_INC_CNT_ADDRA_M2,
	 o_CLR_CNT_ADDRVB_P0_M1 => w_CLR_CNT_ADDRVB_P0_M1,
	 o_INC_CNT_ADDRVB_P0_M1 => w_INC_CNT_ADDRVB_P0_M1,
	 o_INC_CNT_ADDRVB_P2_M1 => w_INC_CNT_ADDRVB_P2_M1,
	 o_SEL_MUX_P0           => w_SEL_MUX_P0,
	 o_SEL_MUX_P1           => w_SEL_MUX_P1,
	 o_SEL_MUX_P2           => w_SEL_MUX_P2,
	 o_SEL_MUX_M0           => w_SEL_MUX_M0,
	 o_SEL_MUX_M1           => w_SEL_MUX_M1,
	 o_SEL_MUX_M2           => w_SEL_MUX_M2,
	 o_SEL_MUX_ADDRA        => w_SEL_MUX_ADDRA_M0,
	 o_SEL_MUX_ADDRA1       => w_SEL_MUX_ADDRA_M1,
	 -- o_INC_PIXEL_MEM        => w_INC_PIXEL_MEM,
	 -- o_CLR_PIXEL_MEM        => w_CLR_PIXEL_MEM,
	 o_INC_CNT_ADDRVB       => w_INC_CNT_ADDRVB_M0,
	 o_CLR_CNT_ADDRVB       => w_CLR_CNT_ADDRVB_M0,
	 o_INC_CNT_ADDRVB2      => w_INC_CNT_ADDRVB_M2,
	 o_INC_CNT_COLUMN       => w_INC_CNT_COLUMN_M0,
	 o_CLR_CNT_COLUMN       => w_CLR_CNT_COLUMN_M0,
	 o_RREQ                 => w_RREQ_M0,
	 o_VALID_PIXEL          => o_VALID_PIXEL,
	 o_SEL_MUX_PIXEL_IN     => w_SEL_MUX_PIXEL_IN,
	 o_CLR_CNT_ADDRB        => w_CLR_CNT_ADDRB_M0,
	 o_WRREN                => w_WRREN_M0,
	 o_START     		        => w_START_M0,
	 o_ITDONE	           		=> w_ITDONE,
	 o_DONE                 => w_DONE_M0
 );

 o_START  <= w_START_M0;
 o_QEMPTY <= w_FIFO_M0_EMPTY;
 o_ITDONE <= w_ITDONE;

end architecture;
