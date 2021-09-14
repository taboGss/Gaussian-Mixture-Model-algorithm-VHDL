--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;

entity Nomatch is
	port( variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
		  mean1, mean2, mean3 : in std_logic_vector(9 downto 0);
		  pixel : in std_logic_vector(7 downto 0);
		  G3 : in std_logic_vector(1 downto 0);
        
		  variance1_nm, variance2_nm, variance3_nm : out std_logic_vector(10 downto 0);
		  mean1_nm, mean2_nm, mean3_nm : out std_logic_vector(9 downto 0));
end entity;

architecture Nomatch_architecture of Nomatch is 
CONSTANT var_init : std_logic_vector(10 downto 0) := "01100100000"; -- initial variance 400 
  
begin

	mean1_nm <= pixel & "00" when (G3 = "01") else
				mean1;
	mean2_nm <= pixel & "00" when (G3 = "10") else
				mean2;
	mean3_nm <= pixel & "00" when (G3 = "11") else
				mean3;
              
	variance1_nm <= var_init when (G3 = "01") else
					variance1;
	variance2_nm <= var_init when (G3 = "10") else
					variance2;
	variance3_nm <= var_init when (G3 = "11") else
					variance3;

end architecture;

