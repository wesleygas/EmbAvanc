library IEEE;
use IEEE.std_logic_1164.all;

entity LAB2_FPGA_NIOS is
    port (
        -- Gloabals
        fpga_clk_50        : in  std_logic;             -- clock.clk

        -- I/Os
        fpga_led_pio       : out std_logic_vector(5 downto 0);
		  fpga_switches_pio  : in std_logic_vector(5 downto 0);
		  fpga_motor_phases  : out std_logic_vector(3 downto 0)
		  
  );
end entity LAB2_FPGA_NIOS;

architecture rtl of LAB2_FPGA_NIOS is
 SIGNAL to_leds : std_logic_vector(5 downto 0);

component niosLab2 is
        port (
            clk_clk         : in  std_logic                    := 'X';             -- clk
            leds_export     : out std_logic_vector(5 downto 0);                    -- export
            reset_reset_n   : in  std_logic                    := 'X';             -- reset_n
            switches_export : in  std_logic_vector(5 downto 0) := (others => 'X')  -- export
        );
    end component niosLab2;

begin

	fpga_led_pio <= to_leds;
	fpga_motor_phases <= to_leds(3 downto 0);
	
 u0 : component niosLab2
        port map (
           clk_clk       => fpga_clk_50,    --  clk.clk
			  reset_reset_n => '1',            --  reset.reset_n
			  leds_export   => to_leds,    --  leds.export
           switches_export => fpga_switches_pio  -- switches.export
        );

end rtl;