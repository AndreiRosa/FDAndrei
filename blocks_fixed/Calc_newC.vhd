library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;
use work.fixed_package.all;

entity Calc_newC is
port(
	i_CLK				    : in  std_logic;
	i_RST				    : in  std_logic;
	i_ENA				    : in  std_logic;
	i_VALID_PIXEL   : in  std_logic;
	i_Pixel			    : in  t_SIZE(8 downto 0);
	o_PIX_RDY				: out std_logic;
	o_Calc_newC 	  : out std_logic_vector(MSB+LSB-1 downto 0)
);
end entity Calc_newC;

architecture arch of Calc_newC is

-- Signals
signal w_Mul_Stage0    	: t_SIZE(8 downto 0);
signal w_StageReg0    	: t_SIZE(8 downto 0);
signal w_Add_Stage1    	: t_SIZE(4 downto 0);
signal w_StageReg1    	: t_SIZE(4 downto 0);
signal w_Add_Stage2    	: t_SIZE(2 downto 0);
signal w_StageReg2    	: t_SIZE(2 downto 0);
signal w_Add_Stage3    	: t_SIZE(1 downto 0);
signal w_StageReg3    	: t_SIZE(1 downto 0);
signal w_BUFF_EN				: std_logic_vector(3 downto 0) := (others => '0');

begin

	-- shift buffer
	process (i_CLK, i_ENA, i_VALID_PIXEL)
	begin
		if (rising_edge(i_CLK)) then
			w_BUFF_EN(3 downto 1) <= w_BUFF_EN(2 downto 0);
			w_BUFF_EN(0) <= i_ENA and i_VALID_PIXEL;
		end if;
	end process;

	-- mul stage 0
	g_Stage0: for i in 0 to 8 generate
		g_IF0 : if (i = 4) generate
			w_Mul_Stage0(i) <= CALCQC * i_Pixel(i);
		else generate
			w_Mul_Stage0(i) <= CALCQX * i_Pixel(i);
		end generate g_IF0;
	end generate g_Stage0;

	-- barrier register stage 0:
	g_Stage_Reg0 : for i in 0 to 8 generate
	u_Reg0 : entity work.reg
		port map(
			i_CLK 	=> i_CLK,
			i_RST 	=> i_RST,
			i_ENA 	=> i_ENA,
			i_CLR 	=> '0',
			i_DIN 	=> w_Mul_Stage0(i),
			o_OUT 	=> w_StageReg0(i)
		);
	end generate;

	-- adder stage 1
	g_Stage1 : for i in 0 to 3 generate
		w_Add_Stage1(i) <= w_StageReg0(i) + w_StageReg0(i+5);
	end generate;
	w_Add_Stage1(4) <= w_StageReg0(4); -- keeps the central pixel in the last position

	-- barrier register stage 1
	g_Stage_Reg1 : for i in 0 to 4 generate
		u_Reg1 : entity work.reg
			port map(
				i_CLK 	=> i_CLK,
				i_RST 	=> i_RST,
				i_ENA 	=> w_BUFF_EN(0),
				i_CLR 	=> '0',
				i_DIN 	=> w_Add_Stage1(i),
				o_OUT 	=> w_StageReg1(i)
		);
	end generate;

	--adder stage 2
	g_Stage_2 : for i in 0 to 1 generate
		w_Add_Stage2(i) <= w_StageReg1(2*i) + w_StageReg1(2*i+1);
	end generate;
	w_Add_Stage2(2) <= w_StageReg1(4); -- keeps the central pixel in the last position

	-- barrier register stage 2
	g_Stage_Reg2 : for i in 0 to 2 generate
		u_Reg2 : entity work.reg
			port map(
				i_CLK 	=> i_CLK,
				i_RST 	=> i_RST,
				i_ENA 	=> w_BUFF_EN(1),
				i_CLR 	=> '0',
				i_DIN 	=> w_Add_Stage2(i),
				o_OUT 	=> w_StageReg2(i)
		);
	end generate;

	--adder stage 3
	w_Add_Stage3(0) <= w_StageReg2(0) + w_StageReg2(1);
	w_Add_Stage3(1) <= w_StageReg2(2); -- keeps the central pixel in the last position

	-- barrier register stage 3
	g_Stage_Reg3 : for i in 0 to 1 generate
		u_Reg3 : entity work.reg
			port map(
				i_CLK 	=> i_CLK,
				i_RST 	=> i_RST,
				i_ENA 	=> w_BUFF_EN(2),
				i_CLR 	=> '0',
				i_DIN 	=> w_Add_Stage3(i),
				o_OUT 	=> w_StageReg3(i)
		);
	end generate;

	-- adder stage 4
	o_Calc_newC <= w_StageReg3(0) + w_StageReg3(1);
	o_PIX_RDY   <= w_BUFF_EN(3);

end architecture arch;

