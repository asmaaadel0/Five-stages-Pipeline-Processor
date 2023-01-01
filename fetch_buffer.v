

//assume read at posedge and write at negative edge
module fetch_buffer #(parameter Width=48)
(read_data, write_data,clk,cs_call,cs_ret,cs_rti,fetch_NOP,previous_rti,cs_ldm,reset);

input clk,reset;
input [Width-1:0] write_data;
output reg [Width-1:0]read_data;

input cs_call,cs_ret,fetch_NOP,previous_rti,cs_ldm;
input cs_rti;
reg [15:0] puch_pc_high = 16'b1_0110_0000_0000_000 
,pop_pc_low  = 16'b1_0111_0000_0000_000 
,pop_flags = 16'b0_1111_0000_0000_000; //,puch_flags,pop_flags,puch_pc_low=0 ,pop_pc_high;


reg [Width-1:0]reg_internal; 

always @(posedge clk) begin
			read_data=reg_internal;	
end


always @(negedge clk) begin
		if(reset)
		begin
			reg_internal = 'b0;
		end
		else if(cs_rti || cs_ret)//then overwrite the fetched instruction to be special inst call pop pc_low
						//NOTE: in the control unit , both instructions should be translated to : pop pc_high 
						//NOTE: to :pop pc_H before pop pc_L
						//NOTE:till now , we will treat ret as rti in the fetch buffer
		begin
			reg_internal[Width-1:Width-16] = pop_pc_low;
		end
		else if(cs_call)//then overwrite the fetched instruction to be special inst call push pc_high
						//NOTE: in the control unit , call instruction should be translated to : puch pc_low
		begin
			reg_internal[Width-1:Width-16] = puch_pc_high;
			//NOTE:
			//for the least 32bit -of the PC- , do not write the "write data" that coming outside as we want the previous pc_add1
		end
		else if(previous_rti)
		begin
			reg_internal[Width-1:Width-16] = pop_flags;
		end
		else if(fetch_NOP )
		begin
			reg_internal[Width-1:Width-16] = 16'b0;
			if(cs_ldm)
			begin
				reg_internal[Width-17:Width-48] = write_data[Width-17:Width-48];
			end
			//?what if : we want to pass in_port_value?
		end
		else 
		begin
			reg_internal = write_data;
		end						
end
endmodule
