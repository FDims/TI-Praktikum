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
signal hexa : std_logic_vector(3 downto 0);
signal sev_segment: std_logic_vector (6 downto 0);
signal cnt: integer := 0;


begin
	
	i_hex7_a : entity work.	hex_to_seven(arch) port map(
		hex : in std_logic_vector(3 downto 0);
		seven_segment : out std_logic_vector (6 downto 0);
		
		);
	i_hex7_b : entity work.	hex_to_seven(arch) port map(
		hex : in std_logic_vector(3 downto 0);
		seven_segment : out std_logic_vector (6 downto 0);
		
		);
	i_hex7_c : entity work.	hex_to_seven(arch) port map(
		hex : in std_logic_vector(3 downto 0);
		seven_segment : out std_logic_vector (6 downto 0);
		
		);
	i_hex7_d : entity work.	hex_to_seven(arch) port map(
		hex : in std_logic_vector(3 downto 0);
		seven_segment : out std_logic_vector (6 downto 0);
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
				i_hex7_a <= i_hex7_a + x"0001";
					if(i_hex7_a="1010") then
					i_hex7_a<="0000";
					i_hex7_b<=i_hex7_b+x"0001";
					end if;
					if(i_hex7_b="1010") then
					i_hex7_b<="0000";
					i_hex7_c<=i_hex7_c+x"0001";
					end if;
					if(i_hex7_c="1010") then
					i_hex7_c<="0000";
					i_hex7_d<=i_hex7_d+x"0001";
					end if;
					if(i_hex7_d="1010") then
					i_hex7_d<="0000";
					end if;
				end if;
			end if;
		end if;
		end process p;



end architecture arch;
	
	
	
	
	
	
	
	