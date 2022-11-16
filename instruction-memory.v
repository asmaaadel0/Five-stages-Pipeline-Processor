module instruction_memory #(parameter Num_of_bits=16, pc_width=32, Num_of_registers= 20)  /// must be 2**20
           (input clk,
            input [pc_width-1:0]pc,
            output reg [Num_of_bits-1:0]instuction,
			output reg [Num_of_bits-1:0]immediate);

    wire [Num_of_bits-1:0]mem[Num_of_registers-1:0];
	
	read_file #(Num_of_bits, Num_of_registers) read (mem);

    integer i;

    always @(posedge clk)
    begin
        instuction <= mem[pc];		
		immediate  <= mem[pc+1];			
    end

endmodule


