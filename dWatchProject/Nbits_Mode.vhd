library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- clk이 들어올 때마다 Mode를 1씩 증가시켜 cycle을 돌게 한다.
entity Nbits_Mode is
	generic( N : integer );		
	port(
	clk : in std_logic;			
	M : out std_logic_vector (N-1 downto 0)	
	);
end Nbits_Mode;

architecture sel of Nbits_Mode is
begin
process(clk)
variable m_var : std_logic_vector (N-1 downto 0) := (others => '0');
begin
	if(rising_edge(clk))	then			-- rising clk마다 m_var을 증가시켜 하나씩 움직인다.
		m_var := m_var + 1 ;
	end if;
	M<=m_var;
end process;
end sel;	
