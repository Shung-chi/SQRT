library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Mylib.all;

entity Datapath is
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
end Datapath;

architecture structure of Datapath is
    -- Tin hieu noi bo
    signal A_src, A_out : std_logic_vector(Data_width-1 downto 0);
    signal X_src, X_out : std_logic_vector(Data_width-1 downto 0);
    signal Y_src, Y_out : std_logic_vector(Data_width-1 downto 0);
    signal Sqrt_a_src   : std_logic_vector(Data_width-1 downto 0);
    
    signal I_out        : std_logic_vector(7 downto 0);
    signal Scale_out    : std_logic_vector(7 downto 0);

    -- Tin hieu ep kieu
    signal a_signed, x_signed, y_signed : signed(Data_width-1 downto 0);
    signal x_shifted, y_shifted         : signed(Data_width-1 downto 0);
    signal i_unsigned                   : unsigned(7 downto 0);
    signal scale_signed                 : signed(7 downto 0);

    -- Cac hang so 
    constant C_0_5   : signed(Data_width-1 downto 0) := to_signed(128, Data_width);  -- 0.5 * 256
    constant C_2_0   : signed(Data_width-1 downto 0) := to_signed(512, Data_width);  -- 2.0 * 256
    constant C_0_25  : signed(Data_width-1 downto 0) := to_signed(64, Data_width);   -- 0.25 * 256
    constant C_K_INV : signed(Data_width-1 downto 0) := to_signed(310, Data_width);  -- He so bu
    constant N_MAX   : unsigned(7 downto 0)          := to_unsigned(33, 8);          -- Loop

    signal mult_product     : signed((Data_width*2)-1 downto 0);
    signal x_gain_corrected : signed(Data_width-1 downto 0);
    signal final_sqrt       : signed(Data_width-1 downto 0);
begin
    -- Ep kieu
    a_signed     <= signed(A_out);
    x_signed     <= signed(X_out);  
    y_signed     <= signed(Y_out);
    i_unsigned   <= unsigned(I_out);
    scale_signed <= signed(Scale_out);

    -- Phep dich tuong duong phep 2 mu
    x_shifted <= shift_right(x_signed, to_integer(i_unsigned));
    y_shifted <= shift_right(y_signed, to_integer(i_unsigned));

    -- Mach giai ma cac tin hieu trang thai gui toi controller
    a_eq_0   <= '1' when a_signed = 0 else '0';
    a_lt_0_5 <= '1' when (a_signed > 0 and a_signed < C_0_5) else '0';
    a_ge_2   <= '1' when a_signed >= C_2_0 else '0';
    a_lt_0   <= '1' when a_signed < 0 else '0';
    y_lt_0   <= '1' when y_signed < 0 else '0';
    i_eq_N   <= '1' when i_unsigned = N_MAX else '0';

    -- MUX cho thanh ghi A
    A_src <= A_i when A_sel = "00" else
             std_logic_vector(shift_left(a_signed, 2))  when A_sel = "01" else
             std_logic_vector(shift_right(a_signed, 2)) when A_sel = "10" else
             A_out;

    -- MUX cho thanh ghi X va Y
    X_src <= std_logic_vector(a_signed + C_0_25) when X_sel = "00" else
             std_logic_vector(x_signed + y_shifted) when X_sel = "01" else
             std_logic_vector(x_signed - y_shifted) when X_sel = "10" else
             X_out;

    Y_src <= std_logic_vector(a_signed - C_0_25) when Y_sel = "00" else
             std_logic_vector(y_signed + x_shifted) when Y_sel = "01" else
             std_logic_vector(y_signed - x_shifted) when Y_sel = "10" else
             Y_out;

    -- Mach nhan 
    mult_product     <= x_signed * C_K_INV;
    x_gain_corrected <= mult_product(23 downto 8);

    -- Bu scale
    process(x_gain_corrected, scale_signed)
    begin
        if scale_signed > 0 then
            final_sqrt <= shift_right(x_gain_corrected, to_integer(scale_signed));
        elsif scale_signed < 0 then
            final_sqrt <= shift_left(x_gain_corrected, to_integer(-scale_signed));
        else
            final_sqrt <= x_gain_corrected;
        end if;
    end process;

    -- MUX output
    sqrt_a_src <= (others => '0') when Sqrt_sel = '0' else std_logic_vector(final_sqrt);

    -------------------------------------------------------------------------
    --  Khoi tao port map cho cac thanh ghi
    Rega: regn generic map(Data_width) port map (A_src, reset, clk, A_ld, A_out);
    Regx: regn generic map(Data_width) port map (X_src, reset, clk, X_ld, X_out);
    Regy: regn generic map(Data_width) port map (Y_src, reset, clk, Y_ld, Y_out);
    Regsqrt: regn generic map(Data_width) port map (sqrt_a_src, reset, clk, Sqrt_ld, Sqrt_a_o);
    Regi: UpCounter 
        generic map(8) 
        port map (
            clk    => clk,
            reset  => reset,
            Ld     => I_ld,   
            enable => I_sel,  
            D      => x"01",  
            count  => I_out
        );
    Regscale: UpDownCounter 
        generic map(8) 
        port map (
            clk   => clk,
            reset => reset,
            Ld    => Scale_ld,     
            Up    => Scale_sel(0), 
            Down  => Scale_sel(1), 
            D     => x"00",        
            count => Scale_out
        );

end structure;
