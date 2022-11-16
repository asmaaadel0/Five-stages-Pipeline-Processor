
module mux_generic #(parameter width=24)
        (   input [width-1:0]i0,i1,
    input  sel,
            output reg [width-1:0]out
            );
assign out=(sel==0)? i0:i1; //just a line?



endmodule


module mux_generic_2bit_selector #(parameter width=24)
        (   input [width-1:0]i0,i1,i2,i3,
            input [1:0] sel,
            output reg [width-1:0]out
            );
assign out=(sel==00)? i0:
           (sel==01)? i1:
		   (sel==10)? i2: i3;

endmodule
