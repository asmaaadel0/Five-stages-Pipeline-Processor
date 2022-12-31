
module load_use_detection (Previus_inst_load,current_add_1 ,current_add_2 ,Previus_dst_add , fetch_nop_LD,not_dumy_zeros);
input Previus_inst_load,not_dumy_zeros;
input [2:0] current_add_1 ,current_add_2 ,Previus_dst_add ;
output reg fetch_nop_LD;

// always @(*)
// begin 
	// if(Previus_inst_load  && not_dumy_zeros && (current_add_1 == Previus_dst_add || current_add_2 == Previus_dst_add) )
	// begin
		// fetch_nop_LD = 1'b1 ;	
	// end
	// else 
	// begin
		// fetch_nop_LD = 1'b0 ;
	// end
// end
always @(*)
begin 
	// if(Previus_inst_load  && not_dumy_zeros && (current_add_1 == Previus_dst_add || current_add_2 == Previus_dst_add) )
	if(Previus_inst_load && ( ((current_add_1 == Previus_dst_add) && not_dumy_zeros )|| current_add_2 == Previus_dst_add) )
	begin
		fetch_nop_LD = 1'b1 ;	
	end
	else 
	begin
		fetch_nop_LD = 1'b0 ;
	end
end
//------------------------------  Load use case -----------------------------------//

//later



endmodule
