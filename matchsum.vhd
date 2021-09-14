--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Sciences                         
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matchsum is
	port( matchsum1, matchsum2, matchsum3 : in std_logic_vector(3 downto 0); 
		  GU, G3 : in std_logic_vector(1 downto 0);
		  weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
        
		  matchsum1_out, matchsum2_out, matchsum3_out : out std_logic_vector(3 downto 0);        
		  matchsum1_nm, matchsum2_nm, matchsum3_nm : out std_logic_vector(3 downto 0);
		  weight1_nm, weight2_nm,weight3_nm : out std_logic_vector(15 downto 0));    
end entity;

architecture matchsum_architecture of matchsum is
  
CONSTANT limit : unsigned(3 downto 0) := "1111";
signal matchsum_add_one : unsigned(3 downto 0);
signal matchsum_one, matchsum_two : unsigned(4 downto 0);
signal matchsum_selected : unsigned(3 downto 0);
signal address_msumtot : unsigned(4 downto 0);
signal weight_nm : std_logic_vector(7 downto 0);

--LUT for the calculation 1/msumtot
type memory is array(0 to 31) of std_logic_vector(7 downto 0);

CONSTANT msumtot_memory : memory :=
(
	 31 => "00001000", -- 0.03225 [0,8]
	 30 => "00001000", -- 0.03225
	 29 => "00001000", -- 0.03225
	 28 => "00001001", -- 0.03571
	 27 => "00001001", -- 0.03571
	 26 => "00001001", -- 0.03571
	 25 => "00001010", -- 0.04
	 24 => "00001010", -- 0.04
	 23 => "00001011", -- 0.04347
	 22 => "00001011", -- 0.04347
	 21 => "00001100", -- 0.04761
	 20 => "00001100", -- 0.05
	 19 => "00001101", -- 0.05263
	 18 => "00001110", -- 0.05555
	 17 => "00001111", -- 0.05882
	 16 => "00010000", -- 0.06250
	 15 => "00010001", -- 0.06666
	 14 => "00010010", -- 0.07142
	 13 => "00010011", -- 0.07692
	 12 => "00010101", -- 0.08333
	 11 => "00010111", -- 0.09090
	 10 => "00011001", -- 0.10000
	  9 => "00011100", -- 0.11111
	  8 => "00100000", -- 0.12500
	  7 => "00100100", -- 0.14285
	  6 => "00101010", -- 0.16666
	  5 => "00110011", -- 0.20000
	  4 => "01000000", -- 0.25000
	  3 => "01010101", -- 0.33333
	  2 => "10000000", -- 0.50000
	  1 => "11111111", -- 0.99999
	  0 => "11111111" -- 0.99999
); 
  
begin
  
	matchsum_selected <= unsigned(matchsum1) when (GU = "01") else
						 unsigned(matchsum2) when (GU = "10") else
						 unsigned(matchsum3);	
	
	matchsum_add_one <= (matchsum_selected + 1) when (matchsum_selected < limit) else
						 "1111";
      
	matchsum_one <= unsigned('0' & matchsum1) when (G3 = "11") else
					unsigned('0' & matchsum1) when (G3 = "10") else
					unsigned('0' & matchsum2);

	matchsum_two <= unsigned('0' & matchsum2) when (G3 = "11") else
					unsigned('0' & matchsum3) when (G3 = "10") else
					unsigned('0' & matchsum3);	

	address_msumtot <= matchsum_one + matchsum_two;          
	weight_nm <= msumtot_memory(to_integer(address_msumtot));
  		
	-- Outputs
	weight1_nm <= (weight_nm & "11111111") when (G3 = "01") else
				  weight1;
	weight2_nm <= (weight_nm & "11111111") when (G3 = "10") else
				  weight2;
	weight3_nm <= (weight_nm & "11111111") when (G3 = "11") else
				  weight3;
  					  
  	matchsum1_out <= std_logic_vector(matchsum_add_one) when (GU = "01") else
                   	 matchsum1;                  
  	matchsum2_out <= std_logic_vector(matchsum_add_one) when (GU = "10") else
                     matchsum2;        
  	matchsum3_out <= std_logic_vector(matchsum_add_one) when (GU = "11") else
                     matchsum3;
                   	
	matchsum1_nm <= "0001" when (G3 = "01") else
					matchsum1;                 
	matchsum2_nm <= "0001" when (G3 = "10") else
					matchsum2;
	matchsum3_nm <= "0001" when (G3 = "11") else
					matchsum3;
                 
end architecture;

