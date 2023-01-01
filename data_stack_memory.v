module data_stack_memory #(parameter data_width=16,address_width=32,num_of_register=11)
(input wire clk,reset ,write_enable,read_enable,input wire [(data_width-1):0] write_data ,input wire [(address_width-1):0] address,output reg  [(data_width-1):0] read_data ) ;

reg [(data_width-1):0] array_reg [2**num_of_register-1:0];
integer i;
always @(negedge clk )
begin
	if(reset)
	begin
		for(i=0; i<2**num_of_register; i=i+1) array_reg[i] = 0;
	end
	else if(write_enable)
	begin
		array_reg[address] = write_data;
	end

 end

always @(*)
begin
	if(read_enable)
	begin
	 //for store and load we care about array_reg[address] which are the most 16bit
	  read_data = array_reg[address];
	  end
	else
	begin
	  read_data='bz;
	end
end

endmodule
