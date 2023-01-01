module count_NOP (read_data,fetch_nop,clk,reset,write_enable);//,rst);

	input clk,reset,write_enable;//,rst;
	output reg fetch_nop;
	output reg [1:0]read_data;
	reg [1:0]reg_internal;
	always @(posedge clk) begin
		if(reg_internal !=2'b00) begin
			reg_internal = reg_internal-1;
		end
		else begin
			fetch_nop = 1'b0;
		end
	end
	assign read_data = reg_internal;
	always @(negedge clk) begin
		if(reset)
		begin
			reg_internal= 2'b00;
			fetch_nop = 1'b0;
		end
	end
	
	
	always @(posedge write_enable) begin
		 reg_internal = 2'b11;
		fetch_nop = 1'b1;
			
	end

endmodule
