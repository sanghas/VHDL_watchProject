----------- File dWatch_components.vhd : ----------------
library ieee;
use IEEE.std_logic_1164.all;
---------------------------------------------------------
package dWatch_components is
	-------------- DeBounce --------------
	component DeBounce is				
	port(
		In1,In2,In3,In4 : in std_logic;	
		clk	:	in std_logic;			
		Out1,Out2,Out3,Out4 : out std_logic	
		);
	end component;
	--------------------------------------
	--------------- Mode -----------------
	component Nbits_Mode is
	generic( N : integer );
	port(
	clk : in std_logic;			
	M : out std_logic_vector (N-1 downto 0)	
	);
	end component;
	--------------------------------------
	------------ Key_Seq_Gen -------------
	component Key_Seq_Gen is
	port(
		clk 	: in std_logic;	
		KeyIn : in std_logic;	
		KeyPulse	: out std_logic	
		);
	end component;
	--------------------------------------
	-------------- Clk_Gen ---------------
	component Clk_gen is
	generic(selinHz : integer );
	port(
		clk : in std_logic;		
		outpulse1 : out std_logic;	 
		outpulse2 : out std_logic;	
		outpulse3 : out std_logic	
		);
	end component;
	--------------------------------------
	------------- decoder2to4 ------------
	component decoder2to4 is
	port(
		d_in : in std_logic_vector (1 downto 0);
		out0, out1, out2, out3 : out std_logic
	);	
	end component;
	--------------------------------------
	------------ Comparator --------------
	component Comparator is
	generic( bits : integer);
	port(
		In1, In2 : in std_logic_vector (bits-1 downto 0);
		comp : out std_logic
		);
	end component;
	--------------------------------------
	----------------- watch ----------------
	component watch is
	port(
		en : in std_logic; 		
		In_HM : in std_logic_vector (15 downto 0);
		clk : in std_logic;		
		Ld_n : in std_logic;		
		Out_HMS :out std_logic_vector (23 downto 0)
		);
	end component;
	----------------------------------------
	---------- watch_Set & Alarm_Set ------------
	component Set_Time is
	port(
		clk : in std_logic;		
		en : in std_logic; 		
		Toggle_HM : in std_logic; 
		Ts_Inc : in std_logic;	
		set_Time : in std_logic; 	
		OUT_HM : out std_logic_vector (15 downto 0);		
		OUT_Set_HM : out std_logic_vector (15 downto 0)
		);
	end component;
	----------------------------------------------
	------------- stop_Watch ------------
	component stop_Watch is
	port(
		en :in std_logic;		
		OnOffToggle : in std_logic;	
		Clr : in std_logic;		
		clk : in std_logic;			
		OUT_MSmS : out std_logic_vector (23 downto 0)		
		);
	end component;
	--------------------------------------
	---------- MUX_4to1_24bit ------------
	component MUX_4to1_24bit is
	port(
		IN1, IN2, IN3, IN4 : in std_logic_vector (23 downto 0);
		sel : in std_logic_vector (1 downto 0);
		Out_Data : out std_logic_vector (23 downto 0)
		);
	end component;
	--------------------------------------
	---------- MUX_2to1_Nbit -------------
	component MUX2to1_Nbits is
	generic( N : integer );
	port( sel : in std_logic;
			Data_in1, Data_in2 : in std_logic_vector(N-1 downto 0);
			Data_out : out std_logic_vector (N-1 downto 0));
	end component;
	--------------------------------------
	---------- Decoder_Block -------------
	component Decoder_Block is
	port(
		In_Data : in std_logic_vector (23 downto 0);
		Out5, Out4, Out3, Out2, Out1, Out0 : out std_logic_vector (6 downto 0)
		);
	end component;
	--------------------------------------
	end dWatch_components;
	