----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:35:55 07/08/2017 
-- Design Name: 
-- Module Name:    dataArray - Behavioral 
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
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dataArray is
  port (
	clk : in std_logic;
	wren : in std_logic;
	address: in std_logic_vector(5 downto 0);
	wrdata: in std_logic_vector(31 downto 0);
	data: out std_logic_vector(31 downto 0)
  ) ;
end dataArray;

architecture Behavioral of dataArray is
	type dArr is array(0 to 63) of std_logic_vector(15 downto 0);
    signal dataarray: dArr;
begin

	process(clk)
	begin
		if clk = '1' and clk'event then
			data <= dataarray(to_integer(unsigned(address)));
			if wren = '1' then
				dataarray(to_integer(unsigned(address))) <= wrdata;
			end if ;
		end if;
	end process ;

end Behavioral;

