library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity project_reti_logiche is
port (
i_clk : in std_logic;
i_start : in std_logic;
i_rst : in std_logic;
i_data : in std_logic_vector(7 downto 0);
o_address : out std_logic_vector(15 downto 0);
o_done : out std_logic;
o_en : out std_logic;
o_we : out std_logic;
o_data : out std_logic_vector (7 downto 0)
);
end project_reti_logiche;

architecture test of project_reti_logiche is 
signal maschera : std_logic_vector(7 downto 0) ; --maschera di input per vedere centroidi validi
signal nmaschera : std_logic_vector(7 downto 0) ;
signal mascheraOut : std_logic_vector(7 downto 0) := "00000000";--maschera output temporanea
signal nmascheraOut : std_logic_vector(7 downto 0) := "00000000";--maschera output temporanea
signal x0 : std_logic_vector(7 downto 0) := "00000000"; --ascissa punto d'interesse
signal y0 : std_logic_vector(7 downto 0) := "00000000" ; --ordinata punto d'interesse
signal nx0 : std_logic_vector(7 downto 0) := "00000000"; --ascissa punto d'interesse
signal ny0 : std_logic_vector(7 downto 0) := "00000000" ; --ordinata punto d'interesse
signal x1 : std_logic_vector(7 downto 0) := "00000000"; --ascissa centroide
signal y1 : std_logic_vector(7 downto 0) := "00000000"; --ordinata centroide
signal nx1 : std_logic_vector(7 downto 0) := "00000000"; --ascissa centroide
signal ny1 : std_logic_vector(7 downto 0) := "00000000"; --ordinata centroide
signal cont : std_logic_vector(7 downto 0) := "00000000"; --contatore stato
signal ncont : std_logic_vector(7 downto 0) := "00000000"; --contatore stato
signal cent : natural := 0;
signal distanza : std_logic_vector(8 downto 0);
signal MinDistanza : std_logic_vector(8 downto 0) := "111111111"; --Registro per memorizzare la distanza minima
signal NMinDistanza : std_logic_vector(8 downto 0) := "111111111"; --Registro per memorizzare la distanza minima


--signal statoCompletato : std_logic;

type state_type is (SR , S0, SK0,S1,SK1, S2,SK2, S3,SK3, S4,SK4 ,S5, SA,SB , S6,SD,SE,SF,SG,SH,SI,SJ, S7, S8, SP); --Tipo stato


signal C_STATE, NEXT_STATE: state_type;

    component sottra is
    Port ( c1x : in STD_LOGIC_VECTOR (7 downto 0);
           c2x : in STD_LOGIC_VECTOR (7 downto 0);
           c1y : in STD_LOGIC_VECTOR (7 downto 0);
           c2y : in STD_LOGIC_VECTOR (7 downto 0);
           dist : out STD_LOGIC_VECTOR (8 downto 0));
end component;

begin

CalcolatoreDistanza: sottra port map(c1x => x0,c2x => nx1,c1y => y0,c2y => ny1,dist => distanza);






--Macchina a stati finiti
state_reg: process(i_clk,i_rst)
  begin
    if i_rst='1' then --va reinizializzata la maschera e il vettore di completezza
     

        
      c_state <= SR;
     
       
      
    elsif rising_edge(i_clk) then
      c_state <= next_state;
      nx1 <= x1; 
      ny1 <= y1;
      nmaschera <= maschera;
      nmascheraOut <= mascheraOut;
      nx0 <= x0;
      ny0 <= y0;
 ncont <= cont;
 
  nminDistanza <= minDistanza ;
    end if;
  end process;
  

  
  
  
  lambda: process(c_state,i_data,i_start,maschera,distanza,minDistanza,mascheraOut,i_rst,nmindistanza,nmascheraout,ncont,ny1,nx1,nx0,ny0,nmaschera,cont) --processo per gestire stati
         variable diff1 : unsigned (7 downto 0);
       variable diff2 : unsigned (7 downto 0);
  begin
  mascheraOut <= nmascheraOut;
  minDistanza <= nminDistanza ;
