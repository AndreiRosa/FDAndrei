library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;

entity TOOP is
port(
	i_CLK          : in  std_logic;
  i_RST          : in  std_logic;
	i_START				 : in  std_logic;
	o_DONE         : out std_logic
);
end TOOP;

architecture arch of TOOP is

signal w_CNT_ADDRROM    : integer := 0;
signal w_ADDRROM        : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_CNT_ADDRRAM    : integer := 0;
signal w_ADDRRAM        : std_logic_vector (c_MEM_SIZE-1 downto 0);
signal w_INPUT_PIXEL    : t_SIZE (PROC_NUMBER-1 downto 0);
signal w_OUT_PIXEL    	: t_SIZE (PROC_NUMBER-1 downto 0);
signal w_READ_DATA_A   	: t_SIZE (PROC_NUMBER-1 downto 0);
signal w_I_VALID_PIXEL  : std_logic;
signal w_O_VALID_PIXEL  : std_logic_vector (PROC_NUMBER-1 downto 0);
signal w_DONE           : std_logic_vector (PROC_NUMBER-1 downto 0);
signal w_ENA						: std_logic;
signal w_DELAY					: std_logic;
signal w_PIXEL				: t_SIZE(c_COUNT_IMG_DONE-1 downto 0);

begin

	u_DELAY : process (i_CLK)
	begin
		if (rising_edge(i_CLK)) then
			w_DELAY <= i_START;
		end if;
	end process;

	w_ENA <= i_CLK and w_DELAY;
  COUNT_ADDRROM: entity work.count
  generic map (
    p_INITVALUE => 0,
    p_STEP			=> 1
  )
	port map(
	  i_CLK => i_CLK,
	  i_RST => i_RST,
	  i_ENA => w_ENA,
	  i_CLR => '0',
	  o_Q   => w_CNT_ADDRROM
	);
	w_ADDRROM <= std_logic_vector(to_unsigned(w_CNT_ADDRROM, w_ADDRROM'length));

	COUNT_ADDRRAM: entity work.count
	generic map (
		p_INITVALUE => 0,
		p_STEP			=> 1
	)
	port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_ENA => w_O_VALID_PIXEL(0),
		i_CLR => '0',
		o_Q   => w_CNT_ADDRRAM
	);
	w_ADDRRAM <= std_logic_vector(to_unsigned(w_CNT_ADDRRAM, w_ADDRRAM'length));

  TOPPEST : entity work.toppest
  port map (
    i_CLK         => i_CLK,
    i_RST         => i_RST,
    i_START       => i_START,
    i_INPUT_PIXEL => w_INPUT_PIXEL,
    i_VALID_PIXEL => w_DELAY,
    o_VALID_PIXEL => w_O_VALID_PIXEL,
    o_OUT_PIXEL   => w_OUT_PIXEL,
    o_DONE        => w_DONE
  );

  g_ROM : for i in 0 to PROC_NUMBER-1 generate
    ROM : entity work.rom
		generic map (
			address_size => c_MEM_SIZE,
			data_size    => MSB+LSB
		)
    port map (
      i_CLK     => i_CLK,
      i_RST     => i_RST,
      i_ENA_RD  => '1',
      i_CONTENT => w_PIXEL,
      i_ADDR    => w_ADDRROM,
      o_DATA    => w_INPUT_PIXEL(i)
    );
  end generate;

	g_RAM : for i in 0 to PROC_NUMBER-1 generate
		RAM : entity work.ram_1
		port map (
		  address	=> w_ADDRRAM,
		  clock   => i_CLK,
		  data    => w_OUT_PIXEL(i),
		  wren    => w_O_VALID_PIXEL(i),
		  q 			=> w_READ_DATA_A(i)
		);
	end generate;

	o_DONE <= w_DONE(0);

end architecture;
