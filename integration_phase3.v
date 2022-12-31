
module sign_extend(a, result);

input [15:0] a; // 16-bit input
output [31:0] result; // 32-bit output

assign result = { {16{a[15]}}, a };

endmodule 
 
 
module sign_extend_16(a, result);

input [2:0] a; // 3-bit input
output [15:0] result; // 16-bit output

assign result = { {13{a[2]}}, a }; //(13+3 =16)

endmodule
 
module POPed_PC (read_data, write_data,clk,reset,write_enable);//,rst);

	input clk,reset,write_enable;//,rst;
	input [15:0] write_data;//as each reg is 16 bits 
	output reg [15:0]read_data;//as each reg is 16 bits

	reg [15:0]reg_internal;
	always @(posedge clk) begin
				read_data = reg_internal;	
	end

	always @(negedge clk) begin
		if(reset)
		begin
			reg_internal= 16'b0;
		end
		else if(write_enable)
		begin
			reg_internal = write_data;	
		end
		// else
		// begin
		// end
	end

endmodule
  

//assume read at posedge and write at negative edge
module Previous_SP_change_reg (read_data, write_data,clk);//,rst);

input clk;//,rst;
input write_data;
// output reg read_data;
output read_data;


reg reg_internal;

// always @(posedge rst) begin
// 	//reg_internal <= 16'b0;
// 	reg_internal = 0;
// end 


// always @(posedge clk) begin
			// read_data=reg_internal;	
// end

assign read_data = reg_internal;	
always @(negedge clk) begin
		reg_internal = write_data;					
end

endmodule
  
  
  
  
//####################################################################################################################################################################// 
module integration_3 (/*input, output later*/); 
localparam Num_of_bits=16;  //width of instruction assumnig immediate separated from instruction
localparam Num_of_registers=20 ; //6; //////////must be 20
localparam pc_width=32;
localparam sp_width=32;
localparam op_code_width=5;
localparam Num_alu=4; //number of alu instructions

localparam CS_NUM=25; //number of signals with alu instruction
localparam pop_width=16; //pop width
//wire pc=2**5; //how to fill instraction from 0 to 2**5 to start from 2**5
//reg pc=2**5;
//reg [pc_width-1:0] pc=0;
// wire [pc_width-1:0] pc;
//wire [pc_width-1:0] pc_modified;
//wire [sp_width-1:0] sp=2**11 -1;

wire selector_2, selector_3, selector_5, selector_6, selector_7;
wire [1:0] selector_1, selector_4;
wire sp_jump=1;
wire [2:0] read_add_1,read_add_2 ;
//---------------------------------------- new 12_10 ------------------------------//
wire clk;
//wire reset_pc;
wire reset_pc_poped;
wire reset_sp;
wire reset_flag;
wire reset_data_stack,reset_decode_regs;
wire Reset_2Power5;
wire [31:0] pc_add1,pc_selected;
wire [15:0] pc_high;
wire [sp_width-1:0] sp_new,chosen_sp,final_sp,sp;//,sp_add1,sp_sub1;
reg [sp_width-1:0] sp_add1,sp_sub1;
wire [pc_width-1:0] pc;
wire [Num_of_bits-1:0] instruction, immediate;	
//wire [pop_width-1:0] data;
wire [Num_of_bits-1:0] read_data1,read_data2;
wire [2:0] flag,alu_flag,final_flag;//=0;
wire [15:0] result;
wire [sp_width-1:0] read_data1_result, mem_address;
wire [pop_width-1:0] value, flag_result;
// wire [pop_width-1:0] read_data1_result; //if pop width = 16 we will not make sign extend
wire [pc_width-1:0] z_value=32'bz;

wire [15:0] write_data;//, op2;

wire [3:0] alu_controls;
wire [1:0] chosen_value, PC_select,chosen_pc_selector,chosen_pc_selector_last, jump_type;//, INT_counter;

wire store_load,cs_ldm,cs_push,SP_change,cs_jmp,cs_call,cs_in,cs_out,
cs_mem_read,cs_mem_write,cs_reg_write,special_int,cs_reset,cs_alu_op,cs_mem_op,
cs_shamt,reset_pc,push_flags,Pc_high_pop,cs_ret,fetch_NOP,decode_reset,execute_reset
,decode_NOP,cs_rti,write_cs_rti,cs_CALL_branch,cs_pop;

