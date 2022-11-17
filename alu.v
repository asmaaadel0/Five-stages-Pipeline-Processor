
module alu(
    input [15:0] op1,
    input [15:0] op2,
    input [3:0]shamt,
    input [12:0] alu_operation,
    input clk,
    output reg [2:0] flag=0,
    output reg [15:0] result
    
    );

always @(posedge clk) 
// always @(*)
begin
//------------------------------------- OUT ---------------------------------------//
if(alu_operation[12])
begin
end
//------------------------------------- IN ---------------------------------------//
if(alu_operation[11])
begin
end

//------------------------------------- NOP ---------------------------------------//
if(alu_operation[10])
begin
end

//------------------------------------- NOT ---------------------------------------//
if(alu_operation[9])
begin
result= ~op2;

end


//------------------------------------- INC ---------------------------------------//
if(alu_operation[8])
begin
 {flag[2],result}= op2 + 1 ;
end
//------------------------------------- DEC ---------------------------------------//
if(alu_operation[7])
begin
result= op2 - 1 ;
end

//------------------------------------- MOV ---------------------------------------//
if(alu_operation[6])
begin
result=op1;
end
//------------------------------------- ADD ---------------------------------------//
if(alu_operation[5])
begin
{flag[2],result}= op1 + op2;
end
//------------------------------------- SUB ---------------------------------------//
if(alu_operation[4])
begin
//result= op1 - op2;
result= op2 - op1;
end
//------------------------------------- AND ---------------------------------------//
if(alu_operation[3])
begin
 result= op1 & op2;
end
//------------------------------------- OR ---------------------------------------//
if(alu_operation[2])
begin
 result= op1 | op2;
end
//------------------------------------- SHL ---------------------------------------//
if(alu_operation[1])
begin
 result= op2 << shamt ;
flag[2]=op2[15-(shamt-1)];
end
//------------------------------------- SHR ---------------------------------------//
if(alu_operation[0])
begin
 result= op2 >> shamt ;
flag[2]=op2[(shamt-1)];
end


 flag[0]=(result==0)? 1:0;
 flag[1]=(result<0)? 1:0;

end

endmodule