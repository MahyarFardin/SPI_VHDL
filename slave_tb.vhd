library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity slave_tb is
end slave_tb;

architecture Behavioral of slave_tb is

    signal CLK_in   : std_logic := '0';
    signal RESET    : std_logic := '1';
    signal ENABLE   : std_logic := '0';
    signal DATA_i   : std_logic_vector(7 downto 0) := (others => '0');
    signal DATA_o   : std_logic_vector(7 downto 0);
    signal MISO     : std_logic;
    signal MOSI     : std_logic;
    
    constant PERIOD : time := 10 ns;

    component slave is
        port (
            CLK_in   : in std_logic;
            RESET    : in std_logic;
            ENABLE   : in std_logic;
            DATA_i   : in std_logic_vector(7 downto 0);
            DATA_o   : out std_logic_vector(7 downto 0);
            MISO     : out std_logic;
            MOSI     : in std_logic
        );
    end component;

begin

    uut: slave
        port map(
            CLK_in   => CLK_in,
            RESET    => RESET,
            ENABLE   => ENABLE,
            DATA_i   => DATA_i,
            DATA_o   => DATA_o,
            MISO     => MISO,
            MOSI     => MOSI
        );

    CLK_process : process
    begin
        for i in 0 to 1000 loop  -- Simulation duration: 10 us
            CLK_in <= '0';
            wait for PERIOD/2;
            CLK_in <= '1';
            wait for PERIOD/2;
        end loop;
        wait;
    end process CLK_process;
    
    simulation_process : process
    begin
		  --DATA_o <= "00000000";
        RESET <= '1';
        ENABLE <= '0';
        DATA_i <= "11110001";
        wait for PERIOD / 2;
		  
		  RESET <= '0';
        ENABLE <= '1';
		  for i in DATA_i'length - 1 downto 0 loop
				MOSI <= DATA_i(i);
				wait for PERIOD * 5;
		  end loop;
    end process simulation_process;

end Behavioral;