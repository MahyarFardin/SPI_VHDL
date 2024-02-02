library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity master_tb is
end master_tb;

architecture Behavioral of master_tb is

    signal CLK_in   : std_logic := '0';
    signal RESET    : std_logic := '1';
    signal ENABLE   : std_logic := '0';
    signal SS_in    : std_logic_vector(1 downto 0) := "00";
    signal DATA_i   : std_logic_vector(7 downto 0) := (others => '0');
    signal DATA_o   : std_logic_vector(7 downto 0);
    signal MISO     : std_logic := '0';
    signal CLK_out  : std_logic;
    signal MOSI     : std_logic;
    signal SS_out   : std_logic_vector(3 downto 0);
    
    constant PERIOD : time := 10 ns;

    component master is
        port (
            CLK_in   : in std_logic;
            RESET    : in std_logic;
            ENABLE   : in std_logic;
            SS_in    : in std_logic_vector(1 downto 0);
            DATA_i   : in std_logic_vector(7 downto 0);
            DATA_o   : out std_logic_vector(7 downto 0);
            MISO     : in std_logic;
            CLK_out  : out std_logic;
            MOSI     : out std_logic;
            SS_out   : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    uut: master
        port map(
            CLK_in   => CLK_in,
            RESET    => RESET,
            ENABLE   => ENABLE,
            SS_in    => SS_in,
            DATA_i   => DATA_i,
            DATA_o   => DATA_o,
            MISO     => MISO,
            CLK_out  => CLK_out,
            MOSI     => MOSI,
            SS_out   => SS_out
        );

    CLK_process : process
    begin
        while now < 1000 ns loop  -- Simulation duration: 10 us
            CLK_in <= '0';
            wait for PERIOD/2;
            CLK_in <= '1';
            wait for PERIOD/2;
        end loop;
        wait;
    end process CLK_process;
    
    simulation_process : process
    begin
        RESET <= '1';
        ENABLE <= '0';
        SS_in <= "00";
        DATA_i <= (others => '1');
        wait for PERIOD * 5;
        
        RESET <= '0';
        wait for PERIOD * 5;
        
        ENABLE <= '1';
        wait for PERIOD * 5;
        
			DATA_i <= "11000011";
			
			wait for 50 ns;
			
			for i in DATA_i'length -1 downto 0 loop
				MISO <= DATA_i(i);
				wait for PERIOD * 5;
			end loop;
			
			
			wait;
    end process simulation_process;

end Behavioral;