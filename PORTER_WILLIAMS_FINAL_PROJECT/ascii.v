module ascii(
	input  [3:0]in0,
	input			clk,
	output reg [7:0]out0
);


	// convert binary to ascii
always @(posedge clk)
	case(in0)
	0: out0 <= "0";
	1: out0 <= "1";
	2: out0 <= "2";
	3: out0 <= "3";
	4: out0 <= "4";
	5: out0 <= "5";
	6: out0 <= "6";
	7: out0 <= "7";
	8: out0 <= "8";
	9: out0 <= "9";
	endcase
	
	endmodule
	
	