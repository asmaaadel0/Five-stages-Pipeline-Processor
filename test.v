module test ();
reg clk;
integration_1 integrated_module(clk);

always begin
#100 clk=~clk;
end

initial begin
$display("Start");

clk=0;


end

endmodule
