module background_rom_tb();

reg        clk;    			
reg  [1:0] x;
reg  [1:0] y; 
wire [2:0] dout;

background_rom background_rom_uut(
.clk(clk),    			
.x(x),
.y(y),  
.dout(dout)
);

always #5 clk = ~clk;

initial begin
	clk = 0; x = 80; y=80;
	#1000;
	$stop;
	end
endmodule