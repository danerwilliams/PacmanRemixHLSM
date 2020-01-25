module noteCounter(
	input clk,
	input rst,
	input enTime,
	input en,
	output reg reset_out,
	output reg [5:0] q
);

	initial q = 6'b0;
	initial reset_out = 0;
	
	always @(posedge clk) begin
		reset_out <= 0;
		if(en) begin
			if(rst)
				q <= 0;
			else if (q[5] & q[3] & q[2] & q[1] & q[0]) begin
				q <= 0;
				reset_out <= 1;
			end
			else if (enTime)
				q <= q + 1;
		end
	end
	
endmodule
