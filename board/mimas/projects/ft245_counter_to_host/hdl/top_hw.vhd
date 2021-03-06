-----------------------------------------------------------------------------
-- file			: top_hw.vhd
--
-- brief		: Top hardware
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

entity top_mimas_ft245_counter_hw is
	port
	(
		-- Mimas
		clk				: in	std_ulogic;
		sw				: in	std_ulogic_vector(3 downto 0);
		led				: out	std_ulogic_vector(7 downto 0);

		-- FT2232h
		FT_CLKOUT		: in	std_ulogic;
		FT_DATA			: inout	std_logic_vector(7 downto 0);
		FT_nRESET		: out	std_ulogic;
		FT_nTXE			: in	std_ulogic;
		FT_nRXF			: in	std_ulogic;
		FT_nWR			: out	std_ulogic;
		FT_nRD			: out	std_ulogic;
		FT_SIWUA		: out	std_ulogic;
		FT_nOE			: out	std_ulogic;
		FT_nSUSPEND		: in	std_ulogic
	);
end entity;

architecture bhv of top_mimas_ft245_counter_hw is
begin

i_top : entity work.top_mimas_ft245_counter
port map
(
	-- Interface to the ftdi chip
	adbus			=> FT_DATA,
	rxf_n			=> FT_nRXF,
	txe_n			=> FT_nTXE,
	rd_n			=> FT_nRD,
	wr_n			=> FT_nWR,
	clkout			=> FT_CLKOUT,
	oe_n			=> FT_nOE,
	siwu			=> FT_SIWUA,
	reset_n			=> FT_nRESET,
	suspend_n		=> FT_nSUSPEND,

	reset			=> '0',

	led				=> led
);

end architecture;
