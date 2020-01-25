module controller_tb();
reg 		clk;
reg 		reset;
reg 		timer_done;
reg [1:0] direction;
reg  		startGame;
reg 		touchingGhost;
reg 		touchingWall;
wire 		en_x_position;
wire 		s_game_over;
wire [1:0] s_x_position;
wire 		en_y_position;
wire [1:0] s_y_position;
wire 		en_direction;
wire [1:0] s_direction;
wire 		en_timer;
wire [1:0] s_timer;
wire 		move_index;
wire [1:0] s_plot_color;
wire [1:0] s_screen;
wire 		en_ghostRand;
wire 		plot;
wire		en_score;
wire		s_score;

controller controller_uut(
.clk(clk),
.reset(reset),
.timer_done(timer_done),
.direction(direction),
.startGame(startGame),
.touchingGhost(touchingGhost),
.touchingWall(touchingWall),
.en_x_position(en_x_position),
.s_game_over(s_game_over),
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
.en_score(en_score),
.s_score(s_score)
);
	
	
	always #5 clk = ~clk;
	always #10 timer_done = ~timer_done;
	
	initial begin
	clk = 0; reset = 0; timer_done = 0; direction = 0; startGame = 0; touchingGhost = 0; touchingWall = 0;
	#50;
	reset = 0;  startGame = 1; touchingWall = 0;
	#50;
	reset = 0;  direction = 0; touchingGhost = 1;
	#50;
	reset = 0;  direction = 0; touchingGhost = 0;
	#100;
	reset = 0;  direction = 0; touchingWall = 1;
	#100;
	reset = 1;  direction = 0; touchingWall = 0;
	#100;
	reset = 0; startGame = 1; direction = 0; touchingWall = 0;
	#100;
	reset = 0;  direction = 0; touchingWall = 0;
	#10000;
	$stop;
	end
endmodule
	
	
	