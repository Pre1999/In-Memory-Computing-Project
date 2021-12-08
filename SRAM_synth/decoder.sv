module decoder (
	input [6:0] in,
	output  [127:0] out
);

	assign out = 1<<in;

endmodule
