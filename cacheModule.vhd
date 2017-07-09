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
	output: out std_logic_vector(31 downto 0)
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
	tag: in std_logic_vector(3 downto 0) ;
	w0, w1: in std_logic_vector(4 downto 0) ;
	hit, w0_valid, w1_valid: out std_logic
  );
end component;
component dataSelection is
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
component dataArray is
  port (
	clk : in std_logic;
	wren : in std_logic;
	address: in std_logic_vector(5 downto 0);
	wrdata: in std_logic_vector(31 downto 0);
	data: out std_logic_vector(31 downto 0)
  ) ;
end component;
begin


end Behavioral;

