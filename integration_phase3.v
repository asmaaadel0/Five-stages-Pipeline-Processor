
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
 
module POPed_PC (read_data, write_data,clk,reset,write_enable);

	input clk,reset,write_enable;
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
	end

endmodule
  

//assume read at posedge and write at negative edge
module Previous_SP_change_reg (read_data, write_data,clk);//,rst);

input clk;//,rst;
input write_data;
output read_data;
reg reg_internal;

assign read_data = reg_internal;	
always @(negedge clk) begin
		reg_internal = write_data;					
end

endmodule
  
  
  
  
//####################################################################################################################################################################// 
module integration_3 (/*input, output later*/); 
localparam Num_of_bits=16;  //width of instruction assumnig immediate separated from instruction
localparam Num_of_registers=20 ;
localparam pc_width=32;
localparam sp_width=32;
localparam op_code_width=5;
localparam Num_alu=4; //number of alu instructions
localparam pop_width=16; //pop width

//---------------------------------------- reset buffers------------------------------//
wire clk;
wire reset_pc_poped;
wire reset_sp;
wire reset_flag;
wire reset_data_stack,reset_decode_regs;
wire Reset_2Power5;
wire stage_buffer_reset;
wire fetch_buffer_reset;
wire reset_Last_instr_buffer;


//wire selector_2, selector_3, selector_5, selector_6, selector_7;
wire [1:0] selector_1, selector_4;
wire sp_jump=1;
wire [2:0] read_add_1,read_add_2 ;

wire [31:0] pc_add1,pc_selected;
wire [15:0] pc_high;
wire [sp_width-1:0] sp_new,chosen_sp,final_sp,sp;
reg [sp_width-1:0] sp_add1,sp_sub1;
wire [pc_width-1:0] pc;
wire [Num_of_bits-1:0] instruction;//, immediate;	
wire [Num_of_bits-1:0] read_data1,read_data2;
wire [2:0] flag,alu_flag,final_flag;
wire [15:0] result;
wire [sp_width-1:0] read_data1_result, mem_address;
wire [pop_width-1:0] value, flag_result;
wire [pc_width-1:0] z_value=32'bz;

wire [15:0] write_data;

wire [3:0] alu_controls;
wire [1:0] chosen_value, PC_select,chosen_pc_selector,chosen_pc_selector_last, jump_type;//, INT_counter;

wire store_load,cs_ldm,cs_push,SP_change,cs_jmp,cs_call,cs_in,cs_out,
cs_mem_read,cs_mem_write,cs_reg_write,special_int,cs_reset,cs_alu_op,cs_mem_op,
cs_shamt,reset_pc,push_flags,Pc_high_pop,cs_ret,fetch_NOP//,decode_reset,execute_reset
,decode_NOP,cs_rti,write_cs_rti,cs_pop;//,cs_CALL_branch

wire CALL_branch;

wire previous_rti;
wire [15:0] in_port_value;
wire [15:0]chosen_data_1;
wire mem_finish,mem_finish_off,previous_e_SP_change;
wire jump_result;
//----------------------------------   buffers  ----------------------------------///

wire [Num_of_bits-1:0] instruction_f, input_port_f;//, immediate_f
wire [31:0]pc_add1_f;

//decode buffer
wire [2:0] d_read_add_2,d_read_add_1;
wire [15:0] d_read_data1,d_read_data2,d_in_port_value;
wire [3:0] d_shamt;
wire [15:0] d_immediate;
wire [3:0] d_alu_controls;
wire [31:0]d_pc_add1;
wire d_cs_reg_write,d_cs_push,d_SP_change,d_store_load,
	d_cs_mem_read,d_cs_mem_write,d_cs_ldm,d_special_int,d_cs_in,d_reset_pc,d_push_flags,d_Pc_high_pop,d_cs_pop;//,d_CALL_branch
wire[1:0] d_chosen_value,d_jump_type,d_PC_select;								   
wire d_start_count_nop,d_cs_alu_op,d_cs_rti,d_write_cs_rti;
wire d_cs_out;

