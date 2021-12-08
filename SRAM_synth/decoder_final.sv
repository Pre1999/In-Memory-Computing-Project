module decoder
(
	input [6:0] read_address1,
	input [6:0] read_address2,
	input read_enable1,
	input read_enable2,
	input [6:0] write_address,
	input write_enable,
	output reg [127:0] read_wl,
	output reg [127:0] write_wl
);
	wire [127:0] read_wl1,read_wl2;
	assign read_wl1 = (read_enable1)?1<<read_address1:128'h0;
	assign read_wl2 = (read_enable2)?1<<read_address2:128'h0;
	assign write_wl = (!(read_enable1 && read_enable2) && write_enable)?1<<write_address:128'h0;
	assign read_wl = read_wl1 | read_wl2;
endmodule

