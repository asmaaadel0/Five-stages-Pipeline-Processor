// module instruction_memory #(parameter Num_of_bits=16, pc_width=32, Num_of_registers= 5)  
           // (input clk,
            // // input cs_ldm,
            // input [pc_width-1:0]pc,
            // output reg [Num_of_bits-1:0]instruction//,
			// // output reg [Num_of_bits-1:0]immediate
			// );

    // wire [Num_of_bits-1:0]mem[2**Num_of_registers-1:0];
	
	// read_file #(Num_of_bits, Num_of_registers) read (mem);

    // integer i;

    // always @(posedge clk)
	// //always @(*)
    // begin
        // instruction = mem[pc];		
		// // immediate  = mem[pc+1];	
        // // pc <= pc +1;		
    // end

    // // always @(negedge clk)
	// // //always @(*)
    // // begin
    // //     // instruction <= mem[pc];	
    // //     if(cs_ldm == 1)
    // //     begin
	// // 	    immediate  = mem[pc];	
    // //         pc <= pc +1;	
    // //     end    		
    // // end

// endmodule

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

	reg [15:0] //puch_pc_low=16'b1_0101_0000_0000_000 
	//,puch_pc_high = 16'b1_0110_0000_0000_000 
	 // puch_pc_low=16'b1_0101_0000_0000_001
	// ,puch_pc_high = 16'b1_0110_0000_0000_001 
	 // puch_pc_low=16'b1_0101_0000_0000_010
	 puch_pc_low=16'b1_0101_0000_0000_110
	,puch_pc_high = 16'b1_0110_0000_0000_010
	// ,puch_flags  = 16'b1_1111_0000_0000_000
	,puch_flags  = 16'b1_1111_0000_0000_100
	// ,pop_pc_low  = 16'b1_0111_0000_0000_000;
	,pop_pc_low  = 16'b1_0111_0000_0000_100;
	// ,pop_flags  = 16'b0_1111_0000_0000_000; //,pop_pc_high;
    always @(posedge clk)
	//always @(*)
    begin
	
		if(INT_counter == 3'b011)//3
							//NOTE: no need to check "cs_rti" as the rti is instruction not a signal like the int 						
		begin
			instruction = puch_flags;
		end
		else if(INT_counter == 3'b010)//2
		begin
			/*if(cs_rti)
			begin
			instruction = pop_pc_low;
			end
			else 
			begin*/
			instruction = puch_pc_low;
			//end
		
		end
		else if(INT_counter == 3'b001)
		begin
			/*if(cs_rti)
			begin
			instruction = pop_flags;//not pop_pc_high, as the stack is FILO
			end
			else 
			begin*/
			instruction = puch_pc_high;
			//end		
		end
		// else if(previous_cs_rti)
		// begin
			// instruction = pop_flags;//not pop_pc_high, as the stack is FILO
		// end
		else //if its =0 or = 3'b100(call or ldm before int case )
		begin
			instruction = mem[pc];	
		end	
        	
		// immediate  = mem[pc+1];	
        // pc <= pc +1;		
    end

    // always @(negedge clk)
	// //always @(*)
    // begin
    //     // instruction <= mem[pc];	
    //     if(cs_ldm == 1)
    //     begin
	// 	    immediate  = mem[pc];	
    //         pc <= pc +1;	
    //     end    		
    // end

endmodule
