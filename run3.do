#project compileall

vsim -gui work.integration_3
########################################
#test

add wave -position 0  sim:/integration_3/decode_stage/array_reg
add wave -position insertpoint  \
sim:/integration_3/pc \
sim:/integration_3/out_port_value \
sim:/integration_3/flag \
sim:/integration_3/alu_flag \
sim:/integration_3/decode_stage/data_width \
sim:/integration_3/decode_stage/address_width \
sim:/integration_3/decode_stage/clk \
sim:/integration_3/decode_stage/reset \
sim:/integration_3/decode_stage/write_enable \
sim:/integration_3/decode_stage/write_data \
sim:/integration_3/decode_stage/write_address \
sim:/integration_3/decode_stage/read_address1 \
sim:/integration_3/decode_stage/read_address2 \
sim:/integration_3/decode_stage/read_data1 \
sim:/integration_3/decode_stage/read_data2 \
sim:/integration_3/decode_stage/array_reg \
sim:/integration_3/decode_stage/i

add wave -position insertpoint  \
sim:/integration_3/LD_sue_case/Previus_inst_load \
sim:/integration_3/LD_sue_case/not_dumy_zeros \
sim:/integration_3/LD_sue_case/Previus_Previus_inst_load \
sim:/integration_3/LD_sue_case/Previus_reg_write \
sim:/integration_3/LD_sue_case/call_or_branch \
sim:/integration_3/LD_sue_case/current_add_1 \
sim:/integration_3/LD_sue_case/current_add_2 \
sim:/integration_3/LD_sue_case/Previus_dst_add \
sim:/integration_3/LD_sue_case/Previus_Previus_dst_add \
sim:/integration_3/LD_sue_case/fetch_nop_LD
#############################################

