module datapath(
	input 					clk,
	input 		[1:0] direction,
	input			 		startGame,
	input					en_x_position,
	input			[1:0] s_x_position,
	input					en_y_position,
	input			[1:0] s_y_position,
	input					en_direction,
	input			[1:0] s_direction,
	input					en_timer,
	input			[1:0] s_timer,
	input					en_score,
	input					s_score,
	input			[7:0] xGhost,
	input			[6:0] yGhost,
	input					badGhostYes,
	input					goodGhosthahaJK,
//	input			 backgroundColorRead,
	input			[1:0] s_plot_color,
	output		[2:0]	plot_color,
	output 		[7:0] x_plot,
   output 		[6:0] y_plot,
	output 				timer_done,
	output				actuallyBadGhost,
	output		[3:0] score
//	output				touchingMaze
);


reg [25:0] timer;
reg [7:0] x_position;
reg [6:0] y_position;
reg [3:0] scorerios;

parameter TIMER_LIMIT = 26'd3000000; //26'd3_000_000; 
parameter init_x_position = 5;
parameter init_y_position = 75;
parameter init_score = 1;

parameter BLACK = 3'd0;

initial timer = 26'd0;

always@(posedge clk)
    if(en_x_position)
        case(s_x_position)
            0: x_position <= init_x_position;
            1: x_position <= x_position + 1;
            2: x_position <= x_position - 1;
        
        endcase


always @(posedge clk)
    if (en_y_position)
        case(s_y_position)
            0: y_position <= init_y_position;
            1: y_position <= y_position + 1;
            2: y_position <= y_position - 1;
        endcase

always @(posedge clk)
    if (en_timer)
        if(s_timer)
            timer <= timer + 1;
        else
            timer <= 0;
		
always @(posedge en_score)
	if (en_score)
		case (s_score)
			0: scorerios <= init_score;
			1: scorerios <= scorerios + 1;
		endcase
				
assign plot_color = BLACK;
assign timer_done = timer == TIMER_LIMIT;
assign x_plot = x_position;
assign y_plot = y_position;
assign score = scorerios;
assign actuallyBadGhost = badGhostYes + goodGhosthahaJK;
//assign actuallyBadGhost = ~(~badGhostYes & 
//			xGhost > 8'd10 & 
//			xGhost < 8'd135 & 
//			yGhost > 7'd10 & 
//			yGhost < 7'd135);
//assign touchingMaze = backgroundColorRead;



endmodule
