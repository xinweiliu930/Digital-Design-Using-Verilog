module display(scancode, CLK, seg, an, flag);

input [7:0] scancode;
input CLK,flag;
output reg [6:0] seg;
output reg [3:0] an;

reg [15:0] counter1;
reg [1:0] counter2;
reg clkscan;
reg [3:0] out;

initial begin
seg <= 7'b1111111;
an <= 4'b1111;
counter1 <= 0;
counter2 <= 0;
clkscan <= 0;
end

always @(posedge CLK) 
begin
if (counter1 == 50000)
begin
clkscan <= ~clkscan;
counter1 <= 1;
end
else 
counter1 <= counter1 + 1;
end

always @(posedge clkscan)
begin
if(counter2 == 0)
    begin
	an <= 4'b1110;
	counter2 <= counter2 + 1;
	end
else if(counter2 == 1)
    begin
	an <= 4'b1101;
	counter2 <= 0;
	end
end

always @(*)
begin
     case (an)
     4'b1110: out = scancode[3:0];
	 4'b1101: out = scancode[7:4];
	 default: out = 0;
     endcase
end



always @(*)
begin
if (flag) begin
    case (out)
    4'h0   : seg = 7'b1000000;
    4'h1   : seg = 7'b1111001;
    4'h2   : seg = 7'b0100100;
    4'h3   : seg = 7'b0110000;
    4'h4   : seg = 7'b0011001;
    4'h5   : seg = 7'b0010010;
    4'h6   : seg = 7'b0000010;
    4'h7   : seg = 7'b1111000;
    4'h8   : seg = 7'b0000000;
    4'h9   : seg = 7'b0011000;
	4'ha   : seg = 7'b0100000; 
	4'hb   : seg = 7'b0000011;
	4'hc   : seg = 7'b1000110;
	4'hd   : seg = 7'b0100001;
	4'he   : seg = 7'b0000100;
	4'hf   : seg = 7'b0001110;

	endcase
	end
else 
    seg = 7'b1111111;
end

endmodule