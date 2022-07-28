library IEEE;
use IEEE.std_logic_1164.all;

entity tbb is
end entity;

architecture tb of tbb is
component MUX2to1_Nbits is
	generic( N : integer );
	port( sel : in std_logic;
			Data_in1, Data_in2 : in std_logic_vector(N-1 downto 0);
			Data_out : out std_logic_vector (N-1 downto 0));
end component;

signal sel : std_logic;
signal data1, data2, outdata : std_logic_vector (15 downto 0);


begin
DUT : MUX2to1_Nbits generic map ( 16 ) port map ( sel, data1, data2, outdata );

process
begin
	data1 <= x"1234";
	data2 <= x"5678";
	sel <= '0';
	wait for 50 ms;
	sel <= '1';
	wait for 30 ms;
	data1 <= x"1411";
	data2 <= x"2222";
	wait for 50 ms;
	sel <= '0';
	wait;
end process;
end tb;
