/*
------------------------------------------------------------------- 
--                        ASCII HEX TABLE
--  Hex						Low Hex Digit
-- Value  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
------\----------------------------------------------------------------
--H  2 |  SP  !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /
--i  3 |  0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
--g  4 |  @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
--h  5 |  P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _
--   6 |  `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o
--   7 |  p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~ DEL
-----------------------------------------------------------------------
*/

module LCD_ram (
	input				clk,
	input		[4:0]	raddr,
	input		[7:0]	din,
	input		[4:0]	waddr,
	input				we,
	output	[7:0]	dout
	);
	
	reg [7:0] m [0:31];               // Initialize 31 x 8bit memory

	
	always@(posedge clk)
		if (we) begin
			m[waddr] <= din;
		end
	
	assign dout = m[raddr];
	
	initial begin
		// Line 1
		m[8'h00] = "S";
		m[8'h01] = "c";
		m[8'h02] = "o";
		m[8'h03] = "r";
		m[8'h04] = "e";
		m[8'h05] = ":";
		m[8'h06] = " ";
		m[8'h07] = " ";
		m[8'h08] = " ";
		m[8'h09] = " ";
		m[8'h0a] = " ";
		m[8'h0b] = " ";
		m[8'h0c] = " ";
		m[8'h0d] = " ";
		m[8'h0e] = " ";
		m[8'h0f] = " ";
		// Line 2
		m[8'h10] = " ";
		m[8'h11] = " ";
		m[8'h12] = " ";
		m[8'h13] = " ";
		m[8'h14] = " ";
		m[8'h15] = " ";
		m[8'h16] = " ";
		m[8'h17] = " ";
		m[8'h18] = " ";
		m[8'h19] = " ";
		m[8'h1a] = " ";
		m[8'h1b] = " ";
		m[8'h1c] = " ";
		m[8'h1d] = " ";
		m[8'h1e] = " ";
		m[8'h1f] = " ";
	end
	
endmodule
