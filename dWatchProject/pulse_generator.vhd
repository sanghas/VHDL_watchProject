library IEEE;
use IEEE.std_logic_1164.all;
-- Pulse generator로 원하는 주기의 아웃풋을 생성할 수 있음
-- 단순한 알고리즘을 사용하여 input Hz가 2*output Hz 의 정수배가 되야함
entity pulse_generator is
	generic ( inHz, outHz : integer );
	port( in_clk : in std_logic;
			out_clk : out std_logic);
end pulse_generator;

architecture cntpulse of pulse_generator is
begin
process(in_clk)
variable cnt : integer := 0;				-- clk이 몇번 돌았는지 확인하기 위한 변수이다
variable pul : std_logic := '0';			-- output pulse에 들어갈 변수이다
begin
	if(rising_edge(in_clk)) then			
		cnt := cnt+1;
		if(cnt mod (inHz/(2*outHz)) = 0)	then	-- out과 in의 관계식으로 원하는 out pluse를 뽑아낸다
			pul := not pul;
		end if;
		out_clk <= pul;
	end if;
end process;
end cntpulse;
