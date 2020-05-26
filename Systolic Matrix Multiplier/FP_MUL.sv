module MUL(A, B, C,overflow);

input [7:0] A, B;
output overflow;
output [7:0] C;

wire signout;
wire [9:0] fracres;
wire [3:0] expres;
wire [3:0] fracout;
wire [2:0] expout;
wire [3:0] exptemp;
wire overflow;


assign fracres = {1, A[3:0]} * {1, B[3:0]};
assign expres = A[6:4] + B[6:4];

assign signout = A[7] ^ B[7];
assign fracout = (fracres[9])? fracres[8:5] : fracres[7:4];
assign exptemp  = (fracres[9])? (expres + 1 - 3) : (expres - 3);
assign expout = exptemp [2:0];
assign overflow = exptemp[3];

assign C = ((A[6:0] == 0) || B[6:0] == 0) ? 8'b00000000:
                            (A[6:4] == 7) ? A :
							(B[6:4] == 7) ? B : {signout, expout, fracout};

endmodule


































