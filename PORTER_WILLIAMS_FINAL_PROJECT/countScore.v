module countScore(
	input en,
	input reset,
	output reg [3:0] q
);


initial q = 4'd0;

always @(posedge en)
	begin
		if (en)
			begin
				q <= q + 1;
			end
		if(reset)
			begin
				q <= 0;
			end
	end
	
endmodule

	