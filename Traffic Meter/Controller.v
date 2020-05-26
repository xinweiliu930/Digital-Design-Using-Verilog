
   			
	  
	  
module Controller(clk, clk20HZ, clk1HZ, Add10, Add180, Add200, Add550, Reset10, Reset205, timeRemain);
input clk, clk20HZ, clk1HZ, Add10, Add180, Add200, Add550, Reset10, Reset205;
output reg [13:0] timeRemain;
wire [13:0] time_remain;



Adder add(
.clk(clk),
.clk20HZ(clk20HZ),
.clk1HZ(clk1HZ),
.Add10(Add10),
.Add180(Add180),
.Add200(Add200),
.Add550(Add550),
.Reset10(Reset10),
.Reset205(Reset205),
.timeRemain(timeRemain),
.time_remain(time_remain));

Decrementer dec(
.clk1HZ(clk1HZ),
.time_remain(time_remain),
.timeRemain(timeRemain));

endmodule












	  
	  
	  
