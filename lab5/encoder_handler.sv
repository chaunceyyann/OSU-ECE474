module encoder_handler(
  input                clk_10k,
  input                    rst,
  input        [1:0]   encoder, // encoder input
  input                  d_btn, // debounced btn input
  output logic [13:0]     cntr
  );
  
  logic [1:0]          d_encoder;// debounced encoder
  logic [3:0] encoder_state[1:0];// holds present state of encoder
  logic [1:0]         curr_state;// current state of encoder
  logic [1:0]         prev_state;// previous state of encoder
  logic [9:0]                inc;// number to increate
  
  /*********************************************
  * debounce quadrature encoder 3 check bits
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    encoder_state <= '{0,0};
  else
    for (int i=0;i<2;i++)
    begin
      encoder_state[i] <= (encoder_state[i]<<1) | encoder[i] | 4'h8;
      if (encoder_state[i] == 4'h8) 
        curr_state[i] <= 1;
      else if (encoder_state[i] == 4'hf)
        curr_state[i] <= 0;
    end
	 
  /*********************************************
  * previous state 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    prev_state <= 2'b11;
  else
    if (curr_state != prev_state)
      prev_state <= curr_state;

  /*********************************************
  * state check: lock cntr at 9999 and 0
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    cntr <= 14'd1000;
  else
    if (curr_state == 2'b11)
      case(prev_state)
        2'b10 : cntr <= ((cntr + inc)>=14'd9999)?14'd9999:(cntr + inc); // cw
        2'b01 : cntr <= (cntr <= inc)?1'd0:(cntr - inc); // ccw
      endcase
	
  /*********************************************
  * cntr inc control by d_btn on encoder
  *********************************************/
  always_ff @(posedge d_btn, negedge rst)
  if (!rst)
    inc <= 1'b1;
  else 
    case (inc)
	 10'd1     :  inc <= 10'd10;
	 10'd10    :  inc <= 10'd100;
	 10'd100   :  inc <= 10'd1000;
	 10'd1000  :  inc <= 10'd1;
	 endcase	 
	 
endmodule 