module square_wave_osc_JWS(
	input 					CLOCK_50,
	input 					reset,
	input 			[5:0] note,
	output 			[31:0] out
);



	reg [19:0] HALF_WAVELENGTH;
	reg [31:0] AMPLITUDE;
	
	always @(note) begin
		case(note)
			//0: HALF_WAVELENGTH = 20'd151_690;
			 0: HALF_WAVELENGTH = 20'd152_439;//E
			 1: HALF_WAVELENGTH = 20'd152_439;//E
			 2: HALF_WAVELENGTH = 20'd50;
			 3: HALF_WAVELENGTH = 20'd171_233; //D
			 4: HALF_WAVELENGTH = 20'd171_233; //D
			 5: HALF_WAVELENGTH = 20'd50;
			 6: HALF_WAVELENGTH = 20'd192_308; //C
			 7: HALF_WAVELENGTH = 20'd192_308; //C
			 8: HALF_WAVELENGTH = 20'd192_308; //C
			 9: HALF_WAVELENGTH = 20'd192_308; //C
			10: HALF_WAVELENGTH = 20'd50;
			11: HALF_WAVELENGTH = 20'd152_439;//E
			12: HALF_WAVELENGTH = 20'd152_439;//E
			13: HALF_WAVELENGTH = 20'd50;
			14: HALF_WAVELENGTH = 20'd171_233; //D
			15: HALF_WAVELENGTH = 20'd171_233; //D
			16: HALF_WAVELENGTH = 20'd50;
			17: HALF_WAVELENGTH = 20'd192_308; //C
			18: HALF_WAVELENGTH = 20'd192_308; //C
			19: HALF_WAVELENGTH = 20'd192_308; //C
			20: HALF_WAVELENGTH = 20'd192_308; //C
			21: HALF_WAVELENGTH = 20'd50;
			22: HALF_WAVELENGTH = 20'd192_308; //C
			23: HALF_WAVELENGTH = 20'd50;
			24: HALF_WAVELENGTH = 20'd192_308; //C
			25: HALF_WAVELENGTH = 20'd50;
			26: HALF_WAVELENGTH = 20'd192_308; //C
			27: HALF_WAVELENGTH = 20'd50;
			28: HALF_WAVELENGTH = 20'd192_308; //C
			29: HALF_WAVELENGTH = 20'd50;
			30: HALF_WAVELENGTH = 20'd171_233; //D
			31: HALF_WAVELENGTH = 20'd50;
			32: HALF_WAVELENGTH = 20'd171_233; //D
			33: HALF_WAVELENGTH = 20'd50;
			34: HALF_WAVELENGTH = 20'd171_233; //D
			35: HALF_WAVELENGTH = 20'd50;
			36: HALF_WAVELENGTH = 20'd171_233; //D
			37: HALF_WAVELENGTH = 20'd50;
			38: HALF_WAVELENGTH = 20'd152_439;//E
			39: HALF_WAVELENGTH = 20'd152_439;//E
			40: HALF_WAVELENGTH = 20'd50;
			41: HALF_WAVELENGTH = 20'd171_233; //D
			42: HALF_WAVELENGTH = 20'd171_233; //D
			43: HALF_WAVELENGTH = 20'd50;
			44: HALF_WAVELENGTH = 20'd192_308; //C
			45: HALF_WAVELENGTH = 20'd192_308; //C
			44: HALF_WAVELENGTH = 20'd192_308; //C
			45: HALF_WAVELENGTH = 20'd192_308; //C
			46: HALF_WAVELENGTH = 20'd50;
			default HALF_WAVELENGTH = 20'd50;
		endcase
		
		if (HALF_WAVELENGTH == 20'd50)
			AMPLITUDE = 0;
		else
			AMPLITUDE = 32'd10_000;	
	end
	
	
	reg [19:0] count = 0;
	reg		  phase = 0;
	
	always @(posedge CLOCK_50)
		if (reset) begin
			count <= 0;
			phase <= 0;
		end
		else if (count == HALF_WAVELENGTH) begin
			count <= 0;
			phase <= ~phase;
		end
		else begin
			count <= count + 1;
		end
		
		assign out = phase ? AMPLITUDE : -AMPLITUDE;
		
endmodule

	
	