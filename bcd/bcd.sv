module bcd(
  input         [7:0]  btn, // 8 buttons
  input                clk, // 1 led refrash
  input                rst, // 1 reset key0
  input                key, // 1 reset key0
  output reg    [7:0]  led, // 8 onboard leds
  output reg    [7:0] sseg, // 8 7 segments + DP
  output reg    [2:0] sel3, // 3 select on encoder
  output reg           pwm, // 1 total bright control
  output reg    [1:0]   en  // 2 enable and bar on encoder
);

  int dec_to_7seg[0:11] = '{
  8'b11000000, 8'b11111001, 8'b10100100, 8'b10110000,  // 0 1 2 3
  8'b10011001, 8'b10010010, 8'b10000010, 8'b11111000,  // 4 5 6 7
  8'b10000000, 8'b10010000, 8'b10000011, 8'b10001000}; // 8 9 ^ :
    
  int sel2_to_3[0:3] = '{
  3'b000, 3'b001, 3'b011, 3'b100}; // 0 1 3 4
  
  int digit     [3:0];
  reg [3:0]  pwm_duty;
  reg [1:0]      sel2;
  reg [15:0]     cntr;
  reg [7:0]      inc;// increase or decrease by inc.
  reg           tdbtn;// total debounced btn
  reg [15:0] clk_cntr;
  reg          clk_1k;
  reg [15:0]btn_state[7:0];//holds present state
  reg [7:0]      dbtn;//debounced btn
  
  assign en   = 2'b10;// enable and enable bar

  /*********************************************
  * clk divider 50m to 1k, 10k
  *********************************************/
  always_ff @(posedge clk, negedge rst)
  begin
    if (!rst)
      clk_cntr <= 16'd0;
    else
    begin
      clk_cntr <= clk_cntr + 1;
      if (clk_cntr == 16'd5000)
        clk_cntr <= 16'd0;
      else if (clk_cntr > 2500)
        clk_1k <= 1'b1;
      else 
        clk_1k <= 1'b0;
    end
  end
  /*********************************************
  * pwm duty cycle create
  *********************************************/
  always_ff @(posedge clk, negedge rst)
    if (!rst)
      pwm <= 1'b0;
    else
      if (clk_cntr > 310*pwm_duty)
        pwm <= 1'b0;
      else
        pwm <= 1'b1;
     
  /*********************************************
  * pwm duty cycle counter
  *********************************************/     
  always_ff @(negedge key, negedge rst)
    if (!rst)
      pwm_duty <= 1'b0;
    else
      pwm_duty <= pwm_duty + 1;
     
  /*********************************************
  * 7seg presistance display 
  *********************************************/
  always_ff @(posedge clk_1k, negedge rst)
  begin
    if (!rst)
    begin
      sel2 <= 2'b00;
      sel3 <= 3'b111;
      sseg <= dec_to_7seg[0];
    end
    else
    begin
      sel2 <= sel2 + 1;
      case(sel2)
        2'b00   : begin
        sseg <= dec_to_7seg[digit[0]];
        sel3 <= sel2_to_3[0];
        end
        2'b01   : begin
        sseg <= dec_to_7seg[digit[1]];
        if (cntr > 9)
          sel3 <= sel2_to_3[1];
        else
          sel3 <= 3'b111;
        end
        2'b10   : begin
        sseg <= dec_to_7seg[digit[2]];
        if (cntr > 99)
         sel3 <= sel2_to_3[2];
        else
          sel3 <= 3'b111;
        end
        2'b11   : begin
        sseg <= dec_to_7seg[digit[3]];
        if (cntr > 999)
         sel3 <= sel2_to_3[3];
        else
          sel3 <= 3'b111;
        end
      endcase
    end
  end

  /*********************************************
  * debounce switch
  *********************************************/

  always_ff @(posedge clk_1k, negedge rst)
  begin
    if (!rst)
    begin
      //btn_state <= 0;
      dbtn <= 0;
    end
    else
    begin
      for (int i=0;i<8;i++)
      begin
        btn_state[i] <= (btn_state[i] << 1) | (btn[i]?1:0) | 16'he000;
        if (btn_state[i] == 16'hf000) 
          dbtn[i] <= 1;
        else
          dbtn[i] <= 0;
      end
    end
  end

  /*********************************************
  * increamental counter 
  *********************************************/
  always_ff @(posedge dbtn[0], negedge rst)
  begin
    if (!rst)
      cntr <= 16'd0;
    else
      cntr <= cntr + 1;
  end

  /*********************************************
  * reverse increamental counter 
  *********************************************/

 /*********************************************
  * Binary to Decimal digit
  *********************************************/
  always_comb begin
    digit[0] <= cntr%10;
    digit[1] <= cntr/10%10;
    digit[2] <= cntr/100%10;
    digit[3] <= cntr/1000;
  end

  /*********************************************
  * testing features 
  *********************************************/
  assign led[3:0] = pwm_duty;
  assign led[7] = pwm;
    
endmodule 

