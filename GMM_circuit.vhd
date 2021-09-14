--**********************************************
-- 	UNIVERSIDAD AUTONOMA DE SAN LUIS POTOSI  
-- 	School of Science                          
-- 	Author: Octavio Torres Delgado           
--**********************************************

library ieee;
use ieee.std_logic_1164.all;

entity GMM_circuit is
	port( matchsum1, matchsum2, matchsum3 : in std_logic_vector(3 downto 0);
		  weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
		  variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
		  mean1, mean2, mean3 : std_logic_vector(9 downto 0);
		  pixel : std_logic_vector(7 downto 0);
			
		  matchsum1_out, matchsum2_out, matchsum3_out : out std_logic_vector(3 downto 0);
		  weight1_out, weight2_out, weight3_out : out std_logic_vector(15 downto 0); 
	  	  variance1_out, variance2_out, variance3_out : out std_logic_vector(10 downto 0);
		  mean1_out, mean2_out, mean3_out : out std_logic_vector(9 downto 0);
		  Fg_bg : out std_logic_vector(7 downto 0));
end entity;

architecture GMM_circuit_architecture of GMM_circuit is

-- learning rates's signals
signal nk1_signal, nk2_signal, nk3_signal : std_logic_vector(4 downto 0); 

-- Match's signals
signal match1_signal, match2_signal, match3_signal : std_logic;
signal pixel_diff1_signal, pixel_diff2_signal, pixel_diff3_signal : std_logic_vector(10 downto 0);
signal pixel_diff2_1_signal, pixel_diff2_2_signal, pixel_diff2_3_signal : std_logic_vector(19 downto 0);

-- IFitness's signals
signal IFitness1_signal, IFitness2_signal, IFitness3_signal : std_logic_vector(26 downto 0);

-- control_logic's signals
signal GU_signal, G1_signal, G2_signal, G3_signal : std_logic_vector(1 downto 0);
signal No_match_signal : std_logic;

-- matchsum's signals
signal matchsum1_out_signal, matchsum2_out_signal, matchsum3_out_signal : std_logic_vector(3 downto 0); 
signal matchsum1_nm_signal, matchsum2_nm_signal, matchsum3_nm_signal : std_logic_vector(3 downto 0);
signal weight1_nm_signal, weight2_nm_signal, weight3_nm_signal : std_logic_vector(15 downto 0);

-- No_match's signals
signal variance1_nm_signal, variance2_nm_signal, variance3_nm_signal : std_logic_vector(10 downto 0);
signal mean1_nm_signal, mean2_nm_signal, mean3_nm_signal : std_logic_vector(9 downto 0); 

-- variance's signals
signal variance1_out_signal, variance2_out_signal, variance3_out_signal : std_logic_vector(10 downto 0); 

-- mean's signals
signal mean1_out_signal, mean2_out_signal, mean3_out_signal : std_logic_vector(9 downto 0);

-- weight's signals
signal weight1_out_signal, weight2_out_signal, weight3_out_signal : std_logic_vector(15 downto 0);

component learningRates is
  port( weight1 : in std_logic_vector(15 downto 0);
        weight2 : in std_logic_vector(15 downto 0);
        weight3 : in std_logic_vector(15 downto 0);  
  
        nk1 : out std_logic_vector(4 downto 0);
        nk2 : out std_logic_vector(4 downto 0);
        nk3 : out std_logic_vector(4 downto 0));
end component;

component match is 
  port( variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
        mean1, mean2, mean3 : in std_logic_vector(9 downto 0);
        pixel : in std_logic_vector(7 downto 0);
        
        match1, match2, match3 : out std_logic;
        pixel_diff1, pixel_diff2, pixel_diff3 : out std_logic_vector(10 downto 0);
        pixel_diff2_1, pixel_diff2_2, pixel_diff2_3 : out std_logic_vector(19 downto 0));
end component;

component IFitness is
 port( nk1, nk2, nk3 : in std_logic_vector(4 downto 0);
       variance1, variance2, variance3 : in std_logic_vector(10 downto 0);

	   IFitness1, IFitness2, IFitness3 : out std_logic_vector(26 downto 0));
end component;

component control_logic is
  port( match1, match2, match3 : in std_logic;
        IFitness1, IFitness2, IFitness3 : in std_logic_vector(26 downto 0);
  
        G1, G2, G3, GU : out std_logic_vector(1 downto 0);
        No_match : out std_logic);
end component;

component matchsum is
  port( matchsum1, matchsum2, matchsum3 : in std_logic_vector(3 downto 0); 
        GU, G3 : in std_logic_vector(1 downto 0);
        weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
        
        matchsum1_out, matchsum2_out, matchsum3_out : out std_logic_vector(3 downto 0);        
        matchsum1_nm, matchsum2_nm, matchsum3_nm : out std_logic_vector(3 downto 0);
        weight1_nm, weight2_nm,weight3_nm : out std_logic_vector(15 downto 0));    
