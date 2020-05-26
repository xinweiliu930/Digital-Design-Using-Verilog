module Adder (clk, clk20HZ, clk1HZ, Add10, Add180, Add200, Add550, Reset10, Reset205, timeRemain, time_remain);
input clk, clk20HZ, clk1HZ, Add10, Add180, Add200, Add550, Reset10, Reset205;
input [13:0] timeRemain;
output reg [13:0] time_remain;
reg [1:0] CurrentState;
reg [1:0] NextState;
reg [1:0] State;

initial begin
time_remain = 0;
CurrentState = 0;
NextState = 0;
State = 0;
end


always @(posedge clk20HZ)
begin
State <= NextState;
end

always@(*)
begin
case (CurrentState)
2'b00: begin 
        if (Reset10)
		NextState = 2'b01;
		else if(Reset205)
		NextState = 2'b10;
		else NextState = 2'b00;
	  end
2'b01: begin
        if (~Reset10)
		NextState = 2'b00;
		else NextState = 2'b01;
	  end
2'b10: begin
        if (~Reset205)
		NextState = 2'b00;
		else NextState = 2'b10;
	  end
default: NextState = 2'b00;
endcase
end

always@(posedge clk20HZ)
begin
    case (NextState)
	2'b00: begin
	       if (time_remain > 9999)
		   time_remain <= 9999;
		   else begin
	            if (Add10)
                time_remain <= timeRemain + 10;
		        else if (Add180)
		        time_remain <= timeRemain + 180;
		        else if (Add200)
		        time_remain <= timeRemain + 200;
		        else if (Add550)
		        time_remain <= timeRemain + 550;
				else time_remain <= timeRemain;
		        end
		   end
	2'b01: time_remain <= 10;
	2'b10: time_remain <= 205;
	default: time_remain <= 0;
	endcase
end
endmodule 
