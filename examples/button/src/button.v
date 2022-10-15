// -------------------------------------------------------
// button.v    gm-study-e1 demo program    @20220924 fm4dd
//
// Requires: LEDs, Push Buttons, 7-Segment modules, clk
//
// Description:
// ------------
// This program runs a light from LED0 to LED9, or back.
// pushbutton PB0 changes the speed between 1, 2, 4, 8Hz.
// pushbutton PB1 reverses the running light direction.
// The pushbuttons are debounced. Two 7-Segment modules
// show speed (HEX4: 0-3) and the direction (HEX5: F/b).
// -------------------------------------------------------
module button(
   input wire clk,
   input wire rst,
   input wire [2:0] stbtn,
   output wire [9:0] stled,
   output wire [7:0] sthex4,
   output wire [7:0] sthex5
);

// -------------------------------------------------------
//  REG/WIRE declarations
// -------------------------------------------------------
wire [4:0] data_0;
wire [4:0] data_1;
reg [9:0] lednum;
reg [22:0] div;
reg [1:0] mode;
reg speed;
reg dir;

// -------------------------------------------------------
//  Structural coding
// -------------------------------------------------------
assign stled = ~lednum;

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
hexdigit h0 (data_0, 1'b0, sthex4);
hexdigit h1 (data_1, 1'b0, sthex5);
assign  data_0 = mode;
assign  data_1 = dir? 5'd11 : 5'd15;

// -------------------------------------------------------
// Module get_speed: Creates a clock derivate based on the
// div factor, returned into register speed.
// -------------------------------------------------------
get_speed sp (clk, rst, div, speed);

// -------------------------------------------------------
// Module debounce: get a clean push-button state signal
// -------------------------------------------------------
reg btn0, btn1;
wire btn0_down, btn1_down;
wire btn0_up, btn1_up;

debounce d0 (stbtn[0], clk, btn0, btn0_down, btn0_up);
debounce d1 (stbtn[1], clk, btn1, btn1_down, btn1_up);

always @(posedge clk or negedge rst)
begin
  if (!rst) begin
    mode <= 2'd0;
    dir <= 1'b0;
  end
  else begin
    if(btn0_down) mode = mode + 1; // increment mode
    if(btn1_down) dir = ~dir;      // change direction
  end
end

always @(posedge speed or negedge rst)
begin
  if(!rst) begin
    lednum = 10'b1111111110;  // LED seed
  end
  else begin
    case (mode)
      0: div = 23'd312499;  // 16Hz
      1: div = 23'd624999;  //  8Hz
      2: div = 23'd1249999; //  4Hz
      3: div = 23'd2499999; //  2Hz
    endcase
    if(!dir)   // forward direction
      if(lednum != 10'b0111111111) begin
        lednum[9] = lednum[8];
        lednum[8] = lednum[7];
        lednum[7] = lednum[6];
        lednum[6] = lednum[5];
        lednum[5] = lednum[4];
        lednum[4] = lednum[3];
        lednum[3] = lednum[2];
        lednum[2] = lednum[1];
        lednum[1] = lednum[0];
        lednum[0] = 1'b1;
      end
      else lednum = 10'b1111111110;
    else begin  // backward direction
      if(lednum != 10'b1111111110) begin
        lednum[0] = lednum[1];
        lednum[1] = lednum[2];
        lednum[2] = lednum[3];
        lednum[3] = lednum[4];
        lednum[4] = lednum[5];
        lednum[5] = lednum[6];
        lednum[6] = lednum[7];
        lednum[7] = lednum[8];
        lednum[8] = lednum[9];
        lednum[9] = 1'b1;
      end
      else lednum = 10'b0111111111;
    end
  end
end
endmodule


// -------------------------------------------------------
// Module get_speed creates a lower frequency based on div
// -------------------------------------------------------
module get_speed(
  input wire clk,
  input wire rst,
  input reg [22:0] div,
  output reg clk_out
);

reg [22:0] count;

always @(posedge clk or negedge rst)
begin
  if (!rst) begin
    clk_out = 1'b1;
    count = 0;
  end
  else begin 
    count <= count + 1;
    if(count == div) begin
      count <= 0;
      clk_out <= ~clk_out;
    end
  end
end
endmodule
