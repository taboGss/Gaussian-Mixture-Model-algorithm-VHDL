--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFitness is
	port( nk1, nk2, nk3 : in std_logic_vector(4 downto 0);
		  variance1, variance2, variance3 : in std_logic_vector(10 downto 0);

		  IFitness1, IFitness2, IFitness3 : out std_logic_vector(26 downto 0));
end entity;

architecture IFitness_architecture of IFitness is

CONSTANT nw : signed(4 downto 0) := "10111"; -- log2(alphaw) = log2(2^-9) = -9.0

signal diff1, diff2, diff3 : signed(4 downto 0);
signal shift1, shift2, shift3 : signed(4 downto 0);
signal shiftIFitness1, shiftIFitness2, shiftIFitness3 : unsigned(26 downto 0);

begin

	-- Calculate (nk,t - nw) and multiply it by 2	
	diff1 <= (signed(nk1) - nw); shift1 <= diff1(3 downto 0) & '0'; 
	diff2 <= (signed(nk2) - nw); shift2 <= diff2(3 downto 0) & '0';
	diff3 <= (signed(nk3) - nw); shift3 <= diff3(3 downto 0) & '0';

	shiftIFitness1 <= shift_left(unsigned("0000000000000000" & variance1), to_integer(unsigned(shift1)));
	shiftIFitness2 <= shift_left(unsigned("0000000000000000" & variance2), to_integer(unsigned(shift2)));
	shiftIFitness3 <= shift_left(unsigned("0000000000000000" & variance3), to_integer(unsigned(shift3)));	
	
	-- Outputs
	IFitness1 <= std_logic_vector(shiftIFitness1);
	IFitness2 <= std_logic_vector(shiftIFitness2);
	IFitness3 <= std_logic_vector(shiftIFitness3);

end architecture;