wire CALL_branch;

wire previous_rti;
wire [15:0] in_port_value;
wire [15:0]chosen_data_1;
wire mem_finish,mem_finish_off,previous_e_SP_change;
wire jump_result;
///////buffers//////

wire [Num_of_bits-1:0] instruction_f, immediate_f, input_port_f;
wire [31:0]pc_add1_f;

//decode buffer
wire [2:0] d_read_add_2,d_read_add_1;
wire [15:0] d_read_data1,d_read_data2,d_in_port_value;
wire [3:0] d_shamt;
wire [15:0] d_immediate;
wire [3:0] d_alu_controls;
wire [31:0]d_pc_add1;
wire d_cs_reg_write,d_cs_push,d_SP_change,d_store_load,
	d_cs_mem_read,d_cs_mem_write,d_cs_ldm,d_special_int,d_CALL_branch,d_cs_in,d_reset_pc,d_push_flags,d_Pc_high_pop,d_cs_pop;
wire[1:0] d_chosen_value,d_jump_type,d_PC_select;								   
wire d_start_count_nop,d_cs_alu_op,d_cs_rti,d_write_cs_rti;
wire d_cs_out;

//excute buffer
wire [15:0] e_result,e_in_port_value,data;
wire [2:0] e_read_add_2,e_flag;
wire [15:0] e_read_data1,e_read_data2;
wire [Num_of_bits-1:0] e_immediate;
wire [31:0]e_pc_add1;
wire e_cs_reg_write,e_cs_ldm,e_CALL_branch,e_cs_in,e_reset_pc,e_Pc_high_pop,ldd;
wire e_cs_push,e_SP_change,e_store_load, e_cs_mem_read,e_cs_mem_write,e_special_int,e_push_flags,e_cs_pop;
wire [1:0]e_chosen_value,e_PC_select;		
wire e_start_count_nop,e_write_cs_rti;
wire e_cs_out;

//memory buffer
wire [15:0] m_data;
wire [15:0] m_result,m_in_port_value,m_read_data2;
wire [2:0] m_read_add_2;
wire [Num_of_bits-1:0] m_immediate;
wire [31:0]m_pc_add1;
wire m_cs_reg_write,m_cs_ldm,m_CALL_branch,m_cs_in,m_reset_pc,m_Pc_high_pop,m_ldd;
wire m_start_count_nop;
wire m_cs_out;

wire [1:0]no_change;
wire reset_count_nop,start_count_nop,fetch_nop_counter;

//---------------------------- int --------------------------------//
wire INT_signal,int_pc_handle;
wire [31:0]read_data2_32;
wire d_puch_pc_h_int,e_puch_pc_h_int;

wire [15:0] Previous_Rdst;
wire [31:0] Previous_Rdst_32;
wire [31:0] Previous_pc,pc_int_result_1,chosen_pc;
//wire Previous_CALL_branch;
wire Previous_branch,Previous_Call;
wire d_cs_call,e_cs_call , m_cs_call;
wire [2:0] INT_counter;
wire will_jump;
//---------------------------- Data Hazards --------------------------------//
wire [15:0] op1,op2;
wire [1:0] sel_1,sel_2 , sel_1_final;
//---------------------------- Laod use case --------------------------------//
wire fetch_nop_LD;
wire cs_ldd;
//---------------------------- ports --------------------------------//
wire [15:0] out_port_value,in_port_readed_data;

//####################################################################################################################################################################//
//later: change pc_add1 here to the output of the muxes before pc as shoen in the design
//PC pc_reg(pc, pc_add1,clk,reset_pc,Reset_2Power5);
assign start_count_nop =  cs_ret| cs_rti;
count_NOP count_nop_inst(no_change,fetch_nop_counter,clk,reset_count_nop,start_count_nop);
// PC pc_reg(pc, pc_selected,clk,reset_pc,Reset_2Power5,no_change);
PC pc_reg(pc, pc_selected,clk,d_reset_pc,Reset_2Power5,no_change,fetch_nop_LD);

//previous_cs_rti rti_buffer(previous_rti, cs_rti,clk,write_cs_rti);
assign previous_rti = d_cs_rti;
//---------------------//
mux_generic_2bit_selector #(1) jump_result_mux(1'b1 ,alu_flag[0],alu_flag[1],alu_flag[2] , jump_type, jump_result);
assign will_jump = jump_result & cs_jmp ;
mux_generic #(2) jump_or_not(chosen_pc_selector, 2'b10, will_jump , chosen_pc_selector_last);

