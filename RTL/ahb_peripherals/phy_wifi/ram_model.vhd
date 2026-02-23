library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
entity ram_model is
  generic(
    RAM_SIZE : INTEGER := 48;
	ADD_WIDTH : INTEGER := 6;
	DATA_WIDTH : INTEGER := 12
	);
  port (
	clk_write   : in STD_LOGIC;
	data_in     : in STD_LOGIC_VECTOR ((DATA_WIDTH) - 1 downto 0);
	we          : in STD_LOGIC;
	add_re      : in STD_LOGIC_VECTOR  (ADD_WIDTH - 1 downto 0);
	add_wr      : in STD_LOGIC_VECTOR  (ADD_WIDTH - 1 downto 0);
	data_out    : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
    );
end ram_model;

architecture memory of ram_model is
    type     ram_type           is array (0 to (RAM_SIZE - 1)) of std_logic_vector((DATA_WIDTH - 1) downto 0);
	signal   ram             :  ram_type;
	
	begin
	  ram_write_proc : process(clk_write)
	  begin
	    if clk_write'event and clk_write = '1' then
		  if we = '1' then
		    if(unsigned(add_wr) <= 47) then
		      ram(to_integer(unsigned(add_wr))) <= data_in;
			end if;
		  end if;
		end if;
	  end process;
	  ram_read_proc : process(add_re,ram)
	  begin
		if(unsigned(add_re) <= 47) then  
		  data_out <= ram(to_integer(unsigned(add_re)));
		else
		  data_out <= (others => '0');
		end if;
      end process;
end memory;
	