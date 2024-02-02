library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.all;

entity master is
    port (
        CLK_in   : in std_logic;		-- inner clock
        RESET    : in std_logic;		-- reset signal
        ENABLE   : in std_logic;		-- enable signal
        SS_in    : in std_logic_vector(1 downto 0) := "00";	-- encoder input signal for selecting the slave
        DATA_i   : in std_logic_vector(7 downto 0);	-- inner data that we want to send
		  DATA_o   : out std_logic_vector(7 downto 0) := "00000000";	-- data that we get from slave
        MISO     : in std_logic;		-- master in slave out
        CLK_out  : out std_logic;	-- outter clock that master provides for slaves == inner clock
        MOSI     : out std_logic;	-- master out slave in
        SS_out   : out std_logic_vector(3 downto 0) := "0000"	-- slave select
    );
end master;

architecture Behavioral of master is
    signal r_buffer : std_logic_vector(7 downto 0);
begin
    slave_select: process(CLK_in, RESET, SS_in)
    begin
		  CLK_out <= CLK_in;
        if RESET = '1' then
            MOSI  <= 'Z';
            SS_out <= "1000";
        elsif falling_edge(CLK_in) then            
            if ENABLE = '1' then
                -- ss_out of master is a bit vector in length of slaves
                -- each bit is connected to corresponding slave's enable
                case SS_in is
					 -- ss is active low in most implementations but in this implementation 
					 -- I defined it as active high and connected the corresponding signal to the 
					 -- enable of the slave
                    when "00" =>
                        SS_out <= "1000"; -- each of the bits connect to its individual slave
                    when "01" =>
                        SS_out <= "0100";
                    when "10" =>
                        SS_out <= "0010";
                    when "11" =>
                        SS_out <= "0001";
                    when others =>
                        SS_out <= "0000";  -- Default value if SS_in is not a defined case
                end case;
            end if;
        end if;
    end process slave_select;

    mosi_m: process(CLK_in, RESET)
    variable bitCount: integer range 0 to 7;
    begin
        if RESET = '1' then
            bitCount := 0;
				MOSI <= '0';
        elsif falling_edge(CLK_in) then
		  -- this is a shift register but instead of using a hardware
		  -- we used indexing; we put data bit by bit on the bus
            if ENABLE = '1' then
                MOSI <= DATA_i(bitCount);
                bitCount := (bitCount + 1) mod 8;						
				else MOSI <= '0';
            end if;
        end if;
    end process;

    miso_m: process(CLK_in, RESET)
    variable bitCount	: integer range -1 to 7;
    begin
        if RESET = '1' then
		  -- we start from -1 to scape the first bit 
		  -- it is the remainder of previous dataframe
            bitCount := -1;
            DATA_o <= (others => '0');
        elsif falling_edge(CLK_in) then
            if ENABLE = '1' then
						if bitCount /= -1 then
							DATA_o(bitCount) <= MISO;
						end if;
						bitCount := (bitCount + 1) mod 8;
				end if;
        end if;
    end process;
end Behavioral;