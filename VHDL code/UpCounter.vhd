library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UpCounter is 
    generic (N : integer := 8); -- M?c ??nh 8-bit cho bi?n I
    port (
        clk    : in std_logic;
        reset  : in std_logic;
        Ld     : in std_logic;                      -- Chân n?p d? li?u kh?i t?o
        enable : in std_logic;                      -- Chân cho phép ??m lên
        D      : in std_logic_vector(N-1 downto 0); -- Giá tr? mu?n n?p vào
        count  : out std_logic_vector(N-1 downto 0)
    );
end UpCounter;

architecture behav of UpCounter is
    signal pre_count: std_logic_vector(N-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pre_count <= (others => '0');
        elsif rising_edge(clk) then
            if Ld = '1' then
                pre_count <= D;             -- N?p giá tr? ban ??u (VD: x"01" t? Datapath)
            elsif enable = '1' then
                pre_count <= pre_count + 1; -- T?ng I thêm 1
            end if;
        end if;
    end process;
    
    count <= pre_count;
end behav;