-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
--
-- library work;
-- use work.fda_package.all;
-- use work.fixed_package.all;
--
-- entity Calc_newC is
-- port(
-- 	i_CLK				    : in  std_logic;
-- 	i_RST				    : in  std_logic;
-- 	i_ENA				    : in  std_logic;
-- 	i_VALID_PIXEL   : in  std_logic;
-- 	i_Pixel			    : in  t_SIZE(8 downto 0);
-- 	o_PIX_RDY				: out std_logic;
-- 	o_Calc_newC 	  : out std_logic_vector(MSB+LSB-1 downto 0)
-- );
-- end entity Calc_newC;
--
-- architecture arch of Calc_newC is
--
-- -- Signals
-- signal w_Mul_Stage0    	: t_SIZE(8 downto 0);
-- signal w_StageReg0    	: t_SIZE(8 downto 0);
-- signal w_Add_Stage1    	: t_SIZE(4 downto 0);
-- signal w_StageReg1    	: t_SIZE(4 downto 0);
-- signal w_Add_Stage2    	: t_SIZE(2 downto 0);
-- signal w_StageReg2    	: t_SIZE(2 downto 0);
-- signal w_Add_Stage3    	: t_SIZE(1 downto 0);
-- signal w_StageReg3    	: t_SIZE(1 downto 0);
-- signal w_BUFF_EN				: std_logic_vector(3 downto 0) := (others => '0');
--
-- begin
--
-- 	-- shift buffer
-- 	process (i_CLK, i_ENA, i_VALID_PIXEL)
-- 	begin
-- 		if (rising_edge(i_CLK)) then
-- 			w_BUFF_EN(3 downto 1) <= w_BUFF_EN(2 downto 0);
-- 			w_BUFF_EN(0) <= i_ENA and i_VALID_PIXEL;
-- 		end if;
-- 	end process;
--
-- 	-- mul stage 0
-- 	g_Stage0: for i in 0 to 8 generate
-- 		g_IF0 : if (i = 4) generate
-- 			w_Mul_Stage0(i) <= i_Pixel(i);
-- 		else generate
-- 			w_Mul_Stage0(i) <= i_Pixel(i);
-- 		end generate g_IF0;
-- 	end generate g_Stage0;
--
-- 	-- barrier register stage 0:
-- 	g_Stage_Reg0 : for i in 0 to 8 generate
-- 	u_Reg0 : entity work.reg
-- 		port map(
-- 			i_CLK 	=> i_CLK,
-- 			i_RST 	=> i_RST,
-- 			i_ENA 	=> i_ENA,
-- 			i_CLR 	=> '0',
-- 			i_DIN 	=> w_Mul_Stage0(i),
-- 			o_OUT 	=> w_StageReg0(i)
-- 		);
-- 	end generate;
--
-- 	-- adder stage 1
-- 	g_Stage1 : for i in 0 to 3 generate
-- 		w_Add_Stage1(i) <= w_StageReg0(i);
-- 	end generate;
-- 	w_Add_Stage1(4) <= w_StageReg0(4); -- keeps the central pixel in the last position
--
-- 	-- barrier register stage 1
-- 	g_Stage_Reg1 : for i in 0 to 4 generate
-- 		u_Reg1 : entity work.reg
-- 			port map(
-- 				i_CLK 	=> i_CLK,
-- 				i_RST 	=> i_RST,
-- 				i_ENA 	=> w_BUFF_EN(0),
-- 				i_CLR 	=> '0',
-- 				i_DIN 	=> w_Add_Stage1(i),
-- 				o_OUT 	=> w_StageReg1(i)
-- 		);
-- 	end generate;
--
-- 	--adder stage 2
-- 	g_Stage_2 : for i in 0 to 1 generate
-- 		w_Add_Stage2(i) <= w_StageReg1(i);
-- 	end generate;
-- 	w_Add_Stage2(2) <= w_StageReg1(4); -- keeps the central pixel in the last position
--
-- 	-- barrier register stage 2
-- 	g_Stage_Reg2 : for i in 0 to 2 generate
-- 		u_Reg2 : entity work.reg
-- 			port map(
-- 				i_CLK 	=> i_CLK,
-- 				i_RST 	=> i_RST,
-- 				i_ENA 	=> w_BUFF_EN(1),
-- 				i_CLR 	=> '0',
-- 				i_DIN 	=> w_Add_Stage2(i),
-- 				o_OUT 	=> w_StageReg2(i)
-- 		);
-- 	end generate;
--
-- 	--adder stage 3
-- 	w_Add_Stage3(0) <= w_StageReg2(0); --
-- 	w_Add_Stage3(1) <= w_StageReg2(2); -- keeps the central pixel in the last position
--
-- 	-- barrier register stage 3
-- 	g_Stage_Reg3 : for i in 0 to 1 generate
-- 		u_Reg3 : entity work.reg
-- 			port map(
-- 				i_CLK 	=> i_CLK,
-- 				i_RST 	=> i_RST,
-- 				i_ENA 	=> w_BUFF_EN(2),
-- 				i_CLR 	=> '0',
-- 				i_DIN 	=> w_Add_Stage3(i),
-- 				o_OUT 	=> w_StageReg3(i)
-- 		);
-- 	end generate;
--
-- 	-- adder stage 4
-- 	o_Calc_newC <= w_StageReg3(1); -- A SAÍDA É O PIXEL central
-- 	o_PIX_RDY   <= w_BUFF_EN(3);
--
-- end architecture arch;
