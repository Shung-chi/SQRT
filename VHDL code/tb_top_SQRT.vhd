
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.Mylib.all;
ENTITY tb_top_SQRT IS
END tb_top_SQRT;

ARCHITECTURE BEV OF tb_top_SQRT IS
    -- C? ??nh 16-bit theo thi?t k? Q8.8 c?a Datapath
    CONSTANT DATA_WIDTH : integer := 16; 

    SIGNAL Reset    : STD_LOGIC := '0';
    SIGNAL CLK      : STD_LOGIC := '0';
    SIGNAL Start_i  : STD_LOGIC;
    SIGNAL A_i      : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    SIGNAL Sqrt_a_o : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    SIGNAL Done_o   : STD_LOGIC;
    SIGNAL Error_o  : STD_LOGIC;
BEGIN
    -- Kh?i t?o thi?t b? c?n test (UUT)
    UUT: entity work.top_SQRT
        --GENERIC MAP (
            --Data_width => DATA_WIDTH
      --  )
        PORT MAP (
            reset    => Reset,
            clk      => CLK,
            Start_i  => Start_i,
            A_i      => A_i,
            Done_o   => Done_o,
            Error_o  => Error_o,
            Sqrt_a_o => Sqrt_a_o
        );

    -- T?o xung nh?p 50MHz (Chu k? 20ns)
    CLK <= not CLK after 10 ns;

    -- Ti?n trình t?o tín hi?u ki?m tra
    Stimulus: PROCESS
        procedure RunCase(constant value : in std_logic_vector(15 downto 0)) is
        begin
            wait until falling_edge(CLK);
            A_i <= value;
            Start_i <= '1';

            loop
                wait until rising_edge(CLK);
                exit when Done_o = '1';
            end loop;

            wait until falling_edge(CLK);
            Start_i <= '0';

            wait until rising_edge(CLK);
            wait until rising_edge(CLK);
        end procedure;
    BEGIN
        -- Kh?i t?o ban ??u
        Start_i <= '0';
        A_i <= (others => '0');
        
        -- Nh?n và nh? Reset
        Reset <= '1';
        wait until falling_edge(CLK);
        Reset <= '0';
        wait until rising_edge(CLK);
        wait until rising_edge(CLK);

        -- Case 1: A_i = 1.0 (Q8.8 = 1 * 256 = 256 = 0x0100)
        RunCase(X"0100");

        -- Case 2: A_i = 4.0 (Q8.8 = 4 * 256 = 1024 = 0x0400)
        RunCase(X"0400");

        -- Case 3: A_i = 9.0 (Q8.8 = 9 * 256 = 2304 = 0x0900)
        RunCase(X"0900");

        -- Case 4: A_i = 0.25 (Q8.8 = 0.25 * 256 = 64 = 0x0040)
        RunCase(X"0040");
        
        -- Case 5: A_i = 0.0 (Q8.8 = 0x0000) -> Ch?y vào nhánh S4
        RunCase(X"0000");

        -- Case 6: A_i = -1.0 (Q8.8 = -256 = 0xFF00) -> Error_o = 1
        RunCase(X"FF00");

        -- Case 7
        RunCase(X"0F77");

        -- K?t thúc mô ph?ng
        wait;
    END PROCESS;
END BEV;
