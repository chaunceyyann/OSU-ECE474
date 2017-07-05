module sseg_display(
  input            clk_10k,
  input                rst,
  input    [3:0] thousands,
  input    [3:0]  hundreds,
  input    [3:0]      tens,
  input    [3:0]      ones,
  input    [13:0]     cntr,
  output logic [2:0]  sel3, // 3 select on encoder
  output logic [7:0]  sseg  // 8 7 segments + DP
  );
  
  logic [1:0]         sel2; // 2bit select for display
  logic [7:0] dec_to_7seg [0:9] = '{
  8'b11000000, 8'b11111001, 8'b10100100, 8'b10110000,  // 0 1 2 3
  8'b10011001, 8'b10010010, 8'b10000010, 8'b11111000,  // 4 5 6 7
  8'b10000000, 8'b10010000};                           // 8 9

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
      if (cntr>4'd9)   sel3 <= 3'b001;
      else          sel3 <= 3'b111;
    2'b10 : 
      if (cntr>7'd99)  sel3 <= 3'b011;
      else          sel3 <= 3'b111;
    2'b11 :
      if (cntr>10'd999) sel3 <= 3'b100;
      else          sel3 <= 3'b111;
  endcase

  /*********************************************
  * select what counter to display
  *********************************************/
  always_comb
  case (sel2)
    2'b00 : sseg <= dec_to_7seg[ones];
    2'b01 : sseg <= dec_to_7seg[tens];
    2'b10 : sseg <= dec_to_7seg[hundreds];
    2'b11 : sseg <= dec_to_7seg[thousands];
  endcase
endmodule 