library IEEE;
use IEEE.std_logic_1164.all;

--2개의 N bits INPUT 중 하나를 출력하는 블록이다-- 
entity MUX2to1_Nbits is
	generic( N : integer );
	port( sel : in std_logic;
			Data_in1, Data_in2 : in std_logic_vector(N-1 downto 0);
			Data_out : out std_logic_vector (N-1 downto 0));
end MUX2to1_Nbits;

architecture sel of MUX2to1_Nbits is
begin
process(sel, Data_in1, Data_in2)
begin
	if(sel = '0')	then
		Data_out <= Data_in1;		-- sel이 '0'이면 Data_in1 출력 
	else
		Data_out <= Data_in2;		-- sel이 '1'이면 Data_in2 출력 
	end if;
end process;
end sel;
	