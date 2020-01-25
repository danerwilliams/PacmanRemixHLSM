module controller(
	input 				clk,
	input 				reset,
	input 				timer_done,
	input 		[1:0] direction,
	input			 		startGame,
	input					touchingGhost,
	input					touchingWall,
	input					actuallybadGhost,
	output reg			en_x_position,
	output reg			s_game_over,
	output reg	[1:0] s_x_position,
	output reg			en_y_position,
	output reg	[1:0] s_y_position,
	output reg			en_direction,
	output reg	[1:0] s_direction,
	output reg			en_timer,
	output reg	[1:0] s_timer,
	output reg			move_index,
	output reg	[1:0] s_plot_color,
	output reg  [1:0] s_screen,
	output reg  		en_ghostRand,
	output reg			plot,
	output reg			s_score,
	output reg			en_score
);

	parameter INIT = 5'd0;
	parameter WAIT = 5'd1;
	parameter OPENING_SCREEN = 5'd2;
	parameter MOVE_UP = 5'd3;
	parameter CHOOSE_DIRECTION = 5'd4;
	parameter MOVE_DOWN = 5'd5;
	parameter MOVE_LEFT = 5'd6;
	parameter MOVE_RIGHT = 5'd7;
	parameter PAUSE = 5'd8;
	parameter MOVE_INDEX = 5'd9;
	parameter DRAW_NEXT = 5'd10;
	parameter CHECK_GHOST_COLLISION = 5'd11;
	parameter CHECK_WALL_COLLISION = 5'd12;
	parameter GAMEOVER = 5'd13;
	parameter WAIT_FOR_PLAY = 5'd14;
	parameter GEN_GHOST = 5'd15;
	parameter CHECK_FREE = 5'd16;
	
	
	parameter init_x_position = 7;
	parameter init_y_position = 50;
	
	
	parameter UP = 2'd0;
	parameter DOWN = 2'd1;
	parameter LEFT = 2'd2;
	parameter RIGHT = 2'd3;
	
	parameter STARTSCREEN = 2'd0;
	parameter PLAYSCREEN = 2'd1;
	parameter GAMEOVERSCREEN = 2'd2;
	
	
	reg [4:0] state, next_state;
	reg startGame1;
	
	
	always @(posedge clk)
		if (reset)
		begin
			startGame1 <= 0;
			state <= OPENING_SCREEN;
		end
		else
		begin
			state <= next_state;
			startGame1 <= startGame;
		end
			
	always @(*) begin
		en_x_position = 0;
		s_x_position = 0;
		en_y_position = 0;
		s_y_position = 0;
		en_direction = 0;
		s_direction = 0;
		move_index = 0;
		en_timer = 0;
		s_timer = 0;
		s_plot_color = 0;
		s_game_over = 0;
//		s_screen = STARTSCREEN;
		plot = 0;
		en_ghostRand = 0;
		s_score = 0;
		en_score = 0;
		next_state = INIT;
		
	case (state)
		INIT: begin
			en_x_position = 1;
			s_x_position = 0;
			en_y_position = 1;
			s_y_position = 0;
			en_direction = 1;
			s_direction = 0;
			move_index = 0;
			s_game_over = 0;
			en_timer = 1;
			s_timer = 0;
			s_plot_color = 0;
			s_score = 1;
			en_score = 1;
			en_ghostRand = 1;
			s_screen = STARTSCREEN; 
			next_state = OPENING_SCREEN; //WAIT;
			end
		WAIT: begin
			  s_screen = PLAYSCREEN;
			  s_timer = 1; en_timer = 1; en_ghostRand = 0;
            if(timer_done)
						next_state = CHOOSE_DIRECTION;
            else
                next_state = WAIT;
            end
				
		WAIT_FOR_PLAY: begin
			s_screen = PLAYSCREEN;
			next_state = WAIT;
			end
		OPENING_SCREEN: begin
			s_screen = STARTSCREEN;
			en_x_position = 1;
			s_x_position = 0;
			en_y_position = 1;
			s_y_position = 0;
			if(startGame1) begin
				next_state = WAIT_FOR_PLAY;
				end
			else
				next_state = OPENING_SCREEN;
			end
		CHOOSE_DIRECTION: begin
			s_screen = PLAYSCREEN;
			case (direction)
				UP: next_state = MOVE_UP;
				DOWN: next_state = MOVE_DOWN;
				LEFT: next_state = MOVE_LEFT;
				RIGHT: next_state = MOVE_RIGHT;
				default: next_state = MOVE_RIGHT; 
         endcase
			end
		 MOVE_UP: begin
				s_screen = PLAYSCREEN;
            en_y_position = 1;
            s_y_position = 2;
            next_state = PAUSE;
            end
        MOVE_LEFT: begin
				s_screen = PLAYSCREEN;
            en_x_position = 1;
            s_x_position = 2;
            next_state = PAUSE;
            end
        MOVE_RIGHT: begin
				s_screen = PLAYSCREEN;
            en_x_position = 1;
            s_x_position = 1;
            next_state = PAUSE;
            end
        MOVE_DOWN: begin
				s_screen = PLAYSCREEN;
            en_y_position = 1;
            s_y_position = 1;
            next_state = PAUSE;
            end
		  PAUSE: begin
				s_screen = PLAYSCREEN;
				en_timer = 1;
				s_timer = 0;
				next_state = CHECK_WALL_COLLISION;
//				next_state = MOVE_INDEX;
				end
		  MOVE_INDEX: begin
				s_screen = PLAYSCREEN;
            move_index = 1;
				en_ghostRand = 0;
            next_state = DRAW_NEXT;
            end
			DRAW_NEXT: begin
				s_screen = PLAYSCREEN;
				s_plot_color = 1;
				plot = 1;
				next_state = WAIT;
			end
			CHECK_WALL_COLLISION: begin
				s_screen = PLAYSCREEN;
				if(touchingWall)
					next_state = GAMEOVER;
				else
					next_state = CHECK_GHOST_COLLISION;
			end
			CHECK_GHOST_COLLISION: begin
				s_screen = PLAYSCREEN;
				if(touchingGhost) begin
					 s_score = 1;
					 next_state = GEN_GHOST;
				end
				else
					next_state = MOVE_INDEX;
			end
			GAMEOVER: begin
				s_screen = GAMEOVERSCREEN;
				next_state = GAMEOVER;
				//s_game_over = 1;
				//next_state = INIT;
			end
			GEN_GHOST: begin
				s_score = 1;
				s_screen = PLAYSCREEN;
				en_ghostRand = 1;
				next_state = CHECK_FREE;
			end
			CHECK_FREE: begin
				s_screen = PLAYSCREEN;
				if(actuallybadGhost)
					next_state = GEN_GHOST;
				else
					next_state = MOVE_INDEX;
			end
			default: next_state = OPENING_SCREEN;
			endcase
		end
endmodule
