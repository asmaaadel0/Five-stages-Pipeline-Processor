 
 //assume read at posedge and write at negative edge
module SP (read_data, write_data,clk,reset,write_enable);//,rst);

input clk,reset,write_enable;//,rst;
input [31:0] write_data;//as each reg is 16 bits 
output  [31:0]read_data;//as each reg is 16 bits

reg [31:0]reg_internal;

assign read_data = reg_internal;

always @(posedge clk) begin
	if(reset)
	begin
		reg_internal= 32'b0111_1111_1111;//2**11-1//2047;
	end
	
end


always @(posedge clk) begin
	if(write_enable)
	begin
		reg_internal = write_data;	
	end

end

endmodule