next_state <= c_state;
            o_data <= "00000000";
         o_en <= '1';
         o_we <= '0';
         o_done <= '0';
         o_address <= "1000000000000000";
   cont <= ncont;
       y1 <= ny1;
          x1 <= nx1;
         y0 <= ny0;
          x0 <= nx0;
        maschera <= nmaschera;
         
    case c_state is


when SR =>
       if i_start = '1' then
	o_done <= '0';
	next_state <= S0;
          
        end if;
      when S0 =>
        
        if i_start = '1'  then
            --Preparazione lettura maschera

            
            o_address <= std_logic_vector(to_unsigned( 0 , 16));
            maschera <= i_data;    
             next_state <= SK0; --Passa allo stato successivo
         else 
             next_state <= S0;
        end if;
        
when SK0 =>
        
        if i_start = '1'  then
            --Preparazione lettura maschera

            
            o_address <= std_logic_vector(to_unsigned( 0 , 16));
            maschera <= i_data;    
             next_state <= S1; --Passa allo stato successivo
         else 
             next_state <= SK0;
        end if;
        
  
when S1 =>
        if i_start = '1'  then
            --Lettura maschera e preparazione lettura x0
            
                  o_address <= std_logic_vector(to_unsigned( 17 , 16));
            x0 <= i_data;
            next_state <= SK1; --Passa allo stato successivo
       else 
            next_state <= S1;
        end if;
        
    
when SK1 =>
        if i_start = '1'  then
            --Lettura maschera e preparazione lettura x0
            
                  o_address <= std_logic_vector(to_unsigned( 17 , 16));
            x0 <= i_data;
            next_state <= S2; --Passa allo stato successivo
       else 
            next_state <= SK1;
        end if;    
 
     
when S2 =>
      
        if i_start = '1'  then
            --Lettura x0 e preparazione lettura y0
      
            o_address <= std_logic_vector(to_unsigned( 18 , 16));
        y0 <= i_data;
          next_state <= SK2; --Passa allo stato successivo
        else 
            next_state <= S2;
        end if;
        
        
when SK2 =>
      
        if i_start = '1'  then
            --Lettura x0 e preparazione lettura y0
      
            o_address <= std_logic_vector(to_unsigned( 18 , 16));
        y0 <= i_data;
          next_state <= S3; --Passa allo stato successivo
        else 
            next_state <= SK2;
        end if;    

when S3 =>
	   
if (cont="00000000") then --1 centroide
	   
        if  i_start = '1'  and ((nmaschera and "00000001") = "00000001" ) then
                --Preparazione lettura ascissa primo centroide
 
                o_address <= std_logic_vector(to_unsigned( 1 , 16)); 
      x1 <= i_data;
                --Preparazione lettura ascissa primo centroide
                next_state <= SK3; --Passa allo stato successivo
        elsif  i_start = '1' then
           
            next_state <= S6;
         else
            next_state <= S3;
        end if;       
	end if;
	
if (cont="00000001") then --2 centroide
	         if  ((nmaschera and "00000010") = "00000010" )and i_start = '1' then
               
              
                o_address <= std_logic_vector(to_unsigned( 3 , 16));
                x1 <= i_data;
                next_state <= SK3; --Passa allo stato successivo
        elsif  i_start = '1' then
           
            next_state <= S6;
        else

           next_state <= S3;
        end if;       

	end if;
	
	
if (cont="00000010") then --3 centroide
	         if  ((nmaschera and "00000100") = "00000100" )and i_start = '1' then
             
           
                o_address <= std_logic_vector(to_unsigned( 5 , 16));
  x1 <= i_data;
   next_state <= SK3; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= S3;
        end if;       

	end if;
	
	
	
	
if (cont="00000100") then --4 centroide
  if  ((nmaschera and "00001000") = "00001000" )and i_start = '1' then
                
              
                o_address <= std_logic_vector(to_unsigned( 7 , 16));
   x1 <= i_data;
   next_state <= SK3; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= S3;
        end if;       

	end if;
		
