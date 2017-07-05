module lab5(
  input                  clk, // 1 led refrash
  input                  btn, // 8 buttons
  input                  rst, // 1 reset key0
  input        [1:0] encoder, // 4 2 encoders input
  output logic [7:0]    sseg, // 8 7 segments + DP
  output logic [2:0]    sel3, // 3 select on encoder
  output logic [7:0]  data_o, // 8 wave output
  output logic [7:0]     led,
  output logic           pwm, // 1 total bright control
  output logic            en, // 1 en
  output logic          en_n, // 1 en_n
  output logic        en_gnd, // 1 gnd for encoder
  output logic       btn_gnd  // 1 gnd for btn
);

  assign en      =    1'b1; // enable
  assign en_n    =    1'b0; // enable bar
  assign en_gnd  =    1'b0; // encoder gnd
  assign btn_gnd =    1'b0; // btn gnd
  assign pwm     =    1'b0; // pwm
  
  logic            clk_ROM;
  logic            clk_10k;
  logic             clk_1m;
  logic [13:0]        cntr; // number to count
  logic              d_btn; // debounced btn
  logic [3:0]    thousands;
  logic [3:0]     hundreds;
  logic [3:0]         tens;
  logic [3:0]         ones;
  
  pll   pll_inst (
    .inclk0 ( clk ),
    .c0 ( clk_10k ),
    .c1 ( clk_1m  ),
	 .c2 ( clk_ROM )
    );

  sseg_display sseg_display_0(.*);
  input_debouncer input_debouncer_0(.*);
  encoder_handler encoder_handler_0(.*);
  sine_ROM sine_ROM_0(.*);
  BCD BCD_0(.*);
  
  /*********************************************
  * turn on and cycle musics. 
  *********************************************/
  
  /*********************************************
  * testing features 
  *********************************************/
 
endmodule 
