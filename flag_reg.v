

//assume read at posedge and write at negative edge
module flag_reg #(parameter Width=3)(read_data, write_data,clk,write_enable,reset);

input clk,write_enable,reset;
input [Width-1:0] write_data;
output [Width-1:0]read_data;

reg [Width-1:0]reg_internal;

always @(posedge clk) begin
	if(reset)
	begin
		reg_internal = 'b0;
	end
end
assign read_data = reg_internal;
//NOTE:negedge not posedge	
always @(negedge clk) begin
	if(write_enable)
	begin
		reg_internal = write_data;
	end
end

endmodule
