module get_direction(
	input					clk,
	input					rst,
	input					ext,
	input			[7:0] keycode,
	input					make,
	output reg  [1:0]	direction
);


parameter UP = 2'd0;
parameter DOWN = 2'd1;
parameter LEFT = 2'd2;
parameter RIGHT = 2'd3;

parameter W = 8'h1D;
parameter A = 8'h1C;
parameter S = 8'h1B;
parameter D = 8'h23;

initial direction <= UP;


always@(posedge clk)
	if(rst)
		direction <= UP;
	else
		case (keycode)
			W:
				direction <= UP;
			A:
				direction <= LEFT;
			S:
				direction <= DOWN;
			D:
				direction <= RIGHT;
			default:
				direction <= direction; //continues in previously selected direction
		endcase
		

endmodule
