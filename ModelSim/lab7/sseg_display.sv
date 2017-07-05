module sseg_display(
  input                clk_10k,
  input                    rst,
  input        [15:0]      bcd,
  input        [13:0]      num,
  output logic [2:0]      sel3, // 3 select on encoder
  output logic [7:0]      sseg  // 8 7 segments + DP
  );
  
  logic        [1:0]      sel2; // 2bit select for display

  int dec_to_7seg[0:17] = '{
  8'b11000000, 8'b11111001, 8'b10100100, 8'b10110000,  // 0 1 2 3
  8'b10011001, 8'b10010010, 8'b10000010, 8'b11111000,  // 4 5 6 7
  8'b10000000, 8'b10010000, 8'b10001000, 8'b10000011,  // 8 9 A B
  8'b11000110, 8'b10100001, 8'b10000110, 8'b10001110,  // C D E F
  8'b10000011, 8'b10001000};                           // ^ :
    
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
    2'b00 : sel3 <= 3'b000;
    2'b01 : sel3 <= 3'b001;
    2'b10 : sel3 <= 3'b011;
    2'b11 : sel3 <= 3'b100;
  endcase

  /*********************************************
  * select what number to display
  *********************************************/
  always_comb
  case (sel2)
    2'b00 : sseg <= dec_to_7seg[bcd[3:0]];
    2'b01 : sseg <= dec_to_7seg[bcd[7:4]];
    2'b10 : sseg <= dec_to_7seg[bcd[11:8]];
    2'b11 : sseg <= dec_to_7seg[bcd[15:12]]^8'h80;
  endcase
endmodule 