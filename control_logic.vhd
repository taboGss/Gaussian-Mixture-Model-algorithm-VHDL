--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_logic is
	port( match1, match2, match3 : in std_logic;
		  IFitness1, IFitness2, IFitness3 : in std_logic_vector(26 downto 0);
  
		  G1, G2, G3, GU : out std_logic_vector(1 downto 0);
		  No_match : out std_logic);
end entity;

architecture control_logic_architecture of control_logic is
  
signal IFitness_G1, IFitness_G2, IFitness_G3 : signed(27 downto 0);

signal G1_compared_to_G2, G2_compared_to_G3, G1_compared_to_G3 : std_logic;  
signal gauss_control : std_logic_vector(2 downto 0);
signal G1_temp, G2_temp, G3_temp : std_logic_vector(1 downto 0);

  
begin
	 
  	IFitness_G1 <= '0' & signed(IFitness1);
  	IFitness_G2 <= '0' & signed(IFitness2);
  	IFitness_G3 <= '0' & signed(IFitness3);
              
	G1_compared_to_G2 <= '1' when (IFitness_G1 <= IFitness_G2) else
						 '0';        
	G2_compared_to_G3 <= '1' when (IFitness_G2 <= IFitness_G3) else
						 '0';
	G1_compared_to_G3 <= '1' when (IFitness_G1 <= IFitness_G3) else
						 '0';
          
	gauss_control <= G1_compared_to_G2 & G2_compared_to_G3 & G1_compared_to_G3;
	
	with gauss_control select G1_temp <=
		"11" when "000"|"100",
		"10" when "010"|"011",
		"01" when "111"|"101",
		"00" when others;
		
	with gauss_control select G2_temp <=
		"11" when "010"|"101",
		"10" when "000"|"111",
		"01" when "100"|"011",
		"00" when others;
	
	with gauss_control select G3_temp <=
		"11" when "011"|"111",
		"10" when "100"|"101",
		"01" when "000"|"010",
		"00" when others;
	
	GU <= G1_temp when (G1_temp = "01" and match1 = '1') else
		  G1_temp when (G1_temp = "10" and match2 = '1') else
		  G1_temp when (G1_temp = "11" and match3 = '1') else
		  G2_temp when (G2_temp = "01" and match1 = '1') else
		  G2_temp when (G2_temp = "10" and match2 = '1') else
		  G2_temp when (G2_temp = "11" and match3 = '1') else
		  G3_temp when (G3_temp = "01" and match1 = '1') else
		  G3_temp when (G3_temp = "10" and match2 = '1') else
		  G3_temp when (G3_temp = "11" and match3 = '1');
				
	-- Outputs	
	G1 <= G1_temp;
	G2 <= G2_temp;
	G3 <= G3_temp;

	No_match <= not(match1 or match2 or match3);
	
end architecture;