//excute buffer
wire [15:0] e_result,data;//,e_in_port_value
wire [2:0] e_read_add_2,e_flag;
wire [15:0] e_read_data1,e_read_data2;
// wire [Num_of_bits-1:0] e_immediate;
wire [31:0]e_pc_add1;
wire e_cs_reg_write,e_cs_ldm,e_cs_in,e_reset_pc,e_Pc_high_pop,ldd;//,e_CALL_branch
wire e_cs_push,e_SP_change,e_store_load, e_cs_mem_read,e_cs_mem_write,e_special_int,e_push_flags,e_cs_pop;
wire [1:0]e_chosen_value,e_PC_select;		
wire e_start_count_nop,e_write_cs_rti;
wire e_cs_out,e_cs_ldd;

//memory buffer
wire [15:0] m_data;
wire [15:0] m_result,m_read_data2;//,m_in_port_value
wire [2:0] m_read_add_2;
wire [Num_of_bits-1:0] m_immediate;
wire [31:0]m_pc_add1;
wire m_cs_reg_write,m_cs_ldm,m_cs_in,m_reset_pc,m_Pc_high_pop,m_ldd;//,m_CALL_branch
wire m_start_count_nop;
wire m_cs_out;

wire [1:0]no_change;
wire reset_count_nop,start_count_nop,fetch_nop_counter;

//---------------------------- int --------------------------------//
wire INT_signal,int_pc_handle;
wire [31:0]chosen_Rdst_32;
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
wire [1:0] sel_1,sel_2 , sel_1_final,sel_2_final;
wire [15:0] modified_d_read_data2;
wire [15:0] chosen_Rdst_1;
wire decode_read_data_1,decode_read_data_2;
wire [15:0] read_data1_final,read_data2_final;
//---------------------------- Laod use case --------------------------------//
wire fetch_nop_LD;
wire cs_ldd,d_cs_ldd;
wire [15:0] chosen_Rdst;
// wire not_this_Rdst;
wire d_fetch_nop_LD;
wire sel_1_LD_case,sel_2_LD_case,d_sel_1_LD_case;
//---------------------------- ports --------------------------------//
wire [15:0] out_port_value,in_port_readed_data;

//####################################################################################################################################################################//
//later: change pc_add1 here to the output of the muxes before pc as shoen in the design
assign pc_add1 = pc + 1;
assign start_count_nop =  cs_ret| cs_rti;
count_NOP count_nop_inst(no_change,fetch_nop_counter,clk,reset_count_nop,start_count_nop);
PC pc_reg(pc, pc_selected,clk,d_reset_pc,Reset_2Power5,no_change,fetch_nop_LD);

assign previous_rti = d_cs_rti;
//---------------------//
mux_generic_2bit_selector #(1) jump_result_mux(1'b1 ,alu_flag[0],alu_flag[1],alu_flag[2] , jump_type, jump_result);
assign will_jump = jump_result & cs_jmp ;
mux_generic #(2) jump_or_not(chosen_pc_selector, 2'b10, will_jump , chosen_pc_selector_last);

//NOTE: this instruction will write in a reg , and its Rdst address is == to Rdst that i will call or jump to
assign sel_1_LD_case = (m_cs_reg_write & ( m_read_add_2 == read_add_2) ) ;
assign sel_2_LD_case = sel_1_LD_case | (e_cs_reg_write &  (e_read_add_2==read_add_2) ) ;
mux_generic #(16) mux_Rdst_selector_1(e_result, write_data , sel_1_LD_case , chosen_Rdst_1);

mux_generic #(16) mux_Rdst_selector_2(read_data2,chosen_Rdst_1 ,sel_2_LD_case , chosen_Rdst);
sign_extend pc_Rdst(chosen_Rdst,chosen_Rdst_32);


POPed_PC pop_pc_high
			(.read_data(pc_high),
			.write_data(data),
			.clk(clk),
			.reset(reset_pc_poped),
			.write_enable(e_Pc_high_pop) );
mux_generic #(2) mux_pc_selector(PC_select, e_PC_select, m_start_count_nop, chosen_pc_selector);
mux_generic_2bit_selector #(32) mux_pc(pc_add1 ,{pc_high,data},chosen_Rdst_32,32'b00 , chosen_pc_selector_last, pc_selected);

//------------------------//

