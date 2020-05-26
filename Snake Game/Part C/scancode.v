/* 22 bit shift register */
module SHF(datain, dataout, clk);

input datain, clk;
output reg [21:0] dataout;


initial begin
dataout <= 0;
end

always@(negedge clk)
begin
    dataout <= {datain,dataout[21:1]};
end
endmodule
/******************************************************************************************************/


/*check scancode */

module KID(PS2Clk, PS2Data, scancode, CLK, strobe, flag);
input PS2Clk, PS2Data, CLK;
output reg [7:0] scancode;
output reg strobe, flag;

wire [21:0] temp;
wire clk100ms;
wire valid;
wire valid1;
wire singlevalid;

initial begin
scancode <= 0;
strobe <= 0;
flag <= 0;
end


clkdiv clk100 (CLK, clk100ms);
SHF shift22 (PS2Data, temp, PS2Clk);
assign valid = (temp [10:0] == 11'h7E0)?1:0;
DFF dff (clk100ms, valid, valid1);
assign singlevalid = valid & !valid1;

always@ (posedge CLK)
begin
if (singlevalid)
flag <= 1;
end

always@ (posedge clk100ms)
begin
if (singlevalid && !strobe)
strobe <= 1;
else 
strobe <= 0;
end

always@ (posedge CLK)
begin
if (singlevalid)
scancode <= temp [19:12];
end
endmodule

/******************************************************************************************************/

/* clock divider 100ms */
module clkdiv (CLK, clk100ms);
input CLK;
output reg clk100ms;

reg [27:0] counter;

initial begin
clk100ms <= 0;
counter <= 0;
end

always@(posedge CLK)
begin
    if(counter == 10000000) begin
      counter <= 1;
      clk100ms <= ~clk100ms;
    end
    else begin
      counter <= counter + 1;
    end
end

endmodule 

/*dff module*/
module DFF (clk, D, Q);
input clk, D;
output reg Q;

	initial begin
		Q = 0;
	end

  always @ (posedge clk) begin
      Q <= D;
  end

endmodule




