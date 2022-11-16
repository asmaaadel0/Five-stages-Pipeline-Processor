module data_stack_memory #(parameter data_width=16,address_width=32,num_of_register=11)

(input wire clk ,write_enable,read_enable,input wire [(data_width-1):0] write_data ,input wire [(address_width-1):0] address,output reg  [(data_width-1):0] read_data ) ;

reg [(data_width-1):0] array_reg [2**num_of_register-1:0];
integer i;
always @(posedge clk )
 begin

if(write_enable)
    array_reg[address] =write_data ;

 end

always @(negedge clk)
 begin

 if(read_enable)
 read_data =array_reg[address];
else
  read_data='bz;

 end

endmodule