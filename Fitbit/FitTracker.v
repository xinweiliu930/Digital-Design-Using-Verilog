module FitTracker(slowClk, PULSES, RESET, SI, stepcnt, distance, sec, sectime);

input PULSES, RESET,slowClk;
output reg SI;
output reg[13:0] stepcnt;
output reg [8:0] distance;
output reg [3:0] sec;
output reg [8:0] sectime;

reg [20:0] counter;
reg [8:0] counter1;
reg [8:0] counter2;
reg [8:0] counter3;
reg [8:0] counter4;

always@(posedge PULSES or posedge RESET)
begin
if (RESET)
begin
  SI <= 0;
  counter <= 0;
  stepcnt <= 0;
  distance <= 0;
 end
else begin
    counter <= counter + 1;
	distance <= counter/1024;
    if (counter >= 9999)
        begin
        stepcnt <= 9999;
		SI <= 1;
		end
	else
	    stepcnt <= stepcnt + 1;	
end
end

always@ (posedge slowClk or posedge RESET)
begin
if (RESET)
begin 
sec <= 0;
sectime <= 0;
counter1 <= 0;
counter2 <= 0;
counter3 <= 0;
counter4 <= 0;
end
else begin
counter2 <= counter2 + 1;
counter4 <= counter ;
counter3 <= counter - counter4;
/*         seconds higher than 63 steps/s          */
if (counter3 > 63)
counter1 <= counter1 + 1;
else
counter1 <= 0;

if (counter1 <= 59)
sectime <= sectime;
else if (counter1 == 60)
sectime <= sectime + 60;
else 
sectime <= sectime + 1;
/*         seconds higher than 32 steps/s in first 9s         */
if ( ((counter - counter4) > 32) && (counter2 <= 9) && (counter2 >0))
sec <= sec + 1;
end
end

/*always@ (*)
begin
if (RESET)
sec = 0;
else if((counter2 <= 9) && (counter3 >= 32))
sec = sec + 1;
else sec = sec;
end*/




endmodule





