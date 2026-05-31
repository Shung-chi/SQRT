LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.Mylib.all;
ENTITY sqrt_tb IS
END sqrt_tb;

ARCHITECTURE BEVa OF sqrt_tb IS

    CONSTANT DATA_WIDTH : integer := 16; 

    SIGNAL Reset    : STD_LOGIC := '0';
    SIGNAL CLK      : STD_LOGIC := '0';
    SIGNAL Start_i  : STD_LOGIC;
    SIGNAL A_i      : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    SIGNAL Sqrt_a_o : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    SIGNAL Done_o   : STD_LOGIC;
    SIGNAL Error_o  : STD_LOGIC;
    component top_SQRT is
    port(
        reset, clk  : in std_logic;
        Start_i     : in std_logic;
        A_i         : in std_logic_vector(Data_width-1 downto 0);
        Done_o      : out std_logic;
        Error_o     : out std_logic;
        Sqrt_a_o    : out std_logic_vector(Data_width-1 downto 0)
    );
end component;
BEGIN

    UUT: top_SQRT
        
        PORT MAP (
            reset    => Reset,
            clk      => CLK,
            Start_i  => Start_i,
            A_i      => A_i,
            Done_o   => Done_o,
            Error_o  => Error_o,
            Sqrt_a_o => Sqrt_a_o
        );


    CLK <= not CLK after 10 ns;


    Stimulus: PROCESS
    BEGIN
        
        Start_i <= '0';
        A_i <= (others => '0');
        
     
        Reset <= '1'; wait for 20 ns;
        Reset <= '0'; wait for 20 ns;

        -- Case 1: A_i = 1.0 
        A_i <= X"0100";
        Start_i <= '1';
        wait until Done_o = '1';
        Start_i <= '0';
        wait for 100 ns;

        -- Case 2: A_i = 4.0 
        A_i <= X"0400";
        Start_i <= '1';
        wait until Done_o = '1';
        Start_i <= '0';
        wait for 100 ns;

        -- Case 3: A_i = 9.0 
        A_i <= X"0900";
        Start_i <= '1';
        wait until Done_o = '1';
        Start_i <= '0';
        wait for 100 ns;

        -- Case 4: A_i = 0.25 
        A_i <= X"0040";
        Start_i <= '1';
        wait until Done_o = '1';
        Start_i <= '0';
        wait for 100 ns;
        
        -- Case 5: A_i = 0.0 
        A_i <= X"0000";
        Start_i <= '1';
        wait until Done_o = '1';
        Start_i <= '0';
        wait for 100 ns;

        -- Case 6: A_i = -1.0 
        A_i <= X"FF00";
        Start_i <= '1';
        wait until Done_o = '1';
        Start_i <= '0';
        wait for 100 ns;
	--case 7 : A_i = 15.42
	A_i <= X"0F77";
        Start_i <= '1';
        wait until Done_o = '1';
        Start_i <= '0';
        wait for 100 ns;
        --case 8 : A_i = 0.5
        A_i <= X"0080";
        Start_i <= '1';
        wait until Done_o = '1';
        Start_i <= '0';
        wait for 100 ns;

        wait;
    END PROCESS;
END BEVa;
