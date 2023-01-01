

//assume read at posedge and write at negative edge
module previous_cs_rti #(parameter Width=1)(read_data, write_data,clk,write_enable,reset);

input clk,write_enable,reset;
input [Width-1:0] write_data;
output reg [Width-1:0]read_data;

reg [Width-1:0]reg_internal;

always @(negedge clk) begin
		if(reset)
		begin
			reg_internal = 'b0;
		end	
		else if(write_enable)
		begin
			reg_internal = write_data;
		end							
end

assign read_data=reg_internal;	

endmodule
