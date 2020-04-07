library iEEE;
use iEEE.std_logic_1164.all;
use iEEE.numeric_std.all;
use iEEE.math_real.all;

entity ram_2 is
generic(
  address_size : integer;
  data_size    : integer
);
port(
  i_ADD_A        : in std_logic_vector(address_size-1 downto 0);
  i_ADD_B   	   : in std_logic_vector(address_size-1 downto 0);
  i_CLK 		 		 : in std_logic;
  i_DATA_B       : in std_logic_vector(data_size-1 downto 0);
  i_WREN_B 	 	 	 : in std_logic;
  o_READ_DATA_A  : out std_logic_vector(data_size-1 downto 0);
  o_READ_DATA_B  : out std_logic_vector(data_size-1 downto 0)
);
end ram_2;

architecture arch1 of ram_2 is

  type vet_reg is array(0 to (2 ** address_size-1)) of std_logic_vector(data_size-1 downto 0);
  signal w_REG_BANK : vet_reg := (others => (others => '0'));
	signal w_RA, w_RB : std_logic_vector(data_size-1 downto 0);

begin

  u_0 : process(i_CLK, i_WREN_B)
  begin

		if(rising_edge(i_CLK)) then
			if (i_WREN_B = '1') then
				w_REG_BANK(to_integer(unsigned(i_ADD_B))) <=  i_DATA_B;
			else
				w_RB <= w_REG_BANK(to_integer(unsigned(i_ADD_B)));
			end if;
			w_RA <= w_REG_BANK(to_integer(unsigned(i_ADD_A)));
		end if;

  end process;

	o_READ_DATA_A <= w_RA;
	o_READ_DATA_B <= w_RB;

end arch1;
