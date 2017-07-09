----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:35:33 07/08/2017 
-- Design Name: 
-- Module Name:    controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
  port (
	clk: in std_logic;
	readmem: in std_logic;
	writemem: in std_logic;
	hit: in std_logic;
	w0_validate: in std_logic;
	w1_validate: in std_logic;
	tv0_validate: in std_logic;
	tv1_validate: in std_logic;
	is_left_greaterthan_right: in std_logic;
	
	memdataready: in std_logic;
	tv0_reset_n: out std_logic;
	tv0_wren: out std_logic;
	tv0_invalidate: out std_logic;
	tv1_reset_n: out std_logic;
	tv1_wren: out std_logic;
	tv1_invalidate: out std_logic;
	data_array0_wren: out std_logic;
	data_array1_wren: out std_logic;
	mru_reset: out std_logic;
	w0_plus: out std_logic;
	w1_plus: out std_logic;
	w0_reset: out std_logic;
	w1_reset : out std_logic;
	ds_w0_hit: out std_logic;
	ds_w1_hit: out std_logic;
	ds_miss: out std_logic;
	readmemtomem: out std_logic;
	writememtomem: out std_logic
  );
end controller;

architecture Behavioral of controller is
	type state is (reset1, reset2 , wait_s, read_s, read_s_hitormiss, write_s,write_to_cache, write_s_hitormiss);
	signal current_state : state := reset1 ;
	signal next_state : state;

begin
	process (clk)
	begin
		if clk = '1' and clk'event then
			current_state <= next_state;
		end if ;
	end process ; 

	process(current_state, memdataready, readmem, writemem)
	begin 
	if not falling_edge(memdataready)and not falling_edge(readmem) and not falling_edge(writemem) then
		
	
		tv0_reset_n <= '0';
		tv0_wren <= '0';
		tv0_invalidate <= '0';
		tv1_reset_n <= '0';
		tv1_wren <= '0';
		tv1_invalidate <= '0';
		data_array0_wren <= '0';
		data_array1_wren <= '0';
		mru_reset <= '0';
		w0_plus <= '0';
		w1_plus <= '0';
		w0_reset <= '0';
		w1_reset <= '0';
		ds_w0_hit <= '0';
		ds_w1_hit <= '0';
		ds_miss <= '0';
		readmemtomem <= '0';
		writememtomem <= '0';

	case current_state is
	
		when reset1 =>
			tv1_reset_n <= '1';
			tv0_reset_n <= '1';
			mru_reset <= '1';
			next_state <= reset2;

		when reset2 =>
			tv1_reset_n <= '1';
			tv0_reset_n <= '1';
			mru_reset <= '1';
			next_state <= wait_s;

		when wait_s =>
			if readmem = '1' then
				next_state <= read_s_hitormiss;

			elsif writemem = '1' then
				next_state <= write_s;
			else
				next_state <= wait_s;
			end if ;

		when read_s_hitormiss =>
			if hit = '1' then
					if w0_validate = '1' then
						ds_w0_hit <= '1';
						w0_plus <='1';
					elsif w1_validate = '1' then
						ds_w1_hit <= '1';
						w1_plus <= '1';
					end if ;
					next_state <= wait_s;
				else
					next_state <= read_s;
				end if ;

		when read_s => 
			readmemtomem <= '1';
			if memdataready = '1' then
				next_state <= write_to_cache;
				

			else
				next_state <= read_s;
			end if ;


		when write_to_cache =>
			if tv0_validate = '0' then
					tv0_wren <= '1';
					tv0_invalidate <= '0';
					data_array0_wren <= '1';
				elsif tv1_validate = '0' then
					tv1_wren <= '1';
					tv1_invalidate <= '0';
					data_array1_wren <= '1';
				elsif is_left_greaterthan_right = '1' then
					tv0_wren <= '1';
					tv0_invalidate <= '0';
					data_array0_wren <= '1';
					w0_reset <= '1';
				elsif is_left_greaterthan_right = '0' then
					tv1_wren <= '1';
					tv1_invalidate <= '0';
					data_array1_wren <= '1';
					w1_reset  <= '1';
				end if ;
				ds_miss <= '1';
				next_state <= wait_s;

		when write_s =>
			writememtomem <= '1';
			if memdataready = '1' then
				next_state <= write_s_hitormiss;
			else
				next_state <= write_s;
			end if ;

		when write_s_hitormiss =>
			if hit = '1' then
					if w0_validate = '1' then
						tv0_invalidate <= '1';
						w0_reset <= '1';
					else
						tv1_invalidate <= '1';
						w1_reset <= '1';
					end if ;
				end if ;
				next_state <= wait_s;

		when others =>
	
	end case ;
	end if ;
	end process ;

begin


end Behavioral;

