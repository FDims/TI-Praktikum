library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sortierer is
	generic (
		CNT_OFL : positive := 24999999; -- Sekundentakt ofl
		TIME_WEG_K : positive := 10 ; -- Kunststoff-Werkstück, langer Weg
		TIME_WEG_M : positive := 10 ; -- Metall-Werkstück, kurzer Weg
		FWD : std_logic := '0';
		BCK : std_logic := '1';
		RUN : std_logic := '1';
		STP : std_logic := '0';
		WEG_K : std_logic := '0';
		WEG_M : std_logic := '1'
		);

	port (
		reset : in std_logic; -- Key0
		clk   	: in std_logic; --50 MHz
		oe_in 	: in std_logic; -- Switch 9
		opt_sens	: in std_logic; -- optischer Sensor
		ind_sens	: in std_logic; -- induktiv Sensor
		oe_n_out	: out std_logic;
		weiche_out	: out std_logic; -- Weg A / Weg B -Umschaltung  
		motor_pwr_out : out std_logic; -- ...
		motor_dir_out : out std_logic -- Motor Drehrichtung
		);
end entity sortierer;

architecture arch of sortierer is

-- signals
signal cnt : unsigned(24 downto 0);
signal time_s : unsigned(4 downto 0); 
signal weiche : std_logic;
signal motor_pwr : std_logic;
signal motor_dir : std_logic;

type main_state_t is (idle, state1, state2, state3);
signal main_state, next_main_state : main_state_t;

begin

sort_control : process(clk, reset) is
begin	
	if (reset = '1') then
	cnt<=(others=>'0');
	time_s<=(others=>'0');
	motor_pwr<=STP;
	next_main_state<=idle;



	elsif rising_edge(clk) then
		main_state <= next_main_state; -- z_reg
				
		-- fast counter, overflow = 1s 
		if cnt = to_unsigned(CNT_OFL, cnt'length) or main_state = idle then
			cnt <= (others => '0');
		else
			cnt <= cnt + 1;			
		end if;

		-- Sekunden timer		
		if main_state = idle then -- reset timer
			time_s <= (others => '0');	
		elsif cnt = CNT_OFL then
			time_s <= time_s + 1;
		end if;

		
		case main_state is
		
			when idle => -- warte auf opt_sens hi
				if(opt_sens='1') then
				motor_pwr<=RUN;
				motor_dir<=FWD;
				next_main_state<=state1;
				elsif(opt_sens='0')then
				next_main_state <= idle;
				end if;

			when state1 =>
				if(ind_sens='1')then
				weiche<=WEG_M;
				next_main_state<=state3;
				elsif(ind_sens='0')then
				weiche<=WEG_K;
				next_main_state<=state2;
				else
				next_main_state<=state1;
				end if;

			when state2 =>
				if(time_s = TIME_WEG_K)then
				motor_pwr<=STP;
				next_main_state<=idle;
				elsif(time_s<TIME_WEG_M)then
				next_main_state<=state2;
				end if;
	
			when state3 =>
				if(time_s = TIME_WEG_M)then
				motor_pwr<=STP;
				next_main_state<=idle;
				elsif(time_s<TIME_WEG_M)then
				next_main_state<=state3;
				end if;
		
		end case;
	end if;
	oe_n_out <= not oe_in; -- voltage translator active
	weiche_out <= weiche;
	motor_pwr_out <= motor_pwr;
   motor_dir_out <= motor_dir; 
		
end process sort_control;

end architecture arch;