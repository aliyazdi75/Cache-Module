----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:36:21 07/08/2017 
-- Design Name: 
-- Module Name:    MRU - Behavioral 
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
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MRU is
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
end MRU;

architecture Behavioral of MRU is
	type arr is array(63 downto 0) of integer;
	signal leftCtr : arr := (others => 0);
	signal rightCtr: arr := (others => 0);
begin

	process(clk)
		begin
			if clk = '1' and clk'event then
				if reset = '1' then
					leftCtr <= (others => 0);
					rightCtr <= (others => 0);
				end if;

				if leftCtr(to_integer(unsigned(address))) > rightCtr(to_integer(unsigned(address))) then
					leftUsed <= '1';
				else
					leftUsed <= '0';
				end if;

				if w0_plus = '1' then
					leftCtr(to_integer(unsigned(address))) <= leftCtr(to_integer(unsigned(address))) + 1;
				elsif w1_plus = '1' then
					rightCtr(to_integer(unsigned(address))) <= rightCtr(to_integer(unsigned(address))) + 1;
				elsif w0_reset = '1' then
					leftCtr(to_integer(unsigned(address))) <= 0;
				elsif w1_reset = '1' then
					rightCtr(to_integer(unsigned(address))) <= 0;
					
				end if;
			end if; 
		end process; 
end Behavioral;

