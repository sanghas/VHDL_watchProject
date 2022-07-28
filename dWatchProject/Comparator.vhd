library IEEE;
use IEEE.std_logic_1164.all;
--2개의 데이터를 입력받아 같은지 비교하는 블록이다 시계 설계에선 시 분을 비교할 것이다,
entity Comparator is
	generic( bits : integer);
	port(
		In1, In2 : in std_logic_vector (bits-1 downto 0);
		comp : out std_logic
		);
end Comparator;

--같으면 '1'출력되고 다르면 '0'출력된다.
architecture comparison of Comparator is
begin
process(In1, In2)
variable com : std_logic;
begin
	if(In1= In2) then
		com := '1';
	else
		com := '0';
	end if;
	comp <= com;
end process;
end comparison;