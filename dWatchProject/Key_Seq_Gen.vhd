library IEEE;
use IEEE.std_logic_1164.all;

entity Key_Seq_Gen is
port(
	clk 	: in std_logic;	-- T=50ms
	KeyIn : in std_logic;	--	DeKey3
	KeyPulse	: out std_logic	--Inc_Pulse
	);
end Key_Seq_Gen;

architecture set of Key_Seq_Gen is
begin
process(clk)
	variable time_cnt : integer := 0;	-- clk이 몇번 반복 횟수에 따라 시간을 측정함
	variable b_clk : std_logic := '0';	-- KeyPulse에 들어갈 변수
begin
	if ( rising_edge(clk) )	then
		if(KeyIn='1') then
			if( time_cnt=0 )then				-- 처음 클락이 들어오면 클락을 발생 시킨다
				b_clk:='1';
				time_cnt := time_cnt+1;
			elsif(b_clk = '1') then			--	클락을 반복하기 위해 1인경우 0으로 바꿔준다
				b_clk := '0';
				time_cnt := time_cnt+1;
			elsif(b_clk = '0' and time_cnt >= 10)	then	-- 일정 시간 버튼을 누르고 있는 경우로 계속 펄스가 발생한다
				b_clk := '1';
			else
				time_cnt := time_cnt + 1;	-- 첫 클릭에서 꾹누르고 있는 시간동안의 동작으로 시간만 증가시킨다
			end if;
		else										-- 버튼을 누르지 않으면 0으로 초기화 시킨다.
			b_clk := '0';
			time_cnt := 0;
		end if;
	end if;
	KeyPulse<=b_clk;
end process;


end set;		
	
	