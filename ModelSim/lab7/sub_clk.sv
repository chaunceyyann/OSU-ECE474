module sub_clk(
  input                clk,
  input                rst,
  output reg       clk_10k, // 10k
  output reg      clk_sclk, // 2.5mhz
  output reg       clk_bud, // 125000
  output reg     clk_8xbud  // 8 x 125000
  );  

  logic [15:0]      clk_cntr;

  /*********************************************
  * clk divider 50m to 10k, 1m
  *********************************************/
  always_ff @(posedge clk, negedge rst)
  if (!rst)
  begin
    clk_cntr <= 1'd0;
    clk_10k <= 1'b0;
    clk_bud <= 1'b0;
    clk_8xbud <= 1'b0;
    clk_sclk <= 1'b0;
  end
  else
  begin
    clk_cntr <= (clk_cntr + 1)%5000;
    if (clk_cntr%2500 == 0)
      clk_10k <= ~clk_10k;
    if (clk_cntr%200 == 0)
      clk_bud <= ~clk_bud;
    if (clk_cntr%25 == 0)
      clk_8xbud <= ~clk_8xbud;
    if (clk_cntr%10 == 0)
      clk_sclk <= ~clk_sclk;
  end

endmodule 
