module lab7(
  input                   clk, // 1 50MHZ
  input        [8:0]      btn, // 8 buttons
  input                   rst, // 1 reset key0
  input              adc_Dout, // 1 adc chip data output
//  input        [2:0] adc_ch_s, // 3 adc channel select switch
  input              uart_rxd, // 1 uart receive
  input        [3:0]  encoder, // 4 2 encoders input
  output logic [7:0]      led, // 8 onboard leds
  output logic [7:0]     sseg, // 8 7 segments + DP
  output logic [2:0]     sel3, // 3 select on encoder
  output logic        adc_Din, // 1 adc chip data input
//  output logic       clk_sclk, // 1 testing
  output logic        adc_out, // 1 testing
  output logic       adc_sclk, // 1 adc chip sclk
  output logic       adc_cs_n, // 1 adc chip select
  output logic        adc_rdy, // 1 adc chip select
  output logic       uart_txd, // 1 uart transmit
  output logic [7:0]  tx_data, // 1 uart transmit
  output logic [7:0]  rx_data, // 1 uart transmit
  output logic       char_sel, // 1 uart transmit
  output logic [3:0]bud_state,
  output logic [2:0]  rx_cntr,
  output logic [2:0]rx_bit_cntr,
  output logic    edge_detect,
  output logic       uart_gnd, // 1 uart gnd
  output logic [13:0]     num, // 1 uart gnd
  output logic            pwm, // 1 total bright control
  output logic             en, // 1 en
  output logic           en_n, // 1 en_n
  output logic         en_gnd, // 1 gnd for encoder
  output logic        btn_gnd  // 1 gnd for btn
);

  logic [13:0]      cntr[1:0]; // number to count
  logic [8:0]           d_btn; // debounced btn
//  logic [13:0]            num; // number to display
  logic [15:0]            bcd; // bin to dec 4 digits
//  logic               adc_rdy; // adc ready
  logic [11:0]       adc_data; // 1 adc chip data input
  logic [11:0]      r3v3_addr; // 3v3 ROM address
  logic [11:0]       adc_D3v3; // 3v3 ROM output
  logic [16:0]       adc_cntr; // adc slow down counter
  logic [2:0]        adc_ch_s; // adc chip channel select
  
//  pll pll_inst (
//    .inclk0  ( clk       ),
//    .c0      ( clk_10k   ),
//    .c1      ( clk_sclk  ),
//    .c2      ( clk_bud   )
//    .c3      ( clk_4xbud ),
//  );
//	 
//  ROM3v3 ROM3v3_inst (
//	 .address ( r3v3_addr ),
//	 .clock   ( clk_sclk  ),
//	 .q       ( adc_D3v3  )
//  );
 
  logic              clk_10k;
  logic             clk_sclk;
  logic              clk_bud;
  logic            clk_8xbud;
  sub_clk sub_clk_0(.*);  
//  input_debouncer input_debouncer_0(.*);
//  encoder_handler encoder_handler_0(.*); 

  BCD BCD_0(.*);
  sseg_display sseg_display_0(.*);
  adc_ctrl adc_ctrl_0(.*);
  uart_ctrl uart_ctrl_0(.*);
  
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
//  assign r3v3_addr= adc_data; // assign adc_data to ROM
  assign uart_gnd =     1'b0; // uart gnd
  assign adc_D3v3 =  12'h987; // uart gnd
  
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
    num <= 0;
  else
    num <= (adc_cntr==17'd1)?adc_D3v3:num;

  /*********************************************
  * testing
  *********************************************/

endmodule 