end component;

component Nomatch is
  port( variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
        mean1, mean2, mean3 : in std_logic_vector(9 downto 0);
        pixel : in std_logic_vector(7 downto 0);
        G3 : in std_logic_vector(1 downto 0);
        
        variance1_nm, variance2_nm, variance3_nm : out std_logic_vector(10 downto 0);
        mean1_nm, mean2_nm, mean3_nm : out std_logic_vector(9 downto 0));
end component;

component variance is
	port( variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
	      GU : in std_logic_vector(1 downto 0);
	      nk1, nk2, nk3 : in std_logic_vector(4 downto 0);
	      pixel_diff2_1, pixel_diff2_2, pixel_diff2_3 : in std_logic_vector(19 downto 0);

	      variance1_out, variance2_out, variance3_out : out std_logic_vector(10 downto 0));
end component;

component mean is
	port( mean1,mean2,mean3 : in std_logic_vector(9 downto 0);
	      GU : in std_logic_vector(1 downto 0);
	      nk1, nk2, nk3 : in std_logic_vector(4 downto 0);
	      pixel_diff1, pixel_diff2, pixel_diff3 : in std_logic_vector(10 downto 0);

	      mean1_out, mean2_out, mean3_out : out std_logic_vector(9 downto 0));
end component;

component weight is 
	port( weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
         GU : in std_logic_vector(1 downto 0);

	      weight1_out, weight2_out, weight3_out : out std_logic_vector(15 downto 0));
end component;

component OutputSelection is
	port( matchsum1_nm, matchsum2_nm, matchsum3_nm : in std_logic_vector(3 downto 0);
	      matchsum1, matchsum2, matchsum3 : in std_logic_vector(3 downto 0);
	      weight1_nm, weight2_nm, weight3_nm : in std_logic_vector(15 downto 0);
	      
	      mean1_nm, mean2_nm, mean3_nm : in std_logic_vector(9 downto 0);
	      variance1_nm, variance2_nm, variance3_nm : in std_logic_vector(10 downto 0);
	      
	      variance1, variance2, variance3 : in std_logic_vector(10 downto 0);
	      mean1, mean2, mean3 : in std_logic_vector(9 downto 0);
	      weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
	     
	      No_match : in std_logic;
	     
	      weight1_out, weight2_out, weight3_out : out std_logic_vector(15 downto 0);
	      mean1_out, mean2_out, mean3_out : out std_logic_vector(9 downto 0);
	      variance1_out, variance2_out, variance3_out : out std_logic_vector(10 downto 0);
	      matchsum1_out, matchsum2_out, matchsum3_out : out std_logic_vector(3 downto 0));
end component;

component bg_identification is
  port( weight1, weight2, weight3 : in std_logic_vector(15 downto 0);
        No_match : in std_logic;
        G1, G2, G3 : in std_logic_vector(1 downto 0);
		match1, match2, match3 : in std_logic;
  
        Fg_bg : out std_logic_vector(7 downto 0));
end component;

