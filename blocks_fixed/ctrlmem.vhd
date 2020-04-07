library ieee;
use ieee.std_logic_1164.all;

library work;
use work.fda_package.all;

entity ctrlmem is
  port (
    i_CLK                     : in  std_logic;
    i_RST                     : in  std_logic;
    i_START                   : in  std_logic;

    i_END_VB_INC              : in std_logic;
    i_IMG_DONE                : in std_logic;
    i_END_R		                : in std_logic;
    i_END_VB_INC_END          : in std_logic;
    i_PROC_DONE               : in std_logic;
    i_ITERATE_END             : in std_logic;

    i_MEM_FULL                : in std_logic;
    i_Q_EMPTY                 : in std_logic;

    o_CLR_CNT_ADDRA           : out std_logic;
    o_INC_CNT_ADDRA           : out std_logic;
    o_INC_CNT_ADDRA2          : out std_logic;
    o_CLR_CNT_ADDRVB_P0_M1    : out std_logic;
    o_INC_CNT_ADDRVB_P0_M1    : out std_logic;
    o_INC_CNT_ADDRVB_P2_M1    : out std_logic;
    o_SEL_MUX_P0              : out std_logic;
   	o_SEL_MUX_P1              : out std_logic_vector (1 downto 0);
	  o_SEL_MUX_P2              : out std_logic;
    o_SEL_MUX_M0              : out std_logic_vector (1 downto 0);
	  o_SEL_MUX_M1              : out std_logic_vector (1 downto 0);
	  o_SEL_MUX_M2              : out std_logic_vector (1 downto 0);
    o_SEL_MUX_ADDRA           : out std_logic;
	  o_SEL_MUX_ADDRA1          : out std_logic_vector (1 downto 0);
    -- o_INC_PIXEL_MEM           : out std_logic;
    -- o_CLR_PIXEL_MEM           : out std_logic;
    o_INC_CNT_ADDRVB          : out std_logic;
    o_CLR_CNT_ADDRVB          : out std_logic;
	  o_INC_CNT_ADDRVB2         : out std_logic;
    o_INC_CNT_COLUMN          : out std_logic;
    o_CLR_CNT_COLUMN          : out std_logic;
    o_RREQ                    : out std_logic;
    o_VALID_PIXEL             : out std_logic;

    o_SEL_MUX_PIXEL_IN        : out std_logic;
    o_CLR_CNT_ADDRB           : out std_logic;
    o_WRREN                   : out std_logic;
    o_START                   : out std_logic;


    o_ITDONE                  : out std_logic; -- ESSE É PRA TESTE APENAS

    o_DONE                    : out std_logic
  );
end ctrlmem;

architecture arch of ctrlmem is	-- states of FSM
type state_type is (
  s_IDLE,
  s_LOAD_MEMORY,
  s_AUX,
  s_R_VB_L,
  s_R_VB_INC,
  s_R_VB_INC2,
  s_R_VB_INC_LAST,
  s_R_VB_R,
  s_R_L,
  s_R_M,
  s_R_M2,
  s_R_M_LAST,
  s_R_R,
  s_AUX2_END,
  s_AUX_END,
  s_R_VB_L_END,
  s_R_VB_INC_END,
  s_R_VB_INC2_END,
  s_R_VB_INC_END_LAST,
  s_R_VB_R_END,
  s_R_END,
  s_WAIT_PROC,
  s_CLEAR,
  s_END
);

signal r_state_reg  : state_type;
signal r_next_state : state_type;

