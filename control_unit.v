module control_unit #(parameter N=5, Num_alu=4)(
 op_code
 ,INT_signal
 ,clk
 ,one_more_fetch
 //------------ outputs --------------//
 ,alu_controls
 ,chosen_value
 ,store_load
 ,cs_ldm
 ,cs_push
,SP_change
,PC_select
,jump_type
,cs_jmp
,cs_call
,cs_in
,cs_out
,cs_mem_read
,cs_mem_write
,cs_reg_write
,special_int
,cs_reset
,cs_alu_op
,cs_mem_op
,shamt
,reset_pc
,push_flags
,Pc_high_pop
,cs_ret
,fetch_NOP
,decode_reset
,execute_reset
,decode_NOP
,cs_rti
,INT_counter
,write_cs_rti
//,CALL_branch
,cs_pop
,cs_ldd);

input [N-1:0] op_code;
input INT_signal,clk,one_more_fetch;
output reg[Num_alu-1:0] alu_controls;
output reg[1:0] chosen_value, PC_select, jump_type;//, INT_counter;
output reg[2:0] INT_counter;

output reg store_load,cs_ldm,cs_push,SP_change,cs_jmp,cs_call,cs_in,cs_out,
cs_mem_read,cs_mem_write,cs_reg_write,special_int,cs_reset,cs_alu_op,cs_mem_op,
shamt,reset_pc,push_flags,Pc_high_pop,cs_ret,fetch_NOP,decode_reset,execute_reset
,decode_NOP,cs_rti,write_cs_rti,cs_pop,cs_ldd;//,CALL_branch
	   
