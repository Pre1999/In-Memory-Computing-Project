module decoder
(
	input [6:0] read_address1,
	input [6:0] read_address2,
	input read_enable1,
	input read_enable2,
	input [6:0] write_address,
	input write_enable,
	output reg [127:0] read_wl1,
	output reg [127:0] read_wl2,
	output reg [127:0] write_wl
);

	assign read_wl1 = (read_enable1)?1<<read_address1:128'h0;
	assign read_wl2 = (read_enable2)?1<<read_address2:128'h0;
	assign write_wl = (!(read_enable1 && read_enable2) && write_enable)?1<<write_address:128'h0;
//always @ (read_enable1, read_enable2, write_enable)
//begin
//	if(read_enable1 == 1'b1 || read_enable2 == 1'b1)
//	begin
//		if(read_enable1 == 1'b1)
//		begin
//			read_wl1 = 1<<read_address1;
//		end
//		else
//			read_wl1=128'h0000_0000_0000_0000_0000_0000_0000_0000;
//
//		if(read_enable2 == 1'b1)
//		begin
//			read_wl2 = 1<<read_address2;
//		end
//		else 
//			read_wl2=128'h0000_0000_0000_0000_0000_0000_0000_0000;
//	end
//	else if(write_enable == 1'b1)
//	begin
//		write_wl = 1<<write_address;
//	end
//	else
//	begin
//		read_wl1=128'h0000_0000_0000_0000_0000_0000_0000_0000;
//		read_wl2=128'h0000_0000_0000_0000_0000_0000_0000_0000;
//		write_wl=128'h0000_0000_0000_0000_0000_0000_0000_0000;		
//	end
//end
endmodule

