library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;	-- Package with project types

entity datapathmem is
port(
	i_CLK                     : in  std_logic;
	i_RST                     : in  std_logic;

	i_INPUTPIXELB_M0          : in std_logic_vector(MSB+LSB-1 downto 0);
  i_INPUTPIXELB_M1          : in t_SIZE (PROC_NUMBER-3 downto 0);
	i_INPUTPIXELB_M2          : in std_logic_vector(MSB+LSB-1 downto 0);

	i_CLR_CNT_ADDRB_M0        : in std_logic;
  i_CLR_CNT_ADDRA_M0        : in std_logic;
  i_INC_CNT_ADDRA_M0        : in std_logic;
  i_SEL_MUX_P0              : in std_logic;
  i_SEL_MUX_M0              : in std_logic_vector (1 downto 0);
  i_SEL_MUX_ADDRA_M0        : in std_logic;
  i_WRENB_M0                : in std_logic;
  i_INC_CNT_ADDRVB_M0       : in std_logic;
  i_CLR_CNT_ADDRVB_M0       : in std_logic;
  i_INC_CNT_COLUMN_M0       : in std_logic;
  i_CLR_CNT_COLUMN_M0       : in std_logic;
  i_CLR_CNT_ADDRVB_P0_M1    : in std_logic;
  i_INC_CNT_ADDRVB_P0_M1    : in std_logic;
  i_INC_CNT_ADDRVB_P2_M1    : in std_logic;
  i_SEL_MUX_P1              : in std_logic_vector (1 downto 0);
  i_SEL_MUX_M1              : in std_logic_vector (1 downto 0);
  i_SEL_MUX_ADDRA_M1        : in std_logic_vector (1 downto 0);
  i_INC_CNT_ADDRA_M2        : in std_logic;
  i_SEL_MUX_P2              : in std_logic;
  i_SEL_MUX_M2              : in std_logic_vector (1 downto 0);
  i_INC_CNT_ADDRVB_M2       : in std_logic;

	-- i_INC_PIXEL_MEM           : in std_logic;
	-- i_CLR_PIXEL_MEM           : in std_logic;

	o_P       								: out t_SIZE (PROC_NUMBER-1 downto 0);

  o_END_VB_INC_M0           : out std_logic;
  o_IMG_DONE_M0             : out std_logic;
  o_END_R		                : out std_logic;
	o_END_VB_INC_END_M0       : out std_logic;

	o_MEM_FULL								: out std_logic
);
end datapathmem;

architecture arch of datapathmem is

-- count/comp signals
signal w_CNT_ADDRA_M0         : integer := 0;
signal w_CNT_ADDRA_M2         : integer := 0;
signal w_CNT_ADDRB_M0         : integer := 0;
signal w_CNT_ADDRESS_VB_P0_M1 : integer := 0;
signal w_CNT_ADDRESS_VB_P2_M1 : integer := 0;

signal w_END_VB_INC_M0      : integer := 0;
signal w_END_VB_INC_M2      : integer := 0;
signal w_IMG_DONE_M0   	    : integer := 0;
signal w_END_R_M0      	    : integer := 0;
signal w_END_VB_INC_END_M2	: integer := 0;
signal w_MEM_FULL						: integer := 0;

-- mem signals
signal w_OUTA_M0      : std_logic_vector (MSB+LSB-1 downto 0);
signal w_OUTB_M0      : std_logic_vector (MSB+LSB-1 downto 0);
signal w_OUTA_M1      : t_SIZE (PROC_NUMBER-3 downto 0); -- GENERATE
signal w_OUTB_M1      : t_SIZE (PROC_NUMBER-3 downto 0); -- GENERATE
signal w_OUTA_M2      : std_logic_vector (MSB+LSB-1 downto 0);
signal w_OUTB_M2      : std_logic_vector (MSB+LSB-1 downto 0);

-- mem's mux_addra signals
signal w_AM0          : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_AM0PLUS      : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_AM2          : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_AM2PLUS      : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_AM1_C        : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_OUT_ADDRA_M0 : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_OUT_ADDRA_M1 : t_ADDR (PROC_NUMBER-3 downto 0); -- GENERATE
signal w_OUT_ADDRA_M2 : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_ZEROS        : std_logic_vector (c_MEM_SIZE-1 downto 0) := (others => '0');

