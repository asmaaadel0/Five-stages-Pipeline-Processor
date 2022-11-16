module read_file #(parameter Num_of_bits=16, Num_of_registers= 2**20)(inst_mem);

    output reg [Num_of_bits-1:0] inst_mem [Num_of_registers-1:0];
    integer outfile;
	integer i=0;

initial begin
    

    outfile=$fopen("inst_mem.txt","r");   //"r" means reading and "w" means writing
	
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
