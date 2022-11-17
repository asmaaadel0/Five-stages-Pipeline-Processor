module integration_1 (/*input, output later*/); 
localparam Num_of_bits=16;  //width of instruction assumnig immediate separated from instruction
localparam Num_of_registers=6 ; //////////must be 20
localparam pc_width=32;
localparam sp_width=32;
localparam op_code_width=5;
localparam Num_alu=13; //number of alu instructions
localparam CS_NUM=34; //number of signals with alu instruction
localparam pop_width=16; //pop width
//wire pc=2**5; //how to fill instraction from 0 to 2**5 to start from 2**5
//reg pc=2**5;
reg [pc_width-1:0] pc=0;
// wire [pc_width-1:0] pc;
wire [pc_width-1:0] pc_modified;
wire [sp_width-1:0] sp=2**11 -1;
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
///////buffers//////
wire [Num_of_bits-1:0] instuction_f, immediate_f;


wire [2:0] d_read_add_2;
wire [15:0] d_read_data1,d_read_data2;
wire [3:0] d_shamt;
wire [Num_of_bits-1:0] d_immediate;
wire [Num_alu-1:0] d_alu_controls;
wire d_push,d_pop,d_ldm,d_ldd,d_std,d_jz,d_jn,
     d_jc,d_jmp,d_call,d_ret,d_rti,d_setc,d_clrc,
     d_mem_read,d_mem_write,d_reg_write,d_int,d_reset,d_alu_op,d_mem_op;


wire [15:0] e_result;
wire [2:0] e_flag,e_read_add_2;
wire [15:0] e_read_data1,e_read_data2;
wire [Num_of_bits-1:0] e_immediate;
wire e_push,e_pop,e_ldm,e_ldd,e_std,e_jz,e_jn,e_jc,e_jmp,e_call,
     e_ret,e_rti,e_setc,e_clrc,e_mem_read,e_mem_write,
     e_reg_write,e_int,e_reset,e_alu_op,e_mem_op;


wire [pop_width-1:0] m_data;
wire [15:0] m_result;
wire [2:0] m_read_add_2;
wire [Num_of_bits-1:0] m_immediate;
wire m_reg_write,m_push,m_pop,m_ldm,m_ldd,
     m_std,m_jz,m_jn,m_jc,m_jmp,m_call,
     m_ret,m_rti,m_setc,m_clrc,m_int,m_reset,m_alu_op,m_mem_op; 
    


instruction_memory #(Num_of_bits,pc_width,Num_of_registers) inst_mem_stage ( .clk(clk),.cs_ldm(cs_ldm),.pc(pc), .instuction(instuction));//.immediate(immediate)

//16 for instruction, 16 for immediate
// buffer #(32)buffer_fetch(.read_data({instuction_f,immediate_f}), .write_data({instuction,immediate}),.clk(clk));
buffer #(16)buffer_fetch(.read_data(instuction_f), .write_data(instuction),.clk(clk));

always@(negedge clk)
begin 
// pc <= pc_modified;
pc = pc + 1;
end
//delete
//if we change pop width to be 16bit we have to change input 'data' this in mux
//mux_generic_2bit_selector #(32) mux_1(0, 2**5, data, pc+1, selector_1, pc);

//equation of this selector for phase 1	
// assign selector_1 = ~cs_ldm;
// mux_generic #(32) mux_1(pc+1, pc+2, 1, pc_modified);


control_unit #(op_code_width,Num_alu,CS_NUM) cont_unit((instuction_f[Num_of_bits-1:Num_of_bits-op_code_width]),alu_controls,cs_push,cs_pop,
                                              cs_ldm,cs_ldd,cs_std,cs_jz,cs_jn,cs_jc,cs_jmp,cs_call,cs_ret,cs_rti,cs_setc,cs_clrc,
											  cs_mem_read,cs_mem_write,cs_reg_write,cs_int,cs_reset,cs_alu_op,cs_mem_op);


wire [2:0] read_add_1 = instuction_f[Num_of_bits-op_code_width-1:Num_of_bits-op_code_width-3];
wire [2:0] read_add_2 = instuction_f[Num_of_bits-op_code_width-4:Num_of_bits-op_code_width-6];
decode_ciruit #(16,3) decode_stage (.clk(clk) ,.write_enable(m_reg_write),.write_data(write_data),
                              .write_address(m_read_add_2), //7:5
							  .read_address1(read_add_1), //10:8
                              .read_address2(read_add_2), //7:5
							  .read_data1(read_data1), .read_data2(read_data2));

