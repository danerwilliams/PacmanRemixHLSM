module space_start(
	input					clk,
	input					rst,
	input					ext,
	input			[7:0] keycode,
	input					make,
	output reg  		startGame
);

parameter SPACE = 8'h29;

initial startGame <= 0;


always@(posedge clk)
	if(rst)
		startGame <= 0;
	else
		case (keycode)
			SPACE:
				startGame <= 1;
			default:
				startGame <= 0; //continues in previously selected direction
		endcase
		

endmodule
