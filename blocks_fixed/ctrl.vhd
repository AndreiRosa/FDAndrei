library ieee;
use ieee.std_logic_1164.all;

library work;
use work.fda_package.all;

entity ctrl is
  port (
   i_CLK              : in  std_logic;
   i_RST              : in  std_logic;
   i_START            : in  std_logic;
   i_QEMPTY           : in  std_logic;

   i_VALID_PIXEL      : in std_logic;
   i_MAX_KER_TOT      : in std_logic;
   i_MAX_KER_ROW      : in std_logic;
   i_MAX_INV_KER      : in std_logic;
   i_BUFFER_FILLED	  : in std_logic;

   i_ITERATE		  	  : in std_logic;

   o_CLR_KER_TOT	    : out std_logic;
 	 o_CLR_KER_ROW	    : out std_logic;
 	 o_CLR_INV_KER	    : out std_logic;
 	 o_CLR_BUF_FIL	    : out std_logic;
 	 o_EN_KER_TOT	      : out std_logic;
 	 o_EN_KER_ROW	      : out std_logic;
 	 o_EN_INV_KER	      : out std_logic;
 	 o_EN_BUF_FIL	      : out std_logic;

 	 o_EN_IT 				    : out std_logic;

 	 o_EN_CALC          : out std_logic;
 	 o_EN_WRITE_KERNEL  : out std_logic;

   o_PROC_DONE        : out std_logic;
   o_DONE             : out std_logic
  );
end ctrl;

architecture arch of ctrl is	-- states of FSM
  type state_type is (
   s_IDLE,					-- initial state
   s_BUFFER_FILLED,	-- stays in this state until the DRA is not fullfilled
	 s_VAL_PIX,				-- valid pixels are generated in this state
	 s_INV_PIX,				-- in this state, the window is not valid
	 s_ITERATE,				-- this state checks if all the iterations are done
   s_WAIT_PROC,
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

  p_next_state : process (r_state_reg, i_CLK, i_RST, i_VALID_PIXEL, i_QEMPTY, i_START, i_MAX_KER_TOT, i_MAX_KER_ROW, i_MAX_INV_KER, i_BUFFER_FILLED, i_ITERATE)
  begin
    case (r_state_reg) is
      when s_IDLE =>
        if(i_START = '1') then
          r_next_state <= s_BUFFER_FILLED;
        else
          r_next_state <= s_IDLE;
        end if;

      when s_BUFFER_FILLED =>
        if (i_BUFFER_FILLED = '1' and i_VALID_PIXEL = '1') then
            r_next_state <= s_VAL_PIX;
        else
            r_next_state <= s_BUFFER_FILLED;
        end if;

      when s_VAL_PIX =>
        if(i_MAX_KER_TOT = '1') then
          r_next_state <= s_ITERATE;
        elsif (i_MAX_KER_ROW = '1' and i_VALID_PIXEL = '1') then
          r_next_state <= s_INV_PIX;
        else
          r_next_state <= s_VAL_PIX;
        end if;

      when s_INV_PIX =>
        if(i_MAX_INV_KER = '1' and i_VALID_PIXEL = '1') then
          r_next_state <= s_VAL_PIX;
        else
          r_next_state <= s_INV_PIX;
        end if;

      when s_ITERATE =>
            r_next_state <= s_WAIT_PROC;

      when s_WAIT_PROC =>
        if (i_ITERATE = '1' and i_QEMPTY = '1') then
          r_next_state <= s_END;
        elsif (i_QEMPTY = '1') then
          r_next_state <= s_BUFFER_FILLED;
        else
          r_next_state <= s_WAIT_PROC;
        end if;

      when s_END =>
        r_next_state <= s_END;

    end case;
  end process;

  o_EN_KER_TOT 			<= '1' when r_state_reg = s_VAL_PIX else '0';
  o_CLR_KER_TOT 	  <= '1' when r_state_reg = s_IDLE or r_state_reg = s_ITERATE else '0';

  o_EN_KER_ROW 			<= '1' when r_state_reg = s_VAL_PIX else '0';
  o_CLR_KER_ROW 	  <= '1' when r_state_reg = s_IDLE or r_state_reg = s_ITERATE or r_state_reg = s_INV_PIX else '0';

  o_EN_INV_KER 			<= '1' when r_state_reg = s_INV_PIX else '0';
  o_CLR_INV_KER 	  <= '1' when r_state_reg = s_VAL_PIX or r_state_reg = s_ITERATE else '0';

  o_EN_BUF_FIL 			<= '1' when r_state_reg = s_BUFFER_FILLED else '0';
	o_CLR_BUF_FIL 	  <= '1' when r_state_reg = s_IDLE or r_state_reg = s_WAIT_PROC else '0';

  o_EN_IT 			    <= '1' when r_state_reg = s_ITERATE else '0';

	o_EN_WRITE_KERNEL	<= '1' when r_state_reg = s_BUFFER_FILLED or r_state_reg = s_VAL_PIX or r_state_reg = s_INV_PIX else '0';
  o_EN_CALC    		  <= '1' when r_state_reg = s_VAL_PIX else '0';
  o_PROC_DONE       <= '1' when r_state_reg = s_ITERATE or r_state_reg = s_WAIT_PROC else '0';
	o_DONE         	  <= '1' when r_state_reg = s_END else '0';

end arch;
