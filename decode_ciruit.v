
module decode_ciruit #(parameter data_width=16,address_width=3)

(input wire clk 
,input wire write_enable
,input wire [(data_width-1):0] write_data 
,input wire [(address_width-1):0] write_address
,input wire [(address_width-1):0] read_address1
,input wire [(address_width-1):0] read_address2
,output reg  [(data_width-1):0] read_data1
,output reg  [(data_width-1):0] read_data2  ) ;

reg [(data_width-1):0] array_reg [2**address_width-1:0];
integer i;
always @(posedge clk )
// always @(*)
 begin

if(write_enable)
    array_reg[write_address] =write_data ;

 end

// always @(negedge clk )
always @(*)
 begin

 
 read_data1 =array_reg[read_address1];
 read_data2 =array_reg[read_address2];

 end

endmodule