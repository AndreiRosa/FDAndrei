library work;
use work.fda_package.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY FIFO_16 IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (MSB+LSB-1 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (MSB+LSB-1 DOWNTO 0)
	);
END FIFO_16;


ARCHITECTURE SYN OF FIFO_16 IS

	SIGNAL sub_wire0	: STD_LOGIC ;
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (MSB+LSB-1 DOWNTO 0);


	COMPONENT scfifo
	GENERIC (
		add_ram_output_register		: STRING;
		intended_device_family		: STRING;
		lpm_numwords		: NATURAL;
		lpm_showahead		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL;
		lpm_widthu		: NATURAL;
		overflow_checking		: STRING;
		underflow_checking		: STRING;
		use_eab		: STRING
	);
	PORT (
			clock	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (MSB+LSB-1 DOWNTO 0);
			rdreq	: IN STD_LOGIC ;
			wrreq	: IN STD_LOGIC ;
			empty	: OUT STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (MSB+LSB-1 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	empty    <= sub_wire0;
	q    <= sub_wire1(MSB+LSB-1 DOWNTO 0);

	scfifo_component : scfifo
	GENERIC MAP (
		add_ram_output_register => "OFF",
		intended_device_family => "Cyclone V",
		lpm_numwords => c_COUNT_IMG_DONE,
		lpm_showahead => "OFF",
		lpm_type => "scfifo",
		lpm_width => MSB+LSB,
		lpm_widthu => c_MEM_SIZE,
		overflow_checking => "ON",
		underflow_checking => "ON",
		use_eab => "ON"
	)
	PORT MAP (
		clock => clock,
		data => data,
		rdreq => rdreq,
		wrreq => wrreq,
		empty => sub_wire0,
		q => sub_wire1
	);
END SYN;
