module encoder_handler(
  input                clk_10k,
  input                    rst,
  input      [3:0]     encoder,
  input      [8:0]       d_btn,
  output reg [13:0] cntr [1:0]
  );
  
  logic [3:0]          d_encoder;// debounced encoder
  logic [7:0] encoder_state[3:0];// holds present state of encoder
  logic [1:0]    curr_state[1:0];// current state of encoder
  logic [3:0]    prev_state[1:0];// previous state of encoder
  logic [9:0]           inc[1:0];// number to increate
  
  /*********************************************
  * debounce quadrature encoder
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    encoder_state <= '{0,0,0,0};
  else
    for (int i=0;i<4;i++)
    begin
      encoder_state[i] <= (encoder_state[i]<<1) | encoder[i] | 8'hf0;
      if (encoder_state[i] == 8'hf0) 
        d_encoder[i] <= 1;
      else if (encoder_state[i] == 8'hff)
        d_encoder[i] <= 0;
    end
	 
  /*********************************************
  * current state 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    curr_state <= '{2'b11,2'b11};
  else
    curr_state <= '{d_encoder[1:0],d_encoder[3:2]};

  /*********************************************
  * previous state 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    prev_state <= '{4'hf,4'hf};
  else
    if      (curr_state[0] != prev_state[0][1:0])
      prev_state[0] <= (prev_state[0]<<2)|curr_state[0];
    else if (curr_state[1] != prev_state[1][1:0])
		prev_state[1] <= (prev_state[1]<<2)|curr_state[1];

  /*********************************************
  * state judge 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    cntr <= '{1'd0,14'd1000};
  else
    if      (curr_state[0] == 2'b11)
      case(prev_state[0])
        4'b0010 : cntr[0] <= ((cntr[0] + inc[0])>=14'd9999)?14'd9999:(cntr[0] + inc[0]); // cw
        4'b0001 : cntr[0] <= (cntr[0] <= inc[0])?1'd0:(cntr[0] - inc[0]);  // ccw
      endcase
	 else if (curr_state[1] == 2'b11)
      case(prev_state[1])
        4'b0010 : cntr[1] <= (cntr[1]==14'd9999)?1'd0:(cntr[1] + inc[1]);  // cw
        4'b0001 : cntr[1] <= (cntr[1]==14'h0)?14'd9999:(cntr[1] - inc[1]); // ccw
      endcase
		
  /*********************************************
  * cntr[0] inc[0] control by d_btn[8] on encoder
  *********************************************/		
		
  always_ff @(posedge d_btn[8], negedge rst)
  if (!rst)
    inc <= '{1,1};
  else 
    case (inc[0])
	 10'd1     :  inc[0] <= 10'd10;
	 10'd10    :  inc[0] <= 10'd100;
	 10'd100   :  inc[0] <= 10'd1000;
	 10'd1000  :  inc[0] <= 10'd1;
	 endcase	 
	 
endmodule 