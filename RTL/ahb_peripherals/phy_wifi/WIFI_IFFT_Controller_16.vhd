library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity WIFI_IFFT_Controller_16 is
	generic
	(
		FFT_SIZE              	: INTEGER := 64;
		SAMPLE_WIDTH          	: INTEGER := 12;
		SCALING_INDEX_WIDTH   	: INTEGER := 6;
		RAM_SIZE              	: INTEGER := 48; -- number of symbols to enter ifft
		ADD_SIZE              	: INTEGER := 6
	);
	port 
	(
		clk         		: in STD_LOGIC;
		clk_div     		: in STD_LOGIC;
		reset       		: in STD_LOGIC;
		sym_re      		: in STD_LOGIC_VECTOR((SAMPLE_WIDTH) - 1 downto 0);
		sym_im      		: in STD_LOGIC_VECTOR((SAMPLE_WIDTH) - 1 downto 0);
		valid_in    		: in STD_LOGIC;
		ifft_start  		: in STD_LOGIC;
		last_symbol 		: in STD_LOGIC;
		mapper_ready		: in STD_LOGIC;
		valid_out   		: out STD_LOGIC;
		sample_real 		: out STD_LOGIC_VECTOR((SAMPLE_WIDTH) - 1 downto 0);
		sample_im   		: out STD_LOGIC_VECTOR((SAMPLE_WIDTH) - 1 downto 0);
		preample_st 		: out STD_LOGIC;
		enable      		: out STD_LOGIC
	);
end WIFI_IFFT_Controller_16;

