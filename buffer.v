
//assume read at posedge and write at negative edge
module buffer #(parameter Width=16)(read_data, write_data,clk,reset);

input clk,reset;
input [Width-1:0] write_data;
output reg [Width-1:0]read_data;

reg [Width-1:0]reg_internal;

always @(posedge clk) begin
			read_data=reg_internal;	
end


always @(negedge clk) begin
	if(reset)
	begin
		reg_internal = 'b0;
	end
	else
	begin
		reg_internal = write_data;	
	end
end

endmodule
