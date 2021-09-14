--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mean is
	port( mean1, mean2, mean3 : in std_logic_vector(9 downto 0);
		  GU : in std_logic_vector(1 downto 0);
		  nk1, nk2, nk3 : in std_logic_vector(4 downto 0);
		  pixel_diff1, pixel_diff2, pixel_diff3 : in std_logic_vector(10 downto 0);

		  mean1_out, mean2_out, mean3_out : out std_logic_vector(9 downto 0));
end entity;

architecture mean_architecture of mean is

signal diff : signed(10 downto 0);
signal mean_selected : signed(10 downto 0);

signal nk_selected : std_logic_vector(4 downto 0); -- Select the nk value according to the Gaussian update (GU)
signal shift_nk : unsigned(4 downto 0); 
signal nk_complement2 : std_logic_vector(4 downto 0);

signal diff_to_shift : signed(10 downto 0);
signal diff_shifted : signed(10 downto 0);

begin

	nk_selected <= nk1 when (GU = "01") else
				   nk2 when (GU = "10") else
				   nk3;
						
	shift_nk <= unsigned(nk_selected) when (nk_selected(3) = '0') else
				unsigned(nk_complement2);
	
	--  If nk is negative. Calculate the complement 2
	nk_complement2 <= "00001" when (nk_selected = "11111") else -- -1.0 -> 1.0
					  "00010" when (nk_selected = "11110") else -- -2.0 -> 2.0
					  "00011" when (nk_selected = "11101") else -- -3.0 -> 3.0
					  "00100" when (nk_selected = "11100") else -- -4.0 -> 4.0
					  "00101" when (nk_selected = "11011") else -- -5.0 -> 5.0
					  "00110" when (nk_selected = "11010") else -- -6.0 -> 6.0
					  "00111" when (nk_selected = "11001") else -- -7.0 -> 7.0
					  "01000" when (nk_selected = "11000") else -- -8.0 -> 8.0
					  "01001" when (nk_selected = "10111") else -- -9.0 -> 9.0
					  "00000";
							 	
	diff_to_shift <= signed(pixel_diff1) when (GU = "01") else
					 signed(pixel_diff2) when (GU = "10") else
					 signed(pixel_diff3);
	
	diff_shifted <= shift_left(diff_to_shift, to_integer(shift_nk)) when (nk_selected(3) = '0') else
					shift_right(diff_to_shift, to_integer(shift_nk));
	
	mean_selected <= signed('0' & mean1) when (GU = "01") else
					 signed('0' & mean2) when (GU = "10") else
					 signed('0' & mean3);
	
	diff <= mean_selected + diff_shifted;
	
	-- Outputs
	mean1_out <= std_logic_vector(diff(9 downto 0)) when (GU = "01") else
				 mean1;
	mean2_out <= std_logic_vector(diff(9 downto 0)) when (GU = "10") else
				 mean2;
	mean3_out <= std_logic_vector(diff(9 downto 0)) when (GU = "11") else
				 mean3;
	
end architecture; 

