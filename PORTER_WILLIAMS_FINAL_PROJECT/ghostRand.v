module ghostRand(
	input clk, 
	input en_ghostRand,
	output reg [7:0] x,
	output reg [6:0] y
);


initial x = 8'd40;
initial y = 8'd40;

always @(posedge clk)
begin
	
		if (en_ghostRand) begin
			x <= {x[6:0], x[7]^x[0]};
			y <= {y[5:0], y[6]^y[0]};
		end
end



endmodule