if (cont="00001000") then --5 centroide
	         if  ((nmaschera and "00010000") = "00010000" )and i_start = '1' then
                
             
                o_address <= std_logic_vector(to_unsigned( 9 , 16));
x1 <= i_data;
                   next_state <= SK3; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                next_state <= S6;
        else

           next_state <= S3;
        end if;       

	end if;
	
	
	if (cont="00010000") then --6 centroide
	         if  ((nmaschera and "00100000") = "00100000" )and i_start = '1' then
                
           
                o_address <= std_logic_vector(to_unsigned( 11 , 16));
   x1 <= i_data;
   next_state <= SK3; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= S3;
        end if;       

	end if;
	
	
if (cont="00100000") then --7 centroide
	         if  ((nmaschera and "01000000") = "01000000" )and i_start = '1' then
            
                o_address <= std_logic_vector(to_unsigned( 13 , 16));
   x1 <= i_data;
   next_state <= SK3; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= S3;
        end if;       

	end if;
	
if (cont="01000000") then --8 centroide
	         if  ((nmaschera and "10000000") = "10000000" )and i_start = '1' then
                
               
                o_address <= std_logic_vector(to_unsigned( 15 , 16));
  x1 <= i_data;
   next_state <= SK3; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= S3;
        end if;       

	end if;
	
	
	
	
	
	
when SK3 =>
	   
if (cont="00000000") then --1 centroide
	   
        if  i_start = '1'  and ((nmaschera and "00000001") = "00000001" ) then
                --Preparazione lettura ascissa primo centroide
      
                o_address <= std_logic_vector(to_unsigned( 1 , 16)); 
      x1 <= i_data;
                --Preparazione lettura ascissa primo centroide
                next_state <= S4; --Passa allo stato successivo
        elsif  i_start = '1' then
           
            next_state <= S6;
         else
            next_state <= SK3;
        end if;       
	end if;
	
if (cont="00000001") then --2 centroide
	         if  ((nmaschera and "00000010") = "00000010" )and i_start = '1' then
               
             
                o_address <= std_logic_vector(to_unsigned( 3 , 16));
                x1 <= i_data;
                next_state <= S4; --Passa allo stato successivo
        elsif  i_start = '1' then
           
            next_state <= S6;
        else

           next_state <= SK3;
        end if;       

	end if;
	
	
if (cont="00000010") then --3 centroide
	         if  ((nmaschera and "00000100") = "00000100" )and i_start = '1' then
             
        
                o_address <= std_logic_vector(to_unsigned( 5 , 16));
  x1 <= i_data;
   next_state <= S4; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= SK3;
        end if;       

	end if;
	
	
	
	
if (cont="00000100") then --4 centroide
  if  ((nmaschera and "00001000") = "00001000" )and i_start = '1' then
                
               
                o_address <= std_logic_vector(to_unsigned( 7 , 16));
   x1 <= i_data;
   next_state <= S4; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= SK3;
        end if;       

	end if;
		
if (cont="00001000") then --5 centroide
	         if  ((nmaschera and "00010000") = "00010000" )and i_start = '1' then
                
           
                o_address <= std_logic_vector(to_unsigned( 9 , 16));
x1 <= i_data;
                   next_state <= S4; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                next_state <= S6;
        else

           next_state <= SK3;
        end if;       

	end if;
	
	
	if (cont="00010000") then --6 centroide
	         if  ((nmaschera and "00100000") = "00100000" )and i_start = '1' then
                
              
                o_address <= std_logic_vector(to_unsigned( 11 , 16));
   x1 <= i_data;
   next_state <= S4; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= SK3;
        end if;       

	end if;
	
	
if (cont="00100000") then --7 centroide
	         if  ((nmaschera and "01000000") = "01000000" )and i_start = '1' then
                
              
                o_address <= std_logic_vector(to_unsigned( 13 , 16));
   x1 <= i_data;
   next_state <= S4; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= SK3;
        end if;       

	end if;
	
