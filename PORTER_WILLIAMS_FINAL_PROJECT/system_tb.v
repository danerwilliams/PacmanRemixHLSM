module system_tb();
	reg			CLOCK_50;
	reg			reset;
	reg			startGame;
	reg	[1:0] direction;
	reg			VGA_CLK;
	reg			x_vga;
	reg			y_vga;
	wire 	[2:0] color_vga;
	
	
system system_uut(

	.CLOCK_50(CLOCK_50),
	.reset(reset),
	.startGame(startGame),
	.direction(direction),
	.VGA_CLK(VGA_CLK),
	.x_vga(x_vga),
	.y_vga(y_vga),
	.color_vga(color_vga)

);

always #5 CLOCK_50 = ~CLOCK_50;
always #10 VGA_CLK = ~VGA_CLK;

initial begin
	CLOCK_50 = 0; reset = 1; startGame = 0; direction = 2'd0; VGA_CLK = 0; x_vga = 80; y_vga = 80; 
	#200;
	reset = 0; startGame = 1; direction = 2'd0; VGA_CLK = 0; x_vga = 80; y_vga = 80; 
	#1000;
	$stop;
	end
endmodule
	