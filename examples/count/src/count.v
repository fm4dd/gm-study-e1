// -------------------------------------------------------
// count.v     gm-study-e1 demo program    @20220924 fm4dd
//
// Requires: LEDs, Slide Switches, 7-Segment modules, clk
//
// Description:
// ------------
// This program is a binary counter, displayed as binary
// on LED's, and in hexadecimal on the 7-Segment digits.
// The hex digits are enabled/disabled by slide switches.
// The 7-segment decimal points pulse the counter clock.
// The count pulse is 1Hz, derived from the system clock:
// 10MHz clock: set breakpoint at 23'd4999999 (gatemate)
// 12MHz clock: set breakpoint at 23'd5999999 (icebreaker)
// 50MHz clock: set breakpoint at 25'd24999999 (de10-lite)
// -------------------------------------------------------

module count(
  input clk,
  input rst,
  input  [9:0] stswi,
  output [9:0] stled,
  output [7:0] sthex0,
  output [7:0] sthex1,
  output [7:0] sthex2,
  output [7:0] sthex3,
  output [7:0] sthex4,
  output [7:0] sthex5
);

parameter pulsebreak = 23'd4999999; // for 10MHz clock
//parameter pulsebreak = 25'd24999999; // for 50MHz clock

// -------------------------------------------------------
//  REG/WIRE declarations
// -------------------------------------------------------
reg clk_1hz;
reg [15:0] count;
reg [24:0] pulse;
wire [4:0] data_0;
wire [4:0] data_1;
wire [4:0] data_2;
wire [4:0] data_3;
wire [4:0] data_4;
wire [4:0] data_5;
assign stled = count;  // negate if using E1 onboard leds

// -------------------------------------------------------
//  Module hexdigit: Creates the LED pattern from 3 args:
// in:  0-15 displays the hex value from 0..F
//      16 = all_on
//      17 = - (show minus sign)
//      18 = _ (show underscore)
//      19 = S
//     >19 = all_off
// dp:  0 or 1, disables/enables the decimal point led
// out: bit pattern result driving the 7seg module leds
// -------------------------------------------------------
hexdigit h0 (data_0, clk_1hz, sthex0);
hexdigit h1 (data_1, clk_1hz, sthex1);
hexdigit h2 (data_2, clk_1hz, sthex2);
hexdigit h3 (data_3, clk_1hz, sthex3);
hexdigit h4 (data_4, clk_1hz, sthex4);
hexdigit h5 (data_5, clk_1hz, sthex5);

// -------------------------------------------------------
// Construct hex digit number from the counter or disable
// the hex digit if the corresponding switch # is "off".
// -------------------------------------------------------
assign data_0 = stswi[0] ?count[3:0]   :20; 
assign data_1 = stswi[1] ?count[7:4]   :20;
assign data_2 = stswi[2] ?count[11:8]  :20;
assign data_3 = stswi[3] ?count[15:12] :20;
assign data_4 = stswi[4] ?0            :20;
assign data_5 = stswi[5] ?0            :20;

always @(posedge clk_1hz or negedge rst)
begin
  if (!rst) count = 0;
  else count <= count + 1;
end

always @(posedge clk or negedge rst)
begin
  if (!rst) begin
    clk_1hz = 1'b1;
    pulse = 0;
  end
  else begin
    pulse <= pulse + 1;
    if(pulse == pulsebreak) begin
      pulse <= 0;
      clk_1hz <= ~clk_1hz;
    end
  end
end

endmodule
