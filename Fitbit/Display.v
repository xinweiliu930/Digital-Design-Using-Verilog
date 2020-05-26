module Display(RESET,CLK,slowClk,stepcnt,distance,sec,sectime,an,seg);

input RESET, slowClk;
input [13:0] stepcnt;
input  [8:0] distance;
input  [3:0] sec;
input  [8:0] sectime;

input CLK;
output reg [6:0] seg;
output  reg [3:0] an;

reg clk1,clk2;
reg [3:0] thou, hun, ten, one,out;
reg [1:0] counter;
reg [15:0] counter1;
reg [1:0] counter3;

always @(posedge slowClk or posedge RESET) 
begin
if (RESET)
clk1 <= 0;
else clk1 = ~clk1;
end

always @(posedge CLK or posedge RESET) 
begin
if (RESET) begin
clk2 <= 0;
counter1 <= 0;
end
else if (counter1 == 50000)
begin
clk2 <= ~clk2;
counter1 <= 1;
end
else 
counter1 <= counter1 + 1;
end


always @(posedge clk1 or posedge RESET) // 2 seconds display
begin
if (RESET)
begin
counter <= 0;
end
else if (counter == 4) 
counter <= 0;
else 
counter <= counter + 1;
end

always @(*)
begin
if (RESET)
begin
thou = 0;
hun = 0;
ten = 0;
one = 0;
end
else begin
    case (counter)
    2'b001: begin
		   one = stepcnt % 10;
		   ten = ((stepcnt - one)/10) % 10;
		   hun = ((stepcnt - one - 10*ten) / 100) %10;
		   thou = (stepcnt - one - 10*ten - 100*hun)/1000;
		   end
	2'b010: begin
	       if (distance % 2 == 0)
		        begin 
			    one = 0;
				ten = 10;
				hun = (distance/2) % 10;
				thou = (distance/2 - hun)/10;
				end
			else begin
                one = 5;
                ten = 10;
                hun = ((distance-1)/2) % 10;
                thou = ((distance - 1)/2 - hun)/10;
                end
			end
    2'b011: begin
           one = sec;
		   ten = 0;
		   hun = 0;
		   thou = 0;
		   end
	2'b100: begin
		   one = sectime % 10;
		   ten = ((sectime - one)/10) % 10;
		   hun = ((sectime - one - 10*ten) / 100) %10;
		   thou = (sectime - one - 10*ten - 100*hun)/1000;
		   end
	endcase
end
end	

always @(posedge clk2 or posedge RESET)
begin
if(RESET)
    begin 
	an <= 4'b1111;
	counter3 <= 0;
	end
else if(counter3 == 0)
    begin
	an <= 4'b1110;
	counter3 <= counter3 + 1;
	end
else if(counter3 == 1)
    begin
	an <= 4'b1101;
	counter3 <= counter3 + 1;
	end
else if(counter3 == 2)
    begin
	an <= 4'b1011;
	counter3 <= counter3 + 1;
	end
else if(counter3 == 3)
    begin
	an <= 4'b0111;
	counter3 <= 0;
	end
end




always @(*)
begin
if (RESET)
out = 0;
else begin
     case (an)
     4'b1110: out = one;
	 4'b1101: out = ten;
	 4'b1011: out = hun;
	 4'b0111: out = thou;
	 default: out = 0;
     endcase
end
end


		   
always @(*)
begin
if (RESET)
seg = 7'b1111111;
else begin
    case (out)
    4'h0   : seg = 7'b1000000;
    4'h1   : seg = 7'b1111001;
    4'h2   : seg = 7'b0100100;
    4'h3   : seg = 7'b0110000;
    4'h4   : seg = 7'b0011001;
    4'h5   : seg = 7'b0010010;
    4'h6   : seg = 7'b0000010;
    4'h7   : seg = 7'b1111000;
    4'h8   : seg = 7'b0000000;
    4'h9   : seg = 7'b0011000;
	4'ha  : seg = 7'b1110111; //for underline
    default: seg = 7'b1111111;
	endcase
end
end
    	
endmodule				
				
				
				
				
				
				
				
				
				
				
				
				
				
	
