library IEEE;
use IEEE.std_logic_1164.all;

entity CLk_Gen_tb is
end CLk_Gen_tb;

architecture tb of CLk_Gen_tb is

component Clk_Gen is
generic(selinHz : integer );
port(
	clk : in std_logic;		-- 2MHz
	outpulse1 : out std_logic;	-- T = 1sec 
	outpulse2 : out std_logic;	-- T = 10ms
	outpulse3 : out std_logic	-- T = 50ms
	);
end component;

signal clk_in, outpulse1, outpulse2, outpulse3 : std_logic;

begin
DUT : Clk_Gen generic map(2000000) port map (clk_in, outpulse1, outpulse2, outpulse3);

process begin
	clk_in <= '1';
	wait for 0.25 us;
	clk_in <= '0';
	wait for 0.25 us;
end process;

end tb;
	