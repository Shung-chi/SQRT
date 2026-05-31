library ieee;
use ieee.std_logic_1164.all;
use work.Mylib.all;

entity top_SQRT is
    generic (Data_width : integer := 16);
    port(
        reset, clk  : in std_logic;
        Start_i     : in std_logic;
        A_i         : in std_logic_vector(Data_width-1 downto 0);
        Done_o      : out std_logic;
        Error_o     : out std_logic;
        Sqrt_a_o    : out std_logic_vector(Data_width-1 downto 0)
    );
end top_SQRT;

architecture Structural of top_SQRT is
    -- Tin hieu tu Controller sang Datapath
    signal w_A_sel, w_X_sel, w_Y_sel, w_Scale_sel : std_logic_vector(1 downto 0);
    signal w_I_sel, w_Sqrt_sel : std_logic;
    signal w_A_ld, w_X_ld, w_Y_ld, w_Scale_ld, w_I_ld, w_Sqrt_ld : std_logic;
    
    -- Tin hieu trang thai tu datapath sang controller
    signal w_a_eq_0, w_a_lt_0_5, w_a_ge_2, w_a_lt_0 : std_logic;
    signal w_y_lt_0, w_i_eq_N : std_logic;

begin
    -- Khoi tao cho Datapath
    U_Datapath: Datapath 
        generic map (Data_width => Data_width)
        port map (
            reset      => reset,
            clk        => clk,
            A_sel      => w_A_sel,
            X_sel      => w_X_sel,
            Y_sel      => w_Y_sel,
            Scale_sel  => w_Scale_sel,
            I_sel      => w_I_sel,
            Sqrt_sel   => w_Sqrt_sel,
            A_ld       => w_A_ld,
            X_ld       => w_X_ld,
            Y_ld       => w_Y_ld,
            Scale_ld   => w_Scale_ld,
            I_ld       => w_I_ld,
            Sqrt_ld    => w_Sqrt_ld,
            A_i        => A_i,
            a_eq_0     => w_a_eq_0,
            a_lt_0_5   => w_a_lt_0_5,
            a_ge_2     => w_a_ge_2,
            a_lt_0     => w_a_lt_0,
            y_lt_0     => w_y_lt_0,
            i_eq_N     => w_i_eq_N,
            Sqrt_a_o   => Sqrt_a_o
        );

    -- Khoi tao cho Controller
    U_Controller: Controller 
        port map (
            reset      => reset,
            clk        => clk,
            Start_i    => Start_i,
            A_sel      => w_A_sel,
            X_sel      => w_X_sel,
            Y_sel      => w_Y_sel,
            Scale_sel  => w_Scale_sel,
            I_sel      => w_I_sel,
            Sqrt_sel   => w_Sqrt_sel,
            A_ld       => w_A_ld,
            X_ld       => w_X_ld,
            Y_ld       => w_Y_ld,
            Scale_ld   => w_Scale_ld,
            I_ld       => w_I_ld,
            Sqrt_ld    => w_Sqrt_ld,
            a_eq_0     => w_a_eq_0,
            a_lt_0_5   => w_a_lt_0_5,
            a_ge_2     => w_a_ge_2,
            a_lt_0     => w_a_lt_0,
            y_lt_0     => w_y_lt_0,
            i_eq_N     => w_i_eq_N,
            Done_o     => Done_o,
            Error_o    => Error_o
        );
end Structural;
