
library ieee;
use ieee.std_logic_1164.all;

--library work;
--use work.wishbone_pkg.all;
--use work.wr_fabric_pkg.all;

entity temp_sensor is

generic (
                clk_frequency   	:       string := "1MHz";
                clock_divider_enable    :       string := "off";
                clock_divider_value     :       natural := 40;
                intended_device_family  :       string := "unused";
                number_of_samples       :       natural := 128;
                poi_cal_temperature     :       natural := 85;
                sim_tsdcalo     	:       natural := 0;
                use_wys 		:       string := "on";
                user_offset_enable      :       string := "off";
                lpm_hint        	:       string := "UNUSED";
                lpm_type        	:       string := "temp_sensor"
);

port (
                ce      	:       in std_logic := '1';
                clk     	:       in std_logic;
                clr     	:       in std_logic := '0';
                tsdcaldone      :       out std_logic;
                tsdcalo 	:       inout std_logic_vector(7 downto 0)
        );
end temp_sensor;

architecture logic of temp_sensor is

signal temp_val : std_logic_vector (7 downto 0) := (others => '0');
signal count   	: integer := 0;

begin

read_data: process (clk,clr,ce)

begin

if (clk'event and clk='1') then

        if (clr='1') then
                temp_val  <= x"D5";
                tsdcalo   <= temp_val;
                tsdcaldone<= '0';
        end if;

        if (ce='1' and clr='0') then
                temp_val  <= tsdcalo;
                tsdcaldone<= '1';
        end if;
end if;
end process;
end logic;
