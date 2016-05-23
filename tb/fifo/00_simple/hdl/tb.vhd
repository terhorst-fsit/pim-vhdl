-----------------------------------------------------------------------------
-- file			: tb.vhd
--
-- brief		: Test bench
-- author(s)	: marc at pignat dot org
-----------------------------------------------------------------------------
-- Copyright 2015,2016 Marc Pignat
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- 		http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- See the License for the specific language governing permissions and
-- limitations under the License.
-----------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity tb is
end tb;

architecture bhv of tb is
	signal reset			: std_ulogic;
	signal clock			: std_ulogic;

	signal counter			: unsigned(7 downto 0);
	signal counter_enable	: unsigned(7 downto 0);

	signal read				: std_ulogic;
	signal empty			: std_ulogic;

	signal write_data		: std_ulogic_vector(7 downto 0);
	signal write			: std_ulogic;
	signal read_data		: std_ulogic_vector(7 downto 0);
	signal full				: std_ulogic;

	signal read_valid		: std_ulogic;
	signal d_in				: std_ulogic_vector(7 downto 0);
	signal d_out			: std_ulogic_vector(7 downto 0);
	signal stop				: std_ulogic;
	signal expected_data	: std_ulogic_vector(7 downto 0);
begin

tb_proc: process
	variable timeout : integer;
	begin
	stop <= '0';

	expected_data <= (others => '0');

	wait until falling_edge(reset);

	for i in 0 to 1000 loop

		timeout := 10;
		while read_valid /= '1' loop
			wait until falling_edge(clock);

			assert timeout > 0 report "Timeout waiting for read_valid" severity failure;

			timeout := timeout - 1;
		end loop;

		while read_valid = '1' loop

			assert read_data = expected_data report "Wrong data out_data:" &integer'image(to_integer(unsigned(read_data))) &" expected : " &integer'image(to_integer(unsigned(expected_data))) severity failure;
			expected_data <= std_ulogic_vector(unsigned(expected_data) + 1);
			wait until falling_edge(clock);
		end loop;

	end loop;

	stop <= '1';

	wait;

end process;

i_fifo : entity work.fifo
generic map
(
	g_depth_log2	=> 1
)
port map
(
	clock			=> clock,
	reset			=> reset,
	reset_sync		=> '0',

	write_data		=> write_data,
	write			=> write,
	status_empty	=> empty,

	read_data		=> read_data,
	read			=> read,
	status_full		=> full
);

-- Fill with consecutive numbers
write_data <= std_ulogic_vector(counter);
write <= not full and not reset and counter_enable(2);
process(reset, clock)
begin
	if reset = '1' then
		counter <= (others => '0');
	elsif rising_edge(clock) then
		if full = '0' and counter_enable(2) = '1' then
			counter <= counter + 1;
		end if;
	end if;
end process;

-- Read
read <= counter_enable(3) and not empty;

process(reset, clock)
begin
	if reset = '1' then
		counter_enable <= (others => '0');
	elsif rising_edge(clock) then
		counter_enable <= counter_enable + 1;
	end if;
end process;

-- Highlight data in/out when valid for debugging
d_out <= read_data when read_valid ='1' else (others => '-');
d_in <= write_data when write ='1' else (others => '-');

process(reset, clock)
begin
	if reset = '1' then
		read_valid <= '0';
	elsif rising_edge(clock) then
		read_valid <= read;
	end if;
end process;

i_clock : entity work.clock_stop
generic map
(
	frequency	=> 80.0e6
)
port map
(
	clock	=> clock,
	stop	=> stop
);

i_reset : entity work.reset
port map
(
	reset	=> reset,
	clock	=> clock
);

end bhv;
