

module instruction_memory #(parameter Num_of_bits=16, pc_width=32, Num_of_registers= 5)  
           (input clk,
            // input cs_ldm,
			// input [1:0]INT_counter,
			input [2:0] INT_counter,
			//input previous_cs_rti,
            input [pc_width-1:0]pc,
            output reg [Num_of_bits-1:0]instruction//,
			// output reg [Num_of_bits-1:0]immediate
			);

    reg [Num_of_bits-1:0]mem[2**Num_of_registers-1:0];
	
	// read_file #(Num_of_bits, Num_of_registers) read (mem);

    integer i;

	reg [15:0] 
	 puch_pc_low=16'b1_0101_0000_0000_110
	,puch_pc_high = 16'b1_0110_0000_0000_010
	,puch_flags  = 16'b1_1111_0000_0000_100
	,pop_pc_low  = 16'b1_0111_0000_0000_100;
	
    always @(posedge clk)
    begin
	
		if(INT_counter == 3'b011)//3
							//NOTE: no need to check "cs_rti" as the rti is instruction not a signal like the int 						
		begin
			instruction = puch_flags;
		end
		else if(INT_counter == 3'b010)//2
		begin
			instruction = puch_pc_low;
		end
		else if(INT_counter == 3'b001)
		begin
			instruction = puch_pc_high;		
		end
		else //if its =0 or = 3'b100(call or ldm before int case )
		begin
			instruction = mem[pc];	
		end	
    end

endmodule
