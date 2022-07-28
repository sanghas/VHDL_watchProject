library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity stop_Watch is
port(
	en :in std_logic;		--	StopWatchEn , DeKey 1
	OnOffToggle : in std_logic;	-- Dekey2 : 스탑워치의 온오프를 조정한다
	Clr : in std_logic;		--Dekey3 : 액티브 하이 신호로 동기식으로 작동한다.
	clk : in std_logic;			--10ms_Clk : ON이 되면 이 clk에 맞춰서 값이 증가한다.
	OUT_MSmS : out std_logic_vector (23 downto 0)		-- 현재 시간을 나타낸다
	);
end stop_watch;

architecture STW of stop_Watch is

	component MUX2to1_Nbits is
	generic( N : integer );
	port( sel : in std_logic;
			Data_in1, Data_in2 : in std_logic_vector(N-1 downto 0);
			Data_out : out std_logic_vector (N-1 downto 0));
	end component;
	component Nbits_Mode is
	generic( N : integer );
	port(
		clk : in std_logic;			--	Input - DeKey1 
		M : out std_logic_vector (N-1 downto 0)
		);
	end component;
	
	signal OnOff : std_logic_vector (0 downto 0);			-- 스탑워치의 동작을 조정한다	
	signal stopW_MSmS : std_logic_vector (23 downto 0);	--스탑워치의 시간을 표시한다
	signal en_OnOffToggle : std_logic;				-- OnOff를 조정하는 버튼으로 en신호가 '1'인 경우에만 동작한다.
	signal en_Clr : std_logic;							-- Clr를 해주는 버튼으로 en신호가 '1'인 경우에만 동작한다.
begin
en_Clr <= clr and en; 								
en_OnOffToggle <= en and OnOffToggle;
sel_OnOff : Nbits_Mode generic map (1) port map(en_OnOffToggle, OnOff);		
MUX : MUX2to1_Nbits generic map (24) port map (en_clr, stopW_MSmS, x"000000", OUT_MSmS);

flowtime : process(clk, en_Clr)						-- ON인 경우 10mS_clk을 받아 시간을 증가시킨다
variable MM10, MM1, SS10, SS1, mSS100, mSS10  : std_logic_vector (3 downto 0) := "0000";	--time set
begin
	-------------------------------en신호와 상관없이 OnOff신호가 '1'이면 시간이 계속 늘어난다----------------------
	if(rising_edge(clk) and en_Clr = '0') then
		if(OnOff(0) = '1') then
			mSS10 := mSS10 + "0001";
			if(mSS10 = "1010") then													--mS 10의자리가 10이 되면 오버플로우
				mSS10 := "0000"; mSS100 := mSS100 + "0001";
				if(mSS100 = "1010")	then											--mS 100의 자리가 10이 되면 오버플로우
					mSS100 := "0000"; SS1 := SS1 +"0001"; 
					if(SS1 = "1010") then											--S 1의 자리가 10이 되면 오버플로우
						SS1 := "0000"; SS10 := SS10 + "0001";
						if(SS10 = "0110")	then										--S 10의 자리가 6이 되면 오버플로우
							SS10 := "0000"; MM1 := MM1 +"0001";
							if(MM1 = "1010")	then									--M 1의 자리가 10이 되면 오버플로우
								MM1 := "0000"; MM10 := MM10 +"0001";
								if(MM10 = "0110") then								--M 10의 자리가 6이 되면 오버플로우
									MM10 := "0000";
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
	-----------------------------------------------------------------------------------------------------
	----------------------------Clr가 들어오면 ACtive High 동기식으로 동작한다----------------------------------
	if(en_Clr = '1') then
			MM10 := "0000"; MM1 := "0000"; SS10 := "0000"; SS1 := "0000"; mSS100 := "0000"; mSS10 := "0000";
	end if;
	-----------------------------------------------------------------------------------------------------
		stopW_MSmS(23 downto 20) <= MM10; 
		stopW_MSmS(19 downto 16) <= MM1; 
		stopW_MSmS(15 downto 12) <= SS10; 
		stopW_MSmS(11 downto 8) <= SS1; 
		stopW_MSmS(7 downto 4) <= mSS100; 
		stopW_MSmS(3 downto 0) <= mSS10;
end process flowtime;

end STW;
