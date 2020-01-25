module sprite_rom ( 
   input                clk,    			
   input          [1:0] x,
   input          [1:0] y,  
   output   reg   [2:0] dout
   );
   
   parameter IMAGE_FILE = "sprite.mem";
   
   wire [3:0] addr  = 4*y + x;
   
   reg [2:0] mem [0:15];
   initial $readmemh(IMAGE_FILE, mem);

   always @(posedge clk)
         dout <= mem[addr];
   
endmodule
