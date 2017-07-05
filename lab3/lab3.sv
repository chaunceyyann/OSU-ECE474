module lab3(
  input 			[7:0] btn,	// 8 buttons
  output reg 	[7:0] led,	// 8 onboard leds
  output reg 	[7:0] sseg,	// 8 7 segments + DP
  output reg	[2:0] sel3,	// 3 select on encoder 
  output reg			pwm,	// 1 total bright control
  output reg	[1:0]	en		// 2 enable and bar on encoder
  );
  
  reg [3:0] digit;
  reg [1:0] sel2;
  
  assign pwm  = 0;
  assign en = 2'b10;// enable / enable bar
  
  int dec_to_7seg[0:11] = '
  {8'b11000000, 8'b11111001, 8'b10100100, 8'b10110000,	// 0 1 2 3
	8'b10011001, 8'b10010010, 8'b10000010, 8'b11111000, 	// 4 5 6 7
	8'b10000000, 8'b10011000, 8'b10000011, 8'b10001000}; 	// 8 9 ^ :
	 									
  int sel2_to_3[0:3] = '
  {3'b000, 3'b001, 3'b011, 3'b100};	// 0 1 3 4
  
  always @(btn)
  begin
    for (int i=3; i>=0; i--)
	 begin
      if (!btn[i])
		begin
		  sel3 = sel2_to_3[i]; 
		  sel2 = i;
		  break;
		end
		sel3 = 3'b111;
	 end
  end
  
  always_comb
  begin
    case(sel2)
	 2'b00   : sseg = dec_to_7seg[9];
	 2'b01   : sseg = dec_to_7seg[6];
	 2'b10   : sseg = dec_to_7seg[0];
	 2'b11   : sseg = dec_to_7seg[7];
	 endcase
  end
  assign led = sseg;
endmodule
	