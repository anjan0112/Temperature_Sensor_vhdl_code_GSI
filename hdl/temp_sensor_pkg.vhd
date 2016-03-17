library ieee;
use ieee.std_logic_1164.all;

--library work;
--use work.wishbone_pkg.all;
--use work.wr_fabric_pkg.all;

package temp_sensor_pkg is

component temp_sensor

generic (
                clk_frequency  		:       string := "1MHz";
                clock_divider_enable    :       string := "off";
                clock_divider_value     :       natural := 40;
                intended_device_family  :       string := "unused";
                number_of_samples       :       natural := 128;
                poi_cal_temperature     :       natural := 85;
                sim_tsdcalo 	        :       natural := 0;
                use_wys		  	:       string := "on";
                user_offset_enable      :       string := "off";
                lpm_hint       		:       string := "UNUSED";
                lpm_type      		:       string := "temp_sensor"
);

port (
                ce      	:       in std_logic := '1';
                clk     	:       in std_logic;
                clr     	:       in std_logic := '0';
                tsdcaldone      :       out std_logic;
                tsdcalo 	:       out std_logic_vector(7 downto 0)
        );

end component;
end temp_sensor_pkg;