instruction_memory #(Num_of_bits,pc_width,Num_of_registers) inst_mem_stage
							( .clk(clk),
							.INT_counter(INT_counter),
							.pc(pc), 
							.instruction(instruction));
//------------------------//
load_use_detection LD_sue_case
				(.Previus_inst_load(cs_ldd | cs_pop ),
				.Previus_Previus_inst_load(d_cs_ldd | d_cs_pop),
				.current_add_1(instruction[Num_of_bits-op_code_width-1:Num_of_bits-op_code_width-3]),
				.current_add_2(instruction [Num_of_bits-op_code_width-4:Num_of_bits-op_code_width-6]),
				.Previus_dst_add(read_add_2) ,
				.Previus_Previus_dst_add(d_read_add_2) ,
				.not_dumy_zeros(instruction[0]),
				.Previus_reg_write(cs_reg_write),
				.call_or_branch(instruction[3] & (!cs_ldm)),
				.fetch_nop_LD(fetch_nop_LD)
				);

IN_Port in (.read_data(in_port_readed_data), .write_data(in_port_value),.clk(clk));

//48+16 of in_port_value
fetch_buffer #(64)buffer_fetch(.read_data({instruction_f,pc_add1_f,input_port_f}),
 .write_data({instruction,pc_add1,in_port_readed_data}),
 .clk(clk),
 .cs_call(cs_call),
 .cs_ret(cs_ret),
 .cs_rti(cs_rti),
  .fetch_NOP(fetch_NOP | fetch_nop_counter | fetch_nop_LD | will_jump &(INT_counter == 3'b000)),
  .previous_rti(previous_rti),
  .cs_ldm(cs_ldm),
  .reset(fetch_buffer_reset));

//-------------------------------- WB at the first half of cycle and Decode (read) at the second half Hazard detection --------------------// 
assign decode_read_data_1 =  (m_cs_reg_write & ( m_read_add_2 == read_add_1) ) ;
assign decode_read_data_2 = sel_1_LD_case ;//as sel_1_LD_case = (m_cs_reg_write & ( m_read_add_2 == read_add_2) ) 
mux_generic #(16) mux_Decode_1(read_data1, write_data, decode_read_data_1, read_data1_final);
mux_generic #(16) mux_Decode_2(read_data2, write_data, decode_read_data_2, read_data2_final);


control_unit #(op_code_width,Num_alu) cont_unit
			((instruction_f[Num_of_bits-1:Num_of_bits-op_code_width])
			,INT_signal
			,clk
			,instruction[2]//=>one_more_fetch  //NOTE: not instruction_f
			,alu_controls,chosen_value,store_load,cs_ldm,cs_push
			,SP_change,PC_select,jump_type,cs_jmp,cs_call,cs_in,cs_out,cs_mem_read,cs_mem_write,cs_reg_write,special_int
			,cs_reset,cs_alu_op,cs_mem_op,cs_shamt,reset_pc,push_flags,Pc_high_pop,cs_ret,fetch_NOP,decode_reset,execute_reset
			,decode_NOP,cs_rti,INT_counter,write_cs_rti/*,cs_CALL_branch*/,cs_pop,cs_ldd);


assign read_add_1 = instruction_f[Num_of_bits-op_code_width-1:Num_of_bits-op_code_width-3];
assign read_add_2 = instruction_f[Num_of_bits-op_code_width-4:Num_of_bits-op_code_width-6];
decode_ciruit #(16,3) decode_stage (.clk(clk),.reset(reset_decode_regs) ,.write_enable(m_cs_reg_write),.write_data(write_data),
                              .write_address(m_read_add_2), //7:5
							  .read_address1(read_add_1), //10:8
                              .read_address2(read_add_2), //7:5
							  .read_data1(read_data1), .read_data2(read_data2));

