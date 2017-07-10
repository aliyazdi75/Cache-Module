----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:52:12 07/09/2017 
-- Design Name: 
-- Module Name:    cacheModule - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cacheModule is
  port (
		clk: in std_logic;
		readmem: in std_logic;
		writemem: in std_logic;
	  memdataready: in std_logic;
		address: in std_logic_vector(9 downto 0);
		mem_output: in std_logic_vector(15 downto 0);
		read_mem_mem: out std_logic;
		write_mem_mem: out std_logic;
		cache_output: out std_logic_vector(15 downto 0)
  );
end cacheModule;

architecture Behavioral of cacheModule is
component tagValid 
  port (
	clk : in std_logic;
	reset_n : in std_logic;
	invalidate : in std_logic;
	wren : in std_logic;
	wrdata: in std_logic_vector(3 downto 0);
	address: in std_logic_vector(5 downto 0);
	output: out std_logic_vector(4 downto 0)
  );
end component;
component memory 
	generic (blocksize : integer := 1024);

	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (9 downto 0);
		databus : inout std_logic_vector (15 downto 0);
		memdataready : out std_logic);
end component;
component missHitLogic  
  port (
	tag: in std_logic_vector(3 downto 0);
	w0: in std_logic_vector(4 downto 0);
	w1: in std_logic_vector(4 downto 0);
	hit: out std_logic;
	w0_valid: out std_logic;
	w1_valid: out std_logic
  );
end component;
component dataSelection 
  port (
	miss: in std_logic;
	w0_hit: in std_logic;
	w1_hit: in std_logic;
	w0_data: in std_logic_vector(15 downto 0);
	w1_data: in std_logic_vector(15 downto 0);
	mem_output: in std_logic_vector(15 downto 0);
	cache_output: out std_logic_vector(15 downto 0) 
  );
end component;
component dataArray 
  port (
	clk : in std_logic;
	wren : in std_logic;
	address: in std_logic_vector(5 downto 0);
	wrdata: in std_logic_vector(15 downto 0);
	data: out std_logic_vector(15 downto 0)
  ) ;
end component;
component MRU 
  port (
	clk: in std_logic;
	reset: in std_logic;
	w0_reset : in std_logic;
	w1_reset : in std_logic;
	w0_plus : in std_logic;
	w1_plus : in std_logic;
	address: in std_logic_vector(5 downto 0);
	leftUsed: out std_logic
  );
end component;
component controller 
  port (
	clk: in std_logic;
	read_mem_mem: in std_logic;
	write_mem_mem: in std_logic;
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
end component;
signal w0_reset_n, w1_reset_n, w0_invalidate, w1_invalidate, w0_wren, w1_wren,
			 hit, w0_valid, w1_valid, miss, w0_hit, w1_hit,
			 leftUsed, w0_plus, w1_plus, w0_reset, w1_reset, mru_reset : std_logic;
signal w0, w1 : std_logic_vector(4 downto 0);
signal w0_data, w1_data: std_logic_vector(15 downto 0);

begin

	aliTagValid1 : tagValid PORT MAP (clk, w0_reset_n, w0_invalidate, w0_wren, w0_wren, address(9 downto 6), address(5 downto 0), w0);

	aliTagValid2 : tagValid PORT MAP (clk, w1_reset_n, w1_invalidate, w1_wren, w1_wren, address(9 downto 6), address(5 downto 0), w1);

	aliDataArray1 : dataArray PORT MAP (clk, da0_wren, address(5 downto 0), mem_output, w0_data);

	aliDataArray2 : dataArray PORT MAP (clk, da1_wren, address(5 downto 0), mem_output, w1_data);

	aliMissHitLogic : missHitLogic PORT MAP (address(9 downto 6), w0, w1, hit, w0_valid, w1_valid);

	aliMRU : MRU PORT MAP (clk, mru_reset, w0_reset, w1_reset, w0_plus, w1_plus, address(5 downto 0), leftUsed);

  aliDataSelection : dataSelection PORT MAP (miss, w0_hit, w1_hit, w0_data, w1_data, mem_output, cache_output);

	aliController : controller PORT MAP (clk,
																			  readmem,
																			  writemem,
																			  hit,
																			  w0_valid,
																			  w1_valid,
																			  w0(4), 
																				w1(4), 
																				leftUsed, 
																				memdataready, 
																				w0_reset_n, 
																				w0_wren, 
																				w0_invalidate,
		 																		w1_reset_n, 
																				w1_wren, 
																				w1_invalidate, 
																				da0_wren, 
																				da1_wren, 
																				mru_reset, 
																				w0_plus,
		  																	w1_plus, 
																				w0_reset, 
																				w1_reset, 
																				w0_hit, 
																				w1_hit, 
																				miss, 
																				read_mem_mem, 
																				write_mem_mem
																				);

end Behavioral;

