-----------------------------------------------------------------------------
-- file			: reset.vhd
--
-- brief		: Reset generators for common hardware
-- author(s)	: marc at pignat dot org
-----------------------------------------------------------------------------
-- Copyright 2015-2019 Marc Pignat
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

-- simple reset for RAM based FPGA
entity reset_for_ram_fpga is
	port
	(
		clock : in		std_ulogic;
		reset : out		std_ulogic := '1'
	);
end reset_for_ram_fpga;

architecture rtl of reset_for_ram_fpga is
	signal counter	: unsigned(1 downto 0) := (others => '0');
begin

reset_gen: process(clock)
begin
	if rising_edge(clock) then
		if counter /= "11" then
			reset <= '1';
			counter <= counter + 1;
		else
			counter <= counter;
			reset <= '0';
		end if;
	end if;
end process;

end architecture rtl;
