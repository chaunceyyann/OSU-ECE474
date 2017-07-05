module BCD(
  input        [13:0]      num,
  output logic [15:0]      bcd
);

  always_comb
  begin
    //set 100's, 10's, and 1's to 0
    bcd = 16'b0;
    for (int i=11; i>=0; i--)
    begin
      //add 3 to columns >= 5
      bcd[15:12] = (bcd[15:12] >= 5)?(bcd[15:12] + 3):bcd[15:12];
		bcd[11:8]  = (bcd[11:8]  >= 5)?(bcd[11:8]  + 3):bcd[11:8];
		bcd[7:4]   = (bcd[7:4]   >= 5)?(bcd[7:4]   + 3):bcd[7:4];
		bcd[3:0]   = (bcd[3:0]   >= 5)?(bcd[3:0]   + 3):bcd[3:0];
      //shift left one
      bcd = bcd << 1;
      bcd[0] = num[i];
    end
  end
endmodule 