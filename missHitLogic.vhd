----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:37:13 07/08/2017 
-- Design Name: 
-- Module Name:    missHitLogic - Behavioral 
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

entity missHitLogic is
  port (
	tag: in std_logic_vector(3 downto 0) ;
	w0, w1: in std_logic_vector(4 downto 0) ;
	hit, w0_valid, w1_valid: out std_logic
  ) ;
end missHitLogic;

architecture Behavioral of missHitLogic is

begin

	w0_valid <= '1' when tag = w0(3 downto 0) and w0(4) = '1' else
	'0';

	w1_valid <= '1' when tag = w1(3 downto 0) and w1(4) = '1' else
	'0';
	
	hit <= w0_valid or w1_valid;

end Behavioral;

