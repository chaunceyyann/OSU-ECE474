module BCD(
  input      [13:0]      num,
  output reg [3:0] thousands,
  output reg [3:0]  hundreds,
  output reg [3:0]      tens,
  output reg [3:0]      ones
);

  always_comb
  begin
    //set 100's, 10's, and 1's to 0
    thousands = 4'd0;
    hundreds = 4'd0;
    tens = 4'd0;
    ones = 4'd0;
    for (int i=13; i>=0; i--)
    begin
      //add 3 to columns >= 5
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
      ones[0] = num[i];
    end
  end
endmodule 
