
module test;

	// Inputs
	reg clk=1;
        reg rest=0;
        reg en=1;
	reg [31:0] A;
	reg [31:0] B;

	// Outputs
	wire [63:0] C;


	// Instantiate the Unit Under Test (UUT)

	integrationMult uut (
		.clk(clk), 
        .reset(0),
        .en(en),
		.inputA(A), 
		.inputB(B), 
		.result(C)
	);
always begin #50 clk = ~ clk ;end  //clock
	initial begin
		// +ve * +ve

A = 32'd2;
		B = 32'd1; //result = 14
		
                #100

                if(C != 64'd2)
	        $display("TestCase#1: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#1: success input %b and %b and Output %b", A , B , C);                

                // -ve * +ve
		

	        A = -32'd7;
	        B = 32'd3; //result = -21
		
                #100 

                if(C != -64'd21)
	        $display("TestCase#2: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#2: success input %b and %b and Output %b", A , B , C);  

                // 0 * -ve

	        A = 32'd0;
	        B = -32'd60; //result = 0
		
                #100 

                if(C != 64'd0)
	        $display("TestCase#3: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#3: success input %b and %b and Output %b", A , B , C);                  

                // +ve * -ve
                
  
	        A = 32'd20;
	        B = -32'd10; //result = -200
		
                #100 

                if(C != -64'd200)
	        $display("TestCase#4: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#4: success input %b and %b and Output %b", A , B , C);    

                // -ve * 0
		
 A = -32'd80;
	        B = 32'd1; //result = 0
		 
                #100 

                if(C != -64'd80)
	        $display("TestCase#5: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#5: success input %b and %b and Output %b", A , B , C);               

                // -ve * -ve

	        A = -32'd2;
	        B = -32'd2; //result = 2
		
                #100 

                if(C != 64'd4)
	        $display("TestCase#6: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#6: success input %b and %b and Output %b", A , B , C);   

                // 0 * +ve
                

	        A = 32'd0;
	        B = 32'd3; //result = 0
		
                #100 

                if(C != 64'd0)
	        $display("TestCase#7: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#7: success input %b and %b and Output %b", A , B , C);   

                // +ve * 0
                
    
	        A = 32'd5;
	        B = 32'd0; //result = 0
		   
                #100 

                if(C != 64'd0)
	        $display("TestCase#8: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#8: success input %b and %b and Output %b", A , B , C);                   

                // -ve * +ve
                
    
	        A = -32'd19;
	        B = 32'd3; //result = -57
		
                #100 

                if(C != -64'd57)
	        $display("TestCase#9: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#9: success input %b and %b and Output %b", A , B , C);                   

                // +ve * -ve
                
     
	        A = 32'd2;
	        B = -32'd125; //result = -250 
		    
                #100 

                if(C != -64'd250)
	        $display("TestCase#10: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#10: success input %b and %b and Output %b", A , B , C);            

         // +ve * +ve
                
 
	        A = 32'd2;
	        B = 32'd5; //result =10
		   
                #100 

                if(C != 64'd10)
	        $display("TestCase#11: failed with input %b and %b and Output %b", A , B , C);
	        else
                $display("TestCase#11: success input %b and %b and Output %b", A , B , C);
		
	end
      
endmodule

