module datapath_tb();

reg 			clk;
reg [1:0] direction;
reg  		startGame;
reg 		en_x_position;
reg [1:0] s_x_position;
reg 		en_y_position;
reg [1:0] s_y_position;
reg 		en_direction;
reg [1:0] s_direction;
reg 		en_timer;
reg [1:0] s_timer;
reg [1:0] s_plot_color;
wire [2:0]	plot_color;
wire [7:0] x_plot;
wire [6:0] y_plot;
wire 		timer_done;

datapath datapath_uut(
.clk(clk),
.direction(direction),
.startGame(startGame),
.en_x_position(en_x_position),
.s_x_position(s_x_position),
.en_y_position(en_y_position),
.s_y_position(s_y_position),
.en_direction(en_direction),
.s_direction(s_direction),
.en_timer(en_timer),
.s_timer(s_timer),
.s_plot_color(s_plot_color),
.plot_color(plot_color),
.x_plot(x_plot),
.y_plot(y_plot),
.timer_done(timer_done)
);


always #5 clk = ~clk;

initial begin
clk = 0; en_timer = 1; s_timer = 1;
#100;
en_timer = 0; s_timer = 1;
#100;
en_timer = 1; s_timer = 0;
#100;
en_timer = 0; s_timer = 0;
#1000;
$stop;
end



endmodule