//103 +21+cs_pop+d_puch_pc_h_int+2 :of d_PC_select+d_start_count_nop+cs_alu_op+cs_rti+d_write_cs_rti+3 of d_read_add_1 +cs_out +d_cs_call + d_cs_ldd +fetch_nop_LD+sel_1_LD_case -sel_1_LD_case -d_fetch_nop_LD
buffer #(139)buffer_decode(.read_data({d_immediate,d_pc_add1,d_shamt,d_read_add_2,d_read_add_1,d_read_data2,d_read_data1,d_in_port_value,
									d_cs_reg_write,d_alu_controls,d_cs_push,d_SP_change,d_chosen_value,d_store_load,
								   d_cs_mem_read,d_cs_mem_write,d_cs_ldm,d_jump_type,d_special_int,d_cs_jmp,//d_CALL_branch,
								   d_cs_in,d_reset_pc,d_push_flags,d_Pc_high_pop,d_cs_pop,d_puch_pc_h_int,d_PC_select,d_start_count_nop,d_cs_alu_op,d_cs_rti,d_write_cs_rti,d_cs_out,d_cs_call,d_cs_ldd//,d_fetch_nop_LD//,d_sel_1_LD_case
								   }), 
                                   .write_data({instruction,pc_add1_f,instruction_f[4:1],read_add_2,read_add_1,read_data2_final,read_data1_final,input_port_f,//in_port_value,
                                   cs_reg_write,alu_controls,cs_push,SP_change,chosen_value,store_load,
								   cs_mem_read,cs_mem_write,cs_ldm,jump_type,special_int,cs_jmp,//CALL_branch
								   cs_in,reset_pc,push_flags,Pc_high_pop,cs_pop,instruction_f[1],PC_select,start_count_nop,cs_alu_op,cs_rti,write_cs_rti,cs_out,cs_call,cs_ldd//,fetch_nop_LD//,sel_1_LD_case
								   }),.clk(clk),.reset(stage_buffer_reset));

//-----------------------------------------   Data Hazards  -------------------------------------//
forwarding_unit FU
		(.current_cs_cin(d_cs_in),.current_cs_ldm(d_cs_ldm),
		.current_add_1(d_read_add_1) ,.current_add_2 (d_read_add_2),
		.E_dst_add(e_read_add_2),.M_dst_add(m_read_add_2),
		.E_WB(e_cs_reg_write),.M_WB(m_cs_reg_write),
		.sel_1(sel_1),.sel_2(sel_2) );

mux_generic_2bit_selector #(16) op1_mux(d_read_data1,e_result, write_data,d_in_port_value ,sel_1, op1);
mux_generic_2bit_selector #(16) op2_mux(d_read_data2,e_result, write_data,d_immediate, sel_2, op2);

alu alu_stage(.op1(op1),.op2(op2),.shamt(d_shamt),.alu_operation(d_alu_controls),.clk(clk),.flag(alu_flag),.result(result));

flag_reg flag_reg_inst(.read_data(flag),
		.write_data(final_flag),
		.clk(clk),
		.write_enable(d_cs_alu_op),
		.reset(reset_flag));
assign final_flag = (e_write_cs_rti)? data[2:0] : alu_flag;
assign modified_d_read_data2 = op2 ;

//16 for instruction, 16 for immediate 
//118+15+cs_pop+puch_pc_h_int +2 of d_PC_select+e_start_count_nop + d_write_cs_rti + d_cs_out +d_cs_call -16 of e_in_port_value +e_cs_ldd-16 of e_read_data1 -16 of e_immediate
buffer #(94)buffer_alu(.read_data({e_read_add_2,e_pc_add1,e_read_data2,e_flag,e_result,//e_in_port_value, 
                                   e_cs_reg_write,e_cs_push,e_SP_change,e_chosen_value,e_store_load,
								   e_cs_mem_read,e_cs_mem_write,e_cs_ldm,e_special_int,e_cs_jmp,//e_CALL_branch,
								   e_cs_in,e_reset_pc,e_push_flags,
								   e_Pc_high_pop,e_cs_pop,e_puch_pc_h_int ,e_PC_select,e_start_count_nop,e_write_cs_rti,e_cs_out,e_cs_call,e_cs_ldd//e_cs_rti//e_cs_alu_op
								   }), 
								    .write_data({d_read_add_2,d_pc_add1,modified_d_read_data2,alu_flag,result,//d_in_port_value ,
                                   d_cs_reg_write,d_cs_push,d_SP_change,d_chosen_value,d_store_load,
								   d_cs_mem_read,d_cs_mem_write,d_cs_ldm,d_special_int,d_cs_jmp,//d_CALL_branch,
								   d_cs_in,d_reset_pc,d_push_flags,
								   d_Pc_high_pop,d_cs_pop,d_puch_pc_h_int ,d_PC_select,d_start_count_nop,d_write_cs_rti,d_cs_out,d_cs_call,d_cs_ldd//d_cs_rti//d_cs_alu_op
								   }),.clk(clk),.reset(stage_buffer_reset));

