module sine_ROM (
  input             clk_ROM,
  input                 rst,
  input        [13:0]  cntr,
  output logic [7:0] data_o
);

  logic [10:0]      addr_i; // sine rom addr input
  logic [23:0]      f_cntr; // sine freq counter
  
  /*********************************************
  * f_cntr assign MSB 11 bits to ROM
  *********************************************/
  always_ff @(posedge clk_ROM, negedge rst)
  if (!rst)
    addr_i <= 0;
  else 
    addr_i <= f_cntr[23:13];
	 
  /*********************************************
  * f_cntr adds cntr every clk tick
  *********************************************/
  always_ff @(posedge clk_ROM, negedge rst)
  if (!rst)
    f_cntr <= 0;
  else 
    f_cntr <= f_cntr + cntr;
	 
  /*********************************************
  * Sine ROM from IP catalog
  *********************************************/
  ROM	ROM_inst (
	.address ( addr_i ),
	.clock ( clk_ROM ),
	.q ( data_o )
	);
	
endmodule 