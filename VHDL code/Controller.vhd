library ieee;
use ieee.std_logic_1164.all;
use work.Mylib.all;

entity Controller is
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
end Controller;

architecture BEV of Controller is
    type State_type is (
        S0, S1, S2, S3, S4, S5, S6, S7, S8, S9,
        S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20
    );
    
    signal state : State_type;
begin

    sync_process : process(reset, clk)
    begin
        if reset = '1' then
            state <= S0;
            Done_o <= '0';
            Error_o <= '0';
        elsif rising_edge(clk) then
            case state is
                when S0 =>  state <= S1;
                when S1 =>  if Start_i = '1' then state <= S2; end if;
                when S2 =>  state <= S3;
                when S3 =>
                    if a_eq_0 = '1' then  state <= S4;
                    else                     state <= S5;
                    end if;
                when S4  => state <= S18;
		when S5  => if a_lt_0 = '1' then     state <= S6;
                    else state <= S7 ; end if;
                when S6  =>  state <= S18; 
                when S7  => if a_lt_0_5 = '1' then state <= S8; else state <= S9; end if;
                when S8  => state <= S7;
                when S9  => if a_ge_2 = '1' then state <= S10; else state <= S11; end if;
                when S10 => state <= S9;
                when S11 => state <= S12;
                when S12 =>
                    if i_eq_N = '1' then     state <= S17;
                    
                    else                     state <= S13;
                    end if;
		when S13 => if y_lt_0 = '1' then  state <= S15; else state <= S14; end if;
                when S14 => state <= S16;
                when S15 => state <= S16;
                when S16 => state <= S12;
                when S17 => state <= S18;
                when S18 => state <= S19;
                when S19 => if Start_i = '0' then state <= S20; else state <=S19; end if;
                when S20 => if Start_i = '1' then state <= S2; else state <= S1; end if;
                when others => state <= S0;
            end case;

            if (state = S6 or state = S18 or state = S19) then
                Done_o <= '1';
            else
                Done_o <= '0';
            end if;

            if state = S6 then
                Error_o <= '1';
            else
                Error_o <= '0';
            end if;
        end if;
    end process;
--combination output
-- TIN HIEU DIEU KHIEN CHO CAC THANH GHI
    A_sel     <= "01" when (state = S8) else 
                 "10" when (state = S10) else 
                 "00";

    X_sel     <= "10" when (state = S14) else 
                 "01" when (state = S15) else 
                 "00";

    Y_sel     <= "10" when (state = S14) else 
                 "01" when (state = S15) else 
                 "00";

    
    I_sel     <= '1'  when (state = S16) else '0';

    Scale_sel <= "01" when (state = S8) else  
                 "10" when (state = S10) else 
                 "00";
    Sqrt_sel  <= '0' when (state = S4) else '1';

    -- (Load Enables)
    A_ld      <= '1' when (state = S2 or state = S8 or state = S10) else '0';
    X_ld      <= '1' when (state = S11 or state = S14 or state = S15) else '0';
    Y_ld      <= '1' when (state = S11 or state = S14 or state = S15) else '0';
    Sqrt_ld   <= '1' when (state = S4 or state = S17) else '0';

    Scale_ld  <= '1' when (state = S2) else '0';  
    I_ld      <= '1' when (state = S11) else '0';  

end BEV;
