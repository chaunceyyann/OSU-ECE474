module BinaryCounter(input key0, input  key1, output [7:0] led);
    
    reg [7:0] cntr;
    reg clk;
    
    always @(key0,key1)
    begin
        if (key1)
            clk = key0;
        else
            clk = key1;
    end
    
    always_ff @(posedge clk)
    begin
        if(key0) 
            cntr = cntr + 1;
        else
            cntr = cntr - 1;
    end

    assign led = cntr;
    
endmodule 