add wave -position insertpoint  \
sim:/integration_3/Num_of_bits \
sim:/integration_3/Num_of_registers \
sim:/integration_3/pc_width \
sim:/integration_3/sp_width \
sim:/integration_3/op_code_width \
sim:/integration_3/Num_alu \
sim:/integration_3/pop_width \
sim:/integration_3/clk \
sim:/integration_3/reset_pc_poped \
sim:/integration_3/reset_sp \
sim:/integration_3/reset_flag \
sim:/integration_3/reset_data_stack \
sim:/integration_3/reset_decode_regs \
sim:/integration_3/Reset_2Power5 \
sim:/integration_3/stage_buffer_reset \
sim:/integration_3/fetch_buffer_reset \
sim:/integration_3/reset_Last_instr_buffer \
sim:/integration_3/selector_1 \
sim:/integration_3/selector_4 \
sim:/integration_3/sp_jump \
sim:/integration_3/read_add_1 \
sim:/integration_3/read_add_2 \
sim:/integration_3/pc_add1 \
sim:/integration_3/pc_selected \
sim:/integration_3/pc_high \
sim:/integration_3/sp_new \
sim:/integration_3/chosen_sp \
sim:/integration_3/final_sp \
sim:/integration_3/sp \
sim:/integration_3/sp_add1 \
sim:/integration_3/sp_sub1 \
sim:/integration_3/instruction \
sim:/integration_3/read_data1 \
sim:/integration_3/read_data2 \
sim:/integration_3/final_flag \
sim:/integration_3/result \
sim:/integration_3/read_data1_result \
sim:/integration_3/mem_address \
sim:/integration_3/value \
sim:/integration_3/flag_result \
sim:/integration_3/z_value \
sim:/integration_3/write_data \
sim:/integration_3/alu_controls \
sim:/integration_3/chosen_value \
sim:/integration_3/PC_select \
sim:/integration_3/chosen_pc_selector \
sim:/integration_3/chosen_pc_selector_last \
sim:/integration_3/jump_type \
sim:/integration_3/store_load \
sim:/integration_3/cs_ldm \
sim:/integration_3/cs_push \
sim:/integration_3/SP_change \
sim:/integration_3/cs_jmp \
sim:/integration_3/cs_call \
sim:/integration_3/cs_in \
sim:/integration_3/cs_out \
sim:/integration_3/cs_mem_read \
sim:/integration_3/cs_mem_write \
sim:/integration_3/cs_reg_write \
sim:/integration_3/special_int \
sim:/integration_3/cs_reset \
sim:/integration_3/cs_alu_op \
sim:/integration_3/cs_mem_op \
sim:/integration_3/cs_shamt \
sim:/integration_3/reset_pc \
sim:/integration_3/push_flags \
sim:/integration_3/Pc_high_pop \
sim:/integration_3/cs_ret \
sim:/integration_3/fetch_NOP \
sim:/integration_3/decode_NOP \
sim:/integration_3/cs_rti \
sim:/integration_3/write_cs_rti \
sim:/integration_3/cs_pop \
sim:/integration_3/CALL_branch \
sim:/integration_3/previous_rti \
sim:/integration_3/in_port_value \
sim:/integration_3/chosen_data_1 \
sim:/integration_3/mem_finish \
sim:/integration_3/mem_finish_off \
sim:/integration_3/previous_e_SP_change \
sim:/integration_3/jump_result \
sim:/integration_3/instruction_f \
sim:/integration_3/input_port_f \
sim:/integration_3/pc_add1_f \
sim:/integration_3/d_read_add_2 \
sim:/integration_3/d_read_add_1 \
sim:/integration_3/d_read_data1 \
sim:/integration_3/d_read_data2 \
sim:/integration_3/d_in_port_value \
sim:/integration_3/d_shamt \
sim:/integration_3/d_immediate \
sim:/integration_3/d_alu_controls \
sim:/integration_3/d_pc_add1 \
sim:/integration_3/d_cs_reg_write \
sim:/integration_3/d_cs_push \
sim:/integration_3/d_SP_change \
sim:/integration_3/d_store_load \
sim:/integration_3/d_cs_mem_read \
sim:/integration_3/d_cs_mem_write \
sim:/integration_3/d_cs_ldm \
sim:/integration_3/d_special_int \
sim:/integration_3/d_cs_in \
sim:/integration_3/d_reset_pc \
sim:/integration_3/d_push_flags \
sim:/integration_3/d_Pc_high_pop \
sim:/integration_3/d_cs_pop \
sim:/integration_3/d_cs_shamt \
sim:/integration_3/d_chosen_value \
sim:/integration_3/d_jump_type \
sim:/integration_3/d_PC_select \
sim:/integration_3/d_start_count_nop \
sim:/integration_3/d_cs_alu_op \
sim:/integration_3/d_cs_rti \
sim:/integration_3/d_write_cs_rti \
sim:/integration_3/d_cs_out \
sim:/integration_3/e_result \
sim:/integration_3/data \
sim:/integration_3/e_read_add_2 \
sim:/integration_3/e_flag \
sim:/integration_3/e_read_data1 \
sim:/integration_3/e_read_data2 \
sim:/integration_3/e_pc_add1 \
sim:/integration_3/e_cs_reg_write \
sim:/integration_3/e_cs_ldm \
sim:/integration_3/e_cs_in \
sim:/integration_3/e_reset_pc \
sim:/integration_3/e_Pc_high_pop \
sim:/integration_3/ldd \
sim:/integration_3/e_cs_push \
sim:/integration_3/e_SP_change \
sim:/integration_3/e_store_load \
sim:/integration_3/e_cs_mem_read \
sim:/integration_3/e_cs_mem_write \
sim:/integration_3/e_special_int \
sim:/integration_3/e_push_flags \
sim:/integration_3/e_cs_pop \
sim:/integration_3/e_chosen_value \
sim:/integration_3/e_PC_select \
sim:/integration_3/e_start_count_nop \
sim:/integration_3/e_write_cs_rti \
sim:/integration_3/e_cs_out \
sim:/integration_3/e_cs_ldd \
sim:/integration_3/m_data \
sim:/integration_3/m_result \
sim:/integration_3/m_read_data2 \
sim:/integration_3/m_read_add_2 \
sim:/integration_3/m_immediate \
sim:/integration_3/m_pc_add1 \
sim:/integration_3/m_cs_reg_write \
sim:/integration_3/m_cs_ldm \
sim:/integration_3/m_cs_in \
sim:/integration_3/m_reset_pc \
sim:/integration_3/m_Pc_high_pop \
sim:/integration_3/m_ldd \
sim:/integration_3/m_start_count_nop \
sim:/integration_3/m_cs_out \
sim:/integration_3/no_change \
sim:/integration_3/reset_count_nop \
sim:/integration_3/start_count_nop \
sim:/integration_3/fetch_nop_counter \
sim:/integration_3/INT_signal \
sim:/integration_3/int_pc_handle \
sim:/integration_3/chosen_Rdst_32 \
sim:/integration_3/d_puch_pc_h_int \
sim:/integration_3/e_puch_pc_h_int \
sim:/integration_3/Previous_Rdst \
sim:/integration_3/Previous_Rdst_32 \
sim:/integration_3/Previous_pc \
sim:/integration_3/pc_int_result_1 \
sim:/integration_3/chosen_pc \
sim:/integration_3/Previous_branch \
sim:/integration_3/Previous_Call \
sim:/integration_3/d_cs_call \
sim:/integration_3/e_cs_call \
sim:/integration_3/m_cs_call \
sim:/integration_3/INT_counter \
sim:/integration_3/will_jump \
sim:/integration_3/op1 \
sim:/integration_3/op2 \
sim:/integration_3/sel_1 \
sim:/integration_3/sel_2 \
sim:/integration_3/sel_1_final \
sim:/integration_3/sel_2_final \
sim:/integration_3/modified_d_read_data2 \
sim:/integration_3/chosen_Rdst_1 \
sim:/integration_3/decode_read_data_1 \
sim:/integration_3/decode_read_data_2 \
sim:/integration_3/read_data1_final \
sim:/integration_3/read_data2_final \
sim:/integration_3/d_read_add_2_final \
sim:/integration_3/fetch_nop_LD \
sim:/integration_3/cs_ldd \
sim:/integration_3/d_cs_ldd \
sim:/integration_3/chosen_Rdst \
sim:/integration_3/d_fetch_nop_LD \
sim:/integration_3/sel_1_LD_case \
sim:/integration_3/sel_2_LD_case \
sim:/integration_3/d_sel_1_LD_case \
sim:/integration_3/in_port_readed_data \
sim:/integration_3/decode_reset \
sim:/integration_3/execute_reset \
sim:/integration_3/d_cs_jmp \
sim:/integration_3/e_cs_jmp \
sim:/integration_3/m_cs_jmp
force -deposit sim:/integration_3/alu_flag 0 0
force -freeze sim:/integration_3/clk 1 0, 0 {50 ps} -r 100
mem load -i {D:/CUFE24/3rd year/first term/Computer Architecture/Five-stages-Pipeline-Processor/CODE_RAM.mem} /integration_3/inst_mem_stage/mem
force -freeze sim:/integration_3/INT_signal 1 1560 -cancel 1590
#------------  resets  ---------------#
#NOTE: cancel Reset_2Power5 after 400 as the instuction at 32-1 is ready just before 400
force -freeze sim:/integration_3/Reset_2Power5 1 0 -cancel 100
force -freeze sim:/integration_3/reset_data_stack 1 0 -cancel 100
force -freeze sim:/integration_3/stage_buffer_reset 1 0 -cancel 100
force -freeze sim:/integration_3/fetch_buffer_reset 1 0 -cancel 100
force -freeze sim:/integration_3/reset_Last_instr_buffer 1 0 -cancel 100
force -freeze sim:/integration_3/reset_pc_poped 1 0 -cancel 100
force -freeze sim:/integration_3/reset_decode_regs 1 0 -cancel 100
force -freeze sim:/integration_3/reset_sp 1 0 -cancel 100
force -freeze sim:/integration_3/reset_count_nop 1 200 -cancel 100
force -freeze sim:/integration_3/reset_flag 1 0 -cancel 100

#----------  initial values  -------------#
force -deposit sim:/integration_3/m_start_count_nop 0 0 
force -deposit sim:/integration_3/jump_result 0 0

#---------------------  int  -----------------#
#final:force -freeze sim:/integration_3/INT_signal 1 1660 -cancel 1690
force -deposit sim:/integration_3/no_change 00 0 
force -deposit sim:/integration_3/PC_select 00 0
force -deposit sim:/integration_3/sel_1_LD_case 0 0

#0
run 

#---------------------  forcing input port values  --------------------#
#50
force -freeze sim:/integration_3/in_port_value 4'h300 0
run
run


run
run

#250
force -freeze sim:/integration_3/in_port_value 4'h40 0
run
run

#350
force -freeze sim:/integration_3/in_port_value 4'h400 0
run
run

#450
force -freeze sim:/integration_3/in_port_value 4'h100 0 
run
run

#550
force -freeze sim:/integration_3/in_port_value 4'h7ff 0 
run
run

#650
force -freeze sim:/integration_3/in_port_value 4'h700 0 
run
run

#------------------------  normal simulation -------------#
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
