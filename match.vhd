--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity match is 
	port( variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
		  mean1, mean2, mean3 : in std_logic_vector(9 downto 0);
		  pixel : in std_logic_vector(7 downto 0);
        
		  match1, match2, match3 : out std_logic;
		  pixel_diff1, pixel_diff2, pixel_diff3 : out std_logic_vector(10 downto 0);
		  pixel_diff2_1, pixel_diff2_2, pixel_diff2_3 : out std_logic_vector(19 downto 0));
end entity;

architecture match_architecture of match is
  
CONSTANT lambda : unsigned(5 downto 0) := "0110" & "01"; -- Lambda = 6.25
signal sig_diff1, sig_diff2, sig_diff3 : signed(10 downto 0); -- Mean minus pixel
signal sig_diff2_1, sig_diff2_2, sig_diff2_3 : unsigned(21 downto 0); -- Mean minus pixel squared
signal condition1, condition2, condition3 : unsigned(21 downto 0); -- Match condition for each gaussian
   
begin
  
	sig_diff1 <= ('0' & signed(pixel)&"00") - ('0' & signed(mean1)); -- mean minus pixel
	sig_diff2 <= ('0' & signed(pixel)&"00") - ('0' & signed(mean2));
	sig_diff3 <= ('0' & signed(pixel)&"00") - ('0' & signed(mean3));
    
	sig_diff2_1 <= unsigned(sig_diff1 * sig_diff1); -- Mean minus the pixel to square
	sig_diff2_2 <= unsigned(sig_diff2 * sig_diff2);
	sig_diff2_3 <= unsigned(sig_diff3 * sig_diff3);
  
	condition1 <= lambda * unsigned("0000" & variance1 & '0'); -- Match condition for each gaussian
	condition2 <= lambda * unsigned("0000" & variance2 & '0');
	condition3 <= lambda * unsigned("0000" & variance3 & '0');

	-- Outputs	
	pixel_diff1 <= std_logic_vector(sig_diff1); 
	pixel_diff2 <= std_logic_vector(sig_diff2);
	pixel_diff3 <= std_logic_vector(sig_diff3);

	pixel_diff2_1 <= std_logic_vector(sig_diff2_1(19 downto 0));
	pixel_diff2_2 <= std_logic_vector(sig_diff2_2(19 downto 0));
	pixel_diff2_3 <= std_logic_vector(sig_diff2_3(19 downto 0));
  
	match1 <= '1' when (sig_diff2_1 < condition1) else -- Check condition
			  '0';
	match2 <= '1' when (sig_diff2_2 < condition2) else
			  '0';
	match3 <= '1' when (sig_diff2_3 < condition3) else
			  '0';
  
end architecture;

