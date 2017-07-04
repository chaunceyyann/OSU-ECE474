module lab4(
  input      [7:0]     btn, // 8 buttons
  input                clk, // 1 led refrash
  input                rst, // 1 reset key0
  input                key, // 1 pwm increament
  input      [3:0] encoder, // 4 2 encoders input
  output reg [7:0]     led, // 8 onboard leds
  output reg [7:0]    sseg, // 8 7 segments + DP
  output reg [2:0]    sel3, // 3 select on encoder
  output reg           pwm, // 1 total bright control
  output reg            en, // 1 en
  output reg          en_n, // 1 en_n
  output reg        en_gnd  // 1 gnd for encoder
);

  assign en      = 1'b1;// enable and enable bar
  assign en_n    = 1'b0;// enable and enable bar
  assign en_gnd  = 1'b0;// enable and enable bar
  
  int dec_to_7seg[0:11] = '{
  8'b11000000, 8'b11111001, 8'b10100100, 8'b10110000,  // 0 1 2 3
  8'b10011001, 8'b10010010, 8'b10000010, 8'b11111000,  // 4 5 6 7
  8'b10000000, 8'b10010000, 8'b10000011, 8'b10001000}; // 8 9 ^ :
    
  logic [1:0]     curr_state;// current state of encoder
  logic [7:0]     prev_state;// previous state of encoder
  logic [15:0]encoder_state[3:0];// holds present state of encoder
  logic [3:0]       dencoder;// debounced encoder
  logic [15:0]          cntr;// number to count
  logic [15:0]btn_state[7:0];// holds present state
  logic [7:0]           dbtn;// debounced btn
  logic [1:0]           sel2;// 2bit select for display
  logic [3:0]       pwm_duty;// 16 pwm duty levels
  logic [15:0]      pwm_cntr;// pwm 2s counter
  logic [7:0]   pwm_clk_cntr;// pwm clk create counter
  
