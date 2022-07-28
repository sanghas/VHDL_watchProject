library IEEE;
use IEEE.std_logic_1164.all;

entity register_Nbit is
	generic( N : integer );
	port(
		data_in :in std_logic_vector ( N-1 downto 0 );
		clk :in std_logic;
		data_out : out std_logic_vector ( N-1 downto 0 )
		);
	end register_Nbit;
architecture reg of register_Nbit is
begin
process(clk)
begin
	if(rising_edge(clk))	then
		data_out <= data_in;
	end if;
end process;
end reg;