//3 for read_add_2(write address),16 for immediate,16 for read_data1, 16 for read_data2,34 controls
buffer #(89)buffer_decode(.read_data({d_immediate,d_read_add_2,d_read_data1,d_read_data2,d_shamt,d_alu_controls,d_push,d_pop,
                                   d_ldm,d_ldd,d_std,d_jz,d_jn,d_jc,d_jmp,d_call,
                                   d_ret,d_rti,d_setc,d_clrc,d_mem_read,d_mem_write,
                                   d_reg_write,d_int,d_reset,d_alu_op,d_mem_op}), 
                                   .write_data({instuction,read_add_2,read_data1,read_data2,instuction_f[Num_of_bits-op_code_width-7:Num_of_bits-op_code_width-10],
                                   alu_controls,cs_push,cs_pop,                                            
                                   cs_ldm,cs_ldd,cs_std,cs_jz,cs_jn,cs_jc,cs_jmp,cs_call,
                                   cs_ret,cs_rti,cs_setc,cs_clrc,cs_mem_read,cs_mem_write,
                                   cs_reg_write,cs_int,cs_reset,cs_alu_op,cs_mem_op}),.clk(clk));

//delete
//mux_generic #(3) mux_7(flag, data[pop_width-14:pop_width-16], selector_7, flag); //14 => -16+2

//deleted for all phases
//mux_generic #(16) mux_6(read_data2, immediate, selector_6, op2);

assign op2 = read_data2;
alu alu_stage(.op1(d_read_data1),.op2(d_read_data2),.shamt(d_shamt),.alu_operation(d_alu_controls),.clk(clk),.flag(flag),.result(result));


//16 for instruction, 16 for immediate 
//////////flag later
//3 for read_add_2(write address),16 for immediate, 16 for result , 3 for flags , 21 for controls
buffer #(91)buffer_alu(.read_data({e_result,e_flag,e_read_add_2,e_read_data1,e_read_data2,e_immediate,e_push,e_pop,
                                   e_ldm,e_ldd,e_std,e_jz,e_jn,e_jc,e_jmp,e_call,
                                   e_ret,e_rti,e_setc,e_clrc,e_mem_read,e_mem_write,
                                   e_reg_write,e_int,e_reset,e_alu_op,e_mem_op}), 
                                   .write_data({result,flag,d_read_add_2,d_read_data1,d_read_data2,d_immediate
                                   ,d_push,d_pop,
                                   d_ldm,d_ldd,d_std,d_jz,d_jn,d_jc,d_jmp,d_call,
                                   d_ret,d_rti,d_setc,d_clrc,d_mem_read,d_mem_write,
                                   d_reg_write,d_int,d_reset,d_alu_op,d_mem_op}),.clk(clk));

//delete
sign_extend extend_1(e_read_data2,read_data2_result);

assign mem_address = read_data2_result;

//delete
//mux_generic #(32) mux_2(read_data2_result, sp, selector_2, mem_address);

//delete
//sign_extend extend_2(flag,flag_result);

//delete
// sign_extend extend_3(e_read_data1,read_data1_result);

// assign value = read_data1_result;
assign value = e_read_data1;
//delete
//mux_generic_2bit_selector #(pop_width) mux_4(flag_result, pc, read_data1_result, z_value, selector_4, value);

data_stack_memory #(16,sp_width,11) memory_stage (.clk(clk) ,.write_enable(e_mem_write),.read_enable(e_mem_read),
                                            .write_data(value) ,.address(mem_address),.read_data(data));
											
//16 for data,16 for result,16 for immediate,3 for read_add_2(write address), and 19 for control signals
buffer #(70)buffer_mem(.read_data({m_data,m_result,m_read_add_2,m_reg_write,m_immediate,m_push,m_pop,
                                   m_ldm,m_ldd,m_std,m_jz,m_jn,m_jc,m_jmp,m_call,
                                   m_ret,m_rti,m_setc,m_clrc,
                                   m_int,m_reset,m_alu_op,m_mem_op}),
                                    .write_data({data,e_result,e_read_add_2,e_reg_write,e_immediate,e_push,e_pop,
                                   e_ldm,e_ldd,e_std,e_jz,e_jn,e_jc,e_jmp,e_call,
                                   e_ret,e_rti,e_setc,e_clrc,
                                   e_int,e_reset,e_alu_op,e_mem_op}),.clk(clk));
/*
//delete	
//mux_generic #(16) mux_5(sp+sp_jump, sp-sp_jump, selector_5, sp);

//equation of this selector for phase 1	     
*/
//assign selector_3 = cs_ldm;
//if cs_ldm = 0 then we will take consider to take result but later we will change the concept of choosing selector_3

//m_read_add_2
mux_generic #(16) mux_3(m_result, m_immediate, m_ldm, write_data);
//delete	
//mux_generic_2bit_selector #(16) mux_3(result, immediate, m_data[pop_width-1:pop_width-16],z_value, selector_3, write_data);

endmodule
