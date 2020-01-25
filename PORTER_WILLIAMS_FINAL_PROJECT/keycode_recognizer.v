module keycode_recognizer (
	input					clk,
	input					reset_n,
	input					ps2_key_en,
	input			[7:0]	ps2_key_data,
	output reg	[7:0]	keycode,
	output reg			ext,
	output reg			make,
	output reg			keycode_ready
	);
	
	reg [7:0]	keycode_d;
	reg			ext_d;
	reg			make_d;
	reg			keycode_ready_d;
	
	always @(posedge clk) begin
		keycode_ready	<= keycode_ready_d;
		if (keycode_ready_d) begin
			keycode 			<= keycode_d;
			ext 				<= ext_d;
			make 				<= make_d;
		end
	end
	
	parameter S_START		= 3'd0;
	parameter S_F0			= 3'd1;
	parameter S_E0			= 3'd2;
	parameter S_E0F0		= 3'd3;
	parameter S_XX			= 3'd4;
	parameter S_F0XX		= 3'd5;
	parameter S_E0XX		= 3'd6;
	parameter S_E0F0XX	= 3'd7;
	
	reg [2:0] state, next_state;
	
	always @(posedge clk)
		if (!reset_n)
			state <= S_START;
		else
			state <= next_state;
	
	always @(*) begin
		keycode_d 			= 0;  
		ext_d 				= 0;  
		make_d 				= 0;  
		keycode_ready_d	= 0;
		case (state)
			S_START:	begin
				if (!ps2_key_en)
					next_state = S_START;
				else begin
					if (ps2_key_data == 8'hE0)
						next_state = S_E0;
					else if (ps2_key_data == 8'hF0)
						next_state = S_F0;
					else
						next_state = S_XX;
				end
			end
			
			S_F0:	begin
				if (!ps2_key_en)
					next_state = S_F0;
				else begin
					next_state = S_F0XX;
				end
			end
			
			S_E0: begin
				if (!ps2_key_en)
					next_state = S_E0;
				else begin
					if (ps2_key_data == 8'hF0)
						next_state = S_E0F0;
					else
						next_state = S_E0XX;
				end
			end
			
			S_E0F0: begin
				if (!ps2_key_en)
					next_state = S_E0F0;
				else begin
					next_state = S_E0F0XX;
				end
			end
			
			S_XX:	begin
				keycode_d = ps2_key_data;
				make_d 				= 1;
				keycode_ready_d	= 1;
				next_state 			= S_START;
			end
			
			S_F0XX: begin
				keycode_d 			= ps2_key_data;
				keycode_ready_d 	= 1;
				next_state 			= S_START;
			end
			
			S_E0XX: begin
				keycode_d 			= ps2_key_data;
				make_d 				= 1;
				ext_d 				= 1;
				keycode_ready_d 	= 1;
				next_state 			= S_START;
			end
			
			S_E0F0XX: begin
				keycode_d 			= ps2_key_data;
				ext_d 				= 1;
				keycode_ready_d	= 1;
				next_state 			= S_START;
			end
			
			default:  next_state = S_START;
		endcase
	end
	
	
	
endmodule