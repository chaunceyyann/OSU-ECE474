module BCD(
  input        [13:0]     cntr,
  output logic [3:0] thousands,
  output logic [3:0]  hundreds,
  output logic [3:0]      tens,
  output logic [3:0]      ones
);

  always_comb
  begin
    //initiate all 4 digits to 0
    thousands = 4'd0;
    hundreds  = 4'd0;
    tens      = 4'd0;
    ones      = 4'd0;
	 
    for (int i=13; i>=0; i--)
    begin
      //add 3 to columns if >= 5
      if (thousands >= 5)
        thousands = thousands + 3;
      if (hundreds >= 5)
        hundreds = hundreds + 3;
      if (tens >= 5)
        tens = tens + 3;
      if (ones >= 5)
        ones = ones + 3;
		  
      //shift left one
      thousands = thousands << 1;
      thousands[0] = hundreds[3];
      hundreds = hundreds << 1;
      hundreds[0] = tens[3];
      tens = tens << 1;
      tens[0] = ones[3];
      ones = ones << 1;
      ones[0] = cntr[i];
    end
  end
endmodule 