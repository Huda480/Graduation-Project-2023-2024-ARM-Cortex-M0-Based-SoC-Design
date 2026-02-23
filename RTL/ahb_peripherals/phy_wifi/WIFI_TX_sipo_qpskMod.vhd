library IEEE;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.ALL;
----------------------------------------------------------------------------------
entity WIFI_TX_sipo_qpskMod is
generic (
          N: integer := 2 --Output Length
        );
port    (
          clk: in std_logic;
          din: in std_logic_vector(0 downto 0);
          rst: in std_logic;
          valid_in: in std_logic;
          valid_out: out std_logic;
          dout:     out std_logic_vector(N-1 downto 0)
        );
end WIFI_TX_sipo_qpskMod;

architecture SinSout of WIFI_TX_sipo_qpskMod is
	signal out_shift_reg: std_logic_vector (N-1 downto 0);
	signal valid_out_s: std_logic;
	begin
		dout <= out_shift_reg;
		valid_out <= valid_out_s;

		process (clk,rst)
		begin
			if (rst = '0') then
				out_shift_reg <= std_logic_vector(conv_unsigned(1,N)); 
				valid_out_s <= '0';
			elsif (rising_edge (clk)) then
				if(valid_out_s = '1') then
					if(valid_in = '1') then
						out_shift_reg <=  '1' & din; 		
					else out_shift_reg <= std_logic_vector(conv_unsigned(0,N-1)) & '1';
					end if;

					valid_out_s <= '0';
				elsif (valid_in= '1') then
					valid_out_s <= out_shift_reg(N - 1);
					out_shift_reg <= out_shift_reg(N - 2 downto 0) & din;
				end if;
			end if;
		end process;
end SinSout;
