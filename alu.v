
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
//------------------------------------- OUT ---------------------------------------//
if(alu_operation==4'b0001)
begin
end
//------------------------------------- IN ---------------------------------------//
if(alu_operation==4'b0010)
begin
end

//------------------------------------- NOP ---------------------------------------//
if(alu_operation==4'b0011)
begin
end

//------------------------------------- NOT ---------------------------------------//
if(alu_operation==4'b0100)
begin
result= ~op2;

end
//------------------------------------- INC ---------------------------------------//
if(alu_operation==4'b0101)
begin
 {flag[2],result}= op2 + 1 ;
end
//------------------------------------- DEC ---------------------------------------//
if(alu_operation==4'b0110)
begin
result= op2 - 1 ;
end
//------------------------------------- MOV ---------------------------------------//
if(alu_operation==4'b0111)
begin
result=op1;
end
//------------------------------------- ADD ---------------------------------------//
if(alu_operation==4'b1000)
begin
{flag[2],result}= op1 + op2;
end
//------------------------------------- SUB ---------------------------------------//
if(alu_operation==4'b1001)
begin
result= op2 - op1;
end
//------------------------------------- AND ---------------------------------------//
if(alu_operation==4'b1010)
begin
 result= op1 & op2;
end
//------------------------------------- OR ---------------------------------------//
if(alu_operation==4'b1011)
begin
 result= op1 | op2;
end
//------------------------------------- SHL ---------------------------------------//
if(alu_operation==4'b1100)
begin
 result= op2 << shamt ;
flag[2]=op2[15-(shamt-1)];
end
//------------------------------------- SHR ---------------------------------------//
if(alu_operation==4'b1101)
begin
 result= op2 >> shamt ;
flag[2]=op2[(shamt-1)];
end




 flag[0]=(result==0)? 1:0;
 flag[1]=(result[15]==1)? 1:0;

end

endmodule