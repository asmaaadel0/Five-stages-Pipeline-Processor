

module alu(
    input [15:0] op1,
    input [15:0] op2,
    input [3:0]shamt,
    input [3:0] alu_operation,
    input clk,
    output reg [2:0] flag=0,
    output reg [15:0] result
    
    );

// always @(posedge clk)

//we make it * for writing in negative edge in buffer
always @(*)
begin
//------------------------------------- SETC ---------------------------------------//
if(alu_operation==4'b0001)
begin
flag[2] = 1'b1;
end
//------------------------------------- CLRC ---------------------------------------//
else if(alu_operation==4'b0010)
begin
flag[2] = 1'b0;
end
//------------------------------------- NOT ---------------------------------------//
else if(alu_operation==4'b0100)
begin
result= ~op2;

 flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
//------------------------------------- INC ---------------------------------------//
else if(alu_operation==4'b0101)
begin
 {flag[2],result}= op2 + 1 ;
 
  flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
//------------------------------------- DEC ---------------------------------------//
else if(alu_operation==4'b0110)
begin
result= op2 - 1 ;

 flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
//------------------------------------- MOV ---------------------------------------//
else if(alu_operation==4'b0111)
begin
result=op1;
end
//------------------------------------- ADD ---------------------------------------//
else if(alu_operation==4'b1000)
begin
{flag[2],result}= op1 + op2;

 flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
//------------------------------------- SUB ---------------------------------------//
else if(alu_operation==4'b1001)
begin
result= op2 - op1;

 flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
//------------------------------------- AND ---------------------------------------//
else if(alu_operation==4'b1010)
begin
 result= op1 & op2;
 
  flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
//------------------------------------- OR ---------------------------------------//
else if(alu_operation==4'b1011)
begin
 result = op1 | op2;
 
  flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
//------------------------------------- SHL ---------------------------------------//
else if(alu_operation==4'b1100)
begin
 result= op2 << shamt ;
flag[2]=op2[15-(shamt-1)];

 flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
//------------------------------------- SHR ---------------------------------------//
else if(alu_operation==4'b1101)
begin
 result= op2 >> shamt ;
flag[2]=op2[(shamt-1)];

 flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;
end
// //------------------------------------- IN ---------------------------------------//
else if(alu_operation==4'b1110)
begin
result = op1 ; //assume op1 has the value of input port
end
//------------------------------------- OUT ---------------------------------------//
else if(alu_operation==4'b1111)
begin
result = op2 ; //assume op2 has the value that will be stored in the output port
end
// ------------------------------------ NOP and alu_controls = xxxx ---------------------------------------//
//?;-
// else 
// begin
// //m.s of this:----
 // result =0 ;
// end
// //------------------------------------- NOP ---------------------------------------//
// else if(alu_operation==4'b0011)
// begin
// end

 // flag[0]=(result==0)? 1:0;
 // flag[1]=(result[15]==1)? 1:0;

end

endmodule