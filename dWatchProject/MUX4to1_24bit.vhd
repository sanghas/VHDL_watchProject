library IEEE;
use IEEE.std_logic_1164.all;

entity MUX_4to1_24bit is
port(
	IN1, IN2, IN3, IN4 : in std_logic_vector (23 downto 0);
	sel : in std_logic_vector (1 downto 0);
	Out_Data : out std_logic_vector (23 downto 0)
	);
end MUX_4to1_24bit;

------ 00 -> IN1, 01 -> IN2, 10 -> IN3, 11 -> IN4 --------
architecture selec of MUX_4to1_24bit is
component MUX2to1_Nbits is
	generic( N : integer );
	port( sel : in std_logic;
			Data_in1, Data_in2 : in std_logic_vector(N-1 downto 0);
			Data_out : out std_logic_vector (N-1 downto 0));
end component;
signal data_out1, data_out2 : std_logic_vector (23 downto 0);
begin
	MUX1 : MUX2to1_Nbits generic map (24) port map (sel(0), IN1, IN2, data_out1);
	MUX2 : MUX2to1_Nbits generic map (24) port map (sel(0), IN3, IN4, data_out2);
	MUX3 : MUX2to1_Nbits generic map (24) port map (sel(1), data_out1, data_out2, Out_Data);
end selec;
