module lab1 (
    input   [3:0]   switches,
    output  [3:0]   led
);


assign led[3:0] = switches[3:0];
endmodule