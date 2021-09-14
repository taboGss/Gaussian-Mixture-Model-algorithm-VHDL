--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity weight is 
	port( weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
		  GU : in std_logic_vector(1 downto 0);

		  weight1_out, weight2_out, weight3_out : out std_logic_vector(15 downto 0));
end entity;

architecture weight_architecture of weight is 
 
CONSTANT alpha_w  : unsigned(15 downto 0) := "0000000010000000"; -- alphaw = 0.001953125

signal shift1, shift2, shift3 : std_logic_vector(15 downto 0);
signal diff1, diff2, diff3 : unsigned(15 downto 0); 
signal weight_selected : unsigned(15 downto 0);
signal weight_GU : std_logic_vector(15 downto 0);

begin

	shift1 <= "000000000" & weight1(15 downto 9);
	shift2 <= "000000000" & weight2(15 downto 9);
	shift3 <= "000000000" & weight3(15 downto 9); 
 

 	diff1 <= unsigned(weight1) - unsigned(shift1);
 	diff2 <= unsigned(weight2) - unsigned(shift2);
 	diff3 <= unsigned(weight3) - unsigned(shift3);

	weight_selected <= diff1 when (GU = "01") else
					   diff2 when (GU = "10") else
					   diff3 when (GU = "11") else
					  (others=>'0');
	
	weight_GU <= std_logic_vector(weight_selected + alpha_w);
	
	-- Outputs
	weight1_out <= weight_GU when (GU = "01") else
				   std_logic_vector(diff1);
	weight2_out <= weight_GU when (GU = "10") else
				   std_logic_vector(diff2);
	weight3_out <= weight_GU when (GU = "11") else
				   std_logic_vector(diff3);

end architecture;

