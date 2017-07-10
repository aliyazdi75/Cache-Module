--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:36:03 07/10/2017
-- Design Name:   
-- Module Name:   D:/Ali Yazdi/Documents/GitHub/Cache-Module/cacheTB.vhd
-- Project Name:  Cache-Module
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cacheModule
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cacheTB IS
END cacheTB;
 
ARCHITECTURE behavior OF cacheTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cacheModule
    PORT(
         clk : IN  std_logic;
         readmem : IN  std_logic;
         writemem : IN  std_logic;
         address : IN  std_logic_vector(9 downto 0);
         cache_output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal readmem : std_logic := '0';
   signal writemem : std_logic := '0';
   signal address : std_logic_vector(9 downto 0) := (others => '0');

 	--Outputs
   signal cache_output : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cacheModule PORT MAP (
          clk => clk,
          readmem => readmem,
          writemem => writemem,
          address => address,
          cache_output => cache_output
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
