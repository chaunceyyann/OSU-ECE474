module pwm_create(
  input             clk_1m,
  input            clk_10k,
  input                rst,
  input      [7:0]   d_btn,
  output reg           pwm, // 1 total bright control
  output reg [3:0]pwm_duty 
  );
  
  logic [15:0]      pwm_cntr;// pwm 2s counter
  logic [7:0]   pwm_clk_cntr;// pwm clk create counter

  /*********************************************
  * pwm counter
  *********************************************/     
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    pwm_cntr <= 16'h0;
  else
    if (d_btn[0]) 
      pwm_cntr <= (pwm_cntr==20000)?1'd1:(pwm_cntr+1);
    else
      pwm_cntr <= 16'h0;
     
  /*********************************************
  * pwm duty 
  *********************************************/     
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    pwm_duty <= 4'h0;
  else
    if (pwm_cntr == 1) 
      pwm_duty <= pwm_duty + 1;
  
  /*********************************************
  * pwm clk cntr
  *********************************************/
  always_ff @(posedge clk_1m, negedge rst)
  if (!rst)
    pwm_clk_cntr <= 8'd0;
  else
    pwm_clk_cntr <= pwm_clk_cntr + 1;  
        
  /*********************************************
  * pwm create
  *********************************************/
  always_ff @(posedge clk_1m, negedge rst)
  if (!rst)
    pwm <= 1'b0;
  else
    if (pwm_clk_cntr >= pwm_duty*pwm_duty)
      pwm <= 1'b1;
    else
      pwm <= 1'b0;

endmodule 