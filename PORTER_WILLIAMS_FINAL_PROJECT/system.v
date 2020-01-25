module system(
	input 				CLOCK_50,
	input					reset,
	input 				startGame,
	input			[1:0] direction,
	input					VGA_CLK,
	input			[7:0] x_vga,
	input			[6:0] y_vga,
	
	input					touchingWall,
	input					touchingGhost,
//	
	output		[2:0] color_vga, //test bench says it's fucked
	
	output				s_game_over,
	output				collisionDetect,
	output		[7:0] realScorefactsB
	
);


	wire 			[7:0] x;
	wire 			[6:0] y;		
	wire 			[7:0] xGhost;
	wire 			[6:0] yGhost;		
	wire 			[2:0] plot_color;
	wire					plot;
	wire					move_index;
	wire					in_sprite;
	wire					in_ghost;
	wire			[2:0] sprite_color;
	wire			[2:0] ghost_color;
	wire			[2:0] ghost_color1;
	wire			[2:0] background_color;
	wire			[2:0] background_color1;
	wire			[2:0] startscreen_color;
	wire			[2:0]	gameover_color;
	wire 			[1:0] s_screen;
	wire					en_ghostRand;
	wire			 		backgroundColorRead;
	wire					ghostColorRead;
	wire					ghostBackgroundlarry;
	wire					badGhostYes;
	wire					goodGhosthahaJK;
	wire			[3:0] score;
	wire			[3:0] score1;
	
	
	parameter STARTSCREEN = 2'd0;
	parameter PLAYSCREEN = 2'd1;
	parameter GAMEOVERSCREEN = 2'd2;
	
processor myProcessor(
	.clk(CLOCK_50),
	.direction(direction),
	.reset(reset),
	.startGame(startGame),
	.x(x),
	.y(y),
	.plot_color(plot_color),
	.plot(plot),
	.s_screen(s_screen),
	.en_ghostRand(en_ghostRand),
	.move_index(move_index),
	.s_game_over(s_game_over),
	.touchingGhost(ghostColorRead),
	.touchingWall(backgroundColorRead),
	.badGhostYes(badGhostYes),
	.xGhost(xGhost),
	.yGhost(yGhost),
	.score(score1),
	.goodGhosthahaJK(goodGhosthahaJK)
//	.backgroundColorRead(touchingWall)
);

	

ghostRand myGhost(
	.clk(CLOCK_50), 
	.en_ghostRand(en_ghostRand), //input from processor so that new random ghost is generated after previous is eaten/collided
	.x(xGhost),
	.y(yGhost)
);

sprite_rom mySprite_rom(
	.clk(VGA_CLK),
	.x(x_vga - x), //	.x(x_vgam - x1),
	.y(y_vga - y), //.y(y_vga - y1),
	.dout(sprite_color)
);

ghost_rom myGhost_rom(
	.clk(VGA_CLK),
	.x(x_vga - xGhost), //	.x(x_vgam - x1),
	.y(y_vga - yGhost), //.y(y_vga - y1),
	.dout(ghost_color)
);

background_rom myBackground_rom (
      .clk        (VGA_CLK),
      .x          (x_vga),
      .y          (y_vga),  
      .dout       (background_color)
);

gameover_rom myGameover_rom (
      .clk        (VGA_CLK),
      .x          (x_vga),
      .y          (y_vga),  
      .dout       (gameover_color)
);

startscreen_rom myStartscreen_rom (
      .clk        (VGA_CLK),
      .x          (x_vga),
      .y          (y_vga),  
      .dout       (startscreen_color)
);



background_rom collisionBackground(
		.clk        (VGA_CLK),
      .x          (x),
      .y          (y),  
      .dout       (background_color1)
);



background_rom ghostBackground(
		.clk        (VGA_CLK),
      .x          (xGhost),
      .y          (yGhost),  
      .dout       (ghostBackgroundlarry)
);

countScore myScore(
	.en(ghostColorRead),
	.reset(reset),
	.q(score)

);	


ascii scoreAscii(
	.in0(score),
	.clk(CLOCK_50),
	.out0(realScorefactsB)
);




assign badGhostYes = (ghostBackgroundlarry == 3'd1) ? 1 : 0;
assign backgroundColorRead = (background_color1 == 3'd1) ? 1 : 0;
assign collisionDetect = (background_color1 == 3'd1) ? 1 : 0;
assign ghostColorRead = 
	(x >= xGhost) &
	(x < (xGhost + 4)) &
	(y >= yGhost) &
	(y < (yGhost + 4));

assign in_sprite = 
	(x_vga >= x) &
	(x_vga < (x + 4)) &
	(y_vga >= y) &
	(y_vga < (y + 4));
	

assign in_ghost = 
	(x_vga >= xGhost) &
	(x_vga < (xGhost + 4)) &
	(y_vga >= yGhost) &
	(y_vga < (yGhost + 4));

assign goodGhosthahaJK = (in_sprite & (x_vga >= 155 | x_vga < 5 | y_vga > 115 | y_vga < 5));
	
assign color_vga =
	s_screen == STARTSCREEN ? startscreen_color : 
	s_screen == GAMEOVERSCREEN ? gameover_color :
	in_sprite ? sprite_color :
	in_ghost	 ? ghost_color :
	background_color;
	
endmodule
