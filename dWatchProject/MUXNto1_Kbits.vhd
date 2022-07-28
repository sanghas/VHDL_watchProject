library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MUXNto1_Kbits is
	generic( N,K : integer );		-- N 은 2의 지수승 max : 16
	port( sel : in std_logic_vector ( 3 downto 0 );
			Data_in : in std_logic_vector((K-1)*(N-1) downto 0);
			Data_out : out std_logic_vector (K-1 downto 0));
end MUXNto1_Kbits;

architecture sel of MUXNto1_Kbits is
begin
process(sel, Data_in)
variable insel : integer ;
begin
	insel:= conv_integer(sel);
	Data_out <= Data_in((K*(insel+1)-1) downto K*insel);
end process;
end sel;
	