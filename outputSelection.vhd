--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;

entity outputSelection is
	port( matchsum1_nm, matchsum2_nm, matchsum3_nm : in std_logic_vector(3 downto 0);
		  weight1_nm, weight2_nm, weight3_nm : in std_logic_vector(15 downto 0);
		  mean1_nm, mean2_nm, mean3_nm : in std_logic_vector(9 downto 0);
		  variance1_nm, variance2_nm, variance3_nm : in std_logic_vector(10 downto 0);
	      
		  variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
		  mean1, mean2, mean3 : in std_logic_vector(9 downto 0);
		  weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
		  matchsum1, matchsum2, matchsum3 : in std_logic_vector(3 downto 0);
	     
		  No_match : in std_logic;
	     
		  weight1_out, weight2_out, weight3_out : out std_logic_vector(15 downto 0);
		  mean1_out, mean2_out, mean3_out : out std_logic_vector(9 downto 0);
		  variance1_out, variance2_out, variance3_out : out std_logic_vector(10 downto 0);
		  matchsum1_out, matchsum2_out, matchsum3_out : out std_logic_vector(3 downto 0));
end entity;

architecture OutputSelection_architecture of OutputSelection is
begin

	-- Matcshum's outputs
	matchsum1_out <= matchsum1_nm when (No_match = '1') else
					 matchsum1;
	matchsum2_out <= matchsum2_nm when (No_match = '1') else
					 matchsum2;
	matchsum3_out <= matchsum3_nm when (No_match = '1') else
					 matchsum3;
	
	-- Mean's outputs
	mean1_out <= mean1_nm when (No_match = '1') else
				 mean1;
	mean2_out <= mean2_nm when (No_match = '1') else
				 mean2;
	mean3_out <= mean3_nm when (No_match = '1') else
				 mean3;

 	-- Variance's outputs
	variance1_out <= variance1_nm when (No_match = '1') else
					 variance1;
	variance2_out <= variance2_nm when (No_match = '1') else
					 variance2;
	variance3_out <= variance3_nm when (No_match = '1') else
					 variance3;

 	-- Weight's outputs
	weight1_out <= weight1_nm when (No_match = '1') else
				   weight1;
	weight2_out <= weight2_nm when (No_match = '1') else
				   weight2;
	weight3_out <= weight3_nm when (No_match = '1') else
				   weight3;

end architecture;