begin

  p_state_reg : process (i_CLK, i_RST)
  begin
    if (i_RST = '1') then
      r_state_reg <= s_IDLE;            -- idle
  elsif (rising_edge(i_CLK)) then
    r_state_reg <= r_next_state;
  end if;
  end process;

  p_next_state : process (r_state_reg, i_CLK, i_RST, i_START, i_END_VB_INC, i_END_VB_INC_END, i_IMG_DONE, i_END_R, i_PROC_DONE, i_ITERATE_END, i_MEM_FULL, i_Q_EMPTY)
  begin
    case (r_state_reg) is
      when s_IDLE =>
        if(i_START = '1') then
          r_next_state <= s_LOAD_MEMORY;
        else
          r_next_state <= s_IDLE;
        end if;

      when s_LOAD_MEMORY =>
        if(i_MEM_FULL = '1') then
          r_next_state <= s_CLEAR;
        else
          r_next_state <= s_LOAD_MEMORY;
        end if;

      when s_CLEAR =>
          r_next_state <= s_AUX;

      when s_AUX =>
          r_next_state <= s_R_VB_L;

      when s_R_VB_L =>
        r_next_state <= s_R_VB_INC;

      when s_R_VB_INC =>
        if (i_END_VB_INC = '0') then
           r_next_state <= s_R_VB_INC;
        else
          r_next_state <= s_R_VB_INC2;
        end if;

      when s_R_VB_INC2 =>
        r_next_state <= s_R_VB_INC_LAST;

      when s_R_VB_INC_LAST =>
        r_next_state <= s_R_VB_R;

      when s_R_VB_R =>
        r_next_state <= s_R_L;

      when s_R_L =>
        r_next_state <=  s_R_M;

      when s_R_M =>
        if (i_END_R = '0') then
           r_next_state <= s_R_M;
        else
          r_next_state <= s_R_M2;
        end if;

      when s_R_M2 =>
        r_next_state <= s_R_M_LAST;

      when s_R_M_LAST =>
        r_next_state <= s_R_R;

      when s_R_R =>
        if (i_IMG_DONE = '0') then
           r_next_state <= s_R_L;
        else
          r_next_state <= s_AUX2_END;
        end if;

      when s_AUX2_END =>
        r_next_state <= s_AUX_END;

      when s_AUX_END =>
        r_next_state <= s_R_VB_L_END;

      when s_R_VB_L_END =>
        r_next_state <= s_R_VB_INC_END;

      when s_R_VB_INC_END =>
        if (i_END_VB_INC_END = '0') then
           r_next_state <= s_R_VB_INC_END;
        else
          r_next_state <= s_R_VB_INC2_END;
        end if;

      when s_R_VB_INC2_END =>
        r_next_state <= s_R_VB_INC_END_LAST;

      when s_R_VB_INC_END_LAST =>
        r_next_state <= s_R_VB_R_END;

  		when s_R_VB_R_END =>
        r_next_state <= s_R_END;

      when s_R_END =>
        r_next_state <= s_WAIT_PROC;

      when s_WAIT_PROC =>
        if (i_ITERATE_END = '1' and i_Q_EMPTY = '1') then
          r_next_state <= s_END;
        elsif (i_PROC_DONE = '1' and i_Q_EMPTY = '1' and i_ITERATE_END = '0') then
           r_next_state <= s_CLEAR;
        else
          r_next_state <= s_WAIT_PROC;
        end if;

      when s_END =>
        r_next_state <= s_END;

    end case;
  end process;

  o_SEL_MUX_PIXEL_IN 	      <= '0'  when r_state_reg = s_IDLE or r_state_reg = s_LOAD_MEMORY else '1';
  o_CLR_CNT_ADDRB   	      <= '1'  when r_state_reg = s_IDLE or r_state_reg = s_CLEAR else '0';
  o_WRREN                   <= '1'  when r_state_reg = s_LOAD_MEMORY else '0';
  o_START                   <= '0'  when r_state_reg = s_IDLE or r_state_reg = s_LOAD_MEMORY or r_state_reg = s_CLEAR else '1';
  o_CLR_CNT_ADDRA           <= '1'  when r_state_reg = s_IDLE or r_state_reg = s_CLEAR or r_state_reg = s_R_VB_INC_LAST else '0';
  o_INC_CNT_ADDRA           <= '1'  when r_state_reg = s_R_M2 or r_state_reg = s_R_L or r_state_reg = s_R_VB_L or r_state_reg = s_R_VB_INC or r_state_reg = s_R_VB_INC2_END or r_state_reg = s_R_VB_INC2 or r_state_reg = s_R_M or r_state_reg = s_R_VB_INC_END or r_state_reg = s_R_VB_L_END else '0';
  o_INC_CNT_ADDRA2          <= '1'  when r_state_reg = s_R_L or r_state_reg = s_R_VB_L or r_state_reg = s_R_M or r_state_reg = s_R_VB_INC or r_state_reg = s_R_VB_INC_LAST or r_state_reg = s_R_M_LAST or r_state_reg = s_R_VB_INC_END or r_state_reg = s_R_VB_L_END else '0'; -- or r_state_reg = s_R_VB_INC2_END or r_state_reg = s_R_VB_INC_END_LAST
  o_CLR_CNT_ADDRVB_P0_M1    <= '1'  when r_state_reg = s_IDLE or r_state_reg = s_CLEAR else '0';
  o_INC_CNT_ADDRVB_P0_M1    <= '1'  when r_state_reg = s_R_M_LAST else '0';
  o_INC_CNT_ADDRVB_P2_M1    <= '1'  when r_state_reg = s_R_R or r_state_reg = s_R_VB_R else '0';
  o_SEL_MUX_P0              <= '1'  when r_state_reg = s_R_R or r_state_reg = s_R_VB_R or r_state_reg = s_R_VB_R_END else '0';
  o_SEL_MUX_P1              <= "01" when r_state_reg = s_R_VB_L or r_state_reg = s_R_L or r_state_reg = s_R_VB_L_END else "10" when r_state_reg = s_R_VB_R or r_state_reg = s_R_VB_R_END or r_state_reg = s_R_R else "00";
  o_SEL_MUX_P2              <= '1'  when r_state_reg = s_R_VB_L or r_state_reg = s_R_L or r_state_reg = s_R_VB_L_END else '0';
  o_SEL_MUX_M0              <= "01" when r_state_reg = s_R_R or r_state_reg = s_R_VB_R or r_state_reg = s_AUX else "11" when r_state_reg = s_AUX_END else "00";
  o_SEL_MUX_M1              <= "01" when r_state_reg = s_R_M_LAST else "10" when r_state_reg = s_R_R or r_state_reg = s_R_VB_R or r_state_reg = s_AUX else "11" when r_state_reg = s_R_VB_INC_END_LAST or r_state_reg = s_AUX_END else "00";
  o_SEL_MUX_M2              <= "01" when r_state_reg = s_R_M_LAST or r_state_reg = s_R_VB_INC_LAST else "10" when r_state_reg = s_R_VB_INC_END_LAST else "00";
  o_SEL_MUX_ADDRA           <= '1'  when r_state_reg = s_R_VB_INC_END_LAST or r_state_reg = s_AUX_END or r_state_reg = s_R_VB_INC_END or r_state_reg = s_R_VB_INC2_END or r_state_reg = s_R_VB_L_END or r_state_reg = s_R_VB_R_END else '0';
  o_SEL_MUX_ADDRA1          <= "01" when r_state_reg = s_AUX_END else "10" when r_state_reg = s_R_VB_INC_END or r_state_reg = s_R_VB_L_END or r_state_reg = s_R_VB_INC2_END else "00";
  -- o_INC_PIXEL_MEM           <= '1'  when r_state_reg = s_R_M2 or r_state_reg = s_R_M or r_state_reg = s_R_M_LAST else '0';
  -- o_CLR_PIXEL_MEM           <= '1'  when r_state_reg = s_IDLE or r_state_reg = s_CLEAR else '0';
  o_INC_CNT_ADDRVB          <= '1'  when r_state_reg = s_R_VB_L or r_state_reg = s_R_VB_INC or r_state_reg = s_R_VB_INC_END or r_state_reg = s_R_VB_L_END or r_state_reg = s_R_VB_INC_END_LAST else '0';
  o_CLR_CNT_ADDRVB          <= '1'  when r_state_reg = s_R_VB_INC2 or r_state_reg = s_R_VB_INC2_END or r_state_reg = s_R_VB_INC_LAST or r_state_reg = s_CLEAR else '0';
  o_INC_CNT_ADDRVB2         <= '1'  when r_state_reg = s_R_VB_L or r_state_reg = s_R_VB_INC2_END or r_state_reg = s_R_VB_INC or r_state_reg = s_R_VB_INC_END or r_state_reg = s_R_VB_L_END else '0';
  o_INC_CNT_COLUMN          <= '1'  when r_state_reg = s_R_M2 or r_state_reg = s_R_M or r_state_reg = s_R_M_LAST else '0';
  o_CLR_CNT_COLUMN          <= '1'  when r_state_reg = s_R_R or r_state_reg = s_CLEAR or r_state_reg = s_IDLE else '0';
  o_RREQ                    <= '1'  when r_state_reg = s_AUX_END or r_state_reg = s_R_VB_INC_END_LAST or r_state_reg = s_R_R or r_state_reg = s_R_M or r_state_reg = s_R_VB_L_END or r_state_reg = s_R_VB_INC_END or r_state_reg = s_R_L or r_state_reg = s_R_VB_R_END or r_state_reg = s_WAIT_PROC or r_state_reg = s_R_END else '0';
  o_VALID_PIXEL             <= '0'  when r_state_reg = s_END or r_state_reg = s_AUX or r_state_reg = s_AUX2_END or r_state_reg = s_AUX_END or r_state_reg = s_IDLE or r_state_reg = s_WAIT_PROC or r_state_reg = s_CLEAR or r_state_reg = s_LOAD_MEMORY else '1';
  o_ITDONE                  <= '1'  when r_state_reg = s_CLEAR else '0';
  o_DONE                    <= '1'  when r_state_reg = s_END else '0';

end architecture;
