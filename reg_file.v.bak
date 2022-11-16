
module reg_array #(parameter data_width=16,address_width=3)

(input wire clk ,write_enable,input wire [(data_width-1):0] write_data ,input wire [(address_width-1):0] write_address,read_address1,read_address2,output reg  [(data_width-1):0] read_data1, read_data2  ) ;

reg [(data_width-1):0] array_reg [2**address_width-1:0];
integer i;
always @(posedge clk )
 begin

if(write_enable)
    array_reg[write_address] =write_data ;

 end

always @(negedge clk )
 begin

 
 read_data1 =array_reg[read_address1];
 read_data2 =array_reg[read_address2];

 end

endmodule