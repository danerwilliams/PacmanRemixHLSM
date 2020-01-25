module system_de2_tb();

reg				CLOCK_50;
reg		[2:0] KEY; //last input
wire				VGA_CLK;  				//	VGA Clock
wire				VGA_HS;					//	VGA H_SYNC
wire				VGA_VS;					//	VGA V_SYNC
wire				VGA_BLANK;				//	VGA BLANK
wire				VGA_SYNC;				//	VGA SYNC
wire[9:0]		VGA_R;   				//	VGA Red[9:0]
wire[9:0]		VGA_G; 				//	VGA Green[9:0]
wire[9:0]		VGA_B;	  

system_de2 system_de2_uut(
	.CLOCK_50(CLOCK_50),
	.KEY(KEY),
	.VGA_CLK(VGA_CLK), 				//	VGA Clock
	.VGA_HS(VGA_HS),					//	VGA H_SYNC
	.VGA_VS(VGA_VS),					//	VGA V_SYNC
	.VGA_BLANK(VGA_BLANK),				//	VGA BLANK
	.VGA_SYNC(VGA_SYNC),				//	VGA SYNC
	.VGA_R(VGA_R),   				//	VGA Red[9:0]
	.VGA_G(VGA_G), 				//	VGA Green[9:0]
	.VGA_B(VGA_B)
);


initial begin
	CLOCK_50 = 0; KEY = 3'd0;
	#1000;
	$stop;
	end


endmodule
