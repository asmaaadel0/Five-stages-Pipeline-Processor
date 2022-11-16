
module mux_generic #(parameter width=24)
        (   input [width-1:0]i0,i1,
    input  sel,
            output reg [width-1:0]out
            );
assign out=(sel==0)? i0:i1; //just a line?



endmodule
