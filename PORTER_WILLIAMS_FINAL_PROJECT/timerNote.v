module timerNote(
	input clk,
	input en_in,
	input rst,
	output t
);
	reg [25:0] count;
	
	assign t = (count == 26'd15000000);
	
	always @(posedge clk) begin
		begin
		if (en_in)
			if (rst | t)
				count <= 0;
			else
				count <= count + 1;
		end
	end
	
endmodule
