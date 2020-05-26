module TOP(clk, rst, halt, leds);
input clk, rst, halt;
output [7:0] leds;
wire [7:0] reg1LED;
wire Reset,Halt;
wire clk10Hz;
wire A_Out, D_Out;

assign leds = reg1LED;

Complete_MIPS u0(clk10Hz, rst, halt, reg1LED);
ClockDivider u1(clk, clk10Hz);

endmodule
