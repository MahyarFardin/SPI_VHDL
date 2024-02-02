library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity spi_tb is
end spi_tb;

architecture Behavioral of spi_tb is
			-- -M : master
			-- -S : slave
			-- -i : input
			-- -o : output
			
        signal CLK_in   : std_logic;
        signal RESET_M  : std_logic;
		  signal RESET_S  : std_logic;
        signal ENABLE   : std_logic;
        signal SS_in    : std_logic_vector(1 downto 0) := "00";
        signal DATA_i_M : std_logic_vector(7 downto 0);
		  signal DATA_i_S : std_logic_vector(7 downto 0);
		  signal DATA_o_M : std_logic_vector(7 downto 0);
		  signal DATA_o_S : std_logic_vector(7 downto 0);
        signal MISO     : std_logic;
        signal CLK_out  : std_logic;
        signal MOSI     : std_logic;
        signal SS_out   : std_logic_vector(3 downto 0) := "0000";

    component master is
        port (
			  CLK_in   : in std_logic;
			  RESET    : in std_logic;
			  ENABLE   : in std_logic;
			  SS_in    : in std_logic_vector(1 downto 0) := "00";
			  DATA_i   : in std_logic_vector(7 downto 0);
			  DATA_o   : out std_logic_vector(7 downto 0) := "00000000";
			  MISO     : in std_logic;
			  CLK_out  : out std_logic;
			  MOSI     : out std_logic;
			  SS_out   : out std_logic_vector(3 downto 0) := "0000"
        );
    end component;

    component slave is
        port(
			  CLK_in   : in std_logic;
			  RESET    : in std_logic;
			  ENABLE   : in std_logic;
			  DATA_i   : in std_logic_vector(7 downto 0);
			  DATA_o   : out std_logic_vector(7 downto 0) := "00000000";
			  MISO     : out std_logic;
			  MOSI     : in std_logic
		  );
    end component;

begin
    uut_master: master
		-- this part is easy, we connect every signal to its corresponding pin
        port map(
			  CLK_in   => CLK_in,
			  RESET	  => RESET_M,
			  ENABLE   => ENABLE,
			  SS_in    => SS_in,
			  DATA_i   => DATA_i_M,
			  DATA_o   => DATA_o_M,
			  MISO     => MISO,
			  CLK_out  => CLK_out,
			  MOSI     => MOSI,
			  SS_out   => SS_out				
        );

		-- this part is tricky because we have to connect master to slave
    uut_slave_00: slave
        port map(
			  CLK_in   => 	CLK_out, -- this is provided by master
			  RESET    =>  RESET_S,
			  ENABLE   =>  SS_out(3),	-- this is the first bit of decoder that connects to enable of this slave
			  DATA_i   =>	DATA_i_S,
			  DATA_o   =>	DATA_o_S,
			  MISO     =>  MISO,
			  MOSI     =>  MOSI
        );

-- this process only producces inner clock for the master
	 clock: process
	 begin
		for i in 0 to 1000 loop
			CLK_in <= '0';
			wait for 20 ns;
			CLK_in <= '1';
			wait for 20 ns;
		end loop;
	 end process;
	 
    stim_proc: process	 
    begin
	 
	 
    	  DATA_i_M <= "11110001";
 		  DATA_i_S <= "10001111";
		  ENABLE <= '0';
		  RESET_M  <= '1';
		  RESET_S  <= '1';
		  wait for 60 ns;
		  
		  ENABLE <= '1';
        RESET_M  <= '0';
		  RESET_S  <= '0';
		  wait ;
    end process stim_proc;

end Behavioral;