// -------------------------------------------------------
// blink.v    gm-study-e1 demo program    @20220924 fm4dd
//
// Requires: 10x LEDs, system clock
//
// Description:
// ------------
// This program blinks alternately the even and odd LEDs.
// A 2Hz blink pulse derived from the 10MHz signal SB_A8:
// 10MHz clock needs breakpoint at 23'd4999999 (gatemate)
// -------------------------------------------------------

module blink(
  input wire clk,
  input wire rst,
  output wire [9:0] stled
);

  reg clk_1hz;
  reg [22:0] count;

  assign {stled[0], stled[2], stled[4], stled[6], stled[8]} = {5{clk_1hz}};
  assign {stled[1], stled[3], stled[5], stled[7], stled[9]} = {5{~clk_1hz}};

  always @(posedge clk or negedge rst)
  begin
    if (!rst) begin
      clk_1hz = 1'b1;
      count = 0;
    end
    else begin 
      count   <= count + 1;
      if(count == 23'd4999999) begin
        count   <= 0;
        clk_1hz <= ~clk_1hz;
      end
    end
  end

endmodule