//if op_code = zeros (buffer after fetch has been reset) then all controls = zero
//out in nop not inc dec mov add sub and or shl shr
always @(*)
begin
	alu_controls = 0;
	  chosen_value= 0;
	  store_load= 0;
	  cs_ldm = 0;
	  cs_push  = 0;
	 SP_change = 0;
	 PC_select = 0;
	 jump_type = 0;
	 cs_jmp = 0;
	 cs_call = 0;
	 cs_in = 0;
	 cs_out = 0;
	 cs_mem_read = 0;
	 cs_mem_write = 0;
	 cs_reg_write = 0;
	 special_int = 0;
	 cs_reset = 0;
	 cs_alu_op = 0;
	 cs_mem_op = 0;
	 shamt = 0;
	 reset_pc = 0;
	 push_flags = 0;
	 Pc_high_pop = 0;
	 cs_ret = 0;
	 fetch_NOP = 0;
	 decode_reset = 0;
	 execute_reset = 0;
	 decode_NOP = 0;
	 cs_rti = 0;
	 //Do not do that: INT_counter = 0;
	 write_cs_rti = 0;
	// CALL_branch = 0;
	 cs_pop = 0;
	 cs_ldd = 0;//1'b0;

	 
	//NOP
	if(op_code == 5'b0_0000)
	begin			
	end
	//SETC
	else if(op_code == 5'b0_0001)
	begin
		cs_alu_op=1'b1;
		alu_controls = 4'b0001;
	end
	//CLRC
	else if(op_code == 5'b0_0010)
	begin 
		cs_alu_op=1'b1;
		alu_controls = 4'b0010;
	end
	//NOT
	else if(op_code == 5'b0_0011)
	begin
		alu_controls = 4'b0100;
		cs_alu_op = 1'b1;
		cs_reg_write =1'b1;
	end	
	//INC
	else if(op_code == 5'b0_0100)
	begin
		alu_controls=4'b0101;
		 cs_alu_op=1'b1;
		 cs_reg_write =1'b1;	
	end
	//DEC
	else if(op_code == 5'b0_0101)
	begin
		alu_controls=4'b0110;
		 cs_alu_op=1'b1;
		 cs_reg_write =1'b1;	
	end
	//OUT
	else if(op_code == 5'b0_0110)
	begin
		alu_controls=4'b1111;
	     // cs_alu_op=1'b1;
		 // cs_reg_write =1'b1;	
		 cs_out = 1'b1;
	end
	//IN
	else if(op_code == 5'b0_0111)
	begin
		alu_controls=4'b1110;
		// cs_alu_op=1'b1;
		 cs_reg_write =1'b1;
		cs_in =1'b1;//**
	end
	//MOV
	else if(op_code == 5'b0_1000)
	begin
		alu_controls=4'b0111;
		// cs_alu_op=1'b1;
		 cs_reg_write =1'b1;	
	end
	//ADD
	else if(op_code == 5'b0_1001)
	begin
		 alu_controls=4'b1000;
		 cs_alu_op=1'b1;
		 cs_reg_write =1'b1;		 
	end
	//SUB
	else if(op_code == 5'b0_1010)
	begin
		alu_controls=4'b1001;
		 cs_alu_op=1'b1;
		 cs_reg_write =1'b1;	
	end
	//AND
	else if(op_code == 5'b0_1011)
	begin
		alu_controls=4'b1010;
		 cs_alu_op=1'b1;
		 cs_reg_write =1'b1;	
	end
	//OR
	else if(op_code == 5'b0_1100)
	begin
		alu_controls=4'b1011;
		 cs_alu_op=1'b1;
		 cs_reg_write =1'b1;	
	end
	//SHL
	else if(op_code == 5'b0_1101)
	begin
		alu_controls=4'b1100;
		 cs_alu_op=1'b1;
		 cs_reg_write =1'b1;	
	end
	//SHR
	else if(op_code == 5'b0_1110)
	begin
		alu_controls=4'b1101;
		 cs_alu_op=1'b1;
		 cs_reg_write =1'b1;	
	end
	//PUSH
	else if(op_code == 5'b1_0000)
	begin
		cs_push = 1'b1;
		cs_mem_op = 1'b1;
		cs_mem_write = 1'b1;
		SP_change = 1'b1;
		chosen_value  =2'b00;
	end
	//POP
	else if(op_code == 5'b1_0001)
	begin
		cs_pop = 1'b1;
		cs_mem_op = 1'b1;
		cs_mem_read = 1'b1;
		SP_change = 1'b1;
		cs_reg_write = 1'b1;
	end
	//LDM
	else if(op_code == 5'b1_0010)
	begin
		alu_controls=4'b1111;
		// cs_alu_op=1'b1;
		cs_reg_write = 1'b1;
		cs_ldm =1'b1;
		fetch_NOP=1'b1;
		cs_mem_op=1'b1;	 
	end
	//LDD
	else if(op_code == 5'b1_0011)
	begin
		alu_controls=4'b1110; //same as IN
		// cs_alu_op=1'b1;
		store_load  =1'b1;
		cs_mem_op  =1'b1;
		cs_mem_read  =1'b1;
		cs_reg_write  =1'b1;
		cs_ldd = 1'b1;
	end
	//STD
	else if(op_code ==5'b1_0100 )
	begin
		alu_controls=4'b1110; //same as IN
		// cs_alu_op=1'b1;
		store_load  =1'b1;
		cs_mem_op  =1'b1;
		cs_mem_write  =1'b1;
		chosen_value  =2'b00;
	end
	//JZ
	else if(op_code == 5'b1_1000)
	begin
		jump_type = 2'b01;
		//fetch_NOP = 1'b1;
		// CALL_branch = 1'b1;
		cs_jmp  = 1'b1;
	end
	//JN
	else if(op_code == 5'b1_1001)
	begin
		jump_type = 2'b10 ;
		//fetch_NOP = 1'b1;
		// CALL_branch = 1'b1;
		cs_jmp  = 1'b1;
	end
	//JC
	else if(op_code == 5'b1_1010)
	begin
		jump_type = 2'b11 ;
		//fetch_NOP = 1'b1;
		// CALL_branch = 1'b1;
		cs_jmp  = 1'b1;
	end
	//JMP
	else if(op_code == 5'b1_1011)
	begin
		jump_type = 2'b00 ;
		//fetch_NOP = 1'b1;
		// CALL_branch = 1'b1;
		cs_jmp  = 1'b1;
	end
	
	//CALL ==> same control signals as :puch_pc_low
	else if(op_code == 5'b1_1100)
	begin
		// CALL_branch = 1'b1;
		cs_call = 1'b1;
		cs_push = 1'b1;
		cs_mem_op = 1'b1;
		cs_mem_write = 1'b1;
		SP_change = 1'b1;
		chosen_value  =2'b11;
		PC_select = 2'b10; 
	end
	//RET ==>pop pc_high
	else if(op_code == 5'b1_1101)
	begin
		cs_mem_op = 1'b1;
		cs_ret = 1'b1;
		SP_change = 1'b1;
		cs_mem_read = 1'b1;
		Pc_high_pop = 1'b1;
		//PC_select = 2'b01; 
		//Do NOT do that :fetch_NOP = 1'b1;
		//as i need to overwrite the readed instructionin the fetch buffer to be pop_pc_low
	end
	//RTI ==>pop pc_high
	else if(op_code == 5'b1_1110)
	begin
		cs_rti = 1'b1;
		// write_cs_rti = 1'b1;
		cs_mem_op = 1'b1;
		SP_change = 1'b1;
		cs_mem_read = 1'b1;
		Pc_high_pop = 1'b1;
		//PC_select = 2'b01; 
		//Do NOT do that :fetch_NOP = 1'b1;
		//as i need to overwrite the readed instructionin the fetch buffer to be pop_pc_low
		
	end
	//-------------------------------- special instruction ----------------------//
	//NOTE: there is no special instruction for pop_pc_high
	//puch_pc_high .. ..
	else if(op_code == 5'b1_0110)
	begin
		//special_int =1'b1;
		cs_push = 1'b1;
		cs_mem_op = 1'b1;
		cs_mem_write = 1'b1;
		SP_change = 1'b1;
		chosen_value  =2'b10;
	end
	//puch_pc_low ..
	else if(op_code == 5'b1_0101)
	begin
		//special_int =1'b1;
		cs_push = 1'b1;
		cs_mem_op = 1'b1;
		cs_mem_write = 1'b1;
		SP_change = 1'b1;
		chosen_value  =2'b11;
	end
	//pop_pc_low ..
	else if(op_code == 5'b1_0111)
	begin
		//special_int =1'b1;
		cs_mem_op = 1'b1;
		SP_change = 1'b1;
		cs_mem_read = 1'b1;
		PC_select = 2'b01;
		//m.s: fetch_NOP = 1'b1;		
	end
	//push_flags ..
	else if(op_code == 5'b1_1111)
	begin
		//special_int =1'b1;
		 reset_pc =1'b1;
		push_flags =1'b1;
		cs_push = 1'b1;
		cs_mem_op = 1'b1;
		cs_mem_write = 1'b1;
		SP_change = 1'b1;
		chosen_value  =2'b01;
	end
	//pop_flags
	else if(op_code == 5'b0_1111)
	begin
		//special_int =1'b1;
		cs_mem_op = 1'b1;
		cs_mem_read = 1'b1;
		SP_change = 1'b1;
		//cs_reg_write = 1'b1;
		
		//reset the buffer of previus cs_rti:
		 write_cs_rti = 1'b1;
		// cs_rti = 1'b0;
		
		//make cs_alu_op=1'b1 as we want to enable the flag write_enable
		cs_alu_op=1'b1;
		
	end
	//-------------- int ---------------//
	if(INT_signal)//assume the int siganl is stable for one cycle negedge+ something to posedge-something
	begin
		// INT_counter =2'b11;
		/*if(still_in)
		begin
			
		end
		else*/ if(one_more_fetch)
		begin
			INT_counter =3'b100;
		end
		else
		begin
			INT_counter =3'b011;
		end
	end
		
	
end

always @(negedge clk) begin
	if(INT_counter != 3'b000)
	begin
		INT_counter = INT_counter-1;
	end
end

endmodule	