// module forwarding_unit (current_cs_cin, current_add_1 ,current_add_2 ,E_dst_add,M_dst_add,E_WB,M_WB,sel_1,sel_2);
// input current_cs_cin,E_WB,M_WB;
// input [2:0]  current_add_1 ,current_add_2 ,E_dst_add,M_dst_add ;
// output reg [1:0]sel_1,sel_2;

// always @(*)
// begin 
	// if(current_cs_cin)
	// begin
		// sel_1 = 2'b11;
		// //NOTE: we do not care about sel_2 here till now
	// end
	// else 
	// begin
		// if (E_WB)
		// begin
			// if( current_add_1 == E_dst_add)
			// begin
				// sel_1 = 2'b01;
			// end
			// if( current_add_2 == E_dst_add)
			// begin
				// sel_2 = 2'b01;
			// end
			
		// end

		// if(M_WB)
		// begin
			// if( current_add_1 == M_dst_add)
			// begin
				// sel_1 = 2'b10;
			// end
			// if( current_add_2 == M_dst_add)
			// begin
				// sel_2 = 2'b10;
			// end
		// end
		// else 
		// begin
			// sel_1 = 2'b00;
			// sel_2 = 2'b00;
		// end
	// end
// end

// endmodule

module forwarding_unit (current_cs_cin, current_add_1 ,current_add_2 ,E_dst_add,M_dst_add,E_WB,M_WB,sel_1,sel_2);
input current_cs_cin,E_WB,M_WB;
input [2:0]  current_add_1 ,current_add_2 ,E_dst_add,M_dst_add ;
output reg [1:0]sel_1,sel_2;

always @(*)
begin 
	if(current_cs_cin)
	begin
		sel_1 = 2'b11;
		//NOTE: we do not care about sel_2 here till now
	end
	else 
	begin
		if( current_add_1 == E_dst_add && E_WB ) 
		begin
			sel_1 = 2'b01;		
		end
		else if( current_add_1 == M_dst_add && M_WB ) 
		begin
			sel_1 = 2'b10;
		end
		else 
		begin
			sel_1 = 2'b00;
		end
		
		if( current_add_2 == E_dst_add && E_WB ) 
		begin
			sel_2 = 2'b01;		
		end
		else if( current_add_2 == M_dst_add && M_WB ) 
		begin
			sel_2 = 2'b10;
		end
		else 
		begin
			sel_2 = 2'b00;
		end
	end
end

//------------------------------  Load use case -----------------------------------//

//later



endmodule
