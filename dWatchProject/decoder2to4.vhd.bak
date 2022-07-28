library IEEE;
use IEEE.std_logic_1164.all;

entity decoder2to4 is
port(
	d_in : in std_logic_vector (1 downto 0);
	out0, out1, out2, out3 : out std_logic
);	
end decoder2to4;

architecture decode of decoder2to4 is
begin
	out0 <= (not d_in(1)) and (not d_in(0));
	out1 <= (not d_in(1)) and  d_in(0);
	out2 <=  d_in(1) and (not d_in(0));
	out3 <=  d_in(1) and  d_in(0);	
end decode;