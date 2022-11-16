module integration (/*input, output later*/); 
localparam Num_of_bits=16;  //width of instruction assumnig immediate separated from instruction
localparam Num_of_registers=6 ; //////////must be 20
localparam pc_width=32;
localparam sp_width=32;
localparam op_code_width=5;
localparam Num_alu=13; //number of alu instructions
localparam CS_NUM=34; //number of signals with alu instruction
localparam pop_width=32; //pop width
wire pc=2**5; ///////how to start from 2**5
wire sp=2**11 -1;
wire clk;
wire [Num_of_bits-1:0] instuction, immediate;
wire [Num_alu-1:0] alu_controls;
wire cs_push,cs_pop,cs_ldm,cs_ldd,cs_std,cs_jz,cs_jn,cs_jc,cs_jmp,
       cs_call,cs_ret,cs_rti,cs_setc,cs_clrc,cs_mem_read,cs_mem_write,
	   cs_reg_write,cs_int,cs_reset,cs_alu_op,cs_mem_op;
wire [pop_width-1:0] data;
wire [Num_of_bits-1:0] read_data1,read_data2;
wire [2:0] flag=0;
wire [15:0] result;
wire [sp_width-1:0] read_data2_result, mem_address;
wire [pop_width-1:0] value, flag_result;
wire [pop_width-1:0] read_data1_result; //if pop width = 16 we will not make sign extend
wire [pc_width-1:0] z_value=32'bz;
wire selector_2, selector_3, selector_5, selector_6, selector_7;
wire [1:0] selector_1, selector_4;
wire [15:0] write_data, op2;
wire sp_jump=1;

instruction_memory #(Num_of_bits,pc_width,Num_of_registers) inst_mem_stage ( .clk(clk),.pc(pc),.instuction(instuction),.immediate(immediate));

//if we change pop width to be 16bit we have to change input 'data' this in mux
mux_generic_2bit_selector #(32) mux_1(0, 2**5, data, pc+1, selector_1, pc);

control_unit #(op_code_width,Num_alu,CS_NUM)((instuction[Num_of_bits-1:Num_of_bits-op_code_width]),alu_controls,cs_push,cs_pop,cs_ldm,cs_ldd,cs_std,cs_jz,cs_jn,
                        cs_jc,cs_jmp,cs_call,cs_ret,cs_rti,cs_setc,cs_clrc,cs_mem_read,cs_mem_write,cs_reg_write,cs_int,cs_reset,
                        cs_alu_op,cs_mem_op);

decode_ciruit #(16,3) decode_stage (.clk(clk) ,.write_enable(cs_reg_write),.write_data(write_data),
                              .write_address(instuction[op_code_width+5:op_code_width+3]),
							  .read_address1(instuction[op_code_width+2:op_code_width]),
                              .read_address2(instuction[op_code_width+5:op_code_width+3]),.read_data1(read_data1), .read_data2(read_data2));

mux_generic #(3) mux_7(flag, data[pop_width-14:pop_width-16], selector_7, flag); //14 => -16+2

mux_generic #(16) mux_6(read_data2, immediate, selector_6, op2);

alu alu_stage(.op1(read_data1),.op2(op2),.shamt(shamt),.alu_operation(alu_controls),.flag(flag),.result(result));

sign_extend extend_1(read_data2,read_data2_result);

mux_generic #(32) mux_2(read_data2_result, sp, selector_2, mem_address);

sign_extend extend_2(flag,flag_result);

sign_extend extend_3(read_data1,read_data1_result);

mux_generic_2bit_selector #(pop_width) mux_4(flag_result, pc, read_data1_result, z_value, selector_4, value);

data_stack_memory #(16,sp_width,11) memory_stage (.clk(clk) ,.write_enable(cs_mem_write),.read_enable(cs_mem_read),
                                            .write_data(value) ,.address(mem_address),.read_data(data));
											
	
mux_generic #(16) mux_5(sp+sp_jump, sp-sp_jump, selector_5, sp);
	
mux_generic #(16) mux_3(result, data[pop_width-1:pop_width-16], selector_3, write_data);

endmodule