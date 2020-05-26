module PulseGenerator(CLK, RESET, START, PULSES, MODE, slowClk);
input [1:0] MODE;
input CLK, RESET, START,slowClk;
output reg PULSES;

reg [40:0] counter;
reg [20:0] counter1;
reg [19:0] counter2;
reg [19:0] counter3;
reg [40:0] counter4,counter5,counter6,counter7,counter8,counter9,counter10,counter11,counter12,counter13,counter14,counter15;
reg [3:0] sig;


parameter WALK = 2'b00;
parameter JOG = 2'b01;
parameter RUN = 2'b10;
parameter HYBRID = 2'b11;

always @(posedge slowClk or posedge RESET)
begin
if (RESET) begin
counter <= 0;
sig <= 0;
end
else begin
counter <= counter + 1;
if (counter == 1)
  sig <= 1;
else if(counter == 2)
  sig <= 2;
 else if(counter == 3)
  sig <= 3;
  else if(counter == 4)
  sig <= 4;
  else if(counter == 5)
  sig <= 5;
  else if(counter == 6)
  sig <= 6;
  else if(counter == 7)
  sig <= 7;
  else if(counter == 8)
  sig <= 8;
  else if(counter == 9)
  sig <= 9;
  else if(counter == 10)
  sig <= 10;
  else if(counter == 74)
  sig <= 11;
  else if(counter == 80)
  sig <= 12;
  else if(counter == 145)
  sig <= 13;
 end
end 

always @(posedge CLK or posedge RESET)
begin
  if (RESET || !START)
  begin
    PULSES <= 0;
	counter1 <= 0;
	counter2 <= 0;
	counter3 <= 0;
	counter4 <= 0;
	counter5 <= 0;
	counter6 <= 0;
	counter7 <= 0;
	counter8 <= 0;
	counter9 <= 0;
	counter10 <= 0;
	counter11 <= 0;
	counter12 <= 0;
	counter13 <= 0;
	counter14 <= 0;
	counter15 <= 0;

  end
 
  else
    case(MODE)
    WALK:begin  
        if (counter1 == 1562500)
        begin
           PULSES <= ~PULSES;
	       counter1 <= 1;
        end
        else begin
           counter1 <= counter1 + 1;
        end
		end
		
	JOG:begin
	    if (counter2 == 781250)
	    begin 
		   PULSES <= ~PULSES;
	       counter2 <= 1;
        end
        else begin
           counter2 <= counter2 + 1;
        end
		end
		
	RUN:begin
	    if (counter3 == 390625)
	    begin 
		   PULSES <= ~PULSES;
	       counter3 <= 1;
        end
        else begin
           counter3 <= counter3 + 1;
        end
		end
		
	HYBRID:begin
		
		
	    if (sig == 1)
		begin 			    
		    counter4 <= counter4 + 1;
		    if (counter4 == 2500000) begin
			PULSES <= ~PULSES;
            counter4 <= 1;			
		    end             
		end
		else if (sig == 2)
		begin			    
		    counter5 <= counter5 + 1;
		    
			if (counter5 == 1515152) begin
			PULSES <= ~PULSES;
			counter5 <= 1; end
		end
		else if (sig == 3)
		begin			    counter6 <= counter6 + 1;
		    
			if (counter6 == 757576) begin
			PULSES <= ~PULSES;
			counter6 <= 1; end
		end
		else if (sig == 4)
		begin			    counter7 <= counter7 + 1;
		    
			if (counter7 == 1851852) begin
			PULSES <= ~PULSES;
			counter7 <= 1; end
		end
		else if (sig == 5)
		begin			    counter8 <= counter8 + 1;
		    
			if (counter8 == 714286) begin
			PULSES <= ~PULSES;
			counter8 <= 1; end
		end
		else if (sig == 6)
		begin			    counter9 <= counter9 + 1;
		    
			if (counter9 == 1666667) begin
			PULSES <= ~PULSES;
			counter9 <= 1; end
		end
		else if (sig == 7)
		begin			    counter10 <= counter10 + 1;
		    
			if (counter10 == 2631579) begin
			PULSES <= ~PULSES;
			counter10 <= 1; end
		end
		else if (sig == 8)
		begin			    counter11 <= counter11 + 1;
		    
			if (counter11 == 1515152) begin
			PULSES <= ~PULSES;
			counter11 <= 1; end
		end
		else if (sig == 9)
		begin			    counter12 <= counter12 + 1;
		    
			if (counter12 == 1666667) begin
			PULSES <= ~PULSES;
			counter12 <= 1; end
		end
		else if (sig == 10)
		begin			    counter13 <= counter13 + 1;
		   
			if (counter13 == 724638) begin
			PULSES <= ~PULSES;
			counter13 <= 1; end
		end
		else if (sig == 11)
		begin			    counter14 <= counter14 + 1;
		    
			if (counter14 == 1470588) begin
			PULSES <= ~PULSES;
			counter14 <= 1; end
		end
		else if (sig == 12)
		begin			    counter15 <= counter15 + 1;
		    
			if (counter15 == 403226) begin
			PULSES <= ~PULSES;
			counter15 <= 1; end
		end
		else if( sig == 13)
			PULSES <= 0;
		end

		endcase
		
		
end
endmodule
