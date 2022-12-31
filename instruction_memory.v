module instruction_memory #(parameter Num_of_bits=16, pc_width=32, Num_of_registers= 5)  
           (input clk,
            // input cs_ldm,
            input [pc_width-1:0]pc,
            output reg [Num_of_bits-1:0]instuction//,
			// output reg [Num_of_bits-1:0]immediate
			);

    reg [Num_of_bits-1:0]inst_mem[2**Num_of_registers-1:0];
	
	// read_file #(Num_of_bits, Num_of_registers) read (inst_mem);

    integer i;

    always @(posedge clk)
	//always @(*)
    begin
        instuction = inst_mem[pc];		
		// immediate  = mem[pc+1];	
        // pc <= pc +1;		
    end

    // always @(negedge clk)
	// //always @(*)
    // begin
    //     // instuction <= mem[pc];	
    //     if(cs_ldm == 1)
    //     begin
	// 	    immediate  = mem[pc];	
    //         pc <= pc +1;	
    //     end    		
    // end

endmodule