sign_extend pc_Rdst(read_data2,read_data2_32);
POPed_PC pop_pc_high
			(.read_data(pc_high),
			.write_data(data),
			.clk(clk),
			.reset(reset_pc_poped),
			.write_enable(e_Pc_high_pop) );
// mux_generic_2bit_selector #(32) mux_pc({data,pc_high},pc_add1 ,read_data2_32,32'b00 , PC_select, pc_selected);
// mux_generic #(16) mux_pc_selector(PC_select, e_PC_select, fetch_nop_counter, chosen_pc_selector);
mux_generic #(16) mux_pc_selector(PC_select, e_PC_select, m_start_count_nop, chosen_pc_selector);

// mux_generic_2bit_selector #(32) mux_pc(pc_add1 ,{pc_high,data},read_data2_32,32'b00 , chosen_pc_selector, pc_selected);
mux_generic_2bit_selector #(32) mux_pc(pc_add1 ,{pc_high,data},read_data2_32,32'b00 , chosen_pc_selector_last, pc_selected);

//------------------------//

instruction_memory #(Num_of_bits,pc_width,Num_of_registers) inst_mem_stage
							( .clk(clk),
							.INT_counter(INT_counter),
							//.previous_cs_rti(previous_rti),
							.pc(pc), 
							.instruction(instruction));//.immediate(immediate)
//------------------------//
load_use_detection LD_sue_case
				(.Previus_inst_load(cs_ldd | cs_pop )
				,.current_add_1(instruction[Num_of_bits-op_code_width-1:Num_of_bits-op_code_width-3]),
				.current_add_2(instruction [Num_of_bits-op_code_width-4:Num_of_bits-op_code_width-6]),
				.Previus_dst_add(read_add_2) ,
				.fetch_nop_LD(fetch_nop_LD),
				.not_dumy_zeros(instruction[0]));

//16 for instruction, 16 for immediate
// buffer #(32)buffer_fetch(.read_data({instruction_f,immediate_f}), .write_data({instruction,immediate}),.clk(clk));
//48+16 of in_port_value
IN_Port in (.read_data(in_port_readed_data), .write_data(in_port_value),.clk(clk));//, write_enable );//,rst);

fetch_buffer #(64)buffer_fetch(.read_data({instruction_f,pc_add1_f,input_port_f}),
 .write_data({instruction,pc_add1,in_port_readed_data}),
 // .write_data({instruction,pc_add1,in_port_value}),
 .clk(clk),
 .cs_call(cs_call),
 .cs_ret(cs_ret),
 .cs_rti(cs_rti),
  .fetch_NOP(fetch_NOP | fetch_nop_counter | fetch_nop_LD | will_jump &(INT_counter == 3'b000)),
  .previous_rti(previous_rti),
  .cs_ldm(cs_ldm));

 // .fetch_NOP(fetch_NOP | (fetch_nop_counter & (!previous_rti) ));

///always@(negedge clk)
///begin 
// pc <= pc_modified;
assign pc_add1 = pc + 1;
///end
//delete
//if we change pop width to be 16bit we have to change input 'data' this in mux
//mux_generic_2bit_selector #(32) mux_1(0, 2**5, data, pc+1, selector_1, pc);

//equation of this selector for phase 1	
// assign selector_1 = ~cs_ldm;
// mux_generic #(32) mux_1(pc+1, pc+2, 1, pc_modified);



control_unit #(op_code_width,Num_alu,CS_NUM) cont_unit
			((instruction_f[Num_of_bits-1:Num_of_bits-op_code_width])
			,INT_signal
			,clk
			,instruction[2]//=>one_more_fetch  //NOTE: not instruction_f
			,alu_controls,chosen_value,store_load,cs_ldm,cs_push
			,SP_change,PC_select,jump_type,cs_jmp,cs_call,cs_in,cs_out,cs_mem_read,cs_mem_write,cs_reg_write,special_int
			,cs_reset,cs_alu_op,cs_mem_op,cs_shamt,reset_pc,push_flags,Pc_high_pop,cs_ret,fetch_NOP,decode_reset,execute_reset
			,decode_NOP,cs_rti,INT_counter,write_cs_rti,cs_CALL_branch,cs_pop,cs_ldd);


assign read_add_1 = instruction_f[Num_of_bits-op_code_width-1:Num_of_bits-op_code_width-3];
assign read_add_2 = instruction_f[Num_of_bits-op_code_width-4:Num_of_bits-op_code_width-6];
decode_ciruit #(16,3) decode_stage (.clk(clk),.reset(reset_decode_regs) ,.write_enable(m_cs_reg_write),.write_data(write_data),
                              .write_address(m_read_add_2), //7:5
							  .read_address1(read_add_1), //10:8
                              .read_address2(read_add_2), //7:5
							  .read_data1(read_data1), .read_data2(read_data2));

