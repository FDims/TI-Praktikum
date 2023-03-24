library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity taktteiler is 


	port (
      clk         : in std_logic; --50 MHz
		clk_10Hz		: out std_logic			
		
		);
end entity taktteiler;

architecture arch of taktteiler is

signal x : integer range 0 to 2499999 :=0;
signal tmp : std_logic := '0';


begin

ttp : process (clk)
		begin
			if (clk 'event and clk='1') then
				if(x=2499999)then
				tmp <=not tmp;
				x<=0;
				else
				x <= x+1;
				end if;
			end if;
			clk_10Hz<=tmp;
end process ttp;




end architecture arch;
	
	
	
	
	
	
	
	