library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.fda_package.all;	-- Package with project types

entity tb_toppest is
end entity;

architecture arch of tb_toppest is
    constant period   : time := 10 ps;
    signal cycles     : integer := 0;
    signal rst        : std_logic := '0';
    signal clk        : std_logic := '0';
    file fil_in1      : text;
    file fil_in2      : text;
    file fil_in3      : text;
    file fil_in4      : text;
    file fil_in5      : text;
    file fil_in6      : text;
    file fil_in7      : text;
    file fil_in8      : text;
    file fil_in9      : text;
    file fil_in10     : text;
    file fil_in11     : text;
    file fil_in12     : text;
    file fil_in13     : text;
    file fil_in14     : text;
    file fil_in15     : text;
    file fil_in16     : text;
    file fil_in17     : text;
    file fil_in18     : text;
    file fil_in19     : text;
    file fil_in20     : text;
    -- file fil_in21     : text;
    -- file fil_in22     : text;
    -- file fil_in23     : text;
    -- file fil_in24     : text;
    -- file fil_in25     : text;
    -- file fil_in26     : text;
    -- file fil_in27     : text;
    -- file fil_in28     : text;
    -- file fil_in29     : text;
    -- file fil_in30     : text;
    -- file fil_in31     : text;
    -- file fil_in32     : text;
    -- file fil_in33     : text;
    -- file fil_in34     : text;
    -- file fil_in35     : text;
    -- file fil_in36     : text;
    -- file fil_in37     : text;
    -- file fil_in38     : text;
    -- file fil_in39     : text;
    -- file fil_in40     : text;
    -- file fil_in41     : text;
    -- file fil_in42     : text;
    -- file fil_in43     : text;
    -- file fil_in44     : text;
    -- file fil_in45     : text;
    -- file fil_in46     : text;
    -- file fil_in47     : text;
    -- file fil_in48     : text;
    -- file fil_in49     : text;
    -- file fil_in50     : text;
    -- file fil_in51     : text;
    -- file fil_in52     : text;
    -- file fil_in53     : text;
    -- file fil_in54     : text;
    -- file fil_in55     : text;
    -- file fil_in56     : text;
    -- file fil_in57     : text;
    -- file fil_in58     : text;
    -- file fil_in59     : text;
    -- file fil_in60     : text;
    -- file fil_in61     : text;
    -- file fil_in62     : text;
    -- file fil_in63     : text;
    -- file fil_in64     : text;

    file fil_out1     : text;
    file fil_out2     : text;
    file fil_out3     : text;
    file fil_out4     : text;
    file fil_out5     : text;
    file fil_out6     : text;
    file fil_out7     : text;
    file fil_out8     : text;
    file fil_out9     : text;
    file fil_out10    : text;
    file fil_out11    : text;
    file fil_out12    : text;
    file fil_out13    : text;
    file fil_out14    : text;
    file fil_out15    : text;
    file fil_out16    : text;
    file fil_out17    : text;
    file fil_out18    : text;
    file fil_out19    : text;
    file fil_out20    : text;
    -- file fil_out21    : text;
    -- file fil_out22    : text;
    -- file fil_out23    : text;
    -- file fil_out24    : text;
    -- file fil_out25    : text;
    -- file fil_out26    : text;
    -- file fil_out27    : text;
    -- file fil_out28    : text;
    -- file fil_out29    : text;
    -- file fil_out30    : text;
    -- file fil_out31    : text;
    -- file fil_out32    : text;
    -- file fil_out33    : text;
    -- file fil_out34    : text;
    -- file fil_out35    : text;
    -- file fil_out36    : text;
    -- file fil_out37    : text;
    -- file fil_out38    : text;
    -- file fil_out39    : text;
    -- file fil_out40    : text;
    -- file fil_out41    : text;
    -- file fil_out42    : text;
    -- file fil_out43    : text;
    -- file fil_out44    : text;
    -- file fil_out45    : text;
    -- file fil_out46    : text;
    -- file fil_out47    : text;
    -- file fil_out48    : text;
    -- file fil_out49    : text;
    -- file fil_out50    : text;
    -- file fil_out51    : text;
    -- file fil_out52    : text;
    -- file fil_out53    : text;
    -- file fil_out54    : text;
    -- file fil_out55    : text;
    -- file fil_out56    : text;
    -- file fil_out57    : text;
    -- file fil_out58    : text;
    -- file fil_out59    : text;
    -- file fil_out60    : text;
    -- file fil_out61    : text;
    -- file fil_out62    : text;
    -- file fil_out63    : text;
    -- file fil_out64    : text;


    signal start    : std_logic := '0';
    signal pix_rdy  : std_logic_vector(PROC_NUMBER-1 downto 0);
    signal done     : std_logic_vector(PROC_NUMBER-1 downto 0);
    signal procdone : std_logic := '0';
    signal vp       : std_logic := '0';

    signal pix_in   : t_SIZE (PROC_NUMBER-1 downto 0);
    signal pix_out  : t_SIZE (PROC_NUMBER-1 downto 0);

begin
    clk     <= not clk after period/2;
    start   <= '1' after period;

p_CNT_CYCLES: process
    variable v_cycles : integer := 0;
    begin
        wait for period*2;
        while done(1) = '0' loop
            cycles <= v_cycles;
            vp <= '1';
            v_cycles := v_cycles + 1;
            wait for period;
        end loop;

end process;

p_READ1 : process
  variable v_line1 : line;
  variable v_data1 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in1, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena1.txt", READ_MODE);
  while not endfile(fil_in1) loop
    readline(fil_in1, v_LINE1);
    read(v_LINE1, v_data1);
    pix_in(0) <= v_data1;
    wait for period;
  end loop;
  wait;
end process;

p_READ2 : process
  variable v_line2 : line;
  variable v_data2 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in2, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena2.txt", READ_MODE);
  while not endfile(fil_in2) loop
    readline(fil_in2, v_LINE2);
    read(v_LINE2, v_data2);
    pix_in(1) <= v_data2;
    wait for period;
  end loop;
  wait;
