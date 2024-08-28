library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFObufferTB is
end FIFObufferTB;

architecture Behavioral of FIFObufferTB is
    
    constant data_width : integer := 8;
    constant fifo_depth : integer := 16;

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal wr_en       : std_logic := '0';
    signal wr_data     : std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal rd_en       : std_logic := '0';
    signal rd_data     : std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal empty       : std_logic;
    signal full        : std_logic;
    signal almost_empty: std_logic;
    signal almost_full : std_logic;
    signal occupancy   : integer range 0 to fifo_depth;

    component FIFObuffer is
        generic (
            data_width : integer := 8;
            fifo_depth : integer := 16
        );
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            wr_en       : in  std_logic;
            wr_data     : in  std_logic_vector(data_width-1 downto 0);
            rd_en       : in  std_logic;
            rd_data     : out std_logic_vector(data_width-1 downto 0);
            empty       : out std_logic;
            full        : out std_logic;
            almost_empty: out std_logic;
            almost_full : out std_logic;
            occupancy   : out integer range 0 to fifo_depth
        );
    end component;

begin
    uut: FIFObuffer
        generic map (
            data_width => data_width,
            fifo_depth => fifo_depth
        )
        port map (
            clk         => clk,
            reset       => reset,
            wr_en       => wr_en,
            wr_data     => wr_data,
            rd_en       => rd_en,
            rd_data     => rd_data,
            empty       => empty,
            full        => full,
            almost_empty=> almost_empty,
            almost_full => almost_full,
            occupancy   => occupancy
        );


	clk <= not clk after 5 ns;


    stim_proc: process
    begin
	
	
        reset <= '1';
        wait for 40 ns;
        reset <= '0';
        wait for 40 ns;

        -- Writing data
        for i in 0 to fifo_depth-1 loop
            wr_en <= '1';
            wr_data <= std_logic_vector(to_unsigned(i, data_width));
            wait for 10 ns;
            wr_en <= '0';
            if full = '1' then
            exit;
           end if;
        end loop;
        wr_en <= '0';

        -- Checking if full
        assert full = '1' report "FIFO should be full" severity error;

        -- Reading data until empty
        for i in 0 to fifo_depth-1 loop
            rd_en <= '1';
            wait for 10 ns;
            assert rd_data = std_logic_vector(to_unsigned(i, data_width))
                report "Read data mismatch" severity error;
        end loop;
        rd_en <= '0';

        
        assert empty = '1' report "FIFO should be empty" severity error;

        -- Testing almost full and almost empty
        for i in 0 to fifo_depth-3 loop
            wr_en <= '1';
            wr_data <= std_logic_vector(to_unsigned(i, data_width));
            wait for 40 ns;
        end loop;
        wr_en <= '0';

        assert almost_full = '1' report "FIFO should be almost full" severity error;

        for i in 0 to fifo_depth-5 loop
            rd_en <= '1';
            wait for 40 ns;
        end loop;
        rd_en <= '0';

        assert almost_empty = '1' report "FIFO should be almost empty" severity error;

        wait;
    end process;

end Behavioral;