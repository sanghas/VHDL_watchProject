library IEEE;
use IEEE.std_logic_1164.all;

entity segment_7 is
port(
	LED_BCD : in std_logic_vector (3 downto 0);
	LED_out : out std_logic_vector (6 downto 0)
);
end segment_7;
--0~9까지의 수를 segment로 표시해주고 다른 값이 들어오면 error를 발생 시킨다
architecture seg of segment_7 is
begin
process(LED_BCD)
begin
    case LED_BCD is
    when "0000" => LED_out <= "0000001"; -- "0"     
    when "0001" => LED_out <= "1001111"; -- "1" 
    when "0010" => LED_out <= "0010010"; -- "2" 
    when "0011" => LED_out <= "0000110"; -- "3" 
    when "0100" => LED_out <= "1001100"; -- "4" 
    when "0101" => LED_out <= "0100100"; -- "5" 
    when "0110" => LED_out <= "0100000"; -- "6" 
    when "0111" => LED_out <= "0001111"; -- "7" 
    when "1000" => LED_out <= "0000000"; -- "8"     
    when "1001" => LED_out <= "0000100"; -- "9" 
	 when others => LED_out <= "1111111"; -- "error"
    end case;
end process;
end seg;