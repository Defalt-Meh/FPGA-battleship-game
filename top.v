// DO NOT CHANGE THE NAME OR THE SIGNALS OF THIS MODULE

module top (
  input        clk    ,
  input  [3:0] sw     ,
  input  [3:0] btn    ,
  output [7:0] led    ,
  output [7:0] seven  ,
  output [3:0] segment
);
wire slow_clk;
wire [3:0] silent_but;
reg [7:0] disp0, disp1, disp2, disp3;
// Clock Divider: Slows down the main clock for game timing
clk_divider clk_dvd (
  .clk_in(clk),
  .divided_clk(slow_clk),
);

// Button Debouncer for Stable Input

debouncer db_inst_0 (
  .clk(slow_clk),
  .rst(~btn[2]),
  .noisy_in(~btn[0]),
  .clean_out(silent_but[0])
);

debouncer db_inst_1 (
  .clk(slow_clk),
  .rst(~btn[2]),
  .noisy_in(~btn[1]),
  .clean_out(silent_but[1])
);

debouncer db_inst_3 (
  .clk(slow_clk),
  .rst(~btn[2]),
  .noisy_in(~btn[3]),
  .clean_out(silent_but[3])
);

battleship battleship_game (
  .clk(slow_clk),
  .rst(~btn[2])  ,
  .start(silent_but[1]),
  .X(sw[3:2])    ,
  .Y(sw[1:0])  ,
  .pAb(silent_but[3])  ,
  .pBb(silent_but[0])  ,
  .disp0(disp0),
  .disp1(disp1),
  .disp2(disp2),
  .disp3(disp3),
  .led(led)
);
// Seven-Segment Display Controller
ssd ssd_inst (
  .clk(clk),
  .disp0(disp0),
  .disp1(disp1),
  .disp2(disp2),
  .disp3(disp3),
  .seven(seven),
  .segment(segment)
);
endmodule