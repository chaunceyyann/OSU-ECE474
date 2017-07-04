module priority_encoder(
  input [7:0] btn,      // 8 buttons
  output reg [7:0] led      // 8 leds
  );
  
  always @(btn)
  begin
    for (int i=7; i>=0; i--)
    begin
      if (!btn[i])
      begin
        led = i + 1;
        break;
      end
      else
        led = 0;
     end
  end
endmodule
     
          
