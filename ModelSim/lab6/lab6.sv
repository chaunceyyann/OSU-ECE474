module lab6(
  input                  clk, // 1 50MHZ
  input        [8:0]     btn, // 8 buttons
  input                  rst, // 1 reset key0
  input                  key, // 1 pwm increament
  input             adc_Dout, // 1 adc chip data output
  input        [3:0] encoder, // 4 2 encoders input
  output logic [7:0]     led, // 8 onboard leds
  output logic [7:0]    sseg, // 8 7 segments + DP
  output logic [2:0]    sel3, // 3 select on encoder
  output logic[11:0]adc_data, // 1 adc chip data input
  output logic       adc_Din, // 1 adc chip data input
  output logic      adc_cs_n,
  output logic      adc_sclk,
  output logic [2:0]adc_ch_s,
  output logic           pwm, // 1 total bright control
  output logic            en, // 1 en
  output logic          en_n, // 1 en_n
  output logic        en_gnd, // 1 gnd for encoder
  output logic       btn_gnd  // 1 gnd for btn
);

  assign en        =    1'b1; // enable
  assign en_n      =    1'b0; // enable bar
  assign en_gnd    =    1'b0; // encoder gnd
  assign btn_gnd   =    1'b0; // btn gnd
  assign pwm       =    1'b0; // pwm to gnd
  
  logic              clk_ROM;
  logic              clk_10k;
  logic             clk_2d5m;
  logic [13:0]     cntr[1:0]; // number to count
  logic [8:0]          d_btn; // debounced btn
  logic [13:0]           num;
  logic [3:0]      thousands;
  logic [3:0]       hundreds;
  logic [3:0]           tens;
  logic [3:0]           ones;
  logic [11:0]     adc_pdata;
  logic [3:0]      adc_state;
  logic              adc_rdy;
  
  //pll   pll_inst (
  //  .inclk0 ( clk ),
  //  .c0 ( clk_10k ),
  //  .c1 ( clk_1m  ),
  //  .c2 ( clk_ROM )
  //  );

  sub_clk sub_clk_0(.*);  
  input_debouncer input_debouncer_0(.*);
  encoder_handler encoder_handler_0(.*); 
  BCD BCD_0(.*);
  sseg_display sseg_display_0(.*);
  adc_control adc_control_0(.*);
  
  /*********************************************
  * assign wires
  *********************************************/
  //assign num = cntr[0];
  
  /*********************************************
  * testing features 
  *********************************************/
  always_ff @(posedge clk_2d5m, negedge rst)
    if (!rst)
      adc_rdy <= 0;
    else
      if (adc_state == 15)
      begin
        adc_data <= adc_pdata;
        adc_rdy  <= 1;
      end
      else
      begin
        adc_data <= 0;
        adc_rdy  <= 0;
      end


  always_ff @(negedge adc_rdy, negedge rst)
    if (!rst)
      adc_ch_s <= 0;
    else 
      adc_ch_s <= adc_ch_s + 1;
	 
endmodule 
