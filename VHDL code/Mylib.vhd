library ieee;
use ieee.std_logic_1164.all;

package Mylib is
    -- Khai bao thanh ghi
    component regn is
        generic(N : integer := 16);
        port(
            D : in std_logic_vector(N-1 downto 0);
            Clr, Clk, En : in std_logic;
            Q : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Khai bao Datapath
    component Datapath is
        generic (Data_width : integer := 16);
        port(
            reset, clk : in std_logic;
            A_sel, X_sel, Y_sel, Scale_sel : in std_logic_vector(1 downto 0);
            I_sel, Sqrt_sel : in std_logic;
            A_ld, X_ld, Y_ld, Scale_ld, I_ld, Sqrt_ld : in std_logic; 
            A_i : in std_logic_vector(Data_width-1 downto 0);
            a_eq_0, a_lt_0_5, a_ge_2, a_lt_0 : out std_logic;
            y_lt_0, i_eq_N : out std_logic;
            Sqrt_a_o : out std_logic_vector(Data_width - 1 downto 0)
        );
    end component;

    -- Khai bao Controller
    component Controller is
        port(
            reset, clk : in std_logic;
            Start_i : in std_logic;
            A_sel, X_sel, Y_sel, Scale_sel : out std_logic_vector(1 downto 0);
            I_sel, Sqrt_sel : out std_logic;
            A_ld, X_ld, Y_ld, Scale_ld, I_ld, Sqrt_ld : out std_logic;
            a_eq_0, a_lt_0_5, a_ge_2, a_lt_0 : in std_logic;
            y_lt_0, i_eq_N : in std_logic;
            Done_o, Error_o : out std_logic
        );
    end component;
	--Khai bao bo dem len
	 component UpCounter is
        generic (N : integer := 8);
        port (
            clk, reset, Ld, enable : in std_logic;
            D : in std_logic_vector(N-1 downto 0);
            count : out std_logic_vector(N-1 downto 0)
        );
    end component;
	--Khaibao bo dem len/xuong
    component UpDownCounter is
        generic (N : integer := 8);
        port (
            clk, reset, Ld, Up, Down : in std_logic;
            D : in std_logic_vector(N-1 downto 0);
            count : out std_logic_vector(N-1 downto 0)
        );
    end component;
end package;