//assign CALL_branch = cs_call | cs_jmp |cs_rti |cs_ret ;
//103 +21+cs_pop+d_puch_pc_h_int+2 :of d_PC_select+d_start_count_nop+cs_alu_op+cs_rti+d_write_cs_rti+3 of d_read_add_1 +cs_out +d_cs_call
buffer #(137)buffer_decode(.read_data({d_immediate,d_pc_add1,d_shamt,d_read_add_2,d_read_add_1,d_read_data2,d_read_data1,d_in_port_value,
									d_cs_reg_write,d_alu_controls,d_cs_push,d_SP_change,d_chosen_value,d_store_load,
								   d_cs_mem_read,d_cs_mem_write,d_cs_ldm,d_jump_type,d_special_int,d_cs_jmp,//d_CALL_branch,
								   d_cs_in,d_reset_pc,d_push_flags,d_Pc_high_pop,d_cs_pop,d_puch_pc_h_int,d_PC_select,d_start_count_nop,d_cs_alu_op,d_cs_rti,d_write_cs_rti,d_cs_out,d_cs_call
								   }), 
                                   .write_data({instruction,pc_add1_f,instruction_f[4:1],read_add_2,read_add_1,read_data2,read_data1,input_port_f,//in_port_value,
                                   cs_reg_write,alu_controls,cs_push,SP_change,chosen_value,store_load,
								   cs_mem_read,cs_mem_write,cs_ldm,jump_type,special_int,cs_jmp,//CALL_branch
								   cs_in,reset_pc,push_flags,Pc_high_pop,cs_pop,instruction_f[1],PC_select,start_count_nop,cs_alu_op,cs_rti,write_cs_rti,cs_out,cs_call
								   }),.clk(clk));

//delete
//mux_generic #(3) mux_7(flag, data[pop_width-14:pop_width-16], selector_7, flag); //14 => -16+2

//deleted for all phases
//mux_generic #(16) mux_6(read_data2, immediate, selector_6, op2);immedia
//-----------------------------------------   Data Hazards  -------------------------------------//
forwarding_unit FU
		(.current_cs_cin(d_cs_in),
		.current_add_1(d_read_add_1) ,.current_add_2 (d_read_add_2),
		.E_dst_add(e_read_add_2),.M_dst_add(m_read_add_2),
		.E_WB(e_cs_reg_write),.M_WB(m_cs_reg_write),
		.sel_1(sel_1),.sel_2(sel_2) );

// mux_generic_2bit_selector #(16) op1_mux(d_read_data1,e_result, m_result,16'bz ,sel_1, op1);
// mux_generic_2bit_selector #(16) op2_mux(d_read_data2,e_result, m_result,16'bz,sel_2, op2);
//assign sel_1_final = (d_cs_in)?2'b11:sel_1;
// mux_generic_2bit_selector #(16) op1_mux(d_read_data1,e_result, write_data,d_in_port_value ,sel_1_final, op1);
mux_generic_2bit_selector #(16) op1_mux(d_read_data1,e_result, write_data,d_in_port_value ,sel_1, op1);
mux_generic_2bit_selector #(16) op2_mux(d_read_data2,e_result, write_data,16'bz, sel_2, op2);

// assign op2 = read_data2;

// alu alu_stage(.op1(d_read_data1),.op2(d_read_data2),.shamt(d_shamt),.alu_operation(d_alu_controls),.clk(clk),.flag(flag),.result(result));
// alu alu_stage(.op1(d_read_data1),.op2(d_read_data2),.shamt(d_shamt),.alu_operation(d_alu_controls),.clk(clk),.flag(alu_flag),.result(result));
alu alu_stage(.op1(op1),.op2(op2),.shamt(d_shamt),.alu_operation(d_alu_controls),.clk(clk),.flag(alu_flag),.result(result));

