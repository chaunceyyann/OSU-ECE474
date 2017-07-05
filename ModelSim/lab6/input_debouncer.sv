module input_debouncer(
  input            clk_10k,
  input                rst,
  input      [8:0]     btn, // 9 buttons
  output reg [8:0]   d_btn  // debounced btn
  );
  
  logic [15:0]  btn_state  [8:0];// holds present state


    /*********************************************
  * debounce switch create btn state
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    btn_state <= '{0,0,0,0,0,0,0,0,0};
  else
    for (int i=0;i<9;i++)
    begin
      btn_state[i] <= (btn_state[i]<<1) | (btn[i]?1:0) | 16'hf000;
      if (btn_state[i] == 16'hf000) 
        d_btn[i] <= 1;
      else
        d_btn[i] <= 0;
    end

endmodule 