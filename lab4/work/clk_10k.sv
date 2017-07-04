module clk_10k (
  inclk0,
  c0,
  );
  input     inclk0;
  output    c0;

  logic [15:0] clk_cntr;
  /*********************************************
  * clk divider 50m to 1k
  *********************************************/
  always_ff @(posedge inclk0, negedge rst)
  begin
    if (!rst)
      clk_cntr <= 16'd0;
    else
    begin
      clk_cntr <= clk_cntr + 1;
      if (clk_cntr == 16'd500)
        clk_cntr <= 16'd0;
      else if (clk_cntr > 250)
        c0 <= 1'b1;
      else
        c0 <= 1'b0;
    end
  end

