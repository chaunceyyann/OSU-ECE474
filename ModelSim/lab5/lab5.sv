module lab5(
  input                clk, // 1 led refrash
  input                rst, // 1 reset key0
  input      [7:0]     btn, // 8 buttons
  input      [3:0] encoder, // 4 2 encoders input
  output reg [7:0]     led, // 8 onboard leds
  output reg [7:0]    sseg, // 8 7 segments + DP
  output reg [2:0]    sel3, // 3 select on encoder
  output reg           pwm, // 1 total bright control
  output reg            en, // 1 en
  output reg          en_n, // 1 en_n
  output reg        en_gnd  // 1 gnd for encoder
);

  assign en      =    1'b1; // enable and enable bar
  assign en_n    =    1'b0; // enable and enable bar
  assign en_gnd  =    1'b0; // enable and enable bar
  
  logic            clk_10k; 
  logic             clk_1m; 
  logic [15:0]        cntr; // number to count
  logic [3:0]     pwm_duty; // 16 pwm duty levels
  logic [15:0]    pwm_cntr; // pwm 2s counter
  logic [7:0] pwm_clk_cntr; // pwm clk create counter
  logic [7:0]        d_btn; // debounced btn
  logic [3:0]    d_encoder; // debounced encoder
  
//  pll   pll_inst (
//    .inclk0        ( clk ),
//    .c0        ( clk_10k ),
//    .c1         ( clk_1m )
//  );

  sub_clk sub_clk_0(.*); 
  sseg_display sseg_display_0(.*);
  pwm_create pwm_create_0(.*);
  input_debouncer input_debouncer_0(.*);
  encoder_handler encoder_handler_0(.*);

  /*********************************************
  * testing features 
  *********************************************/
  assign led[3:0] = pwm_duty;
  assign led[7]   = pwm;
endmodule 


