

//assume read at posedge and write at negative edge
module flag_reg #(parameter Width=3)(read_data, write_data,clk,write_enable,reset);

input clk,write_enable,reset;
input [Width-1:0] write_data;//as each reg is 16 bits 
// output reg [Width-1:0]read_data;//as each reg is 16 bits
// output reg [Width-1:0]read_data;//as each reg is 16 bits
output [Width-1:0]read_data;//as each reg is 16 bits

reg [Width-1:0]reg_internal;

// always @(posedge rst) begin
// 	//reg_internal <= 16'b0;
// 	reg_internal = 0;
// end 

// always @(posedge clk) begin
			// read_data=reg_internal;	
// end

always @(posedge clk) begin
	if(reset)
	begin
		reg_internal = 0;
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

/*


//assume read at posedge and write at negative edge
module flag_reg #(parameter Width=3)(read_data, write_data,clk,write_enable,reset,set_carry,clear_carry);

input set_carry,clear_carry;
input clk,write_enable,reset;
input [Width-1:0] write_data;//as each reg is 16 bits 
// output reg [Width-1:0]read_data;//as each reg is 16 bits
// output reg [Width-1:0]read_data;//as each reg is 16 bits
output [Width-1:0]read_data;//as each reg is 16 bits

reg [Width-1:0]reg_internal;

// always @(posedge rst) begin
// 	//reg_internal <= 16'b0;
// 	reg_internal = 0;
// end 

// always @(posedge clk) begin
			// read_data=reg_internal;	
// end

always @(posedge clk) begin
	if(reset)
	begin
		reg_internal = 0;
	end
end
assign read_data = reg_internal;
//NOTE:negedge not posedge	
always @(negedge clk) begin
	if(set_carry)
	begin
		reg_internal[2] = 1'b1;
	end
	else if(clear_carry)
	begin
		reg_internal[2] = 1'b0;
	end
	else if(write_enable)
	begin
		reg_internal = write_data;
	end
end

endmodule


*/