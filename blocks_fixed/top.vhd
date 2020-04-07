library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;	-- Package with project types

entity top is
port(
	i_CLK          : in  std_logic;
	i_RST          : in  std_logic;
  i_START        : in  std_logic;

	i_INPUT_PIXEL  : in  std_logic_vector (MSB+LSB-1 downto 0);
	i_VALID_PIXEL  : in  std_logic;
	i_QEMPTY       : in  std_logic;

  o_PIXEL_READY  : out std_logic; --valid pixel to mem
  o_PROC_DONE    : out std_logic;

	o_EN_IT        : out std_logic;
	o_ITERATE_END  : out std_logic;

	o_OUT_PIXEL    : out std_logic_vector(MSB+LSB-1 downto 0);
  o_DONE         : out std_logic
);
end top;

architecture arch of top is

signal w_CLR_KER_TOT    	: std_logic;
signal w_CLR_KER_ROW    	: std_logic;
signal w_CLR_INV_KER    	: std_logic;
signal w_CLR_BUF_FIL    	: std_logic;
signal w_EN_KER_TOT     	: std_logic;
signal w_EN_KER_ROW     	: std_logic;
signal w_EN_INV_KER     	: std_logic;
signal w_EN_BUF_FIL     	: std_logic;
signal w_EN_IT          	: std_logic;
signal w_EN_CALC        	: std_logic;
signal w_EN_WRITE_KERNEL	: std_logic;
signal w_MAX_KER_TOT	    : std_logic;
signal w_MAX_KER_ROW	    : std_logic;
signal w_MAX_INV_KER	    : std_logic;
signal w_BUFFER_FILLED	  : std_logic;
signal w_ITERATE	        : std_logic;
signal w_DONE        		  : std_logic;
signal w_D			  		    : std_logic_vector(3 downto 0) := (others => '0');


begin

  DATAPATH : entity work.datapath
  port map (
    i_CLK             => i_CLK,
    i_RST             => i_RST,

    i_INPUT_PIXEL     => i_INPUT_PIXEL,
    i_VALID_PIXEL     => i_VALID_PIXEL,

    i_CLR_KER_TOT     => w_CLR_KER_TOT,
    i_CLR_KER_ROW     => w_CLR_KER_ROW,
    i_CLR_INV_KER     => w_CLR_INV_KER,
    i_CLR_BUF_FIL     => w_CLR_BUF_FIL,
    i_EN_KER_TOT      => w_EN_KER_TOT,
    i_EN_KER_ROW      => w_EN_KER_ROW,
    i_EN_INV_KER      => w_EN_INV_KER,
    i_EN_BUF_FIL      => w_EN_BUF_FIL,
    i_EN_IT           => w_EN_IT,
    i_EN_CALC         => w_EN_CALC,
    i_EN_WRITE_KERNEL => w_EN_WRITE_KERNEL,
    o_MAX_KER_TOT     => w_MAX_KER_TOT,
    o_MAX_KER_ROW     => w_MAX_KER_ROW,
    o_MAX_INV_KER     => w_MAX_INV_KER,
    o_BUFFER_FILLED   => w_BUFFER_FILLED,
    o_ITERATE         => w_ITERATE,
		o_PIXEL_READY     => o_PIXEL_READY,

    o_OUT_PIXEL       => o_OUT_PIXEL
  );

  CTRL : entity work.ctrl
  port map (
    i_CLK             => i_CLK,
    i_RST             => i_RST,
    i_START           => i_START,
		i_QEMPTY					=> i_QEMPTY,
		i_VALID_PIXEL     => i_VALID_PIXEL,
    i_MAX_KER_TOT     => w_MAX_KER_TOT,
    i_MAX_KER_ROW     => w_MAX_KER_ROW,
    i_MAX_INV_KER     => w_MAX_INV_KER,
    i_BUFFER_FILLED   => w_BUFFER_FILLED,
    i_ITERATE         => w_ITERATE,
    o_CLR_KER_TOT     => w_CLR_KER_TOT,
    o_CLR_KER_ROW     => w_CLR_KER_ROW,
    o_CLR_INV_KER     => w_CLR_INV_KER,
    o_CLR_BUF_FIL     => w_CLR_BUF_FIL,
    o_EN_KER_TOT      => w_EN_KER_TOT,
    o_EN_KER_ROW      => w_EN_KER_ROW,
    o_EN_INV_KER      => w_EN_INV_KER,
    o_EN_BUF_FIL      => w_EN_BUF_FIL,
    o_EN_IT           => w_EN_IT,
    o_EN_CALC         => w_EN_CALC,
    o_EN_WRITE_KERNEL => w_EN_WRITE_KERNEL,
    o_PROC_DONE       => o_PROC_DONE,
    o_DONE            => o_DONE
  );

	-- shift buffer
	-- process (i_CLK, w_DONE, i_VALID_PIXEL, w_D)
	-- begin
	-- 	if (rising_edge(i_CLK)) then
	-- 		if (i_VALID_PIXEL = '1') then
	-- 			w_D(3 downto 1) <= w_D(2 downto 0);
	-- 			w_D(0) <= w_DONE;
	-- 		end if;
	-- 	end if;
	-- end process;


	-- o_DONE		  	<= w_D(3); -- TALVEZ O DONE ESTEJA ERRADO PPORQUE ELE SÓ ENTRA AQUI NO FINAL DAS 3 ITERAÇÕES, ACHO QUE DEVERIA ENTRAR NO FINAL DE CADA ITERAÇÃO NO PROC DONE
	o_EN_IT				<= w_EN_IT;
	o_ITERATE_END <= w_ITERATE;

end architecture;
