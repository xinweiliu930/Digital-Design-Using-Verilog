/*dff module
module DFF (clk, D, Q);
input clk, D;
output reg Q;

	initial begin
		Q = 0;
	end

  always @ (posedge clk) begin
      Q <= D;
  end

endmodule*/



module Snakecontrol (scancode, xcoord1, ycoord1, xcoord2, ycoord2, xcoord3, ycoord3, xcoord4, ycoord4, CLK, blackout,strobe, sw8);
input [7:0] scancode;
input CLK, strobe, sw8;
output reg [9:0] xcoord1, ycoord1, xcoord2, ycoord2, xcoord3, ycoord3, xcoord4, ycoord4;
output reg blackout;

reg [3:0] CurrentState, NextState,restart;
reg clkframe1, clkframe2;
reg [25:0] counter, counter1;  
reg first;

wire clkframe;

parameter U = 4'b0011;
parameter L = 4'b0100;
parameter R = 4'b0001;
parameter D = 4'b0110;
parameter S = 4'b0000;
parameter P = 4'b0111;
parameter E = 4'b0010;
parameter Die = 4'b1000;

//DFF dff (clkframe, strobe, strobe1);
//assign strobe = strobe & !strobe1;
initial begin
   xcoord1 = 4;
   ycoord1 = 104;
   xcoord2 = 14;
   ycoord2 = 104;
   xcoord3 = 24;
   ycoord3 = 104;
   xcoord4 = 34;
   ycoord4 = 104;
   CurrentState = 0;
   NextState = 0;
   blackout = 0;
   first = 0;
   counter1 = 0;
end

always @(posedge CLK)
begin
if(counter1 == 10000000) begin
      counter1 <= 0;
      clkframe1 <= ~clkframe1;
end
else begin
      counter1 <= counter1 + 1;
end
end

always @(posedge CLK)
begin
if(counter == 5000000) begin
      counter <= 0;
      clkframe2 <= ~clkframe2;
end
else begin
      counter <= counter + 1;
end
end

assign clkframe = (sw8) ? clkframe2 : clkframe1;

always @(posedge clkframe)
begin
     CurrentState <= NextState;
end

