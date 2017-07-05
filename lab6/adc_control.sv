module adc_control(
  input               clk_sclk,
  input                    rst,
  input               adc_Dout,
  input        [2:0]  adc_ch_s,
  output logic        adc_sclk,
  output logic        adc_cs_n,
  output logic         adc_Din,
  output logic [11:0] adc_data,
  output logic         adc_rdy
  );  
  logic [3:0]        adc_state;
  logic [11:0]       adc_pdata;
  
  assign adc_cs_n = 0;
  assign adc_sclk = clk_sclk;
  /*********************************************
  * state counter sync to sclk
  *********************************************/
  always_ff @(negedge clk_sclk, negedge rst)
  if (!rst)
    adc_state <= 0;
  else 
    adc_state <= adc_state + 1;

  /*********************************************
  * state machine on send
  *********************************************/
  always_ff @(negedge clk_sclk, negedge rst)
  if (!rst)
    adc_Din <= 0;
  else
    case (adc_state)
    4'd2    : adc_Din <= adc_ch_s[2];
    4'd3    : adc_Din <= adc_ch_s[1];
    4'd4    : adc_Din <= adc_ch_s[0];
    default : adc_Din <= 0;
    endcase

  /*********************************************
  * state machine on receive
  *********************************************/
  always_ff @(posedge clk_sclk, negedge rst)
  if (!rst)
    adc_pdata <= 0;
  else
    case (adc_state)
    4'd4    : adc_pdata[11] <= adc_Dout;
    4'd5    : adc_pdata[10] <= adc_Dout;
    4'd6    : adc_pdata[9]  <= adc_Dout;
    4'd7    : adc_pdata[8]  <= adc_Dout;
    4'd8    : adc_pdata[7]  <= adc_Dout;
    4'd9    : adc_pdata[6]  <= adc_Dout;
    4'd10   : adc_pdata[5]  <= adc_Dout;
    4'd11   : adc_pdata[4]  <= adc_Dout;
    4'd12   : adc_pdata[3]  <= adc_Dout;
    4'd13   : adc_pdata[2]  <= adc_Dout;
    4'd14   : adc_pdata[1]  <= adc_Dout;
    4'd15   : adc_pdata[0]  <= adc_Dout;
    endcase
	 
  /*********************************************
  * check if adc data is ready
  *********************************************/
  always_ff @(posedge clk_sclk, negedge rst)
    if (!rst)
      adc_rdy <= 0;
    else
      if (adc_state == 15)
        adc_rdy  <= 1;
      else
        adc_rdy  <= 0;
		  
  /*********************************************
  * assign parallel data to data output
  *********************************************/
  always_ff @(negedge adc_rdy, negedge rst)
    if (!rst)
      adc_data <= 0;
    else
      adc_data <= adc_pdata;
endmodule 
