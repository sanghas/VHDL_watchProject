library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Set_Time is
port(
	clk : in std_logic;		--T = 50ms
	en : in std_logic; 		--WatchSetEn or AlarmSetEn	, Dekey 1
	Toggle_HM : in std_logic; --rising_edge toggle  , Dekey 2
	Ts_Inc : in std_logic;	-- Dekey3
	set_Time : in std_logic; 	--Dekey 4
	OUT_HM : out std_logic_vector (15 downto 0);		-- 현재 내가 설정하고 있는 시간으로 눈에 보이는 값이다. 초기값은 항상 레지스터에 저장된 값으로 한다
	OUT_Set_HM : out std_logic_vector (15 downto 0) -- 레지스터에 저장된 시간으로 Watch와 연결된다
	);
end Set_Time;

architecture set of Set_Time is

	component Key_Seq_Gen is
	port(
		clk 	: in std_logic;	-- T=50ms
		KeyIn : in std_logic;	--	DeKey3
		KeyPulse	: out std_logic	--Inc_Pulse
		);
	end component;
	component Nbits_Mode is
	generic( N : integer );
	port(
		clk : in std_logic;	
		M : out std_logic_vector (N-1 downto 0)	
		);
	end component;
	
	component MUX2to1_Nbits is
	generic( N : integer );
	port( sel : in std_logic;
			Data_in1, Data_in2 : in std_logic_vector(N-1 downto 0);
			Data_out : out std_logic_vector (N-1 downto 0));
	end component;
	
	signal HM_sel : std_logic_vector (0 downto 0);								-- Min Hour 선택
	signal HM : std_logic_vector (15 downto 0) := (others => '0');			-- real time
	signal SHM : std_logic_vector (15 downto 0) := (others => '0');		-- set time
	signal en_set_Time : std_logic;													-- 시간을 저장하는데 쓰이는 signal
	signal En_Toggle_HM : std_logic;													-- en과 Toggle_HM 을 And 연산 함
	signal INC_Pulse :	std_logic ;													-- Inc pulse로 시간을 증가시키는 펄스
	signal in_en, in_Toggle_HM ,Toggle_Key: std_logic_vector (0 downto 0);-- component 와 data type을 맞추기 위한 signal
	
begin
-----------------Key Seq Gen---------------------
KSG : Key_Seq_Gen port map(Clk, Ts_Inc, INC_Pulse);
-------------------------------------------------
in_en(0) <= en; in_Toggle_HM(0) <= Toggle_HM;
En_Toggle_HM <=  (HM_sel(0) and en);
Toggle : MUX2to1_Nbits generic map (1) port map (En_Toggle_HM, in_en, in_Toggle_HM, Toggle_Key);	-- Tog_HM에 따라서 Toggle_Key 설정 -> HM_sel 의 초기값을 항상 '1'로 맞추기 위한 장치
selHM : Nbits_Mode generic map (1) port map(Toggle_Key(0), HM_sel);		-- HM_sel 이 '1' 이면 Min 설정, '0'이면 Hour 설정 

OUT_Set_HM <= SHM;					

en_set_Time <= set_Time and en;
time_Set : process(INC_Pulse, clk, en_set_Time)			--시간 설정을 위한 프로세스
variable HH10, HH1, MM10, MM1 : std_logic_vector (3 downto 0) := "0000";	-- 시간 설정을 위한 변수
begin
----------------------- Inc Pulse가 들어오는 경우 시간 증가-----------------------
	if(en='1' and rising_edge(INC_Pulse))	then										
		if(HM_sel(0) = '1') then								--분 설정
			MM1 := MM1 + "0001"; 
			if(MM1 = "1010") then								--M 1의 자리가 10인 경우 오버플로우
				MM1 := "0000"; MM10 := MM10 + "0001";
				if(MM10 = "0110") then							--M 10의 자리가 6인경우 오버플로우
					MM10 := "0000";
				end if;
			end if;
		else															--시 설정
			HH1 := HH1 + "0001";
			if(HH1 = "1010") then								--H 1의 자리가 10인 경우 오버플로우
				HH1 := "0000"; HH10 := HH10 + "0001";
			end if;
			if(HH10 = "0010" and HH1 = "0100") then		--H가 24가 되면 오버플로우
							HH1 := "0000"; HH10 := "0000";
			end if;
		end if;
		HM(15 downto 12) <= HH10; 
		HM(11 downto 8) <= HH1; 
		HM(7 downto 4) <= MM10; 
		HM(3 downto 0) <= MM1;	
	end if;
------------------------------------------------------------------------------
---------------------- 시간 저장 ----------------------- 
	if(en_set_Time='1') then
		SHM <= HM;
	end if;
------------------------------------------------------
-----Set_Time을 벗어나는 경우 HM에 SHM을 넣어 다시 Set_Time에 들어오는 경우 설정된 시간이 보임-------
	if(en='0') then
		HM <= SHM;
		HH10 := sHM(15 downto 12) ; 
		HH1 := sHM(11 downto 8) ; 
		MM10 := sHM(7 downto 4) ; 
		MM1 := sHM(3 downto 0) ;
	end if;
---------------------------------------------------------------------------------------	
end process time_Set;
OUT_HM <= HM;
end set;