flag_reg flag_reg_inst(.read_data(flag),
		.write_data(final_flag),
		.clk(clk),
		.write_enable(d_cs_alu_op),
		.reset(reset_flag));
// assign final_flag = (e_cs_rti)? data[2:0] : alu_flag;
assign final_flag = (e_write_cs_rti)? data[2:0] : alu_flag;

//16 for instruction, 16 for immediate 
//////////flag later
//118+15+cs_pop+puch_pc_h_int +2 of d_PC_select+e_start_count_nop + d_write_cs_rti + d_cs_out +d_cs_call
buffer #(141)buffer_alu(.read_data({e_read_add_2,e_immediate,e_pc_add1,e_read_data2,e_read_data1,e_flag,e_result,e_in_port_value, 
                                   e_cs_reg_write,e_cs_push,e_SP_change,e_chosen_value,e_store_load,
								   e_cs_mem_read,e_cs_mem_write,e_cs_ldm,e_special_int,e_cs_jmp,//e_CALL_branch,
								   e_cs_in,e_reset_pc,e_push_flags,
								   e_Pc_high_pop,e_cs_pop,e_puch_pc_h_int ,e_PC_select,e_start_count_nop,e_write_cs_rti,e_cs_out,e_cs_call//e_cs_rti//e_cs_alu_op
								   }), 
                                   // .write_data({d_read_add_2,d_immediate,d_pc_add1,d_read_data2,d_read_data1,flag,result,d_in_port_value ,
								    .write_data({d_read_add_2,d_immediate,d_pc_add1,d_read_data2,d_read_data1,alu_flag,result,d_in_port_value ,
                                   d_cs_reg_write,d_cs_push,d_SP_change,d_chosen_value,d_store_load,
								   d_cs_mem_read,d_cs_mem_write,d_cs_ldm,d_special_int,d_cs_jmp,//d_CALL_branch,
								   d_cs_in,d_reset_pc,d_push_flags,
								   d_Pc_high_pop,d_cs_pop,d_puch_pc_h_int ,d_PC_select,d_start_count_nop,d_write_cs_rti,d_cs_out,d_cs_call//d_cs_rti//d_cs_alu_op
								   }),.clk(clk));

//delete
sign_extend extend_1(e_read_data1,read_data1_result);

//assign mem_address = read_data1_result;


sign_extend_16 extend_2(e_flag,flag_result);

//delete
// sign_extend extend_3(e_read_data1,read_data1_result);

// assign value = read_data1_result;
//assign value = e_read_data2;
//delete
//mux_generic_2bit_selector #(16) mux_4(flag_result, e_pc_add1, read_data1_result, z_value, selector_4, value);

//---------------------------//
// Last_instr last_instr_inst
			// (.read_data({Previous_Rdst,Previous_pc,Previous_CALL_branch}),
			// .write_data({m_read_data2,m_pc_add1,m_CALL_branch}),
			// .clk(clk),
			// .write_enable(e_push_flags) );//,rst);
			
Last_instr last_instr_jump
			(.read_data({Previous_Rdst,Previous_pc,Previous_branch}),
			.write_data({m_read_data2,m_pc_add1,m_cs_jmp}),
			.clk(clk),
			.write_enable(e_push_flags) );//,rst);
			
Last_instr  #(1)last_instr_call
			(.read_data({Previous_Call}),
			.write_data({m_cs_call}),
			.clk(clk),
			.write_enable(d_push_flags) );
			
sign_extend extend_previous_Rdst(Previous_Rdst,Previous_Rdst_32);			
mux_generic #(32) mux_pc_int_1(e_pc_add1, Previous_pc, e_puch_pc_h_int, pc_int_result_1);
assign int_pc_handle = (Previous_branch | Previous_Call ) & e_puch_pc_h_int;
mux_generic #(32) mux_pc_int_2(pc_int_result_1, Previous_Rdst_32, int_pc_handle, chosen_pc);
//---------------------------//
mux_generic_2bit_selector #(16) mux_4(e_read_data2,flag_result, chosen_pc[31:16],chosen_pc[15:0],e_chosen_value, value);

//mux_generic_2bit_selector #(16) mux_4(e_read_data2,flag_result, e_pc_add1[31:16],e_pc_add1[15:0],e_chosen_value, value);


