module lab2(
  input 			[7:0]btn,	// 8 input buttons
  output reg 	[7:0]led		// 8 leds
  );
  
  priority_encoder pe_1 (btn, led); 
endmodule 