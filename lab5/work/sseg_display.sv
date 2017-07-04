module sseg_display(
  input            clk_10k,
  input                rst,
  input     [15:0]    cntr, // number to count
  output reg [2:0]    sel3, // 3 select on encoder
  output reg [7:0]    sseg  // 8 7 segments + DP
  );
  
  logic [1:0]         sel2; // 2bit select for display
  
  int dec_to_7seg[0:11] = '{
  8'b11000000, 8'b11111001, 8'b10100100, 8'b10110000,  // 0 1 2 3
  8'b10011001, 8'b10010010, 8'b10000010, 8'b11111000,  // 4 5 6 7
  8'b10000000, 8'b10010000, 8'b10000011, 8'b10001000}; // 8 9 ^ :
    
  /*********************************************
  * 4 digits scan over; sel2++
  *********************************************/
  always_ff @(posedge clk_10k, negedge rst)
  if (!rst)
    sel2 <= 2'b00;
  else 
    sel2 <= sel2 + 1;

  /*********************************************
  * sel2 to sel3 converter
  *********************************************/
  always_comb
  case (sel2)
    2'b00 :         sel3 <= 3'b000;
    2'b01 : 
      if (cntr>9)   sel3 <= 3'b001;
      else          sel3 <= 3'b111;
    2'b10 : 
      if (cntr>99)  sel3 <= 3'b011;
      else          sel3 <= 3'b111;
    2'b11 :
      if (cntr>999) sel3 <= 3'b100;
      else          sel3 <= 3'b111;
  endcase

  /*********************************************
  * select what number to display
  *********************************************/
  always_comb
  case (sel2)
    2'b00 : sseg <= dec_to_7seg[cntr%10];
    2'b01 : sseg <= dec_to_7seg[cntr/10%10];
    2'b10 : sseg <= dec_to_7seg[cntr/100%10];
    2'b11 : sseg <= dec_to_7seg[cntr/1000];
  endcase

endmodule 