----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:39:20 07/08/2017 
-- Design Name: 
-- Module Name:    tagValid - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tagValid is
  port (
	clk : in std_logic;
	reset_n : in std_logic;
	invalidate : in std_logic;
	wren : in std_logic;
	wrdata: in std_logic_vector(3 downto 0);
	address: in std_logic_vector(5 downto 0);
	output: out std_logic_vector(4 downto 0)
  );
end tagValid;

architecture Behavioral of tagValid is
	type tgValid is array(0 to 63) of std_logic_vector(4 downto 0);
   signal tagValid: tgValid;
begin

	output <= tagvalid(to_integer(unsigned(address)));
	process (clk)
	begin
		if clk = '1' and clk'event then
			if reset_n = '1' then
				tagValid <= (others => (others => '0') );
			elsif wren = '1' then
				tagValid(to_integer(unsigned(address))) <= not(invalidate) & wrdata;
			end if ;
		end if ;
	end process ;
end Behavioral;

