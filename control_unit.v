module control_unit #(parameter N=5, Num_alu=4,CS_NUM=25)(op_code,alu_controls,choosen_value,store_load,cs_ldm,cs_push
,SP_change,PC_select,jump_type,cs_jmp,cs_call,cs_in,cs_out,cs_mem_read,cs_mem_write,cs_reg_write,special_inst
,cs_reset,cs_alu_op,cs_mem_op,shamt,reset_pc,push_flags,Pc_low_pop,cs_ret,fetch_NOP,decode_reset,execute_reset
,decode_NOP,cs_rti,INT_counter,write_cs_rti);
input [N-1:0] op_code;
output [Num_alu-1:0] alu_controls;
output [1:0] choosen_value, PC_select, jump_type, INT_counter;

output store_load,cs_ldm,cs_push,SP_change,cs_jmp,cs_call,cs_in,cs_out,
cs_mem_read,cs_mem_write,cs_reg_write,special_inst,cs_reset,cs_alu_op,cs_mem_op,
shamt,reset_pc,push_flags,Pc_low_pop,cs_ret,fetch_NOP,decode_reset,execute_reset
,decode_NOP,cs_rti,write_cs_rti;
	   
reg [CS_NUM-1:0] cs;


//if op_code = zeros (buffer after fetch has been reset) then all controls = zero

//1. LDM Rdst, Imm
//2. STD Rsrc, Rdst
//3. ADD Rsrc, Rdst
//4. NOT Rdst
//5. NOP	   

//• LDM [001]
//• STD [010]
//• ADD [011]
//• NOT [100]
//• NOP [101]
//out in nop not inc dec mov add sub and or shl shr
always @(*)
case(op_code)
//NOP
8'b0_0000: cs='b0011_0000_0000_0000_0000_0001_0000_0000_0000_00;

//SETC


//CLRC


//NOT
8'b0_0011: cs='b0100_0000_0000_0000_0000_1001_0000_0000_0000_00;

//INC


//DEC


//OUT


//IN


//MOV


//ADD
8'b01_001: cs='b1000_0000_0000_0000_0000_1001_0000_0000_0000_00;

//SUB


//AND


//OR


//SHL


//SHR


//PUSH


//POP


//LDM
8'b1_0010: cs='b0000_0001_0000_0000_0000_0000_1000_0000_0000_00;

//LDD


//STD
8'b1_0100: cs='b0000_0010_0000_0000_0001_0000_1000_0000_0000_00;

//JZ


//JN


//JC


//JMP


//CALL


//RET


//RTI


//Interrupt



// 8'b0_0001: cs='b0011_0010_0000_0000_0000_1001_0; //LDM   
// 8'b0_0010: cs='b0000_0000_1000_0000_0001_0000_1; //STD
// 8'b0_0011: cs='b1000_0000_0000_0000_0000_1001_0;//ADD
// 8'b0_0100: cs='b0100_0000_0000_0000_0000_1001_0;//NOT
// 8'b0_0101: cs='b0011_0000_0000_0000_0000_0001_0;//NOP
default:   cs='b0000_0000_0000_0000_0000_0000_0000_0000_0000_00;
endcase
assign alu_controls = cs[CS_NUM-1:CS_NUM-Num_alu];
// assign alu_controls = 'b1000;
assign cs_push = cs[20];
assign cs_pop = cs[19];
assign cs_ldm = cs[18];
assign cs_ldd = cs[17];
assign cs_std = cs[16];
assign cs_jz = cs[15];
assign cs_jn = cs[14];
assign cs_jc = cs[13];
assign cs_jmp = cs[12];
assign cs_call = cs[11];
assign cs_ret = cs[10];
assign cs_rti = cs[9];
assign cs_setc = cs[8];
assign cs_clrc = cs[7];
assign cs_mem_read = cs[6];
assign cs_mem_write = cs[5];
assign cs_reg_write = cs[4];
assign cs_int = cs[3];
assign cs_reset = cs[2];
assign cs_alu_op = cs[1];
assign cs_mem_op = cs[0];


// reg [1:0]INT_counter
// always @(negedge clk) begin
// 	if(INT_counter != 00)
// 	begin
// 		INT_counter = INT_counter-1
// 	end
// end

endmodule	   