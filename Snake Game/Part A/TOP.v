module TOP(PS2Clk,PS2Data,CLK,strobe,seg,an);
input wire PS2Clk, PS2Data, CLK;
output wire strobe;
output wire [6:0] seg;
output wire [3:0] an;

wire [7:0] scancode;
wire flag;

KID kid(
.PS2Clk(PS2Clk),
.PS2Data(PS2Data),
.scancode(scancode),
.CLK(CLK),
.flag(flag),
.strobe(strobe));

display dis(
.scancode(scancode),
.CLK(CLK),
.seg(seg),
.flag(flag),
.an(an));

endmodule