//mux_generic #(32) mux_2(read_data2_result, sp, selector_2, mem_address);

// SP sp_reg(sp, chosen_sp,clk,reset_sp,e_SP_change);
// SP sp_reg(sp, sp_new,clk,reset_sp,e_SP_change);
// SP sp_reg(sp, sp_new,clk,reset_sp,e_SP_change & mem_finish , mem_finish_off);
//SP sp_reg(sp, sp_new,clk,reset_sp,e_SP_change );//, mem_finish , mem_finish_off);
Previous_SP_change_reg sp_change_reg(.read_data(previous_e_SP_change), .write_data(e_SP_change),.clk(clk));
SP sp_reg(sp, sp_new,clk,reset_sp,previous_e_SP_change );//, mem_finish , mem_finish_off);
// always @(posedge mem_finish_off)
// begin
 // mem_finish = 1'b0 ; 
 // mem_finish_off = 1'b0 ; 
// end
assign sp_add1= sp+1; 
assign sp_sub1= sp-1;
// // always @(negedge clk)
// // begin
 // // sp_add1= sp+1; 
 // // sp_sub1= sp-1;
// // end
// always @(sp)
// always @(clk)
// begin
 // sp_add1= sp+1; 
 // sp_sub1= sp-1;
// end
// always @(data)
// begin
 // sp_add1= sp+1; 
 // sp_sub1= sp-1;
// end
mux_generic #(32) mux_m3(sp_add1,sp_sub1 ,e_cs_push ,sp_new );
// // mux_generic #(32) mux_m4(sp,sp_new ,e_SP_change , chosen_sp);
 mux_generic #(32) mux_m5(sp_add1,sp, e_cs_push,final_sp );
//mux_generic #(32) mux_m5(sp_sub1,sp_add1, e_cs_push,final_sp );
// mux_generic #(32) mux_m5(sp,sp_sub1, e_cs_push,final_sp );
mux_generic #(32) mux_m6(final_sp, read_data1_result,e_store_load ,mem_address );

data_stack_memory #(16,sp_width,11) memory_stage (.clk(clk),.reset(reset_data_stack) ,.write_enable(e_cs_mem_write),.read_enable(e_cs_mem_read),
													//.mem_finish_off(mem_finish_off),
                                            .write_data(value) ,.address(mem_address),.read_data(data));//,.mem_finish(mem_finish));



////////////////////////push and pop any register will be written in first address//////////////////////////////

assign ldd= (e_cs_pop | e_store_load ) & e_cs_mem_read;
//115+7+m_start_count_nop+ e_cs_out +e_cs_call
buffer #(125)buffer_mem(.read_data({m_read_add_2,m_immediate,m_pc_add1,m_read_data2,m_result,m_data,m_in_port_value,             
                                   m_cs_reg_write,m_cs_ldm,m_cs_jmp,//m_CALL_branch,
								   m_cs_in,m_reset_pc,m_Pc_high_pop,m_ldd,m_start_count_nop,m_cs_out,m_cs_call//,previous_e_SP_change
								   }),
                                    .write_data({e_read_add_2,e_immediate,e_pc_add1,e_read_data2,e_result,data,e_in_port_value,             
                                   e_cs_reg_write,e_cs_ldm,e_cs_jmp,//e_CALL_branch,
								   e_cs_in,e_reset_pc,e_Pc_high_pop,ldd,e_start_count_nop,e_cs_out,e_cs_call//,e_SP_change
								   }),.clk(clk));
/*
//delete	
//mux_generic #(16) mux_5(sp+sp_jump, sp-sp_jump, selector_5, sp);
//equation of this selector for phase 1	     
*/
//assign selector_3 = cs_ldm;
//if cs_ldm = 0 then we will take consider to take result but later we will change the concept of choosing selector_3

//m_read_add_2
mux_generic #(16) mux_WB_1(m_result, m_immediate, m_cs_ldm, chosen_data_1);
mux_generic #(16) mux_WB_2(chosen_data_1, m_data, m_ldd, write_data);
//delete	
//mux_generic_2bit_selector #(16) mux_3(result, immediate, m_data[pop_width-1:pop_width-16],z_value, selector_3, write_data);
OUT_Port out 
			(.read_data(out_port_value), .write_data(write_data),
			.clk(clk),.write_enable( m_cs_out));
endmodule