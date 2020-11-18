library IEEE;
use IEEE.std_logic_1164.all;

entity WS2812Driver is
    port (
        -- Gloabals
        fpga_clk_50   : in  std_logic;        

        -- I/Os
		  fpga_data_out : out std_logic;
        fpga_led_pio  : out std_logic_vector(9 downto 0)
  );
end entity WS2812Driver;

architecture rtl of WS2812Driver is

signal debug_led : std_logic_vector(23 downto 0) := (others => '0');
signal driver_data : std_logic_vector(23 downto 0) := (others => 'X');
signal input_data : std_logic_vector(23 downto 0) := (others => 'X');
signal raddress : std_logic_vector(9 downto 0);
signal wadrress : std_logic_vector(9 downto 0) := (others => '0');
signal fastclock, slowclock, locked : std_logic := 'X';

component pll is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- fast (100MHz) clk
			outclk_1 : out std_logic;        -- slow (50MHz ) clk
			locked   : out std_logic         -- export
		);
end component pll;

component WS2812 is
	generic (
		pixel_count 	 : integer := 768;
		clock_frequency : integer := 50_000_000 -- Hertz
	);
	port (
		clk : in std_logic := 'X';
		data : in std_logic_vector(23 downto 0) := (others => 'X');
		addr : out std_logic_vector(9 downto 0);
		serial : out std_logic := '1'
	);
end component WS2812;

component vram
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
end component;


begin

	
	fpga_led_pio <= raddress(9 downto 0);
	
	d	: component pll
		port map (
			refclk => fpga_clk_50,
			rst => '0',
			outclk_0 => fastclock,
			outclk_1 => slowclock,
			locked => locked
		);
	
	d0 : component vram
		port map (
			clock => fastclock,
			data => input_data,
			rdaddress => raddress,
			wraddress => wadrress,
			wren => '0',
			q => driver_data
		);
	
	d1 : component WS2812 
		generic map (
			pixel_count => 10,
			clock_frequency => 50_000_000*2
		)
		port map (
			clk => fastclock,
			data => driver_data,
			addr => raddress,
			serial => fpga_data_out
		);

end rtl;