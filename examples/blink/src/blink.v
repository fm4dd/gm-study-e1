// -------------------------------------------------------
// blink.v    gm-study-e1 demo program     @20220924 fm4dd
//
// Requires: 10x LEDs, clk
//
// Description:
// ------------
// This program blinks alternately odd LEDs and even LEDs.
// A 1Hz blink pulse derived from the 10MHz signal SB_A8:
// 10MHz clock needs breakpoint at 23'd4999999 (gatemate)
// -------------------------------------------------------

module blink(
  input wire clk,
  input wire rst,
  output reg [9:0] stled
);

  reg clk_1hz;
  reg [22:0] count;


  always @(posedge clk or negedge rst)
  begin
    if (!rst) begin
      clk_1hz = 1'b1;
      count = 0;
      stled = 10'b0000000000;
    end
    else begin 
      count   <= count + 1;
      if(count == 23'd4999999) begin
        count   <= 0;
        clk_1hz <= ~clk_1hz;
        stled[0] = clk_1hz;
        stled[2] = clk_1hz;
        stled[4] = clk_1hz;
        stled[6] = clk_1hz;
        stled[8] = clk_1hz;
        stled[1] = ~clk_1hz;
        stled[3] = ~clk_1hz;
        stled[5] = ~clk_1hz;
        stled[7] = ~clk_1hz;
        stled[9] = ~clk_1hz;
      end
    end
  end

endmodule
