library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.dWatch_components.all;		-- Top Entity를 설계하기 위한 component들이 들어있는 library이다.
entity DigitalW is
port(
	 Key1, Key2, Key3, Key4: in std_logic;			
	 Mclk: in std_logic;		
	 buzzon : out std_logic;
	 visible_Out5, visible_Out4, visible_Out3, visible_Out2, visible_Out1, visible_Out0: out std_logic_vector (6 downto 0)
	 );
end DigitalW;
------------------------선 연결 하는 부분은 diagram 참고----------------------------------------------
architecture rtl of DigitalW is
signal Clk_1sec, Clk_10ms, Clk_50ms : std_logic;
signal DeKey1, DeKey2, DeKey3, Dekey4 : std_logic;
signal Mde : std_logic_vector (1 downto 0) := (others => '0') ;
signal WatchEn, WatchSetEn, AlarmSetEn, StopWatchEn : std_logic;
signal Watch_HMS, Set_HMS, Alarm_HMS, StopW_MSmS : std_logic_vector (23 downto 0) := (others => '0');
signal SetWatch_HM, SetAlarm_HM : std_logic_vector (15 downto 0) := (others => '0');
signal Display_HMS : std_logic_vector (23 downto 0);
signal WEn : std_logic;
signal Blinkout5,Blinkout4,Blinkout3,Blinkout2,Blinkout1,Blinkout0 : std_logic_vector (6 downto 0);
--------------------------------------------------------------------------------------------------

begin
--Pulse--
pulse : Clk_gen generic map (1000) port map (Mclk, Clk_1sec, Clk_10ms, Clk_50ms);	--1000 Hz input 
--DeBounce--
DeB : DeBounce port map(Key1, Key2, Key3, Key4, Clk_10ms, DeKey1, DeKey2, DeKey3, DeKey4);
--Mode--
Md : Nbits_Mode generic map (2) port map(DeKey1,Mde);
--selEn--
selEn : decoder2to4 port map(Mde, WatchEn, WatchSetEn, AlarmSetEn, StopWatchEn);
--Comparator--
comp : Comparator generic map (16) port map(Watch_HMS (23 downto 8), SetAlarm_HM, BuzzOn);
--Watch--
WEn <= WatchSetEn or WatchEn;
WCH : Watch port map( WEn, SetWatch_HM, Clk_1Sec, DeKey4, Watch_HMS);
--WatchSet--
WCH_Set : Set_Time port map( Clk_50ms, WatchSetEn, DeKey2, Dekey3, DeKey4, Set_HMS (23 downto 8), SetWatch_HM);
--AlarmSet--
ALM_Set : Set_Time port map( Clk_50ms, AlarmSetEn, DeKey2, Dekey3, DeKey4, Alarm_HMS (23 downto 8), SetAlarm_HM);
--StopWatch--
SWCH : stop_Watch port map(StopWatchEn, DeKey2, Dekey3, clk_10ms, StopW_MSmS);
--MUX Block--
MUX : MUX_4to1_24bit port map(Watch_HMS, Set_HMS, Alarm_HMS, StopW_MSmS, Mde, Display_HMS);
--Decoder Block--
Decoder : Decoder_Block port map(Display_HMS,Blinkout5,Blinkout4,Blinkout3,Blinkout2,Blinkout1,Blinkout0);
--Blink MUX--(Hign 일때 안보이게)
Blink5 : MUX2to1_Nbits generic map (7) port map (clk_1sec, Blinkout5, "1111111", visible_Out5);
Blink4 : MUX2to1_Nbits generic map (7) port map (clk_1sec, Blinkout4, "1111111", visible_Out4);
Blink3 : MUX2to1_Nbits generic map (7) port map (clk_1sec, Blinkout3, "1111111", visible_Out3);
Blink2 : MUX2to1_Nbits generic map (7) port map (clk_1sec, Blinkout2, "1111111", visible_Out2);
Blink1 : MUX2to1_Nbits generic map (7) port map (clk_1sec, Blinkout1, "1111111", visible_Out1);
Blink0 : MUX2to1_Nbits generic map (7) port map (clk_1sec, Blinkout0, "1111111", visible_Out0);
end rtl;