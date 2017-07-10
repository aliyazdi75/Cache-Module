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
	w0_valid: in std_logic;
	w1_valid: in std_logic;
	w0: in std_logic;
	w1: in std_logic;
	leftUsed: in std_logic;	
	memdataready: in std_logic;
	
	w0_reset_n: out std_logic;
	w0_wren: out std_logic;
	w0_invalidate: out std_logic;
	w1_reset_n: out std_logic;
	w1_wren: out std_logic;
	w1_invalidate: out std_logic;
	
	da0_wren: out std_logic;
	da1_wren: out std_logic;
	mru_reset: out std_logic;
	
	w0_plus: out std_logic;
	w1_plus: out std_logic;
	w0_reset: out std_logic;
	w1_reset : out std_logic;
	w0_hit: out std_logic;
	w1_hit: out std_logic;
	miss: out std_logic;

	read_mem_mem: out std_logic;
	write_mem_mem: out std_logic
  );
end controller;

architecture Behavioral of controller is
	type state is (SRst0,SRst1,
					 SMem,
					 SReadmem,
					 SHitMiss, 
					 SWritemem,
					 SWritecache, 
					 SWMHitMiss);
	signal current_state : state := SRst0;
	signal next_state : state;

begin
	process (clk)
	begin
		if rising_edge(clk) then
			current_state <= next_state;
		end if ;
	end process ; 

	process(current_state, readmem, writemem, memdataready)
	begin 
		if not(falling_edge(readmem)) and not(falling_edge(writemem))
			and not(falling_edge(memdataready)) then	

			w0_reset_n <= '0';
			w0_wren <= '0';
			w0_invalidate <= '0';
			w1_reset_n <= '0';
			w1_wren <= '0';
			w1_invalidate <= '0';
			da0_wren <= '0';
			da1_wren <= '0';
			mru_reset <= '0';
			w0_plus <= '0';
			w1_plus <= '0';
			w0_reset <= '0';
			w1_reset <= '0';
			w0_hit <= '0';
			w1_hit <= '0';
			miss <= '0';
			read_mem_mem <= '0';
			write_mem_mem <= '0';
			
			case current_state is	
				when SRst0 =>
					mru_reset <= '1';
					w1_reset_n <= '1';
					w0_reset_n <= '1';
					next_state <= SRst1;

				when SRst1 =>
					mru_reset <= '1';
					w1_reset_n <= '1';
					w0_reset_n <= '1';
					next_state <= SMem;

				when SReadmem => 
					read_mem_mem <= '1';
					if memdataready = '0' then
						next_state <= SReadmem;			
					else
						next_state <= SWritecache;
					end if;

				when SMem =>
					if readmem = '1' then
						next_state <= SHitMiss;
					elsif writemem = '1' then
						next_state <= SWritemem;
					else
						next_state <= SMem;
					end if;

				when SHitMiss =>
					if hit = '1' then
						if w1_valid = '1' then
							w1_plus <= '1';
							w1_hit <= '1';
						elsif w0_valid = '1' then
							w0_plus <='1';
							w0_hit <= '1';
						end if;
						next_state <= SMem;
					else
						next_state <= SReadmem;
					end if;

				when SWritemem =>
					write_mem_mem <= '1';
					if memdataready = '0' then
						next_state <= SWritemem;
					else
						next_state <= SWMHitMiss;
					end if;

				when SWMHitMiss =>
					if hit = '1' then
						if w0_valid = '1' then
							w0_reset <= '1';
							w0_invalidate <= '1';
						else
							w1_reset <= '1';
							w1_invalidate <= '1';
						end if;
					end if;
					next_state <= SMem;

				when SWritecache =>
					if w0 = '0' then
						w0_wren <= '1';
						da0_wren <= '1';
						w0_invalidate <= '0';
					elsif w1 = '0' then
						w1_wren <= '1';
						da1_wren <= '1';
						w1_invalidate <= '0';
					elsif leftUsed = '1' then
						w0_wren <= '1';
						w0_reset <= '1';
						da0_wren <= '1';
						w0_invalidate <= '0';
					elsif leftUsed = '0' then
						w1_wren <= '1';
						w1_reset  <= '1';
						da1_wren <= '1';
						w1_invalidate <= '0';
					end if ;
					miss <= '1';
					next_state <= SMem;

				when others => null;
			
			end case ;
		end if ;
	end process ;
end Behavioral;

