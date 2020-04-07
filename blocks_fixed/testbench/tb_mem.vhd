library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;

entity tb_mem is
end entity;

architecture arch of tb_mem is

constant period    : time := 10 ps;
signal rst         : std_logic := '1';
signal start       : std_logic := '0';
signal clk         : std_logic := '0';
signal w_T         : std_logic := '0';
signal pix_in_A    : t_SIZE (5-1 downto 0);
signal pix_in_B    : t_SIZE (5-1 downto 0);
signal P           : t_SIZE (5-1 downto 0);
signal VAL_PIX_M0  : std_logic := '0';
signal PROCDONE_P0 : std_logic := '0';
signal ITERATE_END : std_logic := '0';
signal VPM0        : std_logic;

begin
  clk   <= not clk after period/2;
  rst   <= '0' after period;
  start <= '1' after period;

  topmem_i : entity work.topmem
  port map (
    i_CLK                => clk,
    i_RST                => rst,
    i_START              => start,

    i_INPUTPIXEL_ARM     => pix_in_A,
    i_INPUTPIXEL_PROC    => pix_in_B,
    i_VALIDPIXEL         => VAL_PIX_M0,
    i_PROC_DONE          => PROCDONE_P0,
    i_ITERATE_END        => ITERATE_END,
    o_P                  => P,
    o_VALID_PIXEL        => VPM0
  );

  p_ROCESS : process
  variable v_m      : signed(MSB+LSB-1 downto 0) := x"0000";
  begin
    wait for period*2;

    while (v_m <= x"007D") loop -- c_COUNT_IMG_DONE
      for i in 0 to 4 loop
        pix_in_A(i) <= std_logic_vector(v_m);
      end loop;
      wait for period;
      v_m := v_m + 1;
    end loop;

    v_m := x"0001";
    wait for period*29; -- Ok

    VAL_PIX_M0 <= '1';

    while (v_m <= x"007D") loop -- c_COUNT_IMG_DONE
      for i in 0 to 4 loop
        pix_in_B(i) <= std_logic_vector(v_m);
      end loop;
      v_m := v_m + 1;
      wait for period;
    end loop;

    VAL_PIX_M0 <= '0';
    PROCDONE_P0 <= '1';
    v_m := x"0002";
    wait for period*47; -- 46
    wait for period*29; -- Ok


    PROCDONE_P0 <= '0';
    VAL_PIX_M0 <= '1';

    while (v_m <= x"007E") loop -- c_COUNT_IMG_DONE+1
      for i in 0 to 4 loop
        pix_in_B(i) <= std_logic_vector(v_m);
      end loop;
      v_m := v_m + 1;
      wait for period;
    end loop;

    VAL_PIX_M0 <= '0';
    PROCDONE_P0 <= '1';

    wait for period*45;
    ITERATE_END <= '1';

    wait;
  end process;

end architecture;
