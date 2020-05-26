module TOP(START, CLK, RESET, seg, SI, MODE,an);
input wire START;
input wire CLK;
input wire RESET;
input wire [1:0] MODE;
output wire [6:0] seg;
output wire SI;
output wire [3:0] an;

wire PULSES, slowClk;
wire [13:0] stepcnt;
wire [8:0] distance;
wire [3:0] sec;
wire [8:0] sectime;

PulseGenerator PG(
.slowClk(slowClk),
.CLK(CLK),
.RESET(RESET),
.START(START),
.PULSES(PULSES),
.MODE(MODE));

complexDivider cD(
.CLK(CLK),
.slowClk(slowClk),
.RESET(RESET));

FitTracker FT(
.slowClk(slowClk),
.PULSES(PULSES),
.RESET(RESET),
.SI(SI),
.stepcnt(stepcnt),
.distance(distance),
.sec(sec),
.sectime(sectime));

Display Dp(
.RESET(RESET),
.CLK(CLK),
.slowClk(slowClk),
.stepcnt(stepcnt),
.distance(distance),
.sec(sec),
.sectime(sectime),
.an(an),
.seg(seg));

endmodule
 