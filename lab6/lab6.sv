module lab6(
  input                  clk, // 1 50MHZ
  input        [8:0]     btn, // 9 8 buttons + R encoder btn
  input                  rst, // 1 reset key0
  input             adc_Dout, // 1 adc chip data output
  input        [2:0]adc_ch_s, // 3 adc channel select switch
  input        [3:0] encoder, // 4 2 encoders input
  output logic [7:0]     led, // 8 onboard leds
  output logic [7:0]    sseg, // 8 7 segments + DP
  output logic [2:0]    sel3, // 3 select on encoder
  output logic       adc_Din, // 1 adc chip data input
  output logic      clk_sclk, // 1 testing PIN_J14
  output logic       adc_out, // 1 testing PIN_K15
  output logic      adc_sclk, // 1 adc chip sclk
  output logic      adc_cs_n, // 1 adc chip select
  output logic           pwm, // 1 total bright control
  output logic            en, // 1 en   <= 1
  output logic          en_n, // 1 en_n <= 0
  output logic        en_gnd, // 1 gnd for encoder
  output logic       btn_gnd  // 1 gnd for btn
);

  logic [13:0]     cntr[1:0]; // number to count
  logic [8:0]          d_btn; // debounced btn
  logic [13:0]           num; // number to 7 seg display
  logic [3:0]      thousands; // th
  logic [3:0]       hundreds; // h
  logic [3:0]           tens; // t
  logic [3:0]           ones; // o
  logic              adc_rdy; // adc ready
  logic [11:0]      adc_data; // adc reading data
  logic [11:0]     r3v3_addr; // ROM address
  logic [16:0]      adc_cntr; // adc slow down counter
  
  pll pll_inst (
    .inclk0  ( clk       ),
    .c0      ( clk_10k   ),
    .c1      ( clk_sclk  ),
    .c2      ( clk_ROM   )
    );
	 
  ROM3v3	ROM3v3_inst (
	 .address ( r3v3_addr ),
	 .clock   ( clk_sclk  ),
	 .q       ( num       )
	 );
 

  BCD BCD_0(.*);
  sseg_display sseg_display_0(.*);
  adc_control adc_control_0(.*);
  
  /*********************************************
  * assign wires
  *********************************************/
  assign en       =     1'b1; // enable
  assign en_n     =     1'b0; // enable bar
  assign en_gnd   =     1'b0; // encoder gnd
  assign btn_gnd  =     1'b0; // btn gnd
  assign pwm      =     1'b0; // pwm to gnd
  assign led      = adc_ch_s; // led indicate channel
  assign adc_out  = adc_Dout; // testing 

  /*********************************************
  * adc cntr count up when adc ready
  *********************************************/
  always_ff @(negedge adc_rdy, negedge rst)
  if (!rst)
    adc_cntr <= 0;
  else
    adc_cntr <= (adc_cntr==17'd100000)?1:(adc_cntr+1);
	 
  /*********************************************
  * assign adc data to ROM when its ready
  *********************************************/
  always_ff @(negedge adc_rdy, negedge rst)
  if (!rst)
    r3v3_addr <= 0;
  else
    r3v3_addr <= (adc_cntr==17'd1)?adc_data:r3v3_addr;

  /*********************************************
  * testing
  *********************************************/
endmodule 
