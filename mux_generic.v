

module mux_generic #(parameter width=24)
        (   input [width-1:0]i0,i1,
    input  sel,
            output reg [width-1:0]out
            );
assign out=(sel==1'b0)? i0:i1; //just a line?



endmodule


module mux_generic_2bit_selector #(parameter width=24)
        (   input [width-1:0]i0,i1,i2,i3,
            input [1:0] sel,
            output reg [width-1:0]out
            );
assign out=(sel==2'b00)? i0:
           (sel==2'b01)? i1:
		   (sel==2'b10)? i2: i3;

endmodule