if (cont="01000000") then --8 centroide
	         if  ((nmaschera and "10000000") = "10000000" )and i_start = '1' then
                
              
                o_address <= std_logic_vector(to_unsigned( 15 , 16));
  x1 <= i_data;
   next_state <= S4; --Passa allo stato successivo
        elsif  i_start = '1' then
           
                
                next_state <= S6;
        else

           next_state <= SK3;
        end if;       

	end if;
	
	
	
	
	
	
	
	
	
	
	
when S4 =>
if (cont="00000000") then --1 centroide
        if i_start = '1'  then
            --Lettura ascissa primo centroide e preparazione lettura ordinata primo centroide
          
		  o_address <= std_logic_vector(to_unsigned( 2 , 16));            
          Y1 <= i_data;
            next_state <= SK4; --Passa allo stato successivo
            else 
               next_state <= S4;                  
        end if;
             end if;
			 
 if (cont="00000001") then --2 centroide
        if i_start = '1'  then
          
         
		  o_address <= std_logic_vector(to_unsigned( 4 , 16));            
          Y1 <= i_data;
            next_state <= SK4; --Passa allo stato successivo
            else 
               next_state <= S4;                  
        end if;
             end if;		 
			 
			 
 if (cont="00000010") then --3 centroide
        if i_start = '1'  then
          
         
		  o_address <= std_logic_vector(to_unsigned( 6 , 16));            
          Y1 <= i_data;
            next_state <= SK4; --Passa allo stato successivo
            else 
               next_state <= S4;                  
        end if;
             end if;				 
if (cont="00000100") then --4 centroide
        if i_start = '1'  then
          
        
		  o_address <= std_logic_vector(to_unsigned( 8 , 16));            
         Y1 <= i_data;
            next_state <= SK4; --Passa allo stato successivo
            else 
               next_state <= S4;                  
        end if;
             end if;				 
			 
 if (cont="00001000") then --5 centroide
        if i_start = '1'  then
          
     
		  o_address <= std_logic_vector(to_unsigned( 10 , 16));            
           Y1 <= i_data;
            next_state <= SK4; --Passa allo stato successivo
            else 
               next_state <= S4;                  
        end if;
             end if;					

			 
 if (cont="00010000") then --6 centroide
        if i_start = '1'  then
          

		  o_address <= std_logic_vector(to_unsigned( 12 , 16));            
           Y1 <= i_data;
            next_state <= SK4; --Passa allo stato successivo
            else 
               next_state <= S4;                  
        end if;
             end if;					

			 
 if (cont="00100000") then --7 centroide 
        if i_start = '1'  then
          
          
		  o_address <= std_logic_vector(to_unsigned( 14 , 16));            
          Y1 <= i_data;
            next_state <= SK4; --Passa allo stato successivo
            else 
               next_state <= S4;                  
        end if;
             end if;					
			 
 if (cont="01000000") then --8 centroide 
        if i_start = '1'  then
          
         
		  o_address <= std_logic_vector(to_unsigned( 16 , 16));            
          Y1 <= i_data;
            next_state <= SK4; --Passa allo stato successivo
            else 
               next_state <= S4;                  
        end if;
             end if;					











	
	
when SK4 =>
if (cont="00000000") then --1 centroide
        if i_start = '1'  then
            --Lettura ascissa primo centroide e preparazione lettura ordinata primo centroide
          
		  o_address <= std_logic_vector(to_unsigned( 2 , 16));            
          Y1 <= i_data;
            next_state <= S5; --Passa allo stato successivo
            else 
               next_state <= SK4;                  
        end if;
             end if;
			 
 if (cont="00000001") then --2 centroide
        if i_start = '1'  then
          
         
		  o_address <= std_logic_vector(to_unsigned( 4 , 16));            
          Y1 <= i_data;
            next_state <= S5; --Passa allo stato successivo
            else 
               next_state <= SK4;                  
        end if;
             end if;		 
			 
			 
 if (cont="00000010") then --3 centroide
        if i_start = '1'  then
          
         
		  o_address <= std_logic_vector(to_unsigned( 6 , 16));            
          Y1 <= i_data;
            next_state <= S5; --Passa allo stato successivo
            else 
               next_state <= SK4;                  
        end if;
             end if;				 
