-- libraries and packages
-- ieee
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- wishbone/gsi/cern
library work;
use work.wishbone_pkg.all;

-- submodules
library work;
use work.temp_sensor_pkg.all;

-- entity
entity wb_temp_sense is
generic (
      g_address_size  : natural := 32;  -- in bit(s)
      g_data_size     : natural := 32;  -- in bit(s)
      g_spi_data_size : natural := 8    -- in bit(s)
    );
    port (
      -- generic system interface
      clk_sys_i  : in  std_logic;
      rst_n_i    : in  std_logic;
      -- wishbone slave interface
      slave_i    : in  t_wishbone_slave_in;
      slave_o    : out t_wishbone_slave_out);
      
end wb_temp_sense;

--architecture
architecture behaviour of wb_temp_sense is

--signal declarations

signal	temp_sense_ce		:        std_logic := '1';      --clock enable signal to enable Altera temp sensor IP core
signal  temp_sense_tsdcaldone	:        std_logic;                     --temperature sensing operation complete signal
signal  temp_sense_tsdcalo	:        std_logic_vector(7 downto 0);  --temperature range value

constant c_address_tx_data	:    std_logic_vector (1 downto 0):= "00"; -- 0(3 downto 2) - 00(31 downto 0)

begin

--module: temperature sensor
tx_temp_sense : temp_sensor
port map (
        clk		=> clk_sys_i,
        clr		=> rst_n_i,
        ce		=> temp_sense_ce,
        tsdcaldone	=> temp_sense_tsdcaldone,
        tsdcalo		=> temp_sense_tsdcalo
);
-- process to provide temperature data to slave

p_temp_sense: process(clk_sys_i,rst_n_i,temp_sense_ce)

begin

if (rising_edge(clk_sys_i)) then
      -- check if a request is incoming
      if (slave_i.stb='1' and slave_i.cyc='1') then
        -- evaluate address
        case slave_i.adr(3 downto 2) is

                  when c_address_tx_data =>
                        if (temp_sense_ce='1' and rst_n_i='0') then
                        slave_o.ack <= temp_sense_tsdcaldone;
                        slave_o.dat <= temp_sense_tsdcalo;
                        end if;

                        if (rst_n_i='1') then
                        slave_o.ack <= '0';
                        slave_o.dat <= temp_sense_tsdcalo;
                        end if;
       end case;
     end if;
end if;
end process;
end behaviour;          
