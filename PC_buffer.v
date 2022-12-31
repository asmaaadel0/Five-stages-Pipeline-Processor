//assume read at posedge and write at negative edge
module PC (read_data, write_data,clk,reset_pc,Reset_2Power5,no_change,fetch_nop_LD);//,rst);

	input clk,reset_pc,Reset_2Power5,fetch_nop_LD;//,rst;
	input [31:0] write_data;//as each reg is 16 bits 
	input [1:0]no_change;
	// output reg [31:0]read_data;//as each reg is 16 bits
	output [31:0]read_data;//as each reg is 16 bits

	reg [31:0]reg_internal;

	// always @(posedge rst) begin
	// 	//reg_internal <= 16'b0;
	// 	reg_internal = 0;
	// end 
	
	/*always @( reset_pc) begin
		reg_internal = 0;
	end 
	
	always @(Reset_2Power5) begin
		reg_internal = 32'b10_0000;//m.s of that way of 32'b10_0000?
	end */


	// always @(posedge clk) begin
			// read_data=reg_internal;	
	// end

	assign read_data=reg_internal;	
	always @(negedge clk) begin
		if(Reset_2Power5) begin
			reg_internal = 32'b10_0000;//m.s of that way of 32'b10_0000?
		end 
		else if( reset_pc) begin
			reg_internal = 0;
		end 	 
		else if( no_change == 2'b00 && fetch_nop_LD != 1'b1 )begin
			reg_internal = write_data;	
		end
		//else : do nothing : fix the value of pc
	end

	// always @(*) begin
		// if( no_change == 2'b00)begin
			// reg_internal = write_data;	
		// end
	// end
	
endmodule
  