architecture CONTROLLER of WIFI_IFFT_Controller_16 is
	signal   start           	:  STD_LOGIC; 
	signal   cp_len_we       	:  STD_LOGIC; 
	constant cp_len          	:  STD_LOGIC_VECTOR ((SCALING_INDEX_WIDTH - 1) downto 0 ) := "010000"; 
	signal   fwd_inv_we      	:  STD_LOGIC;
	constant fwd_inv         	:  STD_LOGIC := '0'; 
	constant scale_sch_we    	:  STD_LOGIC := '0'; 
	constant scale_sch       	:  STD_LOGIC_VECTOR ((SCALING_INDEX_WIDTH - 1) downto 0 ) := "000000";
	signal   rfd             	:  STD_LOGIC;
	signal   ce              	:  STD_LOGIC;
	signal   busy            	:  STD_LOGIC; 
	signal   edone           	:  STD_LOGIC; 
	signal   done            	:  STD_LOGIC; 
	signal   dv              	:  STD_LOGIC; 
	signal   cpv             	:  STD_LOGIC; 
	signal   rfs             	:  STD_LOGIC; 
	signal   xn_re           	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 ); 
	signal   xn_im           	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 ); 
	signal   xn_index        	:  STD_LOGIC_VECTOR ((SCALING_INDEX_WIDTH - 1) downto 0 ); 
	signal   xk_index        	:  STD_LOGIC_VECTOR ((SCALING_INDEX_WIDTH - 1) downto 0 ); 
	signal   xk_re           	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   xk_im           	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   rama_in_real     	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   rama_in_imag     	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   rama_out_real    	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   rama_out_imag    	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   rama_we          	:  STD_LOGIC;
	signal   reada_add        	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0);
	signal   writea_add       	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0);
	signal   ramb_in_real     	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   ramb_in_imag     	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   ramb_out_real    	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   ramb_out_imag    	:  STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 );
	signal   ramb_we          	:  STD_LOGIC;
	signal   readb_add        	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0);
	signal   writeb_add       	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0);
	signal   first_valid_in  	:  STD_LOGIC;
	signal   preample_st_sig 	:  STD_LOGIC;
	signal   preample_st_tmp 	:  STD_LOGIC;
	signal   xn_special_index	:  STD_LOGIC;
	signal   xn_pilot        	:  STD_LOGIC;
	signal   xn_null         	:  STD_LOGIC;
	signal   pilot_out       	:  STD_LOGIC_VECTOR((SAMPLE_WIDTH - 1) downto 0);
	signal   pilot_enable    	:  STD_LOGIC;
	signal   valid_out_pilot 	:  STD_LOGIC;
	signal   last_symbol_flag	:  STD_LOGIC;
	signal   turn_off_ifft   	:  STD_LOGIC;
	signal   lock_start_zero 	:  STD_LOGIC;
	signal   mem_switch_write	:  STD_LOGIC;
	signal   mem_switch_read 	:  STD_LOGIC;
	signal   mema_empty      	:  STD_LOGIC;
	signal   memb_empty      	:  STD_LOGIC;
	signal   mema_empty_early	:  STD_LOGIC;
	signal   memb_empty_early	:  STD_LOGIC;
	signal   mema_empty_temp 	:  STD_LOGIC;
	signal   memb_empty_temp 	:  STD_LOGIC;
	signal   enable_sig      	:  STD_LOGIC;
	signal   enable_sig_2    	:  STD_LOGIC;
	signal   enable_counter  	:  STD_LOGIC_VECTOR(6 downto 0);
	-- Special Addresses constants
	constant pilot_add_1     	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0) := std_logic_Vector(to_unsigned(7,ADD_SIZE)); -- pilot 7
	constant pilot_add_2     	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0) := std_logic_vector(to_unsigned(21,ADD_SIZE)); -- pilot 21
	constant pilot_add_3     	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0) := std_logic_vector(to_unsigned(57,ADD_SIZE)); -- pilot -7
	constant pilot_add_4     	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0) := std_logic_vector(to_unsigned(43,ADD_SIZE)); -- pilot -21
	constant zero_add        	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0) := std_logic_vector(to_unsigned(0,ADD_SIZE));  -- null at zero
	constant nulls_start     	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0) := std_logic_vector(to_unsigned(27,ADD_SIZE)); -- null region start at 27
	constant nulls_end       	:  STD_LOGIC_VECTOR ((ADD_SIZE - 1) downto 0) := std_logic_vector(to_unsigned(37,ADD_SIZE)); -- null region end at 37

	component IFFT is
	port 
	(
		clk 			: in STD_LOGIC := 'X'; 
		ce 			: in STD_LOGIC := 'X'; 
		start 			: in STD_LOGIC := 'X'; 
		cp_len_we 		: in STD_LOGIC := 'X'; 
		fwd_inv 		: in STD_LOGIC := 'X'; 
		fwd_inv_we 		: in STD_LOGIC := 'X'; 
		scale_sch_we 		: in STD_LOGIC := 'X'; 
		rfd 			: out STD_LOGIC; 
		busy 			: out STD_LOGIC; 
		edone 			: out STD_LOGIC; 
		done 			: out STD_LOGIC; 
		dv 			: out STD_LOGIC; 
		cpv 			: out STD_LOGIC; 
		rfs 			: out STD_LOGIC; 
		cp_len 			: in STD_LOGIC_VECTOR ( 5 downto 0 ); 
		xn_re 			: in STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 ); 
		xn_im 			: in STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 ); 
		scale_sch 		: in STD_LOGIC_VECTOR ( 5 downto 0 ); 
		xn_index 		: out STD_LOGIC_VECTOR ( 5 downto 0 ); 
		xk_index 		: out STD_LOGIC_VECTOR ( 5 downto 0 ); 
		xk_re 			: out STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 ); 
		xk_im 			: out STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0 ) 
	);
	end component;

	component ram_model is
	generic
	(
		RAM_SIZE 		: INTEGER := RAM_SIZE;
		ADD_WIDTH 		: INTEGER := ADD_SIZE;
		DATA_WIDTH 		: INTEGER := SAMPLE_WIDTH
	);
	port 
	(
		clk_write   		: in STD_LOGIC;
		data_in     		: in STD_LOGIC_VECTOR ((DATA_WIDTH) - 1 downto 0);
		we          		: in STD_LOGIC;
		add_re      		: in STD_LOGIC_VECTOR  (ADD_WIDTH - 1 downto 0);
		add_wr      		: in STD_LOGIC_VECTOR  (ADD_WIDTH - 1 downto 0);
		data_out    		: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
	);
	end component;

	component top_pilotsGenerator_wifi is
	port 
	(
		clk      		: in STD_LOGIC;
		reset    		: in STD_LOGIC;
		enable   		: in STD_LOGIC;
		valid_out		: out STD_LOGIC;
		data_out 		: out STD_LOGIC_VECTOR ((SAMPLE_WIDTH - 1) downto 0)
	);
	end component;

	begin
		enable      				<= enable_sig OR enable_sig_2;
		sample_real 				<= xk_re;
		sample_im   				<= xk_im;
		valid_out   				<= dv;
		preample_st 				<= preample_st_sig;
		rama_we     				<= valid_in AND (NOT mem_switch_write) AND mema_empty;
		ramb_We     				<= valid_in AND mem_switch_write AND memb_empty;
		ce          				<= '1';

		U1: IFFT port map (clk_div,ce,start,cp_len_we,fwd_inv,fwd_inv_we,scale_sch_we,rfd,busy,edone,done,dv,cpv,rfs,cp_len,xn_re,xn_im,scale_sch,xn_index,xk_index,xk_re,xk_im);

		U2: ram_model port map (clk,rama_in_real,rama_we,reada_add,writea_add,rama_out_real);

		U3: ram_model port map (clk,rama_in_imag,rama_we,reada_add,writea_add,rama_out_imag);

		U4: ram_model port map (clk,ramb_in_real,ramb_we,readb_add,writeb_add,ramb_out_real);

		U5: ram_model port map (clk,ramb_in_imag,ramb_we,readb_add,writeb_add,ramb_out_imag);

		U6: top_pilotsGenerator_wifi port map (clk_div,reset,pilot_enable,valid_out_pilot,pilot_out);

		-- Last Symbol and IFFT turn off
		LAST_SYMBOL_PROCESS : process (clk_div,reset)
		begin
			if(reset = '0') 
			then
				last_symbol_flag 	<= '0';
			elsif(clk_div'event and clk_div = '1') 
			then
				if(last_symbol = '1') 
					then
					last_symbol_flag<= '1';
				end if;
			end if;
		end process;

		-- Preample Start 
		PREAMPLE_START : process (clk_div,reset)
		begin
			if(reset = '0') 
			then
				preample_st_sig 	<= '0';
				preample_st_tmp 	<= '0';
			elsif (clk_div'event and clk_div = '1') 
			then
				if(first_valid_in = '1') 
				then
					preample_st_sig <= '1';
				end if;
				if(preample_st_sig = '1') 
				then
					preample_st_tmp <= '1';
				end if;
				if(preample_st_tmp = '1') 
				then
					preample_st_sig <= '0';
				end if;
			end if;
		end process;

		-- Special Address Flag process
		SPECIAL_ADDRESS_PROCESS : process (xn_index)
		begin
			if    (xn_index = pilot_add_1) OR (xn_index = pilot_add_2) OR (xn_index = pilot_add_3) OR (xn_index = pilot_add_4) 
			then
				xn_special_index 	<= '1';
				xn_pilot 		<= '1';
				xn_null  		<= '0';
			elsif xn_index = zero_add OR ((unsigned(xn_index) >= unsigned(nulls_start)) AND (unsigned(xn_index) <= unsigned(nulls_end))) 
			then
				xn_special_index 	<= '1';
				xn_pilot 		<= '0';
				xn_null  		<= '1';
			else
				xn_special_index 	<= '0';
				xn_pilot 		<= '0';
				xn_null  		<= '0';
			end if;
		end process;

		-- Pilot generator enable
		PILOT_GENERATOR_ENABLE : process (xn_index)
		begin
			if    (unsigned(xn_index) = (unsigned(pilot_add_1) - 1)) OR (unsigned(xn_index) = (unsigned(pilot_add_2) - 1)) OR (unsigned(xn_index) = (unsigned(pilot_add_3) - 1)) OR (unsigned(xn_index) = (unsigned(pilot_add_4) - 1)) 
			then
				pilot_enable 		<= '1';
			else
				pilot_enable 		<= '0';
			end if;
		end process;	

		-- IFFT Input process
		IFFT_INPUT_PROCESS : process (xn_special_index,xn_pilot,xn_null,rama_out_real,rama_out_imag,ramb_out_real,ramb_out_imag,mem_switch_read,pilot_out)
		begin
			if (xn_special_index = '1') and (xn_pilot = '1')
			then
				xn_re 			<= pilot_out;
				xn_im 			<= (others => '0');
			elsif (xn_special_index = '1') and (xn_null = '1') 
			then
				xn_re 			<= (others => '0');
				xn_im 			<= (others => '0');
			elsif(mem_switch_read = '0')
			then
				xn_re 			<= rama_out_real;
				xn_im 			<= rama_out_imag;
			elsif (mem_switch_read = '1') 
			then
				xn_re 			<= ramb_out_real;
				xn_im	 		<= ramb_out_imag;
			end if;
		end process;

		-- RAM Input Control
		RAM_INPUT_PROCESS : process (sym_re,sym_im,mem_switch_write)
		begin
			if(mem_switch_write = '0') 
			then
				rama_in_real 		<= sym_re;
				rama_in_imag 		<= sym_im;
				ramb_in_real 		<= (others => '0');
				ramb_in_imag 		<= (others => '0');
			else
				ramb_in_real 		<= sym_re;
				ramb_in_imag 		<= sym_im;
				rama_in_real 		<= (others => '0');
				rama_in_imag 		<= (others => '0');
			end if; 
		end process;

		-- Enable Signal Control
		ENABLE_SIGNAL_PROCESS : process (clk,reset)
		begin
			if (reset = '0') 
			then
				enable_counter 		<= std_logic_vector(to_unsigned(94,7)); -- 92 not 95 because there are three delayed clocks in which I receive input and the enable sig 2 is not zero yet
				enable_sig 		<= '1';
			elsif (clk'event AND clk = '1') 
			then
				if(enable_sig = '1' and enable_sig_2 = '0' and valid_in = '1') 
				then
					enable_counter 	<= std_logic_vector(unsigned(enable_counter) - to_unsigned(1,7));
				if(enable_counter = std_logic_vector(to_unsigned(0,7))) 
				then
					enable_sig 	<= '0';
				end if;
				elsif ((mema_empty = '1' AND mema_empty_temp = '0') OR (memb_empty = '1' AND memb_empty_temp = '0')) 
				then
					enable_counter 	<= std_logic_vector(to_unsigned(46,7));
					enable_sig 	<= '1';
				end if;
			end if;
		end process;

		-- Memory Fill process
		MEMORY_WRITE_PROCESS : process (reset,clk)
		begin
			if (reset = '0') then
				writea_add 		<= (others => '0');
				writeb_add 		<= (others => '0');
				mem_switch_write 	<= '0'; -- Zero for memory A, One for memory B
				mema_empty 		<= '1';
				memb_empty 		<= '1';
				mema_empty_temp 	<= '1';
				memb_empty_temp 	<= '1';
				mema_empty_early 	<= '1';
				memb_empty_early 	<= '1';
				first_valid_in 		<= '0';
				enable_sig_2    	<= '1';
			elsif (clk'event AND clk = '1') 
			then
				-- First Valid in to enable Preample
				if(valid_in = '1') 
				then
					first_valid_in 	<= '1';
				end if;
				-- Start Enable Timer when the mapper starts reading symbols from the FIFO
				if mapper_ready = '1' 
				then
					enable_sig_2 	<= '0';
				end if;
				-- Early Empty Signal for Memory A
				if(unsigned(writea_add) = 48 AND mem_switch_write = '0') 
				then
					mema_empty_early<= '0';
				end if;
				if(unsigned(reada_add)  = 63 AND mem_switch_read  =  '0') 
				then
					mema_empty_early<= '1';
				end if;
				-- Empty Signal for Memory A
				if(unsigned(writea_add) = 48 AND mem_switch_write = '0') 
				then
					mema_empty 	<= '0';
					mem_switch_write<= '1';
				elsif(unsigned(reada_add)  = 0 AND mem_switch_read  =  '0') 
				then
					mema_empty 	<= '1';
					mem_switch_write<= '0';
				end if;

				-- Early Empty Signal for Memory B
				if(unsigned(writeb_add) = 48 AND mem_switch_write = '1') 
				then
					memb_empty_early<= '0';
				end if;
				if(unsigned(readb_add)  = 63 AND mem_switch_read  =  '1') 
				then
					memb_empty_early<= '1';
				end if;
				-- Empty Signal for Memory B
				if(unsigned(writeb_add) = 48 AND mem_switch_write = '1') 
				then
					memb_empty 	<= '0';
				elsif(unsigned(readb_add)  = 0 AND mem_switch_read  = '1') 
				then
					memb_empty 	<= '1';
				end if;

				-- Write in Memory A
				if (mema_empty = '1') AND (mem_switch_write = '0') and (valid_in = '1') 
				then
					writea_add 	<= std_logic_vector(unsigned(writea_add) + to_unsigned(1,ADD_SIZE));
				elsif (mema_empty_early = '0' and mem_switch_write = '0') 
				then
					writea_add 	<= (others => '0');
				end if;

				-- Write in Memory B
				if (memb_empty = '1') AND (mem_switch_write = '1') and (valid_in = '1') 
				then
					writeb_add 	<= std_logic_vector(unsigned(writeb_add) + to_unsigned(1,ADD_SIZE));
				elsif (memb_empty_early = '0' and mem_switch_write = '1') 
				then
					writeb_add 	<= (others => '0');
				end if;

				mema_empty_temp 	<= mema_empty;
				memb_empty_temp 	<= memb_empty;
			end if;  
		end process;

		-- Memory read process
		MEMORY_READ_PROCESS : process(clk_div,reset)
		begin
			if (reset = '0') 
			then
				start 			<= '0';
				fwd_inv_we 		<= '1';
				cp_len_we 		<= '1';
				reada_add 		<= std_logic_vector(to_unsigned(RAM_SIZE,ADD_SIZE) - 1);
				readb_add 		<= std_logic_vector(to_unsigned(RAM_SIZE,ADD_SIZE) - 1);
				mem_switch_read 	<= '0';
				lock_start_zero 	<= '0';
				turn_off_ifft   	<= '0';
			elsif (clk_div'event AND clk_div = '1') 
			then
				-- START IFFT if first valid in is triggered
				if first_valid_in = '1' AND ifft_start = '1' and lock_start_zero = '0' 
				then
					fwd_inv_we 	<= '0';
					cp_len_we 	<= '0';
					start 		<= '1';
				end if;
				-- Shut down IFFT if last symbol is triggered
				if last_symbol_flag = '1' AND unsigned(xn_index) = 63 
				then
					turn_off_ifft 	<= '1';
				end if;
				if turn_off_ifft = '1' AND unsigned(xn_index) = 63 
				then
					start 		<= '0';
					lock_start_zero <= '1';
				end if;
				if start = '1' and rfd = '1' and xn_special_index = '0' and mem_switch_read = '0' 
				then
					reada_add 	<= std_logic_vector(unsigned(reada_add) - to_unsigned(1,ADD_SIZE));
				elsif (unsigned(reada_add) = 63) and (mem_switch_read = '0') 
				then
					reada_add 	<= std_logic_vector(to_unsigned(RAM_SIZE,ADD_SIZE) - 1);
					mem_switch_read <= '1';
				end if;
				if start = '1' and rfd = '1' and xn_special_index = '0' and mem_switch_read = '1' 
				then
					readb_add 	<= std_logic_vector(unsigned(readb_add) - to_unsigned(1,ADD_SIZE));
				elsif (unsigned(readb_add) = 63) and (mem_switch_read = '1') 
				then
					readb_add 	<= std_logic_vector(to_unsigned(RAM_SIZE,ADD_SIZE) - 1);
					mem_switch_read <= '0';
				end if;
			end if;
		end process;
end CONTROLLER;
