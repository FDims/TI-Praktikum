library ieee;
use ieee.std_logic_1164.all;


entity test is
	port(
		a,b  : in std_logic;
		c	  : out std_logic
	);
 
end test;

architecture arch of test is
	begin
		
		c <= a and b;
		
end arch ;