begin

	learningRates_unit : learningRates
		port map(weight1=>weight1, weight2=>weight2, weight3=>weight3,
					nk1=>nk1_signal, nk2=>nk2_signal, nk3=>nk3_signal);
	
	match_unit : match
		port map(variance1=>variance1, variance2=>variance2, variance3=>variance3,
					mean1=>mean1, mean2=>mean2, mean3=>mean3,
					pixel=>pixel,
					match1=>match1_signal, match2=>match2_signal, match3=>match3_signal,
					pixel_diff1=>pixel_diff1_signal, pixel_diff2=>pixel_diff2_signal, pixel_diff3=>pixel_diff3_signal,
					pixel_diff2_1=>pixel_diff2_1_signal, pixel_diff2_2=>pixel_diff2_2_signal, pixel_diff2_3=>pixel_diff2_3_signal);
	
	IFitness_unit : IFitness
		port map(nk1=>nk1_signal, nk2=>nk2_signal, nk3=>nk3_signal,
					variance1=>variance1, variance2=>variance2, variance3=>variance3,
					IFitness1=>IFitness1_signal, IFitness2=>IFitness2_signal, IFitness3=>IFitness3_signal);
	
	control_logic_unit : control_logic
		port map(match1=>match1_signal, match2=>match2_signal, match3=>match3_signal,
					IFitness1=>IFitness1_signal, IFitness2=>IFitness2_signal, IFitness3=>IFitness3_signal,
					GU=>GU_signal, G1=>G1_signal, G2=>G2_signal, G3=>G3_signal,
					No_match=>No_match_signal);
	
	matchsum_unit : matchsum
		port map(matchsum1=>matchsum1, matchsum2=>matchsum2, matchsum3=>matchsum3,
					GU=>GU_signal, G3=>G3_signal,
					weight1=>weight1, weight2=>weight2, weight3=>weight3,
					matchsum1_out=>matchsum1_out_signal, matchsum2_out=>matchsum2_out_signal, matchsum3_out=>matchsum3_out_signal,
					matchsum1_nm=>matchsum1_nm_signal, matchsum2_nm=>matchsum2_nm_signal, matchsum3_nm=>matchsum3_nm_signal,
					weight1_nm=>weight1_nm_signal, weight2_nm=>weight2_nm_signal, weight3_nm=>weight3_nm_signal);
					
	Nomatch_unit : Nomatch
		port map(variance1=>variance1, variance2=>variance2, variance3=>variance3,
					mean1=>mean1, mean2=>mean2, mean3=>mean3,
					pixel=>pixel,
					G3=>G3_signal,
					variance1_nm=>variance1_nm_signal, variance2_nm=>variance2_nm_signal, variance3_nm=>variance3_nm_signal,
					mean1_nm=>mean1_nm_signal, mean2_nm=>mean2_nm_signal, mean3_nm=>mean3_nm_signal);
					
	variance_unit : variance
		port map(variance1=>variance1, variance2=>variance2, variance3=>variance3,
					GU=>GU_signal,
					nk1=>nk1_signal, nk2=>nk2_signal, nk3=>nk3_signal,
					pixel_diff2_1=>pixel_diff2_1_signal, pixel_diff2_2=>pixel_diff2_2_signal, pixel_diff2_3=>pixel_diff2_3_signal,
					variance1_out=>variance1_out_signal, variance2_out=>variance2_out_signal, variance3_out=>variance3_out_signal);
					
	mean_unit : mean
		port map(mean1=>mean1, mean2=>mean2, mean3=>mean3,
					GU=>GU_signal,
					nk1=>nk1_signal, nk2=>nk2_signal, nk3=>nk3_signal,
					pixel_diff1=>pixel_diff1_signal, pixel_diff2=>pixel_diff2_signal, pixel_diff3=>pixel_diff3_signal,
					mean1_out=>mean1_out_signal, mean2_out=>mean2_out_signal, mean3_out=>mean3_out_signal);
					
	weight_unit : weight
		port map(weight1=>weight1, weight2=>weight2, weight3=>weight3,
					GU=>GU_signal,
					weight1_out=>weight1_out_signal, weight2_out=>weight2_out_signal, weight3_out=>weight3_out_signal);
					
	OutputSelection_unit : OutputSelection
		port map(matchsum1_nm=>matchsum1_nm_signal, matchsum2_nm=>matchsum2_nm_signal, matchsum3_nm=>matchsum3_nm_signal,
					matchsum1=>matchsum1_out_signal, matchsum2=>matchsum2_out_signal, matchsum3=>matchsum3_out_signal,
					weight1_nm=>weight1_nm_signal, weight2_nm=>weight2_nm_signal, weight3_nm=>weight3_nm_signal,
					mean1_nm=>mean1_nm_signal, mean2_nm=>mean2_nm_signal, mean3_nm=>mean3_nm_signal,
					variance1_nm=>variance1_nm_signal, variance2_nm=>variance2_nm_signal, variance3_nm=>variance3_nm_signal,
					variance1=>variance1_out_signal, variance2=>variance2_out_signal, variance3=>variance3_out_signal,
					mean1=>mean1_out_signal, mean2=>mean2_out_signal, mean3=>mean3_out_signal,
					weight1=>weight1_out_signal, weight2=>weight2_out_signal, weight3=>weight3_out_signal,
					No_match=>No_match_signal,
					weight1_out=>weight1_out, weight2_out=>weight2_out, weight3_out=>weight3_out,
					mean1_out=>mean1_out, mean2_out=>mean2_out, mean3_out=>mean3_out,
					variance1_out=>variance1_out, variance2_out=>variance2_out, variance3_out=>variance3_out,
					matchsum1_out=>matchsum1_out, matchsum2_out=>matchsum2_out, matchsum3_out=>matchsum3_out);
	
	bg_identification_unit : bg_identification
		port map(weight1=>weight1, weight2=>weight2, weight3=>weight3,
				 No_match=>No_match_signal,
				 G1=>G1_signal, G2=>G2_signal, G3=>G3_signal,
				 match1=>match1_signal, match2=>match2_signal, match3=>match3_signal,
				 Fg_bg=>Fg_bg);

end architecture;
					
