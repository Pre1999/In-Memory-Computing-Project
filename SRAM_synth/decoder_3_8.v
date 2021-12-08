module decoder_3_8 (
    input [2:0] data_in, 
    output reg [7:0] data_out);

    always @ (*) begin
        case (data_in)
            3'b000: data_out <= 8'b00000001;
            3'b001: data_out <= 8'b00000010;
            3'b010: data_out <= 8'b00000100;
            3'b011: data_out <= 8'b00001000;
            3'b100: data_out <= 8'b00010000;
            3'b101: data_out <= 8'b00100000;
            3'b110: data_out <= 8'b01000000;
            3'b111: data_out <= 8'b10000000;
        endcase
    end 
    
endmodule
