module Top(sw0,sw1, sw2, sw3, sw4, sw5, sw6, sw7, R, G, B, hSync, vSync, PS2Clk, PS2Data, clk, an, seg, sw8);

input wire sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, PS2Clk, PS2Data,clk, sw8;
output wire hSync, vSync;
output wire [3:0] R, G, B;
output wire [3:0] an;
output wire [6:0] seg;

wire [7:0] scancode;
wire flag;
wire scancode, blackout;
wire [9:0] xcoord1, ycoord1, xcoord2, ycoord2, xcoord3, ycoord3, xcoord4, ycoord4;
wire strobe;

KID kid(
.PS2Clk(PS2Clk),
.PS2Data(PS2Data),
.scancode(scancode),
.CLK(clk),
.flag(flag),
.strobe(strobe));

Snakecontrol snk(
.scancode(scancode),
.xcoord1(xcoord1),
.ycoord1(ycoord1),
.xcoord2(xcoord2),
.ycoord2(ycoord2),
.xcoord3(xcoord3),
.ycoord3(ycoord3),
.xcoord4(xcoord4),
.ycoord4(ycoord4),
.CLK(clk),
.strobe(strobe),
.sw8(sw8),
.blackout(blackout));

VGAController vga(
.clk(clk),
.sw0(sw0),
.sw1(sw1),
.sw2(sw2),
.sw3(sw3),
.sw4(sw4),
.sw5(sw5),
.sw6(sw6),
.sw7(sw7),
.R(R),
.G(G),
.B(B),
.hSync(hSync),
.vSync(vSync),
.xCoord1(xcoord1),
.yCoord1(ycoord1),
.xCoord2(xcoord2),
.yCoord2(ycoord2),
.xCoord3(xcoord3),
.yCoord3(ycoord3),
.xCoord4(xcoord4),
.yCoord4(ycoord4),
.blackout(blackout));

display dis(
.scancode(scancode),
.CLK(clk),
.flag(flag),
.seg(seg),
.an(an));


endmodule