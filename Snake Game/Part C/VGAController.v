module VGAController(clk, sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, R, G, B, hSync, vSync, xCoord1, xCoord2, yCoord1, yCoord2, xCoord3, xCoord4, yCoord3, yCoord4, blackout);
//module VGAController(clk, sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, R, G, B, hSync, vSync);
input clk;
input sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7;
input blackout;
input	[9:0] xCoord1, xCoord2, yCoord1, yCoord2, xCoord3, xCoord4, yCoord3, yCoord4;
//reg	[9:0] xCoord1, xCoord2, yCoord1, yCoord2;
output reg hSync, vSync;
output reg [3:0] R, G, B;

wire pixelClock;
wire visibleRegion;

reg [9:0] hCounter, vCounter;

ClockDivider u1(.clk100Mhz(clk), .clk25MHz(pixelClock));

initial begin
	hCounter = 0;
	vCounter = 0;
	hSync = 1;
	vSync = 1;
	R = 0;
	G = 0;
	B = 0;
	//xCoord1 = 0;
	//xCoord2 = 49;
	//yCoord1 = 100;
	//yCoord2 = 109;
end

always @(posedge pixelClock) begin
	if (hCounter == 799) begin
		hCounter <= 0;
	end
	else begin
		hCounter <= hCounter + 1;
	end
end

always @(posedge pixelClock) begin
	if (hCounter == 799) begin
		if (vCounter == 524) begin
			vCounter <= 0;
		end
		else begin
			vCounter <= vCounter + 1;
		end
	end
	else begin
		vCounter <= vCounter;
	end
end

always @(posedge pixelClock) begin
	if (hCounter == 658) begin
		hSync <= 0;
	end
	else if (hCounter == 755) begin
		hSync <= 1;
	end
end

always @(posedge pixelClock) begin
	if ((vCounter == 492) && (hCounter == 799)) begin
		vSync <= 0;
	end
	else if ((vCounter == 494) && (hCounter == 799)) begin
		vSync <= 1;
	end
end

//assign hSync = ~((hCounter >= 659) && (hCounter <= 755)) ;	//need to use FF
//assign vSync = ~((vCounter >= 493) && (vCounter <= 494)) ;

assign visibleRegion = ((hCounter < 639) && (vCounter < 479)) || ((hCounter < 639) && (vCounter == 479)) || ((hCounter == 799) && (vCounter < 479)) || ((hCounter == 799) && (vCounter == 524));

always @(posedge pixelClock) begin
	if (~visibleRegion || blackout) begin
		R <= 0;
		G <= 0;
		B <= 0;
	end
	else if ((hCounter >= xCoord1 - 4) && (hCounter <= xCoord1 + 5) && (vCounter >= yCoord1 -4) && (vCounter <= yCoord1 + 5)) begin //square 1
		R <= 0;
		G <= 0;
		B <= 15;
	end
	else if ((hCounter >= xCoord2 - 4) && (hCounter <= xCoord2 + 5) && (vCounter >= yCoord2 -4) && (vCounter <= yCoord2 + 5)) begin //square 2
		R <= 0;
		G <= 0;
		B <= 15;
	end
	else if ((hCounter >= xCoord3 - 4) && (hCounter <= xCoord3 + 5) && (vCounter >= yCoord3 -4) && (vCounter <= yCoord3 + 5)) begin //square 3
		R <= 0;
		G <= 0;
		B <= 15;
	end
	else if ((hCounter >= xCoord4 - 4) && (hCounter <= xCoord4 + 5) && (vCounter >= yCoord4 -4) && (vCounter <= yCoord4 + 5)) begin //square 4
		R <= 0;
		G <= 0;
		B <= 15;
	end
	else if (sw0) begin		//black 0 0 0
		R <= 0;
		G <= 0;
		B <= 0;
	end
	else if (sw1) begin		//blue 0 0 255
		R <= 0;
		G <= 0;
		B <= 15;
	end
	else if (sw2) begin		//brown 165 42 42
		R <= 10;
		G <= 2;
		B <= 2;
	end
	else if (sw3) begin		//cyan 0 139 139
		R <= 0;
		G <= 8;
		B <= 8;
	end
	else if (sw4) begin		//red 255 0 0
		R <= 15;
		G <= 0;
		B <= 0;
	end
	else if (sw5) begin		//magenta 139 0 139
		R <= 8;
		G <= 0;
		B <= 8;
	end
	else if (sw6) begin		//yellow 255 255 0
		R <= 15;
		G <= 15;
		B <= 0;
	end
	else if (sw7) begin		//white 255 255 255
		R <= 15;
		G <= 15;
		B <= 15;
	end
	else begin
		R <= 0;
		G <= 0;
		B <= 0;
	end