if (cont="00000100") then --4 centroide
        if i_start = '1'  then
          
        
		  o_address <= std_logic_vector(to_unsigned( 8 , 16));            
         Y1 <= i_data;
            next_state <= S5; --Passa allo stato successivo
            else 
               next_state <= SK4;                  
        end if;
             end if;				 
			 
 if (cont="00001000") then --5 centroide
        if i_start = '1'  then
          
     
		  o_address <= std_logic_vector(to_unsigned( 10 , 16));            
           Y1 <= i_data;
            next_state <= S5; --Passa allo stato successivo
            else 
               next_state <= SK4;                  
        end if;
             end if;					

			 
 if (cont="00010000") then --6 centroide
        if i_start = '1'  then
          

		  o_address <= std_logic_vector(to_unsigned( 12 , 16));            
           Y1 <= i_data;
            next_state <= S5; --Passa allo stato successivo
            else 
               next_state <= SK4;                  
        end if;
             end if;					

			 
 if (cont="00100000") then --7 centroide 
        if i_start = '1'  then
          
          
		  o_address <= std_logic_vector(to_unsigned( 14 , 16));            
          Y1 <= i_data;
            next_state <= S5; --Passa allo stato successivo
            else 
               next_state <= SK4;                  
        end if;
             end if;					
			 
 if (cont="01000000") then --8 centroide 
        if i_start = '1'  then
          
         
		  o_address <= std_logic_vector(to_unsigned( 16 , 16));            
          Y1 <= i_data;
            next_state <= S5; --Passa allo stato successivo
            else 
               next_state <= SK4;                  
        end if;
             end if;					









			
 when S5 =>
     
            if (distanza >MinDistanza) then
            
                next_state <= S6;
            elsif (distanza = MinDistanza) then
                 next_state <= SA;   
            else
                next_state <= SB;
             end if;
			
			
			
	when SA =>
			if (cont="00000000") then
				mascheraOut <= ("00000001" or nmascheraOut);
				next_state <= S6;
			elsif (cont="00000001") then
				mascheraOut <= ("00000010" or nmascheraOut);
				next_state <= S6;
			elsif (cont="00000010") then
				mascheraOut <= ("00000100" or nmascheraOut);
				next_state <= S6;				
			elsif (cont="00000100") then
				mascheraOut <= ("00001000" or nmascheraOut);
				next_state <= S6;
			elsif (cont="00001000") then
				mascheraOut <= ("00010000" or nmascheraOut);
				next_state <= S6;
	
			elsif (cont="00010000") then
				mascheraOut <= ("00100000" or nmascheraOut);
				next_state <= S6;
			elsif (cont="00100000") then
				mascheraOut <= ("01000000" or nmascheraOut);
				next_state <= S6;	
			elsif (cont="01000000") then
				mascheraOut <= ("10000000" or nmascheraOut);
				next_state <= S6;	
			else 
	            next_state <= SA;
				
			end if;	
			
    when SB => 
			if (cont="00000000") then
				 mascheraOut <= "00000001"; --Resetta maschera
				MinDistanza <= distanza ; --Trovato una distanza minima
				next_state <= S6;
				
			elsif (cont="00000001") then
				 mascheraOut <= "00000010"; --Resetta maschera
				MinDistanza <= distanza ; --Trovato una distanza minima
				next_state <= S6;	
			elsif (cont="00000010") then
				 mascheraOut <= "00000100"; --Resetta maschera
				MinDistanza <= distanza ; --Trovato una distanza minima
				next_state <= S6;	
			elsif (cont="00000100") then
				 mascheraOut <= "00001000"; --Resetta maschera
				MinDistanza <= distanza ; --Trovato una distanza minima
				next_state <= S6;	
			elsif (cont="00001000") then
				 mascheraOut <= "00010000"; --Resetta maschera
				MinDistanza <= distanza ; --Trovato una distanza minima
				next_state <= S6;	
			elsif (cont="00010000") then
				 mascheraOut <= "00100000"; --Resetta maschera
				MinDistanza <= distanza ; --Trovato una distanza minima
				next_state <= S6;	
							
			elsif (cont="00100000") then
				 mascheraOut <= "01000000"; --Resetta maschera
				MinDistanza <= distanza ; --Trovato una distanza minima
				next_state <= S6;	
			elsif (cont="01000000") then
				 mascheraOut <= "10000000"; --Resetta maschera
				MinDistanza <= distanza ; --Trovato una distanza minima
				next_state <= S6;	
				else 
	   next_state <= SB;				
			end if;

 when S6 =>
	if (cont="00000000") then
	
	
	next_state <= SD;
	elsif (cont="00000001") then
	next_state <= SE;
	elsif (cont="00000010") then
	next_state <= SF;
	elsif (cont="00000100") then
	 next_state <= SG;
	elsif (cont="00001000") then
	next_state <= SH;
	elsif (cont="00010000") then
	 next_state <= SI;
	elsif (cont="00100000") then
	next_state <= SJ;
	elsif (cont="01000000") then
	next_state <= S7;
	else 
	   next_state <= S6;
			end if; 
			
	when SD =>
	   		
			cont<="00000001";
	next_state <= S3;
			
		when SE =>
	   		
			cont<="00000010";
	next_state <= S3;		
			
			when SF =>
	   		
			cont<="00000100";
	next_state <= S3;
	
		when SG =>
	   		
			cont<="00001000";
	next_state <= S3;
	
		when SH =>
	   		
			cont<="00010000";
	next_state <= S3;
		when SI =>
	   		
			cont<="00100000";
	next_state <= S3;	
			
	when SJ =>
	   		
			cont<="01000000";
	next_state <= S3;
			
			
			
			
			
			
			
			
			
			
			
			
     when S7 =>
        if i_start='1'  then
                o_we <= '1';
                o_address <= std_logic_vector(to_unsigned( 19 , 16));
                o_data <= mascheraOut;

                next_state <= S8;
                    else 
               next_state <= S7;  
                end if;
                
                
 when S8 =>
        if i_start='1' then
 o_done <= '1'; --è incompleto
                        
     
            next_state <= SP;
    else 
               next_state <= S8;  
            end if;
            
            
 when SP =>
         if i_start='0' then -- va messo ?
   o_en <= '0';
            o_done <= '0'; 
            next_state <=SR;  
                else 
               next_state <= SP;  
              end if;
                
