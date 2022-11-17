//assume read at posedge and write at negative edge
module buffer #(parameter Width=16)(read_data, write_data,clk);//,rst);

input clk;//,rst;
input [Width-1:0] write_data;//as each reg is 16 bits 
output reg [Width-1:0]read_data;//as each reg is 16 bits

reg [Width-1:0]reg_internal;

// always @(posedge rst) begin
// 	//reg_internal <= 16'b0;
// 	reg_internal = 0;
// end 


always @(posedge clk) begin
			read_data=reg_internal;	
end


always @(negedge clk) begin
		reg_internal = write_data;					
end

endmodule
