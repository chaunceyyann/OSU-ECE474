module input_debouncer(
  input            clk_10k,
  input                rst,
  input      [7:0]     btn, // 8 buttons
  input      [3:0] encoder, // 4 2x2 encoder
  output reg [7:0]   d_btn, // debounced btn
  output reg [3:0]d_encoder // debounced encoder
  );
  
  logic [15:0]  btn_state  [7:0];// holds present state
  logic [15:0]encoder_state[3:0];// holds present state of encoder


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
        d_btn[i] <= 1;
      else
        d_btn[i] <= 0;
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
      encoder_state[i] <= (encoder_state[i]<<1) | encoder[i] | 16'hff00;
      if (encoder_state[i] == 16'hff00) 
        d_encoder[i] <= 1;
      else if (encoder_state[i] == 16'hffff)
        d_encoder[i] <= 0;
    end
	 
endmodule 