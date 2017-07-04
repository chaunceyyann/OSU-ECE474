module encoder_handler(
  input            clk_10k,
  input                rst,
  input  [3:0]   d_encoder,
  output reg [15:0]   cntr
  );
  
  logic [1:0]     curr_state;// current state of encoder
  logic [3:0]     prev_state;// previous state of encoder
  /*********************************************
  * current state 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    curr_state <= 2'b00;
  else
    curr_state <= d_encoder[1:0]; 

  /*********************************************
  * previous state 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    prev_state <= 4'b1111;
  else
    if (curr_state == prev_state[1:0])
      prev_state <= prev_state;
    else
      prev_state <= (prev_state<<2)|curr_state;

  /*********************************************
  * state judge 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    cntr <= 16'b0;
  else
    if (curr_state == 2'b11)
      case(prev_state)
        4'b0010 : cntr <= (cntr==16'd999)?0:(cntr + 1); // cw
        4'b0001 : cntr <= (cntr==16'd0)?999:(cntr - 1); // ccw
      endcase
		
endmodule 