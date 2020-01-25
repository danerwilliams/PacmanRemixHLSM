module processor(
	input 						clk,
	input 				[1:0] direction,
	input							reset,
	input							startGame,
	input							touchingGhost,
	input							touchingWall,
	input							badGhostYes,
	input					[7:0] xGhost,
	input					[6:0] yGhost,
	input							goodGhosthahaJK,
//	input					 		backgroundColorRead,
	
	output				[7:0] x,
	output				[6:0] y,
	output				[2:0] plot_color,
	output						plot,
	output				[1:0]	s_screen,
	output						move_index,
	output						en_ghostRand,
	output						s_game_over,
	output				[3:0] score
);


	 wire 						en_x_position;
    wire 				[1:0] s_x_position;
    wire 						en_y_position;
    wire 				[1:0] s_y_position; 
    wire 						en_timer;
    wire 				[1:0] s_timer;
    wire 						en_direction;
    wire 				[1:0] s_direction;
    wire 				[1:0] s_plot_color;
	 wire 						timer_done;
	 wire							actuallyBadGhost;
	 wire							s_score;
	 wire							en_score;
//	 wire							touchingMaze;
	 
	 
controller myController(
	.clk(clk),
	.touchingWall(touchingWall),
	.touchingGhost(touchingGhost),
	.actuallybadGhost(actuallyBadGhost),
	.reset(reset),
	.timer_done(timer_done),
	.direction(direction),
	.startGame(startGame),
	.en_x_position(en_x_position),
	.s_x_position(s_x_position),
	.en_y_position(en_y_position),
	.s_y_position(s_y_position),
	.en_direction(en_direction),
	.s_direction(s_direction),
	.en_timer(en_timer),
	.s_timer(s_timer),
	.move_index(move_index),
	.s_plot_color(s_plot_color),
	.s_screen(s_screen),
	.en_ghostRand(en_ghostRand),
	.plot(plot),
	.s_game_over(s_game_over),
	.en_score(en_score),
	.s_score(s_score)
);

datapath myDatapath(
	.clk(clk),
	.direction(direction),
	.startGame(startGame),
	.en_x_position(en_x_position),
	.s_x_position(s_x_position),
	.en_y_position(en_y_position),
	.s_y_position(s_y_position),
	.en_direction(en_direction),
	.s_direction(s_direction),
	.en_timer(en_timer),
	.s_timer(s_timer),
	.s_plot_color(s_plot_color),
	.plot_color(plot_color),
	.x_plot(x),
	.y_plot(y),
	.timer_done(timer_done),
	.badGhostYes(badGhostYes),
	.xGhost(xGhost),
	.yGhost(yGhost),
	.actuallyBadGhost(actuallyBadGhost),
	.s_score(s_score),
	.en_score(en_score),
	.score(score),
	.goodGhosthahaJK(goodGhosthahaJK)
//	.backgroundColorRead(backgroundColorRead),
//	.touchingMaze(touchingMaze)
);

endmodule

