module control_unit #(parameter N=5, Num_alu=13,CS_NUM=34)(op_code,alu_controls,cs_push,cs_pop,cs_ldm,cs_ldd,cs_std,cs_jz,cs_jn,cs_jc,cs_jmp,
                                                 cs_call,cs_ret,cs_rti,cs_setc,cs_clrc,cs_mem_read,cs_mem_write,cs_reg_write,cs_int,
												 cs_reset,cs_alu_op,cs_mem_op);
input [N-1:0] op_code;
output [Num_alu-1:0] alu_controls;

output cs_push,cs_pop,cs_ldm,cs_ldd,cs_std,cs_jz,cs_jn,cs_jc,cs_jmp,
       cs_call,cs_ret,cs_rti,cs_setc,cs_clrc,cs_mem_read,cs_mem_write,
	   cs_reg_write,cs_int,cs_reset,cs_alu_op,cs_mem_op;
	   
reg [CS_NUM-1:0] cs;
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
8'b0_0001: cs=34'b0000_0000_0000_0001_0000_0000_0000_0100_10; //LDM   /////////////alu or memory
8'b0_0010: cs=34'b0000_0000_0000_0000_1000_0000_0000_1000_01;
8'b0_0011: cs=34'b0000_0001_0000_0000_0000_0000_0000_0100_10;
8'b0_0100: cs=34'b0001_0000_0000_0000_0000_0000_0000_0100_10;
8'b0_0101: cs=34'b0010_0000_0000_0000_0000_0000_0000_0000_10;         /////////////alu or memory
default:   cs=34'b0000_0000_0000_0000_0000_0000_0000_0000_00;
endcase
assign alu_controls = cs[CS_NUM-1:CS_NUM-Num_alu];
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

endmodule	   