library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- this is the same implementation as master but does not have ss and clk out
entity slave is
    port (
        CLK_in   : in std_logic;
        RESET    : in std_logic;
        ENABLE   : in std_logic;
        DATA_i     : in std_logic_vector(7 downto 0);
		  DATA_o     : out std_logic_vector(7 downto 0) := "00000000";
        MISO     : out std_logic;
        MOSI     : in std_logic
    );
end slave;

architecture Behavioral of slave is
begin
    mosi_s: process(CLK_in, RESET)
    variable bitCount: integer range 0 to 7;
    begin
        if RESET = '1' then
            bitCount := 0;
				DATA_o <= (others => '0');
        elsif falling_edge(CLK_in) then
            if ENABLE = '1' then
					 DATA_o(bitCount) <= MOSI;
					 bitCount := (bitCount + 1) mod 8;
            end if;
        end if;
    end process;

    miso_s: process(CLK_in, RESET)
    variable bitCount: integer range 0 to 7;
    begin
        if RESET = '1' then
            bitCount := 0;
				MISO <= '0';
        elsif RESET = '0' and falling_edge(CLK_in) then
            if ENABLE = '1' then
                MISO <= DATA_i(bitCount);
                bitCount := (bitCount + 1) mod 8;
				else MISO <= '0';
            end if;
        end if;
    end process;
end Behavioral;