always @(*)
begin
case (CurrentState)
S:  begin
                if (scancode == 8'h76) begin
			    NextState = E;
				end 
			else 
			NextState = R;

end		  

R:  begin if (xcoord4 < 634) 
            begin
            if(scancode == 8'h75) begin
			    NextState = U;
				end
			else if(scancode == 8'h72) begin
			    NextState = D;
				end
			else if(scancode == 8'h4d) begin
			    NextState = P;
				end
			else if(scancode == 8'h76) begin
			    NextState = E;
				end
			else if (scancode == 8'h1b ) begin
			    if (strobe)
			     NextState = S;
                else 
				 NextState = R;
				 end
            else NextState = CurrentState;
			end
	else NextState = Die;
end

L: begin if (xcoord4 > 4) 
            begin
            if(scancode == 8'h75) begin
			    NextState = U;
				end
			else if(scancode == 8'h72) begin
			    NextState = D;
				end
			else if(scancode == 8'h4d) begin
			    NextState = P;
				end
			else if(scancode == 8'h76) begin
			    NextState = E;
				end
			else if (scancode == 8'h1b) begin
			     NextState = S;
				 end
            else NextState = CurrentState;
			end
		
	else NextState = Die; 
end

U: begin if (ycoord4 > 4) begin
    
            if(scancode == 8'h6b) begin
			    NextState = L;
				end
			else if(scancode == 8'h74) begin
			    NextState = R;
				end
			else if(scancode == 8'h4d) begin
			    NextState = P;
				end
			else if(scancode == 8'h76) begin
			    NextState = E;
				end
			else if (scancode == 8'h1b) begin
			     NextState = S;
				 end
            else NextState = CurrentState;
			end
		
	else NextState = Die;
end

D: begin if (ycoord4 < 474) begin
    
            if(scancode == 8'h6b) begin
			    NextState = L;
				end
			else if(scancode == 8'h74) begin
			    NextState = R;
				end
			else if(scancode == 8'h4d) begin
			    NextState = P;
				end
			else if(scancode == 8'h76) begin
			    NextState = E;
				end
			else if (scancode == 8'h1b) begin
			     NextState = S;
				 end
            else NextState = CurrentState;
			end
		
	else NextState = Die;
end

P: begin 
    
           
            if(scancode == 8'h2d) begin
			    NextState = restart;
				end
			else if(scancode == 8'h76) begin
			    NextState = E;
				end
			else if (scancode == 8'h1b) begin
			     NextState = S;
				 end
            else NextState = CurrentState;   
			end

E: begin 
           
            if(scancode == 8'h1b) begin
			    NextState = S;
				end
            else NextState = CurrentState;
			end


Die: begin
    
	
	        if(scancode == 8'h1b) begin
			    if(strobe)
                NextState = S;
				else 
				NextState = CurrentState;
				end
            else if (scancode == 8'h76) begin
			    NextState = E;
				end
			else NextState = CurrentState;
			end
           

default: NextState = CurrentState;
endcase
end

always @(posedge clkframe)
begin
case (NextState)

S: begin 
    blackout <= 0;
    xcoord1 <= 4;
    ycoord1 <= 104;
    xcoord2 <= 14;
    ycoord2 <= 104;
    xcoord3 <= 24;
    ycoord3 <= 104;
    xcoord4 <= 34;
    ycoord4 <= 104;
	first <= 0;
   end

R: begin 
    restart <= R;
    if(scancode == 8'h75) begin
	xcoord4 <= xcoord4;
	ycoord4 <= ycoord4 - 10;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	end
	
	else if (scancode == 8'h72) begin
	xcoord4 <= xcoord4;
	ycoord4 <= ycoord4 + 10;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
    end

    else begin
	xcoord4 <= xcoord4 + 10;
	ycoord4 <= ycoord4;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	end
  end

L: begin
    restart <= L;
    if(scancode == 8'h75) begin
	xcoord4 <= xcoord4;
	ycoord4 <= ycoord4 - 10;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	end
	
	else if (scancode == 8'h72) begin
	xcoord4 <= xcoord4;
	ycoord4 <= ycoord4 + 10;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
    end

    else begin
	xcoord4 <= xcoord4 - 10;
	ycoord4 <= ycoord4;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	end
  end

U: begin
   restart <= U;
   if(scancode == 8'h6b) begin
	xcoord4 <= xcoord4 - 10;
	ycoord4 <= ycoord4;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	end
	else if(scancode == 8'h74) begin
	xcoord4 <= xcoord4 + 10;
	ycoord4 <= ycoord4;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
    end
	else begin
	xcoord4 <= xcoord4;
	ycoord4 <= ycoord4 - 10;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	end
  end
  
D: begin
   restart <= D;
   if(scancode == 8'h6b) begin
	xcoord4 <= xcoord4 - 10;
	ycoord4 <= ycoord4;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	end
	else if(scancode == 8'h74) begin
	xcoord4 <= xcoord4 + 10;
	ycoord4 <= ycoord4;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
    end
	else begin
	xcoord4 <= xcoord4;
	ycoord4 <= ycoord4 + 10;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	end
  end

E: begin
   blackout <= 1;
   end
   
P: begin
   	xcoord4 <= xcoord4;
	ycoord4 <= ycoord4;
	xcoord3 <= xcoord3;
	ycoord3 <= ycoord3;
	xcoord2 <= xcoord2;
	ycoord2 <= ycoord2;
	xcoord1 <= xcoord1;
	ycoord1 <= ycoord1;
	end

Die: begin
    if (first == 0) begin
    xcoord4 <= xcoord4;
	ycoord4 <= ycoord4;
	xcoord3 <= xcoord4;
	ycoord3 <= ycoord4;
	xcoord2 <= xcoord3;
	ycoord2 <= ycoord3;
	xcoord1 <= xcoord2;
	ycoord1 <= ycoord2;
	first <= 1;
	end
    end
endcase

end

endmodule

















   

