library IEEE;
use IEEE.std_logic_1164.all;
--3종류의 pulse를 생성하는 것으로 1sec, 10ms, 50ms 주기의 펄스 생성
entity Clk_gen is
generic(selinHz : integer );
port(
	clk : in std_logic;		-- 2MHz
	outpulse1 : out std_logic;	-- T = 1sec 
	outpulse2 : out std_logic;	-- T = 10ms
	outpulse3 : out std_logic	-- T = 50ms
	);
end Clk_gen;

architecture Generator of Clk_gen is
component pulse_generator
	generic ( inHz, outHz : integer );
	port( in_clk : in std_logic;
			out_clk : out std_logic);
end component;
begin
PUL1 : pulse_generator generic map(selinHz, 1) port map(clk,outpulse1);		-- 1sec ( 1Hz )
PUL2 : pulse_generator generic map(selinHz, 100) port map(clk,outpulse2);		-- 10ms ( 100Hz )
PUL3 : pulse_generator generic map(selinHz, 20) port map(clk,outpulse3);		-- 50ms ( 20Hz )


end Generator;
 