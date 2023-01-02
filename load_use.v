
// module load_use_detection (Previus_inst_load,Previus_Previus_inst_load,current_add_1 ,current_add_2 ,Previus_dst_add,Previus_Previus_dst_add ,not_dumy_zeros,Previus_reg_write,call_or_branch,fetch_nop_LD);//,sel_1);//all branch but not jump
// input Previus_inst_load,not_dumy_zeros;
// input Previus_Previus_inst_load,Previus_reg_write,call_or_branch;
// input [2:0] current_add_1 ,current_add_2 ,Previus_dst_add ,Previus_Previus_dst_add;
// output reg fetch_nop_LD;

// always @(*)
// begin 
	// if(current_add_2 == Previus_dst_add) 
	// begin
		// if(Previus_inst_load )
		// begin
			// if( not_dumy_zeros && (current_add_1 == Previus_dst_add))
			// begin
				// fetch_nop_LD = 1'b1 ;	
			// end
			// else if(call_or_branch)
			// begin
				// fetch_nop_LD = 1'b1 ;	
			// end	
		// end
		// else if(Previus_reg_write && call_or_branch) 
		// begin
			// fetch_nop_LD = 1'b1 ;	
		// end	
	// end
	// else if(Previus_Previus_inst_load && call_or_branch && (current_add_2 == Previus_Previus_dst_add) )
	// begin
		// fetch_nop_LD = 1'b1 ;	
	// end		
	// else 
	// begin
		// fetch_nop_LD = 1'b0 ;
	// end
// end

// endmodule


// // module load_use_detection (Previus_inst_load,Previus_Previus_inst_load,current_add_1 ,current_add_2 ,Previus_dst_add,Previus_Previus_dst_add ,not_dumy_zeros,Previus_reg_write,call_or_branch,fetch_nop_LD);//,sel_1);//all branch but not jump
// // input Previus_inst_load,not_dumy_zeros;
// // input Previus_Previus_inst_load,Previus_reg_write,call_or_branch;
// // input [2:0] current_add_1 ,current_add_2 ,Previus_dst_add ,Previus_Previus_dst_add;
// // output reg fetch_nop_LD;

// // always @(*)
// // begin 

	// // if( Previus_inst_load && not_dumy_zeros && (current_add_1 == Previus_dst_add))
	// // begin
		// // fetch_nop_LD = 1'b1 ;	
	// // end
	
	// // if( Previus_inst_load && (current_add_2 == Previus_dst_add))
	// // begin
		// // fetch_nop_LD = 1'b1 ;	
	// // end
	
	// // if(call_or_branch &&  (current_add_2 == Previus_dst_add) && Previus_inst_load )
	// // begin
		// // fetch_nop_LD = 1'b1 ;	
	// // end	
	// // if(Previus_reg_write && call_or_branch ) 
	// // begin
		// // fetch_nop_LD = 1'b1 ;	
	// // end	
		

	// // else if(Previus_Previus_inst_load && call_or_branch && (current_add_2 == Previus_Previus_dst_add) )
	// // begin
		// // fetch_nop_LD = 1'b1 ;	
	// // end		
	// // else 
	// // begin
		// // fetch_nop_LD = 1'b0 ;
	// // end
// // end

// // endmodule

module load_use_detection (Previus_inst_load,Previus_Previus_inst_load,current_add_1 ,current_add_2 ,Previus_dst_add,Previus_Previus_dst_add ,not_dumy_zeros,Previus_reg_write,call_or_branch,fetch_nop_LD);//,sel_1);//all branch but not jump
input Previus_inst_load,not_dumy_zeros;
input Previus_Previus_inst_load,Previus_reg_write,call_or_branch;
input [2:0] current_add_1 ,current_add_2 ,Previus_dst_add ,Previus_Previus_dst_add;
output reg fetch_nop_LD;
reg done;
always @(*)
begin 

	if( Previus_inst_load && ( (not_dumy_zeros && (current_add_1 == Previus_dst_add)) || (current_add_2 == Previus_dst_add) )) 
	begin
		fetch_nop_LD = 1'b1 ;	
			//done = 1'b1 ;	
	end
	
	
	// if(call_or_branch &&  (current_add_2 == Previus_dst_add) && Previus_inst_load )
	// begin
		// fetch_nop_LD = 1'b1 ;	
	// end	
	
	else if(Previus_reg_write && call_or_branch ) 
	begin
		fetch_nop_LD = 1'b1 ;
		//done = 1'b1 ;	
	end	
	
	
	else if(Previus_Previus_inst_load && call_or_branch && (current_add_2 == Previus_Previus_dst_add) )
	begin
		fetch_nop_LD = 1'b1 ;	
		//done = 1'b1 ;	
	end	
	
	else 
	begin
		fetch_nop_LD = 1'b0 ;
	end
	
	
	// if( !Previus_inst_load && ! call_or_branch)
	// begin
		// fetch_nop_LD = 1'b0 ;
	// end
	
	// if(!done)
	// begin
	
	// end
	
end

endmodule