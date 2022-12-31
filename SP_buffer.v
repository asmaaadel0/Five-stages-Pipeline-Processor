 
 //assume read at posedge and write at negative edge
module SP (read_data, write_data,clk,reset,write_enable);//,rst);

	input clk,reset,write_enable;//,rst;
	input [31:0] write_data;//as each reg is 16 bits 
	// output reg [31:0]read_data;//as each reg is 16 bits
	output  [31:0]read_data;//as each reg is 16 bits

	reg [31:0]reg_internal;

	// always @(posedge rst) begin
	// 	//reg_internal <= 16'b0;
	// 	reg_internal = 0;
	// end 


	// always @(posedge clk) begin
				// read_data=reg_internal;	
	// end


	// always @(negedge clk) begin
		// if(reset)
		// begin
			// reg_internal= 2**11-1;
		// end
		// else if(write_enable)
		// begin
			// reg_internal = write_data;	
		// end
		// // else
		// // begin
		// // end
	// end
	
	assign read_data = reg_internal;
	
	always @(posedge clk) begin
		if(reset)
		begin
			reg_internal= 2**11-1;
		end
		
	end


	always @(posedge clk) begin
		if(write_enable)
		begin
			reg_internal = write_data;	
		end
		// else
		// begin
		// end
	end

endmodule

/*
 
 //assume read at posedge and write at negative edge
module SP (read_data, write_data,clk,reset,write_enable,mem_finish,mem_finish_off);//,rst);

	input clk,reset,write_enable,mem_finish;//,rst;
	input [31:0] write_data;//as each reg is 16 bits 
	// output reg [31:0]read_data;//as each reg is 16 bits
	output [31:0]read_data;//as each reg is 16 bits
	output reg mem_finish_off;
	reg [31:0]reg_internal;

	// always @(posedge rst) begin
	// 	//reg_internal <= 16'b0;
	// 	reg_internal = 0;
	// end 


	// always @(posedge clk) begin
				// read_data=reg_internal;	
	// end

	// //always @(negedge clk) begin
	// //always @(*) begin
	// always @(posedge clk) begin
		// if(reset)
		// begin
			// reg_internal= 2**11-1;
		// end
		// else if(write_enable)
		// begin
			// reg_internal = write_data;	
		// end
		// // else
		// // begin
		// // end
	// end
	
	// always @(posedge clk) begin
		// if(reset)
		// begin
			// reg_internal= 2**11-1;
		// end
		// else
		// begin
			// read_data=reg_internal;	
		// end
	// end
	
	// always @(*) begin
		// if(write_enable)
		// begin
			// mem_finish_off = 1'b0 ;
			// reg_internal = write_data;	
			// mem_finish_off = 1'b1 ;
		// end
		// // else
		// // begin
		// // end
	// end
	
	//always @(*) begin
	// always @(posedge clk) begin
	always @( write_enable) begin
		if(reset)
		begin
			reg_internal= 2**11-1;
		end
		else if(mem_finish) 
		begin
			// mem_finish_off = 1'b1 ;
				if(write_enable)
				begin
					reg_internal = write_data;	
					// mem_finish_off = ~mem_finish;
					//// mem_finish_off = 1'b1 ;
				end
			mem_finish_off = 1'b1 ;
		end
	end
	assign read_data = reg_internal;	
	
	// always @(posedge clk) begin
		// if(write_enable && mem_finish)
		// begin	
			// // mem_finish_off = ~mem_finish;
			 // mem_finish_off = 1'b1 ;
		// end
	// end
	
	
always @(posedge mem_finish)
begin
 // mem_finish = 1'b0 ;
mem_finish_off = 1'b0 ;
end

endmodule

*/