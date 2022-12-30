module read_file #(parameter Num_of_bits=16, Num_of_registers= 20)(inst_mem);

    output reg [Num_of_bits-1:0] inst_mem [2**Num_of_registers-1:0];
    integer outfile;
	integer i=0;

initial begin
    

    // outfile=$fopen("inst_mem.txt","r");   //"r" means reading and "w" means writing
    outfile=$fopen("./assembler/CODE_RAM.mem","r");   //"r" means reading and "w" means writing
	$display(outfile);
    while (! $feof(outfile)) begin 
        $fscanf(outfile,"%b\n",inst_mem[i]); 
        $display("%b",inst_mem[i]); 
		i = i + 1;
        #10;
    end 
    //once reading and writing is finished, close all the files.
    $fclose(outfile);
end    
      
endmodule
