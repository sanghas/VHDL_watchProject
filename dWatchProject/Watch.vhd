library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity watch is
port(
	en : in std_logic; 		--	WatchSetEn and WatchEn , DeKey1
	In_HM : in std_logic_vector (15 downto 0);	-- Watch_set에서 저장한 데이터 값이 넘어온다
	clk : in std_logic;		-- clk_1sec
	Ld_n : in std_logic;		-- Watch_Set에서 넘어온 데이터를 load하는 신호로 falling_edge로 동기식으로 작동한다. mode가 WatchSetEn and WatchEndlf인 경우만 작동한다 DeKey4
	Out_HMS :out std_logic_vector (23 downto 0)	-- 현재 시간이 출력되는 데이터
	);
end watch;

architecture wtc of watch is
signal oen,voen,viewoen : std_logic := '0';				
signal IN_HMS : std_logic_vector	(23 downto 0) := (others => '0');
signal current_HMS : std_logic_vector (23 downto 0) := (others => '0');
signal MUX_HMS : std_logic_vector (23 downto 0) := (others => '0');

component MUX2to1_Nbits is
	generic( N : integer );
	port( sel : in std_logic;
			Data_in1, Data_in2 : in std_logic_vector(N-1 downto 0);
			Data_out : out std_logic_vector (N-1 downto 0));
end component;

begin


IN_HMS(23 downto 8) <= IN_HM;								--load 하기위한 데이터로 초는 0으로 초기화 된다.
viewoen <= oen and (not voen);							-- oen이 '1'이 되고, voen이 '0'이 되는 순간 ( load 되고 다음 rising clk이 되는 순간까지 '1'을 유지한다.)
MUX : MUX2to1_Nbits generic map (24) port map (oen,  current_HMS,In_HMS, MUX_HMS);		-- oen신호에 따라 MUX_HMS에 current_HMS을 넣을지 In_HMS을 넣을지 결정해준다
OUTHM : MUX2to1_Nbits generic map (24) port map (viewoen,  current_HMS, MUX_HMS, Out_HMS);	--화면에 보이는 신호를 설정해주는 mux이다

------- 시간을 1초씩 증가시키는 카운터로 입력으로 MUX_HMS를 받아 1초 증가시켜 current_HMS을 출력한다 ------- 
flowtime : process(clk)
variable HH10, HH1, MM10, MM1, SS10, SS1 : std_logic_vector (3 downto 0) := (others => '0');
begin
	if(rising_edge(clk)) then
		HH10 := MUX_HMS(23 downto 20);
		HH1 := MUX_HMS(19 downto 16);
		MM10 := MUX_HMS(15 downto 12);
		MM1 := MUX_HMS(11 downto 8);
		SS10 := MUX_HMS(7 downto 4);
		SS1 := MUX_HMS(3 downto 0);
		
		SS1 := SS1 + "0001";
		if(SS1 = "1010") then
			SS1 := "0000"; SS10 := SS10 + "0001";
			if(SS10 = "0110")	then
				SS10 := "0000"; MM1 := MM1 +"0001"; 
				if(MM1 = "1010") then
					MM1 := "0000"; MM10 := MM10 + "0001";
					if(MM10 = "0110")	then
						MM10 := "0000"; HH1 := HH1 +"0001";
						if(HH1 = "1010")	then
							HH1 := "0000"; HH10 := HH10 +"0001";
						end if;
						if(HH10 = "0010" and HH1 = "0100") then
							HH1 := "0000"; HH10 := "0000";
						end if;
					end if;
				end if;
			end if;
		end if;
			
	end if;
	current_HMS(23 downto 20) <= HH10;
	current_HMS(19 downto 16) <= HH1;
	current_HMS(15 downto 12) <= MM10;
	current_HMS(11 downto 8) <= MM1;
	current_HMS(7 downto 4) <= SS10;
	current_HMS(3 downto 0) <= SS1;
end process flowtime;	
--------------------------------------------------------------------------------------------

---OUTHM을 조정하는 process Out_HMS 값을 설정해준다---
viewtime : process
begin
	voen <= oen;
	wait until rising_edge(clk);	
	voen <= '0';
end process viewtime; 
------------------------------------------------
---MUX를 조정하는 process로 MUX_HMS 값을 설정해준다---
loadtime : process
begin
	wait until falling_edge(Ld_n);
	if(en = '1')	then
		oen <= '1','0' after 1 sec;
	end if;
end process loadtime; 
-------------------------------------------------

end wtc;