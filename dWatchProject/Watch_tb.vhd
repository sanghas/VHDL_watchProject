library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity watch_tb is
end watch_tb;

architecture tb of watch_tb is
component watch is
port(
	en : in std_logic; 		--WatchSetEn
	In_HM : in std_logic_vector (15 downto 0);
	clk : in std_logic;		-- clk_1sec
	Ld_n : in std_logic;		-- watch_set data load key4
	Out_HMS :out std_logic_vector (23 downto 0)
	);
end component;
	signal en_in :std_logic;
	signal In_HM_in : std_logic_vector (15 downto 0) := (others => '0');
	signal clk_in, Ld_n_in : std_logic;
	signal Out_HMS_out : std_logic_vector (23 downto 0);

begin
	DUT : watch port map ( en_in, In_HM_in, clk_in, Ld_n_in, Out_HMS_out );
	
	
	
	
	set : process begin
	In_HM_in <= "0010001100101000";
	en_in <= '1';
	Ld_n_in <= '0';
	wait for 0.748 sec;
	Ld_n_in <= '1';

	wait for 0.534 sec;
	Ld_n_in <= '0';
	wait for 0.884 sec;
	Ld_n_in <= '1';
	wait;
	end process set;
	
	clk : process begin
	clk_in <= '1';	wait for 500 ms;
	clk_in <= '0';	wait for 500 ms;
	end process clk;
end tb;

	
	
