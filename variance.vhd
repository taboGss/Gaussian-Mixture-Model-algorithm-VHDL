--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity variance is
	port( variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
		  GU : in std_logic_vector(1 downto 0);
		  nk1, nk2, nk3 : in std_logic_vector(4 downto 0);
		  pixel_diff2_1, pixel_diff2_2, pixel_diff2_3 : in std_logic_vector(19 downto 0);

		  variance1_out, variance2_out, variance3_out : out std_logic_vector(10 downto 0));
end entity;

architecture variance_architecture of variance is

signal pixel_diff_selected : signed(20 downto 0);
signal variance_selected :signed(20 downto 0);

signal nk_selected : std_logic_vector(4 downto 0); -- Select the nk according to the Gaussian update (GU)
signal shift_nk : unsigned(4 downto 0); -- Shift variance according to the value of nk

signal nk_complement2 : std_logic_vector(4 downto 0);
signal diff_to_shift : signed(20 downto 0);
signal diff_shifted : signed(20 downto 0);
signal diff : signed(20 downto 0);

begin

	variance_selected <= "0000000" & signed(variance1 & "000") when (GU = "01") else
					   	 "0000000" & signed(variance2 & "000") when (GU = "10") else
					   	 "0000000" & signed(variance3 & "000");

	pixel_diff_selected <= signed('0' & pixel_diff2_1) when (GU = "01") else
						   signed('0' & pixel_diff2_2) when (GU = "10") else
						   signed('0' & pixel_diff2_3);	
	
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
							
	diff_to_shift <= pixel_diff_selected - variance_selected;
	
	diff_shifted <= shift_left(diff_to_shift, to_integer(shift_nk)) when (nk_selected(3) = '0') else
					shift_right(diff_to_shift, to_integer(shift_nk));

	diff <= diff_shifted + variance_selected;
	
	-- Outputs
	variance1_out <= std_logic_vector(diff(13 downto 3)) when (GU = "01") else
					 variance1;
	variance2_out <= std_logic_vector(diff(13 downto 3)) when (GU = "10") else
					 variance2;
	variance3_out <= std_logic_vector(diff(13 downto 3)) when (GU = "11") else
					 variance3;					  
	
end architecture; 

