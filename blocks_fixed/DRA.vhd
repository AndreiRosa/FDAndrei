library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;

entity DRA is
port(
    i_CLK 				: in std_logic;
    i_RST 				: in std_logic;
    i_INPUT_PIXEL : in std_logic_vector(MSB+LSB-1 downto 0);
    i_ENA_WRI_KER : in std_logic;
	 o_OUT_KERNEL  	: out t_SIZE(0 to c_KERNEL_SIZE-1)
);
end DRA;

architecture arch_1 of DRA is

-- Kernel
signal w_KER_DAT : t_SIZE(0 to c_KERNEL_SIZE-1);

-- ROW BUFFER
signal w_ROW_BUF_IN   : t_SIZE(0 to KERNEL_HEIGHT-2);
signal w_ROW_BUF_OUT	 : t_SIZE(0 to KERNEL_HEIGHT-2);

begin
    -- ROW BUFFERS
	g_RB : for i in 0 to KERNEL_HEIGHT-2 generate
		row_buffer_i : Row_Buffer
			generic map (
			  c_SIZE  => c_ROW_BUF_SIZE,
			  c_WIDTH => MSB+LSB
			)
			port map (
			  i_CLK      => i_CLK,
			  i_RST      => i_RST,
			  i_ENA      => i_ENA_WRI_KER,
			  i_CLR      => i_RST,
			  i_DATA_IN  => w_ROW_BUF_IN(i),
			  o_DATA_OUT => w_ROW_BUF_OUT(i)
			);

		w_KER_DAT((i+1) * KERNEL_WIDTH) <= w_ROW_BUF_IN(i);
	end generate;

	-- KERNEL WINDOW
	g_K: for i in 0 to c_KERNEL_SIZE-2 generate

		-- START REG KERNEL LINE
		if_Start_End_Line: if (i > 0 and (i mod (KERNEL_WIDTH) = 0)) generate
			u_R_S : Reg
				generic map (
  					p_SIZE => MSB+LSB
				)
				port map (
					i_CLK  => i_CLK,
					i_RST  => i_RST,
					i_ENA  => i_ENA_WRI_KER,
					i_CLR  => i_RST,
					i_DIN  => w_KER_DAT(i+1),
					o_OUT => w_ROW_BUF_IN((i/KERNEL_WIDTH)-1)
				);
		-- END REG KERNEL LINE
        elsif ((i+1) mod KERNEL_WIDTH = 0) generate
			u_R_E : Reg
				generic map (
				  p_SIZE => MSB+LSB
				)
				port map (
				  i_CLK  => i_CLK,
				  i_RST  => i_RST,
				  i_ENA  => i_ENA_WRI_KER,
				  i_CLR  => i_RST,
				  i_DIN  => w_ROW_BUF_OUT((i+1)/(KERNEL_WIDTH)-1),
				  o_OUT => w_KER_DAT(i)
				);

		else generate
			u_R : Reg
				generic map (
				  p_SIZE => MSB+LSB
				)
				port map (
				  i_CLK  => i_CLK,
				  i_RST  => i_RST,
				  i_ENA  => i_ENA_WRI_KER,
				  i_CLR  => i_RST,
				  i_DIN  => w_KER_DAT(i+1),
				  o_OUT => w_KER_DAT(i)
				);
		end generate if_Start_End_Line;

	end generate g_K;

	-- KERNEL WINDOW
	u_Last_Reg : Reg
		generic map (
		  p_SIZE => MSB+LSB
		)
		port map (
		  i_CLK  => i_CLK,
		  i_RST  => i_RST,
		  i_ENA  => i_ENA_WRI_KER,
		  i_CLR  => i_RST,
		  i_DIN  => i_INPUT_PIXEL,
		  o_OUT => w_KER_DAT(c_KERNEL_SIZE-1)
		);

    o_OUT_KERNEL <= w_KER_DAT;

end arch_1;
