module ClockDivider(clk100Mhz, clk10Hz);
input clk100Mhz;
output reg clk10Hz;

  reg[27:0] counter10Hz;

  initial begin
    counter10Hz = 0;
    clk10Hz = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter10Hz == 5000000) begin //5000000
      counter10Hz <= 1;
      clk10Hz <= ~clk10Hz;
    end
    else begin
      counter10Hz <= counter10Hz + 1;
    end
  end

endmodule
