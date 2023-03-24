library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stoppuhr is 

	port (
		reset_n     : in std_logic; -- Key 0
      clk         : in std_logic; --50 MHz
		cnt_enable	: in std_logic; -- SW 0: Start / Stop
		
		led_hex_a	: out std_logic_vector(6 downto 0); -- s-:--
		led_hex_b	: out std_logic_vector(6 downto 0); -- -s:--
		led_hex_c	: out std_logic_vector(6 downto 0); -- --:ms-
		led_hex_d	: out std_logic_vector(6 downto 0)	-- --:-ms
		
		);
end entity stoppuhr;

architecture arch of stoppuhr is
signal hexa : std_logic_vector (3 downto 0):="0000";
signal hexb : std_logic_vector (3 downto 0):="0000";
signal hexc : std_logic_vector (3 downto 0):="0000";
signal hexd : std_logic_vector (3 downto 0):="0000";
signal seva : std_logic_vector (6 downto 0);
signal sevb : std_logic_vector (6 downto 0);
signal sevc : std_logic_vector (6 downto 0);
signal sevd : std_logic_vector (6 downto 0);
signal cnt: integer range 0 to 2499999 ;


begin

	i_hex7_a : entity work.	hex_to_seven(arch) port map(
		hex=>hexa,
		seven_segment=>seva
	
		);
	i_hex7_b : entity work.	hex_to_seven(arch) port map(
		hex=>hexb,
		seven_segment=>sevb
	
		);
	i_hex7_c : entity work.	hex_to_seven(arch) port map(
		hex=>hexc,
		seven_segment=>sevc
	
		);
	i_hex7_d : entity work.	hex_to_seven(arch) port map(
		hex=>hexd,
		seven_segment=>sevd
	
		);
		p : process (clk, reset_n, cnt_enable)
		begin
		if (reset_n = '1') then
			i_hex7_a<=(others=>'0');
			i_hex7_b<=(others=>'0');
			i_hex7_c<=(others=>'0');
			i_hex7_d<=(others=>'0');
		elsif (clk 'event and clk = '1') then
			cnt<=cnt+1;
			if(cnt=2499999) then
			cnt <= 0;
				if(cnt_enable ='1') then
				hexa <= hexa + x"0001";
					if(hexa="1010") then
					hexa<="0000";
					hexb<=hexb+x"0001";
					end if;
					if(hexb="1010") then
					hexb<="0000";
					hexc<=hexc+x"0001";
					end if;
					if(hexc="1010") then
					hexc<="0000";
					hexd<=hexd+x"0001";
					end if;
					if(hexd="1010") then
					hexd<="0000";
					end if;
				end if;
			end if;
		end if;
		end process p;

		led_hex_a <= seva;
		led_hex_b <= sevb;
		led_hex_c <= sevc;
		led_hex_d <= sevd;

end architecture arch;
	
	
	
	
	
	
	
	