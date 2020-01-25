module background_rom ( 
   input                clk,    			
   input          [7:0] x,
   input          [6:0] y,  
   output   reg   [2:0] dout
   );
   
   parameter IMAGE_FILE = "maze.mem";
   
   wire [14:0] addr  = 160*y + x;
   
   reg [2:0] mem [0:19199];
   initial $readmemh(IMAGE_FILE, mem);

   always @(posedge clk)
      dout <= mem[addr];
   
endmodule
