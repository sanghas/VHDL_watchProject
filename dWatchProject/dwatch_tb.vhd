library IEEE;
use IEEE.std_logic_1164.all;

entity dWatch_tb is
end dWatch_tb;

architecture tb of dWatch_tb is

component DigitalW is
port(
	 Key1, Key2, Key3, Key4: in std_logic;			
	 Mclk: in std_logic;		-- 1000 Hz
	 visible_Out5, visible_Out4, visible_Out3, visible_Out2, visible_Out1, visible_Out0: out std_logic_vector (6 downto 0)
	 );
end component;

signal Key1_in, Key2_in, Key3_in, Key4_in : std_logic := '0' ;
signal Mclk_in : std_logic;
signal visible_Out5_out, visible_Out4_out, visible_Out3_out, visible_Out2_out, visible_Out1_out, visible_Out0_out : std_logic_vector(6 downto 0);

begin
DUT : DigitalW port map (Key1_in, Key2_in, Key3_in, Key4_in, Mclk_in,visible_Out5_out, visible_Out4_out, visible_Out3_out, visible_Out2_out, visible_Out1_out, visible_Out0_out);
Mclk : process begin	-- 1000Hz Input
	Mclk_in <= '1';
	wait for 0.5 ms;
	Mclk_in <= '0';
	wait for 0.5 ms;
end process Mclk;

Key : process begin
	--Watch--
	wait for 3 sec;													--Watch Time 은 계속 증가 중
	-- Watch_set Mode변경에 따른 display변화와 버튼 클릭에 따른 설정값 변경, 데이터 저장 및 로드를 보여줌 --
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		--	mode change ( Watch -> WatchSet )
	wait for 1.8 sec;
	key3_in <= '1'; wait for 2.16 sec; key3_in <= '0';		-- DeKey 3 -> time setting( Key pulse generator )
	wait for 1.153 sec;
	key2_in <= '1'; wait for 138 ms; key2_in <= '0';		-- HM change ( M -> H )
	wait for 1.548 sec;
	key3_in <= '1'; wait for 1.32 sec; key3_in <= '0';			-- DeKey 3 -> time setting( Key pulse generator )
	wait for 1.154 sec;
	key4_in <= '1'; wait for 300 ms; key4_in <= '0';		-- Set Time ( (riging Dekey4) Set Time Register <- Set time  &&  (falling Dekey4) Watch <- Set Time Register )
	wait for 1.684 sec;
	key3_in <= '1'; wait for 1.2 sec; key3_in <= '0';			-- DeKey 3 -> time setting( Key pulse generator )
	wait for 1.154 sec;
	----------------------------------------------------------------------------------------
	----------- Alarm_Set 위와 동일----------------
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		--	mode change ( WatchSet -> AlarmSet )
	wait for 1.8 sec;
	key3_in <= '1'; wait for 2.16 sec; key3_in <= '0';		-- DeKey 3 -> time setting( Key pulse generator )
	wait for 1.153 sec;
	key2_in <= '1'; wait for 138 ms; key2_in <= '0';		-- HM change ( M -> H )
	wait for 1.548 sec;
	key3_in <= '1'; wait for 1.32 sec; key3_in <= '0';			-- DeKey 3 -> time setting( Key pulse generator )
	wait for 1.154 sec;
	key4_in <= '1'; wait for 300 ms; key4_in <= '0';		-- Set Time ( (riging Dekey4) Set Time Register <- time )
	wait for 1.684 sec;
	key3_in <= '1'; wait for 1.2 sec; key3_in <= '0';			-- DeKey 3 -> time setting( Key pulse generator )
	wait for 1.154 sec;
	------StopWatch on만 시켜놓고 모드 변경-----
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		-- mode change ( AlarmSet -> StopWatch )
	wait for 1.28 sec;
	key2_in <= '1'; wait for 145 ms; Key2_in <= '0';		-- run
	wait for 1.648 sec;
	---------------------------------------
	------Watch Watch상태에서 load를 누른 경우도 load가 됨, 다른 버튼을 누른 경우 스탑워치에 영향이 가지 않음--
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		-- mode change ( StopWatch -> Watch )
	wait for 0.681 sec;
	key4_in <= '1'; wait for 300 ms; key4_in <= '0';		--	Set Time ( (falling Dekey4) Watch <- Set Time Register ) && Buzz on 1 minute
	wait for 0.485 sec;
	key2_in <= '1'; wait for 145 ms; Key2_in <= '0';		-- StopWatch 변화 없음 
	wait for 1.87 sec;
	-------------------------------------------------------------------------------------------
	--WatchSet--
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		-- mode change ( Watch -> WatchSet ) && Set time display 출력
	wait for 1.11 sec;
	--AlarmSet--
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		-- mode change ( WatchSet -> AlarmSet) && Set time display 출력
	wait for 0.15 sec;
	--Stop_Watch 작동하는 상태에서 clr를 누르는 경우 초기화가 되고 버튼을 때면 다시 동작을 이어 나감 , stop버튼과 clr버튼 동작 확인--
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		-- mode change ( AlarmSet -> StopWatch )
	wait for 1.684 sec;
	key3_in <= '1'; wait for 145 ms; Key3_in <= '0';		-- (rising clr) Initialization 
	wait for 10.489 sec;
	key2_in <= '1'; wait for 145 ms; Key2_in <= '0';		-- stop
	wait for 1.684 sec;
	key3_in <= '1'; wait for 145 ms; Key3_in <= '0';		-- (rising clr) Initialization 
	wait for 1 sec;
	------------------------------------------------------------------------------------------------------------
	---------   23:59 -> 24:00  을 관측하기 위해 시간을 23:59으로 맞춰주는 작업 ----------------
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		-- mode change ( StopWatch -> Watch )
	wait for 1.684 sec;
	key1_in <= '1'; wait for 145 ms; Key1_in <= '0';		-- mode change ( Watch -> WatchSet )
	wait for 1.684 sec;
	key3_in <= '1'; wait for 4.5 sec; key3_in <= '0';		-- DeKey 3 -> time setting( Key pulse generator )
	wait for 1.153 sec;
	key2_in <= '1'; wait for 138 ms; key2_in <= '0';		-- HM change ( M -> H )
	wait for 1.548 sec;
	key3_in <= '1'; wait for 1.81 sec; key3_in <= '0';		-- DeKey 3 -> time setting( Key pulse generator )
	wait for 1.153 sec;
	key4_in <= '1'; wait for 300 ms; key4_in <= '0';		-- Set Time ( (riging Dekey4) Set Time Register <- time )
	wait;
	-----------------------------------------------------------------------------------
end process Key;
	
end tb;