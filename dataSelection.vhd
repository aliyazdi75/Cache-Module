----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:48:38 07/09/2017 
-- Design Name: 
-- Module Name:    dataSelection - Behavioral 
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

entity dataSelection is
  port (
	w0_data, w1_data, mem_output: in std_logic_vector(15 downto 0);
	w0_hit, w1_hit, miss: in std_logic;
	cache_output: out std_logic_vector(15 downto 0) 
  );
end dataSelection;

architecture Behavioral of dataSelection is

begin

	cache_output <= w0_data when w0_hit = '1' else
						w1_data when w1_hit = '1' else
						mem_output when miss = '1' else
						"ZZZZZZZZZZZZZZZZ";
	
end Behavioral;

