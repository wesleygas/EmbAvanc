library IEEE;
use IEEE.std_logic_1164.all;

entity Lab1_FPGA_RTL is
    port (
        -- Gloabals
        fpga_clk_50   : in  std_logic;        

        -- I/Os
        fpga_led_pio  : out std_logic_vector(5 downto 0)
  );
end entity Lab1_FPGA_RTL;

architecture rtl of Lab1_FPGA_RTL is

-- signal
signal blink : std_logic := '0';

begin

  process(fpga_clk_50) 
      variable counter : integer range 0 to 25000000 := 0;
      begin
        if (rising_edge(fpga_clk_50)) then
                  if (counter < 10000000) then
                      counter := counter + 1;
                  else
                      blink <= not blink;
                      counter := 0;
                  end if;
        end if;
  end process;

  fpga_led_pio(0) <= blink;
  fpga_led_pio(1) <= blink;
  fpga_led_pio(2) <= blink;
  fpga_led_pio(3) <= blink;
  fpga_led_pio(4) <= blink;
  fpga_led_pio(5) <= blink;

end rtl;