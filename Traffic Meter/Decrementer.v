module Decrementer(clk20HZ,time_remain,timeRemain);
input clk20HZ;
input [13:0] time_remain;
output [13:0] timeRemain;

reg  state;
reg [4:0] counter;

initial begin
timeRemain = 0;
counter = 0;
end

always @(posedge clk20HZ)
begin
if (counter == 20)begin
counter <= 1;
timeRemain <= time_remain - 1;end
else counter <= counter + 1;
end

endmodule         