end

endmodule

/*
module VGAController(clk, sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, R, G, B, hSync, vSync);
input clk;
input sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7;
output reg hSync, vSync;
output reg [3:0] R, G, B;

wire pixelClock;
wire visibleRegion;

reg [9:0] hCounter, vCounter;

ClockDivider u1(.clk100Mhz(clk), .clk25MHz(pixelClock));

initial begin
	hCounter = 0;
	vCounter = 0;
	hSync = 1;
	vSync = 1;
	R = 0;
	G = 0;
	B = 0;
end

always @(posedge pixelClock) begin
	if (hCounter == 799) begin
		hCounter <= 0;
	end
	else begin
		hCounter <= hCounter + 1;
	end
end

always @(posedge pixelClock) begin
	if (hCounter == 799) begin
		if (vCounter == 524) begin
			vCounter <= 0;
		end
		else begin
			vCounter <= vCounter + 1;
		end
	end
	else begin
		vCounter <= vCounter;
	end
end

always @(posedge pixelClock) begin
	if (hCounter == 658) begin
		hSync <= 0;
	end
	else if (hCounter == 755) begin
		hSync <= 1;
	end
end

always @(posedge pixelClock) begin
	if ((vCounter == 492) && (hCounter == 799)) begin
		vSync <= 0;
	end
	else if ((vCounter == 494) && (hCounter == 799)) begin
		vSync <= 1;
	end
end

//assign hSync = ~((hCounter >= 659) && (hCounter <= 755)) ;	//need to use FF
//assign vSync = ~((vCounter >= 493) && (vCounter <= 494)) ;

assign visibleRegion = ((hCounter < 639) && (vCounter < 479)) || ((hCounter < 639) && (vCounter == 479)) || ((hCounter == 799) && (vCounter < 479)) || ((hCounter == 799) && (vCounter == 524));

always @(posedge pixelClock) begin
	if (~visibleRegion) begin
		R <= 0;
		G <= 0;
		B <= 0;
	end
	else if (sw0) begin		//black 0 0 0
		R <= 0;
		G <= 0;
		B <= 0;
	end
	else if (sw1) begin		//blue 0 0 255
		R <= 0;
		G <= 0;
		B <= 15;
	end
	else if (sw2) begin		//brown 165 42 42
		R <= 10;
		G <= 2;
		B <= 2;
	end
	else if (sw3) begin		//cyan 0 139 139
		R <= 0;
		G <= 8;
		B <= 8;
	end
	else if (sw4) begin		//red 255 0 0
		R <= 15;
		G <= 0;
		B <= 0;
	end
	else if (sw5) begin		//magenta 139 0 139
		R <= 8;
		G <= 0;
		B <= 8;
	end
	else if (sw6) begin		//yellow 255 255 0
		R <= 15;
		G <= 15;
		B <= 0;
	end
	else if (sw7) begin		//white 255 255 255
		R <= 15;
		G <= 15;
		B <= 15;
	end
	else begin
		R <= 0;
		G <= 0;
		B <= 0;
	end
end

endmodule
*/