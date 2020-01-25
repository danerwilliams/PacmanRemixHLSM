/*
 * Based on the University of Toronto vga_controller, modified by Jay Brockman, U. Notre Dame
 * Major differences
 *    - Outputs x,y indices rather than linear memory address
 *    - Takes CLOCK_50 as input and generates 25 MHz VGA_CLK using simple clock divider
 *    - Self contained, no dependence on external modules
 */

module vga_xy_controller(
   CLOCK_50, 
   resetn, 
   color, 
   x, 
   y, 
   VGA_R, 
   VGA_G, 
   VGA_B,
   VGA_HS, 
   VGA_VS, 
   VGA_BLANK,
   VGA_SYNC, 
   VGA_CLK);
	
	/* Screen resolution and colour depth parameters. */
	
	parameter BITS_PER_COLOR_CHANNEL = 1;
	/* The number of bits per colour channel used to represent the colour of each pixel. A value
	 * of 1 means that Red, Green and Blue colour channels will use 1 bit each to represent the intensity
	 * of the respective colour channel. For BITS_PER_COLOR_CHANNEL=1, the adapter can display 8 colours.
	 * In general, the adapter is able to use 2^(3*BITS_PER_COLOR_CHANNEL) colours. The number of colours is
	 * limited by the screen resolution and the amount of on-chip memory available on the target device.
	 */	
	
	parameter MONOCHROME = "FALSE";
	/* Set this parameter to "TRUE" if you only wish to use black and white colours. Doing so will reduce
	 * the amount of memory you will use by a factor of 3. */
	
