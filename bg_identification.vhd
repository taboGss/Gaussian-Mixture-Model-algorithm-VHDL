--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bg_identification is
	port( weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
		  No_match : in std_logic;
		  G1, G2, G3 : in std_logic_vector(1 downto 0);
		  match1, match2, match3 : in std_logic; 
  
		  Fg_bg : out std_logic_vector(7 downto 0));
end entity;

architecture bg_identification_architecture of bg_identification is

CONSTANT Threshold : unsigned(15 downto 0) := "1000000000000000"; -- Threshold = 0.5
signal first_weight, second_weight, third_weight : unsigned(15 downto 0);
signal sum1_temp, sum2_temp : unsigned(15 downto 0);

signal S1, S2, S3 : std_logic;
signal match1_signal, match2_signal, match3_signal : std_logic; 
    
begin
  
	first_weight <= unsigned(weight1) when (G1 = "01") else
                    unsigned(weight2) when (G1 = "10") else
                    unsigned(weight3);
                   
  	second_weight <= unsigned(weight1) when (G2 = "01") else
                     unsigned(weight2) when (G2 = "10") else
                     unsigned(weight3);
                   
  	third_weight <= unsigned(weight1) when (G3 = "01") else
                    unsigned(weight2) when (G3 = "10") else
                    unsigned(weight3);
  
  	sum1_temp <= first_weight + second_weight;
  	sum2_temp <= sum1_temp + third_weight;
 
	S1 <= '1' when (first_weight > Threshold) else
		  '0';
  	S2 <= '1' when ((sum1_temp > Threshold) and S1 = '0') else
		  '0';
  	S3 <= '1' when ((sum2_temp > Threshold) and S1 = '0' and S2 = '0') else
		  '0';

	match1_signal <= match1 when (G1 = "01") else
					 match2 when (G1 = "10") else
					 match3;

	match2_signal <= match1 when (G2 = "01") else
					 match2 when (G2 = "10") else
					 match3;

	match3_signal <= match1 when (G3 = "01") else
					 match2 when (G3 = "10") else
					 match3;
  
  	-- Output
	fg_bg <= "11111111" when (No_match = '1') else
			 "00000000" when (S1 = '1') and (match1_signal = '1') else
			 "00000000" when (S2 = '1') and (match1_signal = '1' or match2_signal = '1') else
			 "00000000" when (S3 = '1') else
			 "11111111";
           
end architecture;

