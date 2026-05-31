library ieee;
use ieee.std_logic_1164.all;

entity regn is
    generic (N : integer := 16);
    port (
        D   : in std_logic_vector(N-1 downto 0);
        Clr : in std_logic;
        Clk : in std_logic;
        En  : in std_logic;
        Q   : out std_logic_vector(N-1 downto 0)
    );
end regn;

architecture Behavior of regn is
begin
    process(Clk, Clr)
    begin
        if Clr = '1' then
            Q <= (others => '0');
        elsif rising_edge(Clk) then
            if En = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavior;
