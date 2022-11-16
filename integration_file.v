module integration (/*input, output later*/); 
localparam Num_of_bits=16;  //width of instruction assumnig immediate separated from instruction
localparam Num_of_registers=6 ; //////////must be 20
localparam pc_width=32;
localparam sp_width=32;
localparam op_code_width=5;
localparam Num_alu=13; //number of alu instructions
localparam CS_NUM=34; //number of signals with alu instruction
wire pc=2**5; ///////how to start from 2**5
wire sp=2**11 -1;
wire clk, instuction, immediate;
wire [Num_of_bits-1:0] instuction, immediate
wire [Num_alu-1:0] alu_controls;
wire cs_push,cs_pop,cs_ldm,cs_ldd,cs_std,cs_jz,cs_jn,cs_jc,cs_jmp,
       cs_call,cs_ret,cs_rti,cs_setc,cs_clrc,cs_mem_read,cs_mem_write,
	   cs_reg_write,cs_int,cs_reset,cs_alu_op,cs_mem_op;
wire data;
wire [Num_of_bits-1:0] read_data1,read_data2;
wire [2:0] flag=0;
wire [15:0] result;
instruction_memory #(Num_of_bits,pc_width,Num_of_registers) inst_mem_stage ( .clk(clk),.pc(pc),.instuction(instuction),.immediate(immediate));

control_unit #(op_code_width,Num_alu,CS_NUM)(.op_code(instuction[op_code_width-1:0]),alu_controls,cs_push,cs_pop,cs_ldm,cs_ldd,cs_std,cs_jz,cs_jn,
                        cs_jc,cs_jmp,cs_call,cs_ret,cs_rti,cs_setc,cs_clrc,cs_mem_read,cs_mem_write,cs_reg_write,cs_int,cs_reset,
                        cs_alu_op,cs_mem_op);

decode_ciruit #(16,3) decode_stage (.clk(clk) ,.write_enable(cs_reg_write),.write_data(data),
                              .write_address(instuction[op_code_width+5:op_code_width+3]),
							  .read_address1(instuction[op_code_width+2:op_code_width]),
                              .read_address2(instuction[op_code_width+5:op_code_width+3]),.read_data1(read_data1), .read_data2(read_data2));

alu alu_stage(.op1(read_data1),.op2(read_data2),.shamt(shamt),.alu_operation(alu_controls),.flag(flag),.result(result));

data_stack_memory #(16,sp_width,11) memory_stage (.clk(clk) ,.write_enable(cs_mem_write),.read_enable(cs_mem_read),
                                            .write_data(data) ,.address(address),.read_data(read_data));

endmodule