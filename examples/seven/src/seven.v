// -------------------------------------------------------
// seven.v     gm-study-e1 demo program    @20220924 fm4dd
//
// Requires: LEDs, Slide Switches, 7-Segment modules
//
// Description:
// ------------
// This program tests the 7-segment digits without a clock.
// It lights up all led segments, and switch 0-5 shows the
// corresponding digit on the modules 0-5.
// -------------------------------------------------------
module seven(
  input [9:0] stswi,
  output [9:0] stled,
  output [7:0] sthex0,
  output [7:0] sthex1,
  output [7:0] sthex2,
  output [7:0] sthex3,
  output [7:0] sthex4,
  output [7:0] sthex5
);

// -------------------------------------------------------
//  REG/WIRE declarations
// -------------------------------------------------------
wire [4:0] data_0;
wire [4:0] data_1;
wire [4:0] data_2;
wire [4:0] data_3;
wire [4:0] data_4;
wire [4:0] data_5;

// -------------------------------------------------------
//  Structural coding
// -------------------------------------------------------
assign stled = stswi;

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
hexdigit h0 (data_0, 1'b0, sthex0);
hexdigit h1 (data_1, 1'b0, sthex1);
hexdigit h2 (data_2, 1'b0, sthex2);
hexdigit h3 (data_3, 1'b0, sthex3);
hexdigit h4 (data_4, 1'b0, sthex4);
hexdigit h5 (data_5, 1'b0, sthex5);

// -------------------------------------------------------
// Set hex digit number to the switch number, or disable
// the hex module if the corresponding switch # is "off"
// We have less digits than switches, for switch 6-9 only
// updates the led. Assigning '20' triggers the default
// "off" pattern for the 7-seg display digit.
// -------------------------------------------------------
assign data_0 = stswi[0] ?0 :16; 
assign data_1 = stswi[1] ?1 :16;
assign data_2 = stswi[2] ?2 :16;
assign data_3 = stswi[3] ?3 :16;
assign data_4 = stswi[4] ?4 :16;
assign data_5 = stswi[5] ?5 :16;

endmodule
