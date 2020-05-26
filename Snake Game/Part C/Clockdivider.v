module ClockDivider(clk100Mhz, clk25MHz);
input clk100Mhz;
output reg clk25MHz;

  reg[2:0] counter25MHz;

  initial begin
    counter25MHz = 0;
    clk25MHz = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter25MHz == 2) begin //50000000
      counter25MHz <= 1;
      clk25MHz <= ~clk25MHz;
    end
    else begin
      counter25MHz <= counter25MHz + 1;
    end
  end

endmodule