end case;
  end process;




end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sottra is
    Port ( c1x : in std_logic_vector (7 downto 0);
           c2x : in STD_LOGIC_VECTOR (7 downto 0);
           c1y : in STD_LOGIC_VECTOR (7 downto 0);
           c2y : in STD_LOGIC_VECTOR (7 downto 0);
           dist : out STD_LOGIC_VECTOR (8 downto 0)
           );
end sottra;

architecture Distanza of sottra is

begin

    CalcoloDistanza : process(c1x, c2x, c1y, c2y)
       variable diff1 : unsigned (8 downto 0);
       variable diff2 : unsigned (8 downto 0);
        variable diff3 : unsigned (8 downto 0);
     begin
     if (c1x > c2x) then
     
        
        diff1 :=  unsigned('0'&c1x) - unsigned('0'&c2x);
     else
        diff1 :=  unsigned('0'&c2x) - unsigned('0'&c1x);
     end if;   
     
     if (c1y > c2y) then
     
        diff2 :=  unsigned('0'&c1y) - unsigned('0'&c2y);
     else
        diff2 :=  unsigned('0'&c2y) - unsigned('0'&c1y);
     end if; 
    diff3:= diff1 + diff2;
     dist <=  std_logic_vector(diff3);       
     
     end process;
     end distanza;