//	parameter RESOLUTION = "320x240";
	parameter RESOLUTION = "160x120";
	/* Set this parameter to "160x120" or "320x240". It will cause the VGA adapter to draw each dot on
	 * the screen by using a block of 4x4 pixels ("160x120" resolution) or 2x2 pixels ("320x240" resolution).
	 * It effectively reduces the screen resolution to an integer fraction of 640x480. It was necessary
	 * to reduce the resolution for the Video Memory to fit within the on-chip memory limits.
	 */
	
	//--- Timing parameters.
	/* Recall that the VGA specification requires a few more rows and columns are drawn
	 * when refreshing the screen than are actually present on the screen. This is necessary to
	 * generate the vertical and the horizontal syncronization signals. If you wish to use a
	 * display mode other than 640x480 you will need to modify the parameters below as well
	 * as change the frequency of the clock driving the monitor (VGA_CLK).
	 */
   
   parameter C_VERT_NUM_PIXELS  = 10'd480;
	parameter C_VERT_SYNC_START  = 10'd489;
	parameter C_VERT_SYNC_END    = 10'd490; //(C_VERT_SYNC_START + 2 - 1); 
	parameter C_VERT_TOTAL_COUNT = 10'd525;

	parameter C_HORZ_NUM_PIXELS  = 10'd640;
	parameter C_HORZ_SYNC_START  = 10'd656;
	parameter C_HORZ_SYNC_END    = 10'd751; //(C_HORZ_SYNC_START + 96 - 1); 
	parameter C_HORZ_TOTAL_COUNT = 10'd800;
		
	/*****************************************************************************/
	/* Declare inputs and outputs.                                               */
	/*****************************************************************************/
	
	input CLOCK_50, resetn;
	input [((MONOCHROME == "TRUE") ? (0) : (BITS_PER_COLOR_CHANNEL*3-1)):0] color;
	output reg [((RESOLUTION == "320x240") ? (8) : (7)):0] x;
	output reg [((RESOLUTION == "320x240") ? (7) : (6)):0] y;
	output reg [9:0] VGA_R;
	output reg [9:0] VGA_G;
	output reg [9:0] VGA_B;
	output reg VGA_HS;
	output reg VGA_VS;
	output reg VGA_BLANK;
	output VGA_SYNC;
   output reg VGA_CLK;
	
	/*****************************************************************************/
	/* Local Signals.                                                            */
	/*****************************************************************************/
	
	reg VGA_HS1;
	reg VGA_VS1;
	reg VGA_BLANK1; 
	reg [9:0] xCounter, yCounter;
	wire xCounter_clear;
	wire yCounter_clear;
	wire vcc;
	
   initial VGA_CLK = 1'b0;

	
	/*****************************************************************************/
	/* Controller implementation.                                                */
	/*****************************************************************************/

	assign vcc =1'b1;
   
   /* Generate VGA_CLOCK at 25 MHz */
   always @(posedge CLOCK_50)
      VGA_CLK <= ~VGA_CLK;
	
	/* A counter to scan through a horizontal line. */
	always @(posedge VGA_CLK or negedge resetn)
	begin
		if (!resetn)
			xCounter <= 10'd0;
		else if (xCounter_clear)
			xCounter <= 10'd0;
		else
		begin
			xCounter <= xCounter + 1'b1;
		end
	end
	assign xCounter_clear = (xCounter == (C_HORZ_TOTAL_COUNT-1));

	/* A counter to scan vertically, indicating the row currently being drawn. */
	always @(posedge VGA_CLK or negedge resetn)
	begin
		if (!resetn)
			yCounter <= 10'd0;
		else if (xCounter_clear && yCounter_clear)
			yCounter <= 10'd0;
		else if (xCounter_clear)		//Increment when x counter resets
			yCounter <= yCounter + 1'b1;
	end
	assign yCounter_clear = (yCounter == (C_VERT_TOTAL_COUNT-1)); 
	
	/* Convert the xCounter/yCounter location from screen pixels (640x480) to our
	 * local dots (320x240 or 160x120). Here we effectively divide x/y coordinate by 2 or 4,
	 * depending on the resolution. */
	always @(*)
	begin
		if (RESOLUTION == "320x240")
		begin
			x = xCounter[9:1];
			y = yCounter[8:1];
		end
		else
		begin
			x = xCounter[9:2];
			y = yCounter[8:2];
		end
	end

	/* Generate the vertical and horizontal synchronization pulses. */
	always @(posedge VGA_CLK)
	begin
		//- Sync Generator (ACTIVE LOW)
		VGA_HS1 <= ~((xCounter >= C_HORZ_SYNC_START) && (xCounter <= C_HORZ_SYNC_END));
		VGA_VS1 <= ~((yCounter >= C_VERT_SYNC_START) && (yCounter <= C_VERT_SYNC_END));
		
		//- Current X and Y is valid pixel range
		VGA_BLANK1 <= ((xCounter < C_HORZ_NUM_PIXELS) && (yCounter < C_VERT_NUM_PIXELS));	
	
		//- Add 1 cycle delay
		VGA_HS <= VGA_HS1;
		VGA_VS <= VGA_VS1;
		VGA_BLANK <= VGA_BLANK1;	
	end
	
	/* VGA sync should be 1 at all times. */
	assign VGA_SYNC = vcc;
	
	
	/* Brighten the colour output. */
	// The colour input is first processed to brighten the image a little. Setting the top
	// bits to correspond to the R,G,B colour makes the image a bit dull. To brighten the image,
	// each bit of the colour is replicated through the 10 DAC colour input bits. For example,
	// when BITS_PER_COLOR_CHANNEL is 2 and the red component is set to 2'b10, then the
	// VGA_R input to the DAC will be set to 10'b1010101010.
	
	integer index;
	integer sub_index;
	
	always @(color)
	begin		
		VGA_R <= 'b0;
		VGA_G <= 'b0;
		VGA_B <= 'b0;
		if (MONOCHROME == "FALSE")
		begin
			for (index = 10-BITS_PER_COLOR_CHANNEL; index >= 0; index = index - BITS_PER_COLOR_CHANNEL)
			begin
				for (sub_index = BITS_PER_COLOR_CHANNEL - 1; sub_index >= 0; sub_index = sub_index - 1)
				begin
					VGA_R[sub_index+index] <= color[sub_index + BITS_PER_COLOR_CHANNEL*2];
					VGA_G[sub_index+index] <= color[sub_index + BITS_PER_COLOR_CHANNEL];
					VGA_B[sub_index+index] <= color[sub_index];
				end
			end	
		end
		else
		begin
			for (index = 0; index < 10; index = index + 1)
			begin
				VGA_R[index] <= color[0:0];
				VGA_G[index] <= color[0:0];
				VGA_B[index] <= color[0:0];
			end	
		end
	end

endmodule
