module MAC(A, B, C, D, overflow);
input [7:0] A, B, C;
output [7:0]D;
output overflow;
wire [7:0]E, F;
wire overflow1;
wire overflow2;

MUL mul1(B, C, E, overflow1);
FloatingPointAdder fpa(A, E, D, overflow2);
assign overflow = overflow1 | overflow2;
endmodule



module C0 #(parameter START_TIME = 1)(a00,b00, a01, b10, a02,b20, c00, clk, rst_n, overflow);


input [7:0] a00,b00, a01, b10, a02,b20;
input rst_n, clk;
output [7:0] c00;
output reg overflow;

wire overflow1, overflow2, overflow3;
wire [7:0] D,E,F;
reg [3:0] counter;
reg [7:0] A_reg;
MAC mac1(A_reg, a00, b00, D, overflow1);
MAC mac2(A_reg, a01, b10, E, overflow2);
MAC mac3(A_reg, a02, b20, F, overflow3);

initial begin
counter = 0;
A_reg = 0;
overflow = 0;
end

always @(posedge clk or negedge rst_n)
begin
if(~rst_n)begin
counter <= 0;
A_reg <= 0;
overflow <= 0;
end
else begin
if(counter < 7)
counter <= counter + 1;
else counter <= 7;

if (counter == START_TIME)
A_reg <= D;
else if (counter == START_TIME+1)
A_reg <= E;

if (overflow1 || overflow2 || overflow3)
overflow <= 1;
end
end
assign c00 = F;
endmodule

module TOP(A, B, C, clk, rst_n, overflow);
input wire [7:0] A[2:0][2:0], B[2:0][2:0];
input rst_n;
output overflow;
output wire [7:0] C[2:0][2:0];
input clk;
wire overflow_wire0,overflow_wire1, overflow_wire2, overflow_wire3, overflow_wire4, overflow_wire5, overflow_wire6,overflow_wire7, overflow_wire8;
C0 #(.START_TIME (1)) c00 (A[0][0],B[0][0], A[0][1], B[1][0], A[0][2], B[2][0], C[0][0], clk, rst_n, overflow_wire0);
C0 #(.START_TIME (2)) c01 (A[0][0],B[0][1], A[0][1], B[1][1], A[0][2], B[2][1], C[0][1], clk, rst_n, overflow_wire1);
C0 #(.START_TIME (2)) c10 (A[1][0],B[0][0], A[1][1], B[1][0], A[1][2], B[2][0], C[1][0], clk, rst_n, overflow_wire2);
C0 #(.START_TIME (3)) c02 (A[0][0],B[0][2], A[0][1], B[1][2], A[0][2], B[2][2], C[0][2], clk, rst_n, overflow_wire3);
C0 #(.START_TIME (3)) c11 (A[1][0],B[0][1], A[1][1], B[1][1], A[1][2], B[2][1], C[1][1], clk, rst_n, overflow_wire4);
C0 #(.START_TIME (3)) c20 (A[2][0],B[0][0], A[2][1], B[1][0], A[2][2], B[2][0], C[2][0], clk, rst_n, overflow_wire5);
C0 #(.START_TIME (4)) c12 (A[1][0],B[0][2], A[1][1], B[1][2], A[1][2], B[2][2], C[1][2], clk, rst_n, overflow_wire6);
C0 #(.START_TIME (4)) c21 (A[2][0],B[0][1], A[2][1], B[1][1], A[2][2], B[2][1], C[2][1], clk, rst_n, overflow_wire7);
C0 #(.START_TIME (5)) c22 (A[2][0],B[0][2], A[2][1], B[1][2], A[2][2], B[2][2], C[2][2], clk, rst_n, overflow_wire8);

assign overflow = overflow_wire0 | overflow_wire1 | overflow_wire2 | overflow_wire3 | overflow_wire4 | overflow_wire5 | overflow_wire6 | overflow_wire7 | overflow_wire8;
endmodule 








