module lab1	(
	input 	[3:0]	switches,
	output 	[4:7]	led
);


assign led[4:7] = switches[3:0];
endmodule