//  pll   pll_inst (
//    .inclk0 ( clk ),
//    .c0 ( clk_10k ),
//    .c1 ( clk_1m )
//    );

  logic              clk_10k;
  logic               clk_1m;
  logic [15:0]      clk_cntr;

  /*********************************************
  * clk divider 50m to 10k
  *********************************************/
  always_ff @(posedge clk, negedge rst)
  if (!rst)
  begin
    clk_cntr <= 16'd0;
    clk_10k <= 1'b0;
    clk_1m <= 1'b0;
  end
  else
  begin
    clk_cntr <= (clk_cntr + 1)%5000;
    if (clk_cntr%2500 == 0)
      clk_10k <= ~clk_10k;
    if (clk_cntr%25 == 0)
      clk_1m <= ~clk_1m;
  end

  /*********************************************
  * pwm clk cntr
  *********************************************/
  always_ff @(posedge clk_1m, negedge rst)
  if (!rst)
    pwm_clk_cntr <= 8'd0;
  else
    pwm_clk_cntr <= pwm_clk_cntr + 1;  
        
  /*********************************************
  * pwm duty cycle create
  *********************************************/
  always_ff @(posedge clk_1m, negedge rst)
  if (!rst)
    pwm <= 1'b0;
  else
    if (pwm_clk_cntr >= pwm_duty*pwm_duty)
      pwm <= 1'b1;
    else
      pwm <= 1'b0;

  /*********************************************
  * pwm clk counter up 
  *********************************************/     
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    pwm_cntr <= 16'h0;
  else
    if (dbtn[0]) 
      pwm_cntr <= pwm_cntr + 1;
    else
      pwm_cntr <= 16'h0;
     
  /*********************************************
  * pwm duty cycle counter at 2s
  *********************************************/     
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    pwm_duty <= 4'h0;
  else
    if (pwm_cntr%20000 == 1) 
      pwm_duty <= pwm_duty + 1;
     
  /*********************************************
  * 4 digits scan over; sel2++
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    sel2 <= 2'b00;
  else 
    sel2 <= sel2 + 1;

  /*********************************************
  * sel2 to sel3 converter
  *********************************************/
  always_comb
  case (sel2)
    2'b00 :         sel3 <= 3'b000;
    2'b01 : 
      if (cntr>9)   sel3 <= 3'b001;
      else          sel3 <= 3'b111;
    2'b10 : 
      if (cntr>99)  sel3 <= 3'b011;
      else          sel3 <= 3'b111;
    2'b11 :
      if (cntr>999) sel3 <= 3'b100;
      else          sel3 <= 3'b111;
  endcase

  /*********************************************
  * select what number to display
  *********************************************/
  always_comb
  case (sel2)
    2'b00 : sseg <= dec_to_7seg[cntr%10];
    2'b01 : sseg <= dec_to_7seg[cntr/10%10];
    2'b10 : sseg <= dec_to_7seg[cntr/100%10];
    2'b11 : sseg <= dec_to_7seg[cntr/1000];
  endcase

  /*********************************************
  * debounce switch create btn state
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    btn_state <= '{0,0,0,0,0,0,0,16'hffff};
  else
    for (int i=0;i<8;i++)
    begin
      btn_state[i] <= (btn_state[i]<<1) | (btn[i]?1:0) | 16'hf000;
      if (btn_state[i] == 16'hf000) 
        dbtn[i] <= 1;
      else
        dbtn[i] <= 0;
    end

  /*********************************************
  * debounce quadrature encoder
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    encoder_state <= '{0,0,0,0};
  else
    for (int i=0;i<4;i++)
    begin
      encoder_state[i] <= (encoder_state[i]<<1) | (encoder[i]?1:0) | 16'hfff0;
      if (encoder_state[i] == 16'hfff0) 
        dencoder[i] <= 1;
      else if (encoder_state[i] == 16'hffff)
        dencoder[i] <= 0;
    end

  /*********************************************
  * current state 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    curr_state <= 2'b00;
  else
    curr_state <= dencoder[1:0]; 
  /*********************************************
  * previous state 
  *********************************************/
  always_ff @(posedge clk_1m, negedge rst)
  if (!rst)
  begin
    prev_state <= 8'hff;
     cntr <= 16'b0;
  end
  else
  begin
    if (curr_state == 2'b11)
      case(prev_state)
//        4'b0010 : cntr <= (cntr==16'd999)?0:(cntr + 1); // cw
//        4'b0001 : cntr <= (cntr==16'd0)?999:(cntr - 1); // ccw
        8'b11010010 : cntr <= (cntr==16'd999)?0:(cntr + 1); // cw
        8'b11100001 : cntr <= (cntr==16'd0)?999:(cntr - 1); // ccw
        default     : prev_state <= (prev_state<<2)|curr_state;
      endcase
    if (prev_state[1:0] != curr_state)
      prev_state <= (prev_state<<2)|curr_state;  
  end
//  /*********************************************
//  * previous state 
//  *********************************************/
//  always_ff @(posedge clk_10k, negedge rst)
//  if (!rst)
//    prev_state <= 8'h00;
//  else
//    if (curr_state == prev_state[1:0])
//      prev_state <= prev_state;
//    else
//      prev_state <= (prev_state<<2)|curr_state;
//
//  /*********************************************
//  * state judge 
//  *********************************************/
//  always_ff @(posedge clk_10k, negedge rst)
//  if (!rst)
//    //prev_state <= 2'b11;
//    cntr <= 16'b0;
//  else
//    if (curr_state == 2'b11)
//      case(prev_state)
//        8'b11010010 : cntr <= (cntr==16'd999)?0:(cntr + 1); // cw
//        8'b11100001 : cntr <= (cntr==16'd0)?999:(cntr - 1); // ccw
//      endcase
//
  /*********************************************
  * testing features 
  *********************************************/
  assign led[3:0] = pwm_duty;
  assign led[7] = pwm;
    
endmodule 

