library IEEE;
use IEEE.std_logic_1164.all;
-- 버튼을 눌렀을 때 발생하는 접촉에러를 무시하기 위한 것으로 10ms단위로 키가 눌러졌는지 아닌지 판별
entity DeBounce is
port(
	In1,In2,In3,In4 : in std_logic;	--	Key1,2,3
	clk	:	in std_logic;			--	T = 10ms
	Out1,Out2,Out3,Out4 : out std_logic	--	DeKey1,2,3
	);
end DeBounce;

architecture DFF of DeBounce is
begin

process(clk)
begin
	if(rising_edge(clk)) then
		Out1 <= In1;	Out2 <= In2;	Out3 <= In3; Out4 <= In4;
	end if;
end process;

end DFF;