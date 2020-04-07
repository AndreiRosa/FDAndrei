library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.fda_package.all;	-- Package with project types

entity tb_fda is
end entity;

architecture arch of tb_fda is
    constant period : time := 10 ps;
    signal cycles   : integer := 0;
    signal rst      : std_logic := '1';
    signal clk      : std_logic := '0';
    file fil_in     : text;
    file fil_out    : text;

    signal start    : std_logic := '1';
    signal pix_rdy  : std_logic := '0';
    signal done     : std_logic := '0';
    signal procdone : std_logic := '0';
    signal vp       : std_logic := '0';
    signal enit       : std_logic;
    signal ite       : std_logic;

    signal pix_in   : std_logic_vector (15 downto 0);
    signal pix_out  : std_logic_vector (15 downto 0);

begin
    clk   <= not clk after period/2;
    rst   <= '0' after period;
    start <= '0' after period*2;
    -- vp    <= not vp after period;

p_CNT_CYCLES: process
    variable v_cycles : integer := 0;
    begin
        wait for period*2;
        while done = '0' loop
            cycles <= v_cycles;
            v_cycles := v_cycles + 1;
            wait for period;
        end loop;
end process;

p_READ : process
    variable v_line : line;
    variable v_data : std_logic_vector(15 downto 0);

    begin
    wait for period*1;
    file_open(fil_in, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena256VB.txt", READ_MODE);
    while not endfile(fil_in) loop
      -- wait until vp = '1';
      readline(fil_in, v_LINE);
      read(v_LINE, v_data);
      pix_in <= v_data;
      wait for period;
    end loop;
    wait;
  end process;

p_WRITE : process
  variable v_line : line;
begin
  wait for period;
  file_open(fil_out, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida256.txt", WRITE_MODE);
  while done = '0' loop
    if pix_rdy = '1' then
        write(v_line, pix_out);
        writeline(fil_out, v_line);
   end if;
   wait for period;
  end loop;
  wait;
end process;

top_i : entity work.top
port map (
  i_CLK         => clk,
  i_RST         => rst,
  i_START       => start,
  i_INPUT_PIXEL => pix_in,
  i_VALID_PIXEL => '1',
  i_QEMPTY      => '1',
  o_PIXEL_READY => pix_rdy,
  o_PROC_DONE   => procdone,
  o_OUT_PIXEL   => pix_out,
  o_EN_IT       =>enit,
  o_ITERATE_END => ite,
  o_DONE        => done
);


end architecture;
