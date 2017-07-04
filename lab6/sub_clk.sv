module sub_clk(
  input                clk,
  input                rst,
  output reg       clk_10k, 
  output reg        clk_2d5m, 
  output reg        clk_ROM
  );  

  logic [15:0]      clk_cntr;

  /*********************************************
  * clk divider 50m to 10k, 1m
  *********************************************/
  //always_ff @(posedge clk, negedge rst)
  //if (!rst)
  //  clk_cntr <= 1'd0;
  //else
  //  clk_cntr <= (clk_cntr + 1)%5000;

  //always_comb
  //begin
  //  if (clk_cntr%2500 == 0)
  //    clk_10k = ~clk_10k;
  //  if (clk_cntr%125 == 0)
  //    clk_1m  = ~clk_1m;
  //end

  always_ff @(posedge clk, negedge rst)
  if (!rst)
  begin
    clk_cntr <= 1'd0;
    clk_10k <= 1'b0;
    clk_2d5m <= 1'b0;
    clk_ROM <= 1'b0;
  end
  else
  begin
    clk_cntr <= (clk_cntr + 1)%5000;
    if (clk_cntr%2500 == 0)
      clk_10k <= ~clk_10k;
    if (clk_cntr%10 == 0)
      clk_2d5m <= ~clk_2d5m;
    if (clk_cntr%2 == 0)
      clk_ROM <= ~clk_ROM;
  end

endmodule 