sign_extend extend_1(e_result,read_data1_result);
sign_extend_16 extend_2(e_flag,flag_result);
//---------------------------//
Last_instr last_instr_jump
			(.read_data({Previous_Rdst,Previous_pc,Previous_branch}),
			.write_data({m_read_data2,m_pc_add1,m_cs_jmp}),
			.clk(clk),
			.write_enable(e_push_flags),
			.reset(reset_Last_instr_buffer));
			
Last_instr  #(1)last_instr_call
			(.read_data({Previous_Call}),
			.write_data({m_cs_call}),
			.clk(clk),
			.write_enable(d_push_flags),
			.reset(reset_Last_instr_buffer));
			
sign_extend extend_previous_Rdst(Previous_Rdst,Previous_Rdst_32);			
mux_generic #(32) mux_pc_int_1(e_pc_add1, Previous_pc, e_puch_pc_h_int, pc_int_result_1);
assign int_pc_handle = (Previous_branch | Previous_Call ) & e_puch_pc_h_int;
mux_generic #(32) mux_pc_int_2(pc_int_result_1, Previous_Rdst_32, int_pc_handle, chosen_pc);
//---------------------------//
mux_generic_2bit_selector #(16) mux_4(e_read_data2,flag_result, chosen_pc[31:16],chosen_pc[15:0],e_chosen_value, value);
Previous_SP_change_reg sp_change_reg(.read_data(previous_e_SP_change), .write_data(e_SP_change),.clk(clk));
SP sp_reg(sp, sp_new,clk,reset_sp,previous_e_SP_change );//, mem_finish , mem_finish_off);
assign sp_add1= sp+1; 
assign sp_sub1= sp-1;
mux_generic #(32) mux_m3(sp_add1,sp_sub1 ,e_cs_push ,sp_new );
mux_generic #(32) mux_m5(sp_add1,sp, e_cs_push,final_sp );
mux_generic #(32) mux_m6(final_sp, read_data1_result,e_store_load ,mem_address );

data_stack_memory #(16,sp_width,11) memory_stage (.clk(clk),.reset(reset_data_stack) ,.write_enable(e_cs_mem_write),.read_enable(e_cs_mem_read),
													//.mem_finish_off(mem_finish_off),
                                            .write_data(value) ,.address(mem_address),.read_data(data));//,.mem_finish(mem_finish));



////////////////////////push and pop any register will be written in first address//////////////////////////////
assign ldd = (e_cs_pop | e_cs_ldd ) ;
//115+7+m_start_count_nop+ e_cs_out +e_cs_call -16 of m_in_port_value -16 of m_immediate
buffer #(93)buffer_mem(.read_data({m_read_add_2,m_pc_add1,m_read_data2,m_result,m_data,//m_in_port_value,             
                                   m_cs_reg_write,m_cs_ldm,m_cs_jmp,//m_CALL_branch,
								   m_cs_in,m_reset_pc,m_Pc_high_pop,m_ldd,m_start_count_nop,m_cs_out,m_cs_call//,previous_e_SP_change
								   }),
                                    .write_data({e_read_add_2,e_pc_add1,e_read_data2,e_result,data,//e_in_port_value,             
                                   e_cs_reg_write,e_cs_ldm,e_cs_jmp,//e_CALL_branch,
								   e_cs_in,e_reset_pc,e_Pc_high_pop,ldd,e_start_count_nop,e_cs_out,e_cs_call//,e_SP_change
								   }),.clk(clk),.reset(stage_buffer_reset));
mux_generic #(16) mux_WB_2(m_result, m_data, m_ldd, write_data);	
OUT_Port out 
			(.read_data(out_port_value), .write_data(write_data),
			.clk(clk),.write_enable( m_cs_out));
endmodule