-- mem's mux_addrb signals
signal w_M0           : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_P1M0L        : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_P0M1         : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_P0M1P        : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_P2M1         : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_PCID         : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_OUT_ADDRB_M0 : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_OUT_ADDRB_M1 : t_ADDR (PROC_NUMBER-3 downto 0); -- GENERATE
signal w_OUT_ADDRB_M2 : std_logic_vector (c_MEM_SIZE-1 downto 0);

-- flip flops
signal w_CNT_ADDRESS_VB_P0_M1_REG : integer;
signal w_CNT_ADDRESS_VB_P2_M1_REG : integer;

signal w_IMG_DONE : std_logic;

signal w_Z0 : std_logic_vector (MSB+LSB-1 downto 0) := (others => '0');

begin

  -- casting addresses
  w_AM0     <= std_logic_vector(to_unsigned(w_CNT_ADDRA_M0, w_AM0'length));
  w_AM0PLUS <= std_logic_vector(to_unsigned((w_CNT_ADDRA_M0-MEM_HEIGHT/PROC_NUMBER), w_AM0PLUS'length));
  w_AM1_C   <= std_logic_vector(to_unsigned((w_CNT_ADDRA_M0-MEM_HEIGHT/PROC_NUMBER), w_AM1_C'length));
  w_AM2     <= std_logic_vector(to_unsigned(w_CNT_ADDRA_M2, w_AM2'length));
  w_AM2PLUS <= std_logic_vector(to_unsigned((w_CNT_ADDRA_M2-MEM_HEIGHT/PROC_NUMBER), w_AM2'length));

  w_M0     <= std_logic_vector(to_unsigned(w_CNT_ADDRB_M0, w_M0'length));
	w_P1M0L  <= std_logic_vector(to_unsigned((w_CNT_ADDRESS_VB_P2_M1-MEM_HEIGHT/PROC_NUMBER), w_P1M0L'length));
	w_P0M1   <= std_logic_vector(to_unsigned(w_CNT_ADDRESS_VB_P0_M1, w_P0M1'length));
  w_P0M1P  <= std_logic_vector(to_unsigned(c_COUNT_IMG_DONE-MEM_HEIGHT/PROC_NUMBER, w_P0M1'length));
  w_P2M1   <= std_logic_vector(to_unsigned(w_CNT_ADDRESS_VB_P2_M1, w_P2M1'length));
	w_PCID   <= std_logic_vector(to_unsigned(c_COUNT_IMG_DONE-1, w_P2M1'length));


  -- mux addr_a
  MUX_ADDRA_M0 : entity work.mux
	generic map (
		address_size => c_MEM_SIZE
	)
  port map (
    i_SEL	=> i_SEL_MUX_ADDRA_M0,
    i_A	  => w_AM0,
    i_B 	=> w_AM0PLUS,
    o_S 	=> w_OUT_ADDRA_M0
  );

	g_MUX_ADDRA_M1 : for i in 0 to PROC_NUMBER-3 generate
	  MUX_ADDRA_M1 : entity work.mux4_1
		generic map (
			address_size => c_MEM_SIZE
		)
	  port map (
	    i_SEL	=> i_SEL_MUX_ADDRA_M1,
	    i_A	  => w_AM0,
	    i_B 	=> w_P0M1,
	    i_C 	=> w_AM1_C,
	    i_D 	=> w_ZEROS,
	    o_S 	=> w_OUT_ADDRA_M1(i)
	  );
	end generate;

  MUX_ADDRA_M2 : entity work.mux
	generic map (
		address_size => c_MEM_SIZE
	)
  port map (
    i_SEL	=> i_SEL_MUX_ADDRA_M0,
    i_A	  => w_AM2,
    i_B 	=> w_AM2PLUS,
    o_S 	=> w_OUT_ADDRA_M2
  );

  -- mux addr_b
  MUX_ADDRB_M0 : entity work.mux4_1
	generic map (
		address_size => c_MEM_SIZE
	)
  port map (
    i_SEL	=> i_SEL_MUX_M0,
    i_A	  => w_M0,
    i_B 	=> w_P2M1,
		i_C 	=> w_P1M0L,
		i_D   => w_PCID,
    o_S 	=> w_OUT_ADDRB_M0
  );

	g_MUX_ADDRB_M1 : for i in 0 to PROC_NUMBER-3 generate
	  MUX_ADDRB_M1 : entity work.mux4_1
		generic map (
			address_size => c_MEM_SIZE
		)
	  port map (
	    i_SEL	=> i_SEL_MUX_M1,
	    i_A	  => w_M0,
	    i_B 	=> w_P0M1,
	    i_C 	=> w_P2M1,
	    i_D   => w_P0M1P,
	    o_S 	=> w_OUT_ADDRB_M1(i)
	  );
	end generate;

  MUX_ADDRB_M2 : entity work.mux4_1
	generic map (
		address_size => c_MEM_SIZE
	)
  port map (
    i_SEL	=> i_SEL_MUX_M2,
    i_A	  => w_M0,
    i_B 	=> w_P0M1,
		i_C 	=> w_P0M1P,
		i_D   => w_ZEROS,
    o_S 	=> w_OUT_ADDRB_M2
  );

  -- mux processors
  MUX_P0 : entity work.mux
	generic map (
		address_size => MSB+LSB
	)
  port map (
    i_SEL	=> i_SEL_MUX_P0,
    i_A	  => w_OUTA_M0,
    i_B 	=> w_OUTB_M1(0),
    o_S 	=> o_P(0)
  );


	g_MUX_P1 : for i in 0 to PROC_NUMBER-3 generate
		g_IF : if (i = 0) generate
			MUX_P1_L : entity work.mux4_1
			generic map (
				address_size => MSB+LSB
			)
			port map (
				i_SEL	=> i_SEL_MUX_P1,
				i_A	  => w_OUTA_M1(i),
				i_B 	=> w_OUTB_M0,
				i_C 	=> w_OUTB_M1(i+1),
				i_D 	=> w_Z0,
				o_S 	=> o_P(i+1)
			);
		elsif (i = PROC_NUMBER-3) generate
			MUX_P1_R : entity work.mux4_1
			generic map (
				address_size => MSB+LSB
			)
			port map (
				i_SEL	=> i_SEL_MUX_P1,
				i_A	  => w_OUTA_M1(i),
				i_B 	=> w_OUTB_M1(i-1),
				i_C 	=> w_OUTB_M2,
				i_D 	=> w_Z0,
				o_S 	=> o_P(i+1)
			);
		else generate
			MUX_P1 : entity work.mux4_1
			generic map (
				address_size => MSB+LSB
			)
		  port map (
			i_SEL	=> i_SEL_MUX_P1,
			i_A	  => w_OUTA_M1(i),
			i_B 	=> w_OUTB_M1(i-1),
			i_C 	=> w_OUTB_M1(i+1),
			i_D 	=> w_Z0,
			o_S 	=> o_P(i+1)
		  );
		end generate g_IF;
	end generate g_MUX_P1;

  MUX_P2 : entity work.mux
	generic map (
		address_size => MSB+LSB
	)
  port map (
    i_SEL	=> i_SEL_MUX_P2,
    i_A	  => w_OUTA_M2,
    i_B 	=> w_OUTB_M1(PROC_NUMBER-3),
    o_S 	=> o_P(PROC_NUMBER-1)
  );

	-- RAMs
	RAM0 : entity work.ram_2
	generic map (
		address_size => c_MEM_SIZE,
		data_size    => MSB+LSB
	)
	port map (
		i_ADD_A       => w_OUT_ADDRA_M0,
		i_ADD_B       => w_OUT_ADDRB_M0,
		i_CLK					=> i_CLK,
		i_DATA_B      => i_INPUTPIXELB_M0,
		i_WREN_B      => i_WRENB_M0,
		o_READ_DATA_A => w_OUTA_M0,
		o_READ_DATA_B => w_OUTB_M0
	);

	g_RAM1 : for i in 0 to PROC_NUMBER-3 generate
		RAM1 : entity work.ram_2
		generic map (
			address_size => c_MEM_SIZE,
			data_size    => MSB+LSB
		)
		port map (
			i_ADD_A       => w_OUT_ADDRA_M1(i),
			i_ADD_B       => w_OUT_ADDRB_M1(i),
			i_CLK					=> i_CLK,
			i_DATA_B      => i_INPUTPIXELB_M1(i),
			i_WREN_B      => i_WRENB_M0,
			o_READ_DATA_A => w_OUTA_M1(i),
			o_READ_DATA_B => w_OUTB_M1(i)
		);
	end generate;

	RAM2 : entity work.ram_2
	generic map (
		address_size => c_MEM_SIZE,
		data_size    => MSB+LSB
	)
	port map (
		i_ADD_A       => w_OUT_ADDRA_M2,
		i_ADD_B       => w_OUT_ADDRB_M2,
		i_CLK					=> i_CLK,
		i_DATA_B      => i_INPUTPIXELB_M2,
		i_WREN_B      => i_WRENB_M0,
		o_READ_DATA_A => w_OUTA_M2,
		o_READ_DATA_B => w_OUTB_M2
	);

  -- counts addr_A
  CNT_ADDRA_M0 : entity work.count
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> 1
	)
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_INC_CNT_ADDRA_M0,
    i_CLR => i_CLR_CNT_ADDRA_M0,
    o_Q   => w_CNT_ADDRA_M0
  );

  CNT_ADDRA_M2 : entity work.countsync
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> 1
	)
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_INC_CNT_ADDRA_M2,
    i_CLR => i_CLR_CNT_ADDRA_M0,
    o_Q   => w_CNT_ADDRA_M2
  );

  -- counts addr_B
  CNT_ADDRB_M0 : entity work.count
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> 1
	)
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_WRENB_M0,
    i_CLR => i_CLR_CNT_ADDRB_M0,
    o_Q   => w_CNT_ADDRB_M0
  );

  -- counts VB
  CNT_ADDR_VB_P0_M1 : entity work.count
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> (MEM_WIDTH/PROC_NUMBER)
	)
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_INC_CNT_ADDRVB_P0_M1,
    i_CLR => i_CLR_CNT_ADDRVB_P0_M1,
    o_Q   => w_CNT_ADDRESS_VB_P0_M1_REG
  );

	regint_i_P0_M1 : regint
	port map (
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_ENA => '1',
		i_CLR => i_RST,
		i_DIN => w_CNT_ADDRESS_VB_P0_M1_REG,
		o_OUT => w_CNT_ADDRESS_VB_P0_M1
	);

  CNT_ADDR_VB_P2_M1 : entity work.count
	generic map (
		p_INITVALUE => (MEM_WIDTH/PROC_NUMBER)-1,
		p_STEP			=> (MEM_WIDTH/PROC_NUMBER)
	)
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_INC_CNT_ADDRVB_P2_M1,
    i_CLR => i_CLR_CNT_ADDRVB_P0_M1,
    o_Q   => w_CNT_ADDRESS_VB_P2_M1_REG
  );

	regint_i_P2_M1 : regint
	port map (
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_ENA => '1',
		i_CLR => i_RST,
		i_DIN => w_CNT_ADDRESS_VB_P2_M1_REG,
		o_OUT => w_CNT_ADDRESS_VB_P2_M1
	);

  -- count/comp
  CNT_END_VB_INC : entity work.count
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> 1
	)
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_INC_CNT_ADDRVB_M0,
    i_CLR => i_CLR_CNT_ADDRVB_M0,
    o_Q   => w_END_VB_INC_M0
  );
	w_IMG_DONE <= '1' when (w_END_VB_INC_M0 >= ((MEM_WIDTH/PROC_NUMBER)-2)) else '0';
	o_END_VB_INC_M0 <= '1' when (w_END_VB_INC_M0 = ((MEM_WIDTH/PROC_NUMBER)-2)) else '0';
  o_END_VB_INC_END_M0 <= '1' when (w_END_VB_INC_M0 >= ((MEM_WIDTH/PROC_NUMBER)-2)) else '0';

  CNT_COLUMN : entity work.count
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> 1
	)
  port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_ENA => i_INC_CNT_COLUMN_M0,
    i_CLR => i_CLR_CNT_COLUMN_M0,
    o_Q   => w_END_R_M0
  );
	o_END_R <= '1' when (w_END_R_M0 = ((MEM_WIDTH/PROC_NUMBER)-3)) else '0';

	CNT_IMG_DONE : entity work.count
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> 1
	)
	port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_ENA => i_INC_CNT_COLUMN_M0,
		i_CLR => w_IMG_DONE,
		o_Q   => w_IMG_DONE_M0
	);
	o_IMG_DONE_M0 <= '1' when (w_IMG_DONE_M0 >= c_COUNT_IMG_DONE-1) else '0';

	CNT_MEM_FULL : entity work.count
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> 1
	)
	port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_ENA => i_WRENB_M0,
		i_CLR => i_CLR_CNT_ADDRB_M0,
		o_Q   => w_MEM_FULL
	);
	o_MEM_FULL <= '1' when (w_MEM_FULL = c_COUNT_IMG_DONE-1) else '0'; --2

end architecture;