end process;

p_READ3 : process
  variable v_line3 : line;
  variable v_data3 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in3, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena3.txt", READ_MODE);
  while not endfile(fil_in3) loop
    readline(fil_in3, v_LINE3);
    read(v_LINE3, v_data3);
    pix_in(2) <= v_data3;
    wait for period;
  end loop;
  wait;
end process;

p_READ4 : process
  variable v_line4 : line;
  variable v_data4 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in4, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena4.txt", READ_MODE);
  while not endfile(fil_in4) loop
    readline(fil_in4, v_LINE4);
    read(v_LINE4, v_data4);
    pix_in(3) <= v_data4;
    wait for period;
  end loop;
  wait;
end process;

p_READ5 : process
  variable v_line5 : line;
  variable v_data5 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in5, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena5.txt", READ_MODE);
  while not endfile(fil_in5) loop
    readline(fil_in5, v_LINE5);
    read(v_LINE5, v_data5);
    pix_in(4) <= v_data5;
    wait for period;
  end loop;
  wait;
end process;

p_READ6 : process
  variable v_line6 : line;
  variable v_data6 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in6, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena6.txt", READ_MODE);
  while not endfile(fil_in6) loop
    readline(fil_in6, v_LINE6);
    read(v_LINE6, v_data6);
    pix_in(5) <= v_data6;
    wait for period;
  end loop;
  wait;
end process;

p_READ7 : process
  variable v_line7 : line;
  variable v_data7 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in7, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena7.txt", READ_MODE);
  while not endfile(fil_in7) loop
    readline(fil_in7, v_LINE7);
    read(v_LINE7, v_data7);
    pix_in(6) <= v_data7;
    wait for period;
  end loop;
  wait;
end process;

p_READ8 : process
  variable v_line8 : line;
  variable v_data8 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in8, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena8.txt", READ_MODE);
  while not endfile(fil_in8) loop
    readline(fil_in8, v_LINE8);
    read(v_LINE8, v_data8);
    pix_in(7) <= v_data8;
    vp <= '1';
    wait for period;
  end loop;
  wait;
end process;

p_READ9 : process
  variable v_line9 : line;
  variable v_data9 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in9, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena9.txt", READ_MODE);
  while not endfile(fil_in9) loop
    readline(fil_in9, v_LINE9);
    read(v_LINE9, v_data9);
    pix_in(8) <= v_data9;
    vp <= '1';
    wait for period;
  end loop;
  wait;
end process;

p_READ10 : process
  variable v_line10 : line;
  variable v_data10 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in10, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena10.txt", READ_MODE);
  while not endfile(fil_in10) loop
    readline(fil_in10, v_LINE10);
    read(v_LINE10, v_data10);
    pix_in(9) <= v_data10;
    vp <= '1';
    wait for period;
  end loop;
  wait;
end process;

p_READ11 : process
  variable v_line11 : line;
  variable v_data11 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in11, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena11.txt", READ_MODE);
  while not endfile(fil_in11) loop
    readline(fil_in11, v_LINE11);
    read(v_LINE11, v_data11);
    pix_in(10) <= v_data11;
    wait for period;
  end loop;
  wait;
end process;

p_READ12 : process
  variable v_line12 : line;
  variable v_data12 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in12, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena12.txt", READ_MODE);
  while not endfile(fil_in12) loop
    readline(fil_in12, v_LINE12);
    read(v_LINE12, v_data12);
    pix_in(11) <= v_data12;
    wait for period;
  end loop;
  wait;
end process;

p_READ13 : process
  variable v_line13 : line;
  variable v_data13 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in13, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena13.txt", READ_MODE);
  while not endfile(fil_in13) loop
    readline(fil_in13, v_LINE13);
    read(v_LINE13, v_data13);
    pix_in(12) <= v_data13;
    wait for period;
  end loop;
  wait;
end process;

p_READ14 : process
  variable v_line14 : line;
  variable v_data14 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in14, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena14.txt", READ_MODE);
  while not endfile(fil_in14) loop
    readline(fil_in14, v_LINE14);
    read(v_LINE14, v_data14);
    pix_in(13) <= v_data14;
    wait for period;
  end loop;
  wait;
end process;

p_READ15 : process
  variable v_line15 : line;
  variable v_data15 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in15, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena15.txt", READ_MODE);
  while not endfile(fil_in15) loop
    readline(fil_in15, v_LINE15);
    read(v_LINE15, v_data15);
    pix_in(14) <= v_data15;
    wait for period;
  end loop;
  wait;
end process;

p_READ16 : process
  variable v_line16 : line;
  variable v_data16 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in16, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena16.txt", READ_MODE);
  while not endfile(fil_in16) loop
    readline(fil_in16, v_LINE16);
    read(v_LINE16, v_data16);
    pix_in(15) <= v_data16;
    wait for period;
  end loop;
  wait;
end process;

p_READ17 : process
  variable v_line17 : line;
  variable v_data17 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in17, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena17.txt", READ_MODE);
  while not endfile(fil_in17) loop
    readline(fil_in17, v_LINE17);
    read(v_LINE17, v_data17);
    pix_in(16) <= v_data17;
    wait for period;
  end loop;
  wait;
end process;

p_READ18 : process
  variable v_line18 : line;
  variable v_data18 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in18, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena18.txt", READ_MODE);
  while not endfile(fil_in18) loop
    readline(fil_in18, v_LINE18);
    read(v_LINE18, v_data18);
    pix_in(17) <= v_data18;
    wait for period;
  end loop;
  wait;
end process;

