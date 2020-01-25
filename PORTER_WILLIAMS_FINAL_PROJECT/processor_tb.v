`timescale 1ns/1ns

module processor_tb();

	reg 						clk;
	reg 				[1:0] direction;
	reg							reset;
	reg							startGame;
	reg							touchingGhost;
	reg							touchingWall;
	reg							badGhostYes;
	reg					[7:0] xGhost;
	reg					[6:0] yGhost;
	
	wire				[7:0] x;
	wire				[6:0] y;
	wire				[2:0] plot_color;
	wire						plot;
	wire				[1:0]	s_screen;
	wire						move_index;
	wire						en_ghostRand;
	wire						s_game_over;
	wire				[3:0] score;


	processor processor_uut(
		.clk(clk),
		.direction(direction),
		.reset(reset),
		.startGame(startGame),
		.touchingGhost(touchingGhost),
		.touchingWall(touchingWall),
		.badGhostYes(badGhostYes),
		.xGhost(xGhost),
		.yGhost(yGhost),
		.x(x),
		.y(y),
		.plot_color(plot_color),
		.plot(plot),
		.s_screen(s_screen),
		.move_index(move_index),
		.en_ghostRand(en_ghostRand),
		.s_game_over(s_game_over),
		.score(score)
	);


	always #5 clk = ~clk;
	
	initial begin
	clk = 0; reset = 0; direction = 0; startGame = 0; touchingWall = 0; touchingGhost = 0; badGhostYes = 0;
	#50;
	startGame = 1;
	#50;
	touchingGhost = 1;
	#50;
	touchingGhost = 0;
	#50;
	touchingGhost = 1;
	#50;
	touchingGhost = 0;
	#50;
	$stop;
	end

	
	
endmodule
