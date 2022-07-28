library IEEE;
use IEEE.std_logic_1164.all;
--Input Data를 쪼개어 segment로 넣어준다.--
entity Decoder_Block is
port(
	In_Data : in std_logic_vector (23 downto 0);
	Out5, Out4, Out3, Out2, Out1, Out0 : out std_logic_vector (6 downto 0)
	);
end Decoder_Block;

architecture Decoder of Decoder_Block is

component segment_7
port(	LED_BCD : in std_logic_vector (3 downto 0);	LED_out : out std_logic_vector (6 downto 0) );
end component;


signal IN5, IN4, In3, In2, In1, In0 : std_logic_vector (3 downto 0);

begin
	In5 <= In_Data (23 downto 20);
	In4 <= In_Data (19 downto 16);
	In3 <= In_Data (15 downto 12);
	In2 <= In_Data (11 downto 8);
	In1 <= In_Data (7 downto 4);
	In0 <= In_Data (3 downto 0);
	
	O5 : segment_7 port map (In5, Out5);
	O4 : segment_7 port map (In4, Out4);
	O3 : segment_7 port map (In3, Out3);
	O2 : segment_7 port map (In2, Out2);
	O1 : segment_7 port map (In1, Out1);
	O0 : segment_7 port map (In0, Out0);
end Decoder;
