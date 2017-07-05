module input_debouncer(
  input            clk_10k,
  input                rst,
  input                btn, // 1 button on encoder
  output logic       d_btn  // debounced btn
  );
  
  logic [7:0]    btn_state;// holds present state

  /*********************************************
  * debounce switch 
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    btn_state <= 8'b0;
  else
    begin
      btn_state <= (btn_state<<1) | (btn?1:0) | 8'he0;
      if (btn_state == 8'hf0) 
        d_btn <= 1;
      else
        d_btn <= 0;
    end

endmodule 