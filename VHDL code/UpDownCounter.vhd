library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UpDownCounter is 
    generic (N : integer := 8);
    port (
        clk   : in std_logic;
        reset : in std_logic;
        Ld    : in std_logic;
        Up    : in std_logic;  -- Chân ??m lên (+1)
        Down  : in std_logic;  -- Chân ??m xu?ng (-1)
        D     : in std_logic_vector(N-1 downto 0);
        count : out std_logic_vector(N-1 downto 0)
    );
end UpDownCounter;

architecture behav of UpDownCounter is
    signal pre_count: std_logic_vector(N-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pre_count <= (others => '0');
        elsif rising_edge(clk) then
            if Ld = '1' then
                pre_count <= D;             -- N?p giá tr? ban ??u (x"00")
            elsif Up = '1' then
                pre_count <= pre_count + 1; -- Scale + 1
            elsif Down = '1' then
                pre_count <= pre_count - 1; -- Scale - 1
            end if;
        end if;
    end process;
    
    count <= pre_count;
end behav;
