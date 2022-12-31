module sign_recovery
	( 
		input [31:0] product_signs,
		input reset,
		output reg [31:0]sign_sum //= 0
	);

  reg [31:0] [31:0]sign_sum_temp ;
    reg [31:0] [31:0]sign_sum_temp_2 ;
    reg [31:0] [31:0]sign_sum_temp_3 ;

	// assign sign_sum = sign_sum_temp[32] ;
  	// assign sign_sum = sign_sum_temp[0] ;
  //	assign sign_sum = sign_sum_temp[31] ;

	always @(*)
	//always @(product_signs)
	begin:B1
  // sign_sum_temp[0] = 32'b00000000000000000000000000000000;
	//sign_sum =32'b0;
			integer i;
			for(i=0; i<32 ; i=i+1 )
			begin
        // sign_sum_temp_2[i] = {32{product_signs[i]} } ;
        // sign_sum_temp_3[i] = (sign_sum_temp_2[i] <<(i)) ;
		sign_sum_temp_3  ={ {32{product_signs[i]} , {{i{1'b0}} } ;
			// sign_sum_temp[i] = product_signs[i] & sign_sum_temp_3[i] ;
      sign_sum_temp[i] = (product_signs[i] == 1)?sign_sum_temp_3[i]:32'b0 ;

      end

      // integer j;
			// for(j=1; j<32 ; j=j+1 )
			// begin
			// sign_sum_temp[j] = sign_sum_temp[j]+sign_sum_temp[j-1] ;
      // end
			sign_sum = sign_sum_temp[0]+sign_sum_temp[1]+sign_sum_temp[2]
			+ sign_sum_temp[3]+sign_sum_temp[4]+sign_sum_temp[5]
			+ sign_sum_temp[6]+sign_sum_temp[7]+sign_sum_temp[8]
			+ sign_sum_temp[9]+sign_sum_temp[10]+sign_sum_temp[11]
			+ sign_sum_temp[12]+sign_sum_temp[13]+sign_sum_temp[14]
			+ sign_sum_temp[15]+sign_sum_temp[16]+sign_sum_temp[17]
			+ sign_sum_temp[18]+sign_sum_temp[19]+sign_sum_temp[20]
			+ sign_sum_temp[21]+sign_sum_temp[22]+sign_sum_temp[23]
			+ sign_sum_temp[24]+sign_sum_temp[25]+sign_sum_temp[26]
			+ sign_sum_temp[27]+sign_sum_temp[28]+sign_sum_temp[29]
			+ sign_sum_temp[30]+sign_sum_temp[31];


end	
endmodule

module full_adder 
            ( 
              input i_bit1,
              input i_bit2,
              input i_carry,
              output o_sum,
              output o_carry );
	assign o_sum = i_bit1 ^ i_bit2 ^ i_carry;
	assign o_carry = ((i_bit1 ^ i_bit2) & i_carry) | (i_bit1 & i_bit2);        
endmodule

module half_adder (a , b , sum , carry );
         input a,b; 
         output sum , carry;
         assign sum = a ^b;
         assign carry=a&b;
          
endmodule 


module wallace_tree_multi(
		input [7:0] a1, b1,
		input invert,p7_cin,
		output [15:0] result ,
		output [7:0] prod_sign ,
		output p7_cout
		
    );
	 
	 wire [7:0] p0,p1,p2,p3,p4,p5,p6,p7,p7_first;
	 wire [7:0] r1, r2, r3, r4, r5, r6, r7, r8;
	 wire [64:0] cr;
	 wire [53:0] sum;
	 
	 

	 assign r1  =  {8{b1[0]}};
	 assign r2  =  {8{b1[1]}};
	 assign r3  =  {8{b1[2]}};
	 assign r4  =  {8{b1[3]}};
	 assign r5  =  {8{b1[4]}};
	 assign r6  =  {8{b1[5]}};
	 assign r7  =  {8{b1[6]}};
	 assign r8  =  {8{b1[7]}};
	 
	 //the internal result of multiplication
	 assign p0=a1&r1;
	 assign p1=a1&r2;
	 assign p2=a1&r3;
	 assign p3=a1&r4;
	 assign p4=a1&r5;
	 assign p5=a1&r6;
	 assign p6=a1&r7;
	 assign p7_first=(invert==1)? ~(a1&r8):(a1&r8);
	 assign {p7_cout,p7} = p7_cin+p7_first;
	 //assign p7 = (p7_cin == 1) :(p7_first+p7_cin):p7_first;
	 
	 assign prod_sign[7:0]={p7[7],p6[7],p5[7],p4[7],p3[7],p2[7],p1[7],p0[7]};
	 ///assign p7_original=a1&r8;
	
	//to treat the sign problem
	///p7_comp
	
	///assign p7 = 
	
	
	half_adder a1241(p0[1], p1[0], sum[1], cr[1]);
	
	full_adder a2(p0[2], p1[1], p2[0], sum[2], cr[2]);
	full_adder a3(p0[3], p1[2], p2[1], sum[3], cr[3]);
	full_adder a4(p0[4], p1[3], p2[2], sum[4], cr[4]);
	
	half_adder a5(p3[1], p4[0], sum[10], cr[10]);
	
	full_adder a6(p0[5], p1[4], p2[3], sum[5], cr[5]);
	full_adder a7(p3[2], p4[1], p5[0], sum[11], cr[11]);
	full_adder a8(p0[6], p1[5], p2[4], sum[6], cr[6]);
	full_adder a9(p3[3], p4[2], p5[1], sum[12], cr[12]);
	full_adder a10(p0[7], p1[6], p2[5], sum[7], cr[7]);
	full_adder a11(p3[4], p4[3], p5[2], sum[13], cr[13]);
	
	//half_adder not full_adder?:--
	half_adder a12(p1[7], p2[6], sum[8], cr[8]);
	
	full_adder a13(p3[5], p4[4], p5[3], sum[14], cr[14]);
	full_adder a14(p2[7], p3[6], p4[5], sum[9], cr[9]);
	full_adder a15(p3[7], p4[6], p5[5], sum[15], cr[15]);
	
	//half_adder not full_adder?:--
	half_adder a16(p4[7], p5[6], sum[16], cr[16]);	

	
	half_adder a17(sum[2], cr[1], sum[17], cr[17]);
	
	full_adder a18(sum[3], cr[2], p3[0], sum[18], cr[18]);
	full_adder a19(sum[4], cr[3], sum[10], sum[19], cr[19]);		
	full_adder a20(sum[5], cr[4], sum[11], sum[20], cr[20]);
	full_adder a21(sum[6], cr[5], sum[12], sum[21], cr[21]);  	
	full_adder a22(sum[7], cr[6], sum[13], sum[22], cr[22]);
	
	
	full_adder a23(sum[8], cr[7], sum[14], sum[23], cr[23]);
	full_adder a24(sum[9], cr[8], cr[14], sum[24], cr[24]);
	full_adder a25(cr[9], p6[4], p7[3], sum[29], cr[29]);		
	
	//later:-
	full_adder a26(cr[15], p6[5], p7[4], sum[30], cr[30]);
	full_adder a27(p5[7], p6[6], p7[5], sum[31], cr[31]);
	
	half_adder a28(p6[7], p7[6], sum[32], cr[32]);
	half_adder a29(p6[0], cr[11], sum[25], cr[25]);
	
	full_adder a30(cr[12], p6[1], p7[0], sum[26], cr[26]);
	full_adder a31(cr[13], p6[2], p7[1], sum[27], cr[27]);
	full_adder a32(p5[4], p6[3], p7[2], sum[28], cr[28]);

	
	half_adder a33(sum[18], cr[17], sum[33], cr[33]);
	half_adder a34(sum[19], cr[18], sum[34], cr[34]);
	
	full_adder a35(sum[20], cr[19], cr[10], sum[35], cr[35]);
	full_adder a36(sum[21], cr[20], sum[25], sum[36], cr[36]);
	full_adder a37(sum[22], cr[21], sum[26], sum[37], cr[37]);
	
	
	full_adder a38(sum[23], cr[22], sum[27], sum[38], cr[38]);
	full_adder a39(sum[24], cr[23], sum[28], sum[39], cr[39]);
	full_adder a40(sum[15], cr[24], sum[29], sum[40], cr[40]);
	
	half_adder a41(sum[16], sum[30], sum[41], cr[41]);
	half_adder a42(cr[16], sum[31], sum[42], cr[42]);
	
	
	half_adder a43(sum[34], cr[33], sum[43], cr[43]);
	half_adder a44(sum[35], cr[34], sum[44], cr[44]);
	half_adder a45(sum[36], cr[35], sum[45], cr[45]);
	full_adder a46(sum[37], cr[36], cr[25], sum[46], cr[46]);
	full_adder a47(sum[38], cr[37], cr[26], sum[47], cr[47]);	
	full_adder a48(sum[39], cr[38], cr[27], sum[48], cr[48]);
	full_adder a49(sum[40], cr[39], cr[28], sum[49], cr[49]);	
	full_adder a50(sum[41], cr[40], cr[29], sum[50], cr[50]);	
	full_adder a51(sum[42], cr[30], cr[41], sum[51], cr[51]);	
	full_adder a52(cr[42], sum[32], cr[31], sum[52], cr[52]);	
	half_adder a53(p7[7], cr[32], sum[53], cr[53]);
	
	
	half_adder a54(sum[44], cr[43], result[5], cr[54]);
	full_adder a55(sum[45], cr[44], cr[54], result[6], cr[55]);	
	full_adder a56(sum[46], cr[45], cr[55], result[7], cr[56]);
	full_adder a57(sum[47], cr[46], cr[56], result[8], cr[57]);
	full_adder a58(sum[48], cr[47], cr[57], result[9], cr[58]);
	full_adder a59(sum[49], cr[48], cr[58], result[10], cr[59]);
	full_adder a60(sum[50], cr[49], cr[59], result[11], cr[60]);
	full_adder a61(sum[51], cr[50], cr[60], result[12], cr[61]);
	full_adder a62(sum[52], cr[51], cr[61], result[13], cr[62]);
	full_adder a63(sum[53], cr[52], cr[62], result[14], cr[63]);
	
	assign result[0] = p0[0];
	assign result[1] = sum[1];
	assign result[2] = sum[17];
	assign result[3] = sum[33];
	assign result[4] = sum[43];
	assign result[15] = cr[53];
      
	 
endmodule
	
module wallace_tree_multi_new(reset_sum,a, b, final_result);
 
input reset_sum; 
input [31:0]a;
input [31:0]b;
output [63:0]final_result;
    
wire [63:0]result;//,after_result;
//wire [63:0] temp_add_1, temp_add_2, temp_add_3, temp_add_4, temp_add_5, temp_add_6,  temp_add_7, temp_add_8;
wire [63:0] temp_result1, temp_result2, temp_result3, temp_result4, temp_result5, temp_result6, temp_result7, temp_result8, temp_result9, temp_result10, temp_result11, temp_result12, temp_result13, temp_result14, temp_result15, temp_result16;
wire [15:0] temp_result[15:0];
wire [7:0] prod_sign[15:0];
//wire [63:0] w1, w2, w3, w4, w5, w6;
//wire w10;

wire [15:0] invert,p7_cin_wall,p7_cout_wall;
wire [3:0]p7_cin,p7_cout;
//assign p7_cin[0] =1;
assign p7_cin[0] =b[31];
//assign p7_cin[1] =p7_cout[0];
//assign p7_cin[2] =p7_cout[1];
//assign p7_cin[3] =p7_cout[2];

assign p7_cin[1] =p7_cout_wall[3];
assign p7_cin[2] =p7_cout_wall[7];
assign p7_cin[3] =p7_cout_wall[11];

genvar i,j;
  generate
    for (i=0 ; i<4; i=i+1) 
    begin
		for (j=0; j<4; j=j+1) 
		begin
			assign invert[i*4+j] = (j==3 && b[31] == 1)?1:0;
			//assign p7_cin[i*4+j] = (j==3 && p7_cout[(i-1)*4+j] == 1)?1:0;
			assign p7_cin_wall[i*4+j] = (j==3)? p7_cin[i]: 0;
			wallace_tree_multi inst
				(   
				  //.a1(a[(7*(j+1)+j) : (7*(j)+j) ]),
				  //.b1(b[(7*(i+1)+i) : (7*(i)+i)]),
				  .a1(a[(7*(i+1)+i) : (7*(i)+i)]),
				  .b1(b[(7*(j+1)+j) : (7*(j)+j) ]),
				  .invert(invert[i*4+j]),
				  //.p7_cin(p7_cin[i*4+j]),
				  .p7_cin(p7_cin_wall[i*4+j]),
				  .result(temp_result[i*4+j]),
				  //sign recovery
				  .prod_sign(prod_sign[i*4+j]),
				  //.p7_cout(p7_cout[(i-1)*4+j])
				  .p7_cout(p7_cout_wall[i*4+j])
				);
		end
		
    end
  endgenerate

//sign recovery
/*
wire [30:0]sign_sum;
wire [30:0]final_product_sign ;
assign final_product_sign = {prod_sign[15][6:0],prod_sign[14],prod_sign[13],prod_sign[12]};
*/
wire [31:0]sign_sum;
wire [31:0]final_product_sign ;
//assign final_product_sign = {prod_sign[15],prod_sign[11],prod_sign[7],prod_sign[3]};
assign final_product_sign = {prod_sign[15],prod_sign[14],prod_sign[13],prod_sign[12]};

sign_recovery sig_rec(
						.product_signs(final_product_sign),
						.reset(reset_sum),
						.sign_sum(sign_sum)	
					);
					
					
assign temp_result1 = {48'b0, temp_result[0]};
assign temp_result2 = {40'b0, temp_result[1], 8'b0};
assign temp_result3 = {40'b0, temp_result[2], 16'b0};
assign temp_result4 = {32'b0, temp_result[3], 24'b0};

assign temp_result5 = {40'b0, temp_result[4], 8'b0};
assign temp_result6 = {40'b0, temp_result[5], 16'b0};
assign temp_result7 = {32'b0, temp_result[6], 24'b0};
assign temp_result8 =  {16'b0, temp_result[7], 32'b0};

assign temp_result9 = {40'b0, temp_result[8], 16'b0};
assign temp_result10 = {24'b0, temp_result[9], 24'b0};
assign temp_result11 = {16'b0, temp_result[10], 32'b0};
assign temp_result12 = {8'b0, temp_result[11], 40'b0};

assign temp_result13 = {24'b0, temp_result[12], 24'b0};
assign temp_result14 = {16'b0, temp_result[13], 32'b0};
assign temp_result15 = {8'b0, temp_result[14], 40'b0};
assign temp_result16 = {8'b0, temp_result[15], 48'b0};


assign result = temp_result1 +temp_result2 +temp_result3 
				+temp_result4 +temp_result5 +temp_result6 
				+temp_result7 +temp_result8 +temp_result9 
				+temp_result10 +temp_result11 +temp_result12 
				+temp_result13 +temp_result14 +temp_result15 +temp_result16;

//assign after_result =( b[31] == 1)?result+{1'b1,31'b00000000000000000000000000000000}:result;
//sign recovery
//assign final_result= after_result+ {sign_sum ,32'b00000000000000000000000000000000};
//assign final_result= (a==0 || b==0)? 64'b0:result+ {sign_sum ,32'b00000000000000000000000000000000};
assign final_result= result+ {sign_sum ,32'b00000000000000000000000000000000};


//wire [63:0]built_result;
//assign built_result=a*b;
endmodule

//11111111111111111111111111111111 :32 ones
//00000000000000000000000000000000


module registerNbits #(parameter N = 32) (clk,reset,en, inp, out);
	input clk,reset,en;
	output  reg signed[N-1:0] out;
	input signed [N-1:0] inp;
	always @(posedge clk)
		begin
			if (reset) 
				out <= 'b0;
			else if(en)
				out <= inp;
			
		end
endmodule

module integrationMult #(parameter N = 32 ) (clk,reset,en,inputA,inputB,result);
input clk,reset,en;

input signed [N-1:0] inputA, inputB;
output  signed [2*N-1:0] result;

wire [N-1:0] A_reg;
wire [N-1:0] B_reg;
wire [N-1:0] outA_reg;
wire [N-1:0] outB_reg;


registerNbits #(32) regA (clk,reset,en,inputA, A_reg);
registerNbits #(32) regB (clk,reset,en,inputB, B_reg);
//multiplyTimes #(32) mult (A_reg,B_reg,{outA_reg,outB_reg});
wallace_tree_multi_new mult(reset,A_reg,B_reg, {outA_reg,outB_reg});
registerNbits #(32) outA (clk,reset,en,outB_reg,result[N-1:0]);
registerNbits #(32) outB (clk,reset,en,outA_reg,result[2*N-1:N]);
 // wire [64:0] y ; 
 // assign y = 
endmodule