p_READ19 : process
  variable v_line19 : line;
  variable v_data19 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in19, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena19.txt", READ_MODE);
  while not endfile(fil_in19) loop
    readline(fil_in19, v_LINE19);
    read(v_LINE19, v_data19);
    pix_in(18) <= v_data19;
    wait for period;
  end loop;
  wait;
end process;

p_READ20 : process
  variable v_line20 : line;
  variable v_data20 : std_logic_vector(MSB+LSB-1 downto 0);

  begin
  wait for period*2;
  file_open(fil_in20, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena20.txt", READ_MODE);
  while not endfile(fil_in20) loop
    readline(fil_in20, v_LINE20);
    read(v_LINE20, v_data20);
    pix_in(19) <= v_data20;
    wait for period;
  end loop;
  wait;
end process;

-- p_READ21 : process
--   variable v_line21 : line;
--   variable v_data21 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in21, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena21.txt", READ_MODE);
--   while not endfile(fil_in21) loop
--     readline(fil_in21, v_LINE21);
--     read(v_LINE21, v_data21);
--     pix_in(20) <= v_data21;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ22 : process
--   variable v_line22 : line;
--   variable v_data22 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in22, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena22.txt", READ_MODE);
--   while not endfile(fil_in22) loop
--     readline(fil_in22, v_LINE22);
--     read(v_LINE22, v_data22);
--     pix_in(21) <= v_data22;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ23 : process
--   variable v_line23 : line;
--   variable v_data23 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in23, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena23.txt", READ_MODE);
--   while not endfile(fil_in23) loop
--     readline(fil_in23, v_LINE23);
--     read(v_LINE23, v_data23);
--     pix_in(22) <= v_data23;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ24 : process
--   variable v_line24 : line;
--   variable v_data24 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in24, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena24.txt", READ_MODE);
--   while not endfile(fil_in24) loop
--     readline(fil_in24, v_LINE24);
--     read(v_LINE24, v_data24);
--     pix_in(23) <= v_data24;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ25 : process
--   variable v_line25 : line;
--   variable v_data25 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in25, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena25.txt", READ_MODE);
--   while not endfile(fil_in25) loop
--     readline(fil_in25, v_LINE25);
--     read(v_LINE25, v_data25);
--     pix_in(24) <= v_data25;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ26 : process
--   variable v_line26 : line;
--   variable v_data26 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in26, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena26.txt", READ_MODE);
--   while not endfile(fil_in26) loop
--     readline(fil_in26, v_LINE26);
--     read(v_LINE26, v_data26);
--     pix_in(25) <= v_data26;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ27 : process
--   variable v_line27 : line;
--   variable v_data27 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in27, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena27.txt", READ_MODE);
--   while not endfile(fil_in27) loop
--     readline(fil_in27, v_LINE27);
--     read(v_LINE27, v_data27);
--     pix_in(26) <= v_data27;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ28 : process
--   variable v_line28 : line;
--   variable v_data28 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in28, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena28.txt", READ_MODE);
--   while not endfile(fil_in28) loop
--     readline(fil_in28, v_LINE28);
--     read(v_LINE28, v_data28);
--     pix_in(27) <= v_data28;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ29 : process
--   variable v_line29 : line;
--   variable v_data29 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in29, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena29.txt", READ_MODE);
--   while not endfile(fil_in29) loop
--     readline(fil_in29, v_LINE29);
--     read(v_LINE29, v_data29);
--     pix_in(28) <= v_data29;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ30 : process
--   variable v_line30 : line;
--   variable v_data30 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in30, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena30.txt", READ_MODE);
--   while not endfile(fil_in30) loop
--     readline(fil_in30, v_LINE30);
--     read(v_LINE30, v_data30);
--     pix_in(29) <= v_data30;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ31 : process
--   variable v_line31 : line;
--   variable v_data31 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in31, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena31.txt", READ_MODE);
--   while not endfile(fil_in31) loop
--     readline(fil_in31, v_LINE31);
--     read(v_LINE31, v_data31);
--     pix_in(30) <= v_data31;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ32 : process
--   variable v_line32 : line;
--   variable v_data32 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in32, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena32.txt", READ_MODE);
--   while not endfile(fil_in32) loop
--     readline(fil_in32, v_LINE32);
--     read(v_LINE32, v_data32);
--     pix_in(31) <= v_data32;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ33 : process
--   variable v_line33 : line;
--   variable v_data33 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in33, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena33.txt", READ_MODE);
--   while not endfile(fil_in33) loop
--     readline(fil_in33, v_LINE33);
--     read(v_LINE33, v_data33);
--     pix_in(32) <= v_data33;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ34 : process
--   variable v_line34 : line;
--   variable v_data34 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in34, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena34.txt", READ_MODE);
--   while not endfile(fil_in34) loop
--     readline(fil_in34, v_LINE34);
--     read(v_LINE34, v_data34);
--     pix_in(33) <= v_data34;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ35 : process
--   variable v_line35 : line;
--   variable v_data35 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in35, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena35.txt", READ_MODE);
--   while not endfile(fil_in35) loop
--     readline(fil_in35, v_LINE35);
--     read(v_LINE35, v_data35);
--     pix_in(34) <= v_data35;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ36 : process
--   variable v_line36 : line;
--   variable v_data36 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in36, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena36.txt", READ_MODE);
--   while not endfile(fil_in36) loop
--     readline(fil_in36, v_LINE36);
--     read(v_LINE36, v_data36);
--     pix_in(35) <= v_data36;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ37 : process
--   variable v_line37 : line;
--   variable v_data37 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in37, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena37.txt", READ_MODE);
--   while not endfile(fil_in37) loop
--     readline(fil_in37, v_LINE37);
--     read(v_LINE37, v_data37);
--     pix_in(36) <= v_data37;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ38 : process
--   variable v_line38 : line;
--   variable v_data38 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in38, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena38.txt", READ_MODE);
--   while not endfile(fil_in38) loop
--     readline(fil_in38, v_LINE38);
--     read(v_LINE38, v_data38);
--     pix_in(37) <= v_data38;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ39 : process
--   variable v_line39 : line;
--   variable v_data39 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in39, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena39.txt", READ_MODE);
--   while not endfile(fil_in39) loop
--     readline(fil_in39, v_LINE39);
--     read(v_LINE39, v_data39);
--     pix_in(38) <= v_data39;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ40 : process
--   variable v_line40 : line;
--   variable v_data40 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in40, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena40.txt", READ_MODE);
--   while not endfile(fil_in40) loop
--     readline(fil_in40, v_LINE40);
--     read(v_LINE40, v_data40);
--     pix_in(39) <= v_data40;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ41 : process
--   variable v_line41 : line;
--   variable v_data41 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in41, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena41.txt", READ_MODE);
--   while not endfile(fil_in41) loop
--     readline(fil_in41, v_LINE41);
--     read(v_LINE41, v_data41);
--     pix_in(40) <= v_data41;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ42 : process
--   variable v_line42 : line;
--   variable v_data42 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in42, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena42.txt", READ_MODE);
--   while not endfile(fil_in42) loop
--     readline(fil_in42, v_LINE42);
--     read(v_LINE42, v_data42);
--     pix_in(41) <= v_data42;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ43 : process
--   variable v_line43 : line;
--   variable v_data43 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in43, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena43.txt", READ_MODE);
--   while not endfile(fil_in43) loop
--     readline(fil_in43, v_LINE43);
--     read(v_LINE43, v_data43);
--     pix_in(42) <= v_data43;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ44 : process
--   variable v_line44 : line;
--   variable v_data44 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in44, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena44.txt", READ_MODE);
--   while not endfile(fil_in44) loop
--     readline(fil_in44, v_LINE44);
--     read(v_LINE44, v_data44);
--     pix_in(43) <= v_data44;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ45 : process
--   variable v_line45 : line;
--   variable v_data45 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in45, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena45.txt", READ_MODE);
--   while not endfile(fil_in45) loop
--     readline(fil_in45, v_LINE45);
--     read(v_LINE45, v_data45);
--     pix_in(44) <= v_data45;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ46 : process
--   variable v_line46 : line;
--   variable v_data46 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in46, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena46.txt", READ_MODE);
--   while not endfile(fil_in46) loop
--     readline(fil_in46, v_LINE46);
--     read(v_LINE46, v_data46);
--     pix_in(45) <= v_data46;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ47 : process
--   variable v_line47 : line;
--   variable v_data47 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in47, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena47.txt", READ_MODE);
--   while not endfile(fil_in47) loop
--     readline(fil_in47, v_LINE47);
--     read(v_LINE47, v_data47);
--     pix_in(46) <= v_data47;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ48 : process
--   variable v_line48 : line;
--   variable v_data48 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in48, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena48.txt", READ_MODE);
--   while not endfile(fil_in48) loop
--     readline(fil_in48, v_LINE48);
--     read(v_LINE48, v_data48);
--     pix_in(47) <= v_data48;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ49 : process
--   variable v_line49 : line;
--   variable v_data49 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in49, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena49.txt", READ_MODE);
--   while not endfile(fil_in49) loop
--     readline(fil_in49, v_LINE49);
--     read(v_LINE49, v_data49);
--     pix_in(48) <= v_data49;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ50 : process
--   variable v_line50 : line;
--   variable v_data50 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in50, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena50.txt", READ_MODE);
--   while not endfile(fil_in50) loop
--     readline(fil_in50, v_LINE50);
--     read(v_LINE50, v_data50);
--     pix_in(49) <= v_data50;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ51 : process
--   variable v_line51 : line;
--   variable v_data51 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in51, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena51.txt", READ_MODE);
--   while not endfile(fil_in51) loop
--     readline(fil_in51, v_LINE51);
--     read(v_LINE51, v_data51);
--     pix_in(50) <= v_data51;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ52 : process
--   variable v_line52 : line;
--   variable v_data52 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in52, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena52.txt", READ_MODE);
--   while not endfile(fil_in52) loop
--     readline(fil_in52, v_LINE52);
--     read(v_LINE52, v_data52);
--     pix_in(51) <= v_data52;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ53 : process
--   variable v_line53 : line;
--   variable v_data53 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in53, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena53.txt", READ_MODE);
--   while not endfile(fil_in53) loop
--     readline(fil_in53, v_LINE53);
--     read(v_LINE53, v_data53);
--     pix_in(52) <= v_data53;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ54 : process
--   variable v_line54 : line;
--   variable v_data54 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in54, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena54.txt", READ_MODE);
--   while not endfile(fil_in54) loop
--     readline(fil_in54, v_LINE54);
--     read(v_LINE54, v_data54);
--     pix_in(53) <= v_data54;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ55 : process
--   variable v_line55 : line;
--   variable v_data55 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in55, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena55.txt", READ_MODE);
--   while not endfile(fil_in55) loop
--     readline(fil_in55, v_LINE55);
--     read(v_LINE55, v_data55);
--     pix_in(54) <= v_data55;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ56 : process
--   variable v_line56 : line;
--   variable v_data56 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in56, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena56.txt", READ_MODE);
--   while not endfile(fil_in56) loop
--     readline(fil_in56, v_LINE56);
--     read(v_LINE56, v_data56);
--     pix_in(55) <= v_data56;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ57 : process
--   variable v_line57 : line;
--   variable v_data57 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in57, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena57.txt", READ_MODE);
--   while not endfile(fil_in57) loop
--     readline(fil_in57, v_LINE57);
--     read(v_LINE57, v_data57);
--     pix_in(56) <= v_data57;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ58 : process
--   variable v_line58 : line;
--   variable v_data58 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in58, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena58.txt", READ_MODE);
--   while not endfile(fil_in58) loop
--     readline(fil_in58, v_LINE58);
--     read(v_LINE58, v_data58);
--     pix_in(57) <= v_data58;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ59 : process
--   variable v_line59 : line;
--   variable v_data59 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in59, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena59.txt", READ_MODE);
--   while not endfile(fil_in59) loop
--     readline(fil_in59, v_LINE59);
--     read(v_LINE59, v_data59);
--     pix_in(58) <= v_data59;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ60 : process
--   variable v_line60 : line;
--   variable v_data60 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in60, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena60.txt", READ_MODE);
--   while not endfile(fil_in60) loop
--     readline(fil_in60, v_LINE60);
--     read(v_LINE60, v_data60);
--     pix_in(49) <= v_data60;
--     wait for period;
--   end loop;
--   wait;
-- end process;

-- p_READ61 : process
--   variable v_line61 : line;
--   variable v_data61 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in61, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena61.txt", READ_MODE);
--   while not endfile(fil_in61) loop
--     readline(fil_in61, v_LINE61);
--     read(v_LINE61, v_data61);
--     pix_in(60) <= v_data61;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ62 : process
--   variable v_line62 : line;
--   variable v_data62 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in62, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena62.txt", READ_MODE);
--   while not endfile(fil_in62) loop
--     readline(fil_in62, v_LINE62);
--     read(v_LINE62, v_data62);
--     pix_in(61) <= v_data62;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ63 : process
--   variable v_line63 : line;
--   variable v_data63 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in63, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena63.txt", READ_MODE);
--   while not endfile(fil_in63) loop
--     readline(fil_in63, v_LINE63);
--     read(v_LINE63, v_data63);
--     pix_in(62) <= v_data63;
--     wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_READ64 : process
--   variable v_line64 : line;
--   variable v_data64 : std_logic_vector(MSB+LSB-1 downto 0);
--
--   begin
--   wait for period*2;
--   file_open(fil_in64, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/lena64.txt", READ_MODE);
--   while not endfile(fil_in64) loop
--     readline(fil_in64, v_LINE64);
--     read(v_LINE64, v_data64);
--     pix_in(63) <= v_data64;
--     wait for period;
--   end loop;
--   wait;
-- end process;

--
--
--

p_WRITE1 : process
  variable v_linew1 : line;
begin
  wait for period;
  file_open(fil_out1, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida1.txt", WRITE_MODE);
  while done(0) = '0' loop
    if pix_rdy(0) = '1' then
        write(v_linew1, pix_out(0));
        writeline(fil_out1, v_linew1);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE2 : process
  variable v_linew2 : line;
begin
  wait for period;
  file_open(fil_out2, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida2.txt", WRITE_MODE);
  while done(1) = '0' loop
    if pix_rdy(1) = '1' then
        write(v_linew2, pix_out(1));
        writeline(fil_out2, v_linew2);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE3 : process
  variable v_linew3 : line;
begin
  wait for period;
  file_open(fil_out3, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida3.txt", WRITE_MODE);
  while done(2) = '0' loop
    if pix_rdy(2) = '1' then
        write(v_linew3, pix_out(2));
        writeline(fil_out3, v_linew3);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE4 : process
  variable v_linew4 : line;
begin
  wait for period;
  file_open(fil_out4, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida4.txt", WRITE_MODE);
  while done(3) = '0' loop
    if pix_rdy(3) = '1' then
        write(v_linew4, pix_out(3));
        writeline(fil_out4, v_linew4);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE5 : process
  variable v_linew5 : line;
begin
  wait for period;
  file_open(fil_out5, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida5.txt", WRITE_MODE);
  while done(4) = '0' loop
    if pix_rdy(4) = '1' then
        write(v_linew5, pix_out(4));
        writeline(fil_out5, v_linew5);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE6 : process
  variable v_linew6 : line;
begin
  wait for period;
  file_open(fil_out6, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida6.txt", WRITE_MODE);
  while done(5) = '0' loop
    if pix_rdy(5) = '1' then
        write(v_linew6, pix_out(5));
        writeline(fil_out6, v_linew6);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE7 : process
  variable v_linew7 : line;
begin
  wait for period;
  file_open(fil_out7, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida7.txt", WRITE_MODE);
  while done(6) = '0' loop
    if pix_rdy(6) = '1' then
        write(v_linew7, pix_out(6));
        writeline(fil_out7, v_linew7);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE8 : process
  variable v_linew8 : line;
begin
  wait for period;
  file_open(fil_out8, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida8.txt", WRITE_MODE);
  while done(7) = '0' loop
    if pix_rdy(7) = '1' then
        write(v_linew8, pix_out(7));
        writeline(fil_out8, v_linew8);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE9 : process
  variable v_linew9 : line;
begin
  wait for period;
  file_open(fil_out9, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida9.txt", WRITE_MODE);
  while done(8) = '0' loop
    if pix_rdy(8) = '1' then
        write(v_linew9, pix_out(8));
        writeline(fil_out9, v_linew9);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE10 : process
  variable v_linew10 : line;
begin
  wait for period;
  file_open(fil_out10, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida10.txt", WRITE_MODE);
  while done(9) = '0' loop
    if pix_rdy(9) = '1' then
        write(v_linew10, pix_out(9));
        writeline(fil_out10, v_linew10);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE11 : process
  variable v_linew11 : line;
begin
  wait for period;
  file_open(fil_out11, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida11.txt", WRITE_MODE);
  while done(10) = '0' loop
    if pix_rdy(10) = '1' then
        write(v_linew11, pix_out(10));
        writeline(fil_out11, v_linew11);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE12 : process
  variable v_linew12 : line;
begin
  wait for period;
  file_open(fil_out12, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida12.txt", WRITE_MODE);
  while done(11) = '0' loop
    if pix_rdy(11) = '1' then
        write(v_linew12, pix_out(11));
        writeline(fil_out12, v_linew12);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE13 : process
  variable v_linew13 : line;
begin
  wait for period;
  file_open(fil_out13, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida13.txt", WRITE_MODE);
  while done(12) = '0' loop
    if pix_rdy(12) = '1' then
        write(v_linew13, pix_out(12));
        writeline(fil_out13, v_linew13);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE14 : process
  variable v_linew14 : line;
begin
  wait for period;
  file_open(fil_out14, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida14.txt", WRITE_MODE);
  while done(13) = '0' loop
    if pix_rdy(13) = '1' then
        write(v_linew14, pix_out(13));
        writeline(fil_out14, v_linew14);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE15 : process
  variable v_linew15 : line;
begin
  wait for period;
  file_open(fil_out15, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida15.txt", WRITE_MODE);
  while done(14) = '0' loop
    if pix_rdy(14) = '1' then
        write(v_linew15, pix_out(14));
        writeline(fil_out15, v_linew15);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE16 : process
  variable v_linew16 : line;
begin
  wait for period;
  file_open(fil_out16, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida16.txt", WRITE_MODE);
  while done(15) = '0' loop
    if pix_rdy(15) = '1' then
        write(v_linew16, pix_out(15));
        writeline(fil_out16, v_linew16);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE17 : process
  variable v_linew17 : line;
begin
  wait for period;
  file_open(fil_out17, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida17.txt", WRITE_MODE);
  while done(16) = '0' loop
    if pix_rdy(16) = '1' then
        write(v_linew17, pix_out(16));
        writeline(fil_out17, v_linew17);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE18 : process
  variable v_linew18 : line;
begin
  wait for period;
  file_open(fil_out18, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida18.txt", WRITE_MODE);
  while done(17) = '0' loop
    if pix_rdy(17) = '1' then
        write(v_linew18, pix_out(17));
        writeline(fil_out18, v_linew18);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE19 : process
  variable v_linew19 : line;
begin
  wait for period;
  file_open(fil_out19, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida19.txt", WRITE_MODE);
  while done(18) = '0' loop
    if pix_rdy(18) = '1' then
        write(v_linew19, pix_out(18));
        writeline(fil_out19, v_linew19);
   end if;
   wait for period;
  end loop;
  wait;
end process;

p_WRITE20 : process
  variable v_linew20 : line;
begin
  wait for period;
  file_open(fil_out20, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida20.txt", WRITE_MODE);
  while done(19) = '0' loop
    if pix_rdy(19) = '1' then
        write(v_linew20, pix_out(19));
        writeline(fil_out20, v_linew20);
   end if;
   wait for period;
  end loop;
  wait;
end process;

-- p_WRITE21 : process
--   variable v_linew21 : line;
-- begin
--   wait for period;
--   file_open(fil_out21, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida21.txt", WRITE_MODE);
--   while done(20) = '0' loop
--     if pix_rdy(20) = '1' then
--         write(v_linew21, pix_out(20));
--         writeline(fil_out21, v_linew21);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE22 : process
--   variable v_linew22 : line;
-- begin
--   wait for period;
--   file_open(fil_out22, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida22.txt", WRITE_MODE);
--   while done(21) = '0' loop
--     if pix_rdy(21) = '1' then
--         write(v_linew22, pix_out(21));
--         writeline(fil_out22, v_linew22);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE23 : process
--   variable v_linew23 : line;
-- begin
--   wait for period;
--   file_open(fil_out23, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida23.txt", WRITE_MODE);
--   while done(22) = '0' loop
--     if pix_rdy(22) = '1' then
--         write(v_linew23, pix_out(22));
--         writeline(fil_out23, v_linew23);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE24 : process
--   variable v_linew24 : line;
-- begin
--   wait for period;
--   file_open(fil_out24, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida24.txt", WRITE_MODE);
--   while done(23) = '0' loop
--     if pix_rdy(23) = '1' then
--         write(v_linew24, pix_out(23));
--         writeline(fil_out24, v_linew24);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE25 : process
--   variable v_linew25 : line;
-- begin
--   wait for period;
--   file_open(fil_out25, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida25.txt", WRITE_MODE);
--   while done(24) = '0' loop
--     if pix_rdy(24) = '1' then
--         write(v_linew25, pix_out(24));
--         writeline(fil_out25, v_linew25);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE26 : process
--   variable v_linew26 : line;
-- begin
--   wait for period;
--   file_open(fil_out26, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida26.txt", WRITE_MODE);
--   while done(25) = '0' loop
--     if pix_rdy(25) = '1' then
--         write(v_linew26, pix_out(25));
--         writeline(fil_out26, v_linew26);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE27 : process
--   variable v_linew27 : line;
-- begin
--   wait for period;
--   file_open(fil_out27, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida27.txt", WRITE_MODE);
--   while done(26) = '0' loop
--     if pix_rdy(26) = '1' then
--         write(v_linew27, pix_out(26));
--         writeline(fil_out27, v_linew27);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE28 : process
--   variable v_linew28 : line;
-- begin
--   wait for period;
--   file_open(fil_out28, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida28.txt", WRITE_MODE);
--   while done(27) = '0' loop
--     if pix_rdy(27) = '1' then
--         write(v_linew28, pix_out(27));
--         writeline(fil_out28, v_linew28);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE29 : process
--   variable v_linew29 : line;
-- begin
--   wait for period;
--   file_open(fil_out29, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida29.txt", WRITE_MODE);
--   while done(28) = '0' loop
--     if pix_rdy(28) = '1' then
--         write(v_linew29, pix_out(28));
--         writeline(fil_out29, v_linew29);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE30 : process
--   variable v_linew30 : line;
-- begin
--   wait for period;
--   file_open(fil_out30, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida30.txt", WRITE_MODE);
--   while done(29) = '0' loop
--     if pix_rdy(29) = '1' then
--         write(v_linew30, pix_out(29));
--         writeline(fil_out30, v_linew30);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE31 : process
--   variable v_linew31 : line;
-- begin
--   wait for period;
--   file_open(fil_out31, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida31.txt", WRITE_MODE);
--   while done(30) = '0' loop
--     if pix_rdy(30) = '1' then
--         write(v_linew31, pix_out(30));
--         writeline(fil_out31, v_linew31);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE32 : process
--   variable v_linew32 : line;
-- begin
--   wait for period;
--   file_open(fil_out32, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida32.txt", WRITE_MODE);
--   while done(31) = '0' loop
--     if pix_rdy(31) = '1' then
--         write(v_linew32, pix_out(31));
--         writeline(fil_out32, v_linew32);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE33 : process
--   variable v_linew33 : line;
-- begin
--   wait for period;
--   file_open(fil_out33, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida33.txt", WRITE_MODE);
--   while done(32) = '0' loop
--     if pix_rdy(32) = '1' then
--         write(v_linew33, pix_out(32));
--         writeline(fil_out33, v_linew33);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE34 : process
--   variable v_linew34 : line;
-- begin
--   wait for period;
--   file_open(fil_out34, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida34.txt", WRITE_MODE);
--   while done(33) = '0' loop
--     if pix_rdy(33) = '1' then
--         write(v_linew34, pix_out(33));
--         writeline(fil_out34, v_linew34);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE35 : process
--   variable v_linew35 : line;
-- begin
--   wait for period;
--   file_open(fil_out35, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida35.txt", WRITE_MODE);
--   while done(34) = '0' loop
--     if pix_rdy(34) = '1' then
--         write(v_linew35, pix_out(34));
--         writeline(fil_out35, v_linew35);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE36 : process
--   variable v_linew36 : line;
-- begin
--   wait for period;
--   file_open(fil_out36, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida36.txt", WRITE_MODE);
--   while done(35) = '0' loop
--     if pix_rdy(35) = '1' then
--         write(v_linew36, pix_out(35));
--         writeline(fil_out36, v_linew36);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE37 : process
--   variable v_linew37 : line;
-- begin
--   wait for period;
--   file_open(fil_out37, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida37.txt", WRITE_MODE);
--   while done(36) = '0' loop
--     if pix_rdy(36) = '1' then
--         write(v_linew37, pix_out(36));
--         writeline(fil_out37, v_linew37);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE38 : process
--   variable v_linew38 : line;
-- begin
--   wait for period;
--   file_open(fil_out38, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida38.txt", WRITE_MODE);
--   while done(37) = '0' loop
--     if pix_rdy(37) = '1' then
--         write(v_linew38, pix_out(37));
--         writeline(fil_out38, v_linew38);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE39 : process
--   variable v_linew39 : line;
-- begin
--   wait for period;
--   file_open(fil_out39, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida39.txt", WRITE_MODE);
--   while done(38) = '0' loop
--     if pix_rdy(38) = '1' then
--         write(v_linew39, pix_out(38));
--         writeline(fil_out39, v_linew39);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE40 : process
--   variable v_linew40 : line;
-- begin
--   wait for period;
--   file_open(fil_out40, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida40.txt", WRITE_MODE);
--   while done(39) = '0' loop
--     if pix_rdy(39) = '1' then
--         write(v_linew40, pix_out(39));
--         writeline(fil_out40, v_linew40);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE41 : process
--   variable v_linew41 : line;
-- begin
--   wait for period;
--   file_open(fil_out41, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida41.txt", WRITE_MODE);
--   while done(40) = '0' loop
--     if pix_rdy(40) = '1' then
--         write(v_linew41, pix_out(40));
--         writeline(fil_out41, v_linew41);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE42 : process
--   variable v_linew42 : line;
-- begin
--   wait for period;
--   file_open(fil_out42, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida42.txt", WRITE_MODE);
--   while done(41) = '0' loop
--     if pix_rdy(41) = '1' then
--         write(v_linew42, pix_out(41));
--         writeline(fil_out42, v_linew42);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE43 : process
--   variable v_linew43 : line;
-- begin
--   wait for period;
--   file_open(fil_out43, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida43.txt", WRITE_MODE);
--   while done(42) = '0' loop
--     if pix_rdy(42) = '1' then
--         write(v_linew43, pix_out(42));
--         writeline(fil_out43, v_linew43);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE44 : process
--   variable v_linew44 : line;
-- begin
--   wait for period;
--   file_open(fil_out44, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida44.txt", WRITE_MODE);
--   while done(43) = '0' loop
--     if pix_rdy(43) = '1' then
--         write(v_linew44, pix_out(43));
--         writeline(fil_out44, v_linew44);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE45 : process
--   variable v_linew45 : line;
-- begin
--   wait for period;
--   file_open(fil_out45, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida45.txt", WRITE_MODE);
--   while done(44) = '0' loop
--     if pix_rdy(44) = '1' then
--         write(v_linew45, pix_out(44));
--         writeline(fil_out45, v_linew45);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE46 : process
--   variable v_linew46 : line;
-- begin
--   wait for period;
--   file_open(fil_out46, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida46.txt", WRITE_MODE);
--   while done(45) = '0' loop
--     if pix_rdy(45) = '1' then
--         write(v_linew46, pix_out(45));
--         writeline(fil_out46, v_linew46);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE47 : process
--   variable v_linew47 : line;
-- begin
--   wait for period;
--   file_open(fil_out47, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida47.txt", WRITE_MODE);
--   while done(46) = '0' loop
--     if pix_rdy(46) = '1' then
--         write(v_linew47, pix_out(46));
--         writeline(fil_out47, v_linew47);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE48 : process
--   variable v_linew48 : line;
-- begin
--   wait for period;
--   file_open(fil_out48, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida48.txt", WRITE_MODE);
--   while done(47) = '0' loop
--     if pix_rdy(47) = '1' then
--         write(v_linew48, pix_out(47));
--         writeline(fil_out48, v_linew48);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE49 : process
--   variable v_linew49 : line;
-- begin
--   wait for period;
--   file_open(fil_out49, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida49.txt", WRITE_MODE);
--   while done(48) = '0' loop
--     if pix_rdy(48) = '1' then
--         write(v_linew49, pix_out(48));
--         writeline(fil_out49, v_linew49);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE50 : process
--   variable v_linew50 : line;
-- begin
--   wait for period;
--   file_open(fil_out50, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida50.txt", WRITE_MODE);
--   while done(49) = '0' loop
--     if pix_rdy(49) = '1' then
--         write(v_linew50, pix_out(49));
--         writeline(fil_out50, v_linew50);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;

-- p_WRITE51 : process
--   variable v_linew51 : line;
-- begin
--   wait for period;
--   file_open(fil_out51, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida51.txt", WRITE_MODE);
--   while done(50) = '0' loop
--     if pix_rdy(50) = '1' then
--         write(v_linew51, pix_out(50));
--         writeline(fil_out51, v_linew51);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE52 : process
--   variable v_linew52 : line;
-- begin
--   wait for period;
--   file_open(fil_out52, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida52.txt", WRITE_MODE);
--   while done(51) = '0' loop
--     if pix_rdy(51) = '1' then
--         write(v_linew52, pix_out(51));
--         writeline(fil_out52, v_linew52);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE53 : process
--   variable v_linew53 : line;
-- begin
--   wait for period;
--   file_open(fil_out53, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida53.txt", WRITE_MODE);
--   while done(52) = '0' loop
--     if pix_rdy(52) = '1' then
--         write(v_linew53, pix_out(52));
--         writeline(fil_out53, v_linew53);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE54 : process
--   variable v_linew54 : line;
-- begin
--   wait for period;
--   file_open(fil_out54, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida54.txt", WRITE_MODE);
--   while done(53) = '0' loop
--     if pix_rdy(53) = '1' then
--         write(v_linew54, pix_out(53));
--         writeline(fil_out54, v_linew54);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE55 : process
--   variable v_linew55 : line;
-- begin
--   wait for period;
--   file_open(fil_out55, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida55.txt", WRITE_MODE);
--   while done(54) = '0' loop
--     if pix_rdy(54) = '1' then
--         write(v_linew55, pix_out(54));
--         writeline(fil_out55, v_linew55);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE56 : process
--   variable v_linew56 : line;
-- begin
--   wait for period;
--   file_open(fil_out56, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida56.txt", WRITE_MODE);
--   while done(55) = '0' loop
--     if pix_rdy(55) = '1' then
--         write(v_linew56, pix_out(55));
--         writeline(fil_out56, v_linew56);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE57 : process
--   variable v_linew57 : line;
-- begin
--   wait for period;
--   file_open(fil_out57, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida57.txt", WRITE_MODE);
--   while done(56) = '0' loop
--     if pix_rdy(56) = '1' then
--         write(v_linew57, pix_out(56));
--         writeline(fil_out57, v_linew57);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE58 : process
--   variable v_linew58 : line;
-- begin
--   wait for period;
--   file_open(fil_out58, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida58.txt", WRITE_MODE);
--   while done(57) = '0' loop
--     if pix_rdy(57) = '1' then
--         write(v_linew58, pix_out(57));
--         writeline(fil_out58, v_linew58);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE59 : process
--   variable v_linew59 : line;
-- begin
--   wait for period;
--   file_open(fil_out59, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida59.txt", WRITE_MODE);
--   while done(58) = '0' loop
--     if pix_rdy(58) = '1' then
--         write(v_linew59, pix_out(58));
--         writeline(fil_out59, v_linew59);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE60 : process
--   variable v_linew60 : line;
-- begin
--   wait for period;
--   file_open(fil_out60, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida60.txt", WRITE_MODE);
--   while done(59) = '0' loop
--     if pix_rdy(59) = '1' then
--         write(v_linew60, pix_out(59));
--         writeline(fil_out60, v_linew60);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;

-- p_WRITE61 : process
--   variable v_linew61 : line;
-- begin
--   wait for period;
--   file_open(fil_out61, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida61.txt", WRITE_MODE);
--   while done(60) = '0' loop
--     if pix_rdy(60) = '1' then
--         write(v_linew61, pix_out(60));
--         writeline(fil_out61, v_linew61);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE62 : process
--   variable v_linew62 : line;
-- begin
--   wait for period;
--   file_open(fil_out62, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida62.txt", WRITE_MODE);
--   while done(61) = '0' loop
--     if pix_rdy(61) = '1' then
--         write(v_linew62, pix_out(61));
--         writeline(fil_out62, v_linew62);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE63 : process
--   variable v_linew63 : line;
-- begin
--   wait for period;
--   file_open(fil_out63, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida63.txt", WRITE_MODE);
--   while done(62) = '0' loop
--     if pix_rdy(62) = '1' then
--         write(v_linew63, pix_out(62));
--         writeline(fil_out63, v_linew63);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;
--
-- p_WRITE64 : process
--   variable v_linew64 : line;
-- begin
--   wait for period;
--   file_open(fil_out64, "C:/Users/andre/Desktop/FDAndrei/blocks_fixed/saida64.txt", WRITE_MODE);
--   while done(63) = '0' loop
--     if pix_rdy(63) = '1' then
--         write(v_linew64, pix_out(63));
--         writeline(fil_out64, v_linew64);
--    end if;
--    wait for period;
--   end loop;
--   wait;
-- end process;

  toppest_i : toppest
  port map (
    i_CLK         => clk,
    i_RST         => rst,
    i_START       => start,
    i_INPUT_PIXEL => pix_in,
    i_VALID_PIXEL => vp,
    o_VALID_PIXEL => pix_rdy,
    o_OUT_PIXEL   => pix_out,
    o_DONE        => done
  );


end architecture;
