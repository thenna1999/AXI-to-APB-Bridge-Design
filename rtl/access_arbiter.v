`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:52:30
// Design Name: 
// Module Name: access_arbiter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module apb_access_arbiter (input clk,rstn,wr_avail,wr,ra_avail,rd_avail,rd,input [2:0] ratio,output reg wr_en,rd_en);

parameter IDLE   = 5'b00001;
parameter RSTART = 5'b00010;
parameter RWAIT  = 5'b00100;
parameter WSTART = 5'b01000;
parameter WWAIT  = 5'b10000;

reg [4:0] cstate,nstate;
reg [2:0]ratio_r,cmd_cnt;
wire cmd;
wire r_avail,both_avail;
reg rd_temp,wr_temp;
wire wr_temp1,rd_temp1;

always @(posedge clk or negedge rstn)
 begin
	 if(!rstn) ratio_r <= 3'b000;
	 else if(cstate == IDLE) ratio_r <= ratio;
	 else ratio_r <= ratio_r;
 end

assign cmd = (ratio_r[2]) ? wr : rd;

always @(posedge clk or negedge rstn)
 begin
	 if(!rstn) cmd_cnt <= 3'b000;
	 else if (cstate == IDLE) cmd_cnt <= 3'b001;
	 else if (cmd_cnt[1:0] == ratio_r[1:0]) cmd_cnt <= 3'b000;
	 else if(cmd) cmd_cnt <= cmd_cnt +1'b1;
	 else cmd_cnt <= cmd_cnt;
 end

assign r_avail    = ra_avail & rd_avail;
assign both_avail = r_avail & wr_avail;

//FSM
always @(posedge clk or negedge rstn)
 begin
	 if(!rstn) cstate <= IDLE;
	 else cstate <= nstate;
 end
/*
always @(*)
begin
	case(cstate)
		IDLE : if((r_avail && !wr_avail) || (both_avail && !ratio[2])) nstate = RSTART;
		       else if((!r_avail && wr_avail) || (both_avail && ratio[2])) nstate = WSTART;
		       else nstate = IDLE;
		       //else if (!r_avail && !wr_avail) nstate = IDLE;

	      RSTART : if((!r_avail && wr_avail) || (both_avail && !ratio[2] && ( cmd_cnt[1:0] == ratio_r[1:0] )))   nstate = WWAIT;
	               //else if((r_avail && !wr_avail) || (!r_avail && !wr_avail) || (both_avail && !ratio[2] && (ratio_r[1:0] <=2'b01)) || (both_avail && !ratio[2] && ( cmd_cnt[1:0] <= ratio_r[1:0] ))) nstate = RWAIT;
		       else  nstate = RWAIT;

	       RWAIT : 
                       if((rd || wr || wr_temp1 || rd_temp1))
		          begin
			      if ((r_avail && !wr_avail) || (both_avail && !ratio[2])) nstate = RSTART; 
                              else if(both_avail && ratio[1:0] <= 2'b01)  nstate = WWAIT;
			      else if(both_avail && ratio[2]) nstate = WSTART;
			      // else if(!r_avail && !wr_avail) nstate = IDLE;
		              else nstate = IDLE;
			  end
		       else nstate = RWAIT;
		     
	      WSTART : if((r_avail && !wr_avail) || (both_avail && ratio[2] && ( cmd_cnt[1:0] == ratio_r[1:0] )))    nstate = RWAIT;
                       //else if((!r_avail && wr_avail) || (!r_avail && !wr_avail) || (both_avail && ratio[2] && (ratio_r[1:0] <=2'b01)) || (both_avail && ratio[2] && ( cmd_cnt[1:0] <= ratio_r[1:0] ))) nstate = WWAIT;
		       else  nstate = WWAIT;

	       WWAIT : 
                       if((rd || wr || wr_temp1 || rd_temp1))
		          begin
			      if ((!r_avail && wr_avail) || (both_avail && ratio[2])) nstate = WSTART; 
                              else if(both_avail && ratio[1:0] <= 2'b01)  nstate = RWAIT;
			      else if(both_avail && !ratio[2]) nstate = RSTART;
			      //else if(!r_avail && !wr_avail) nstate = IDLE;
		              else nstate = IDLE;
			  end
		       else nstate = WWAIT;

		 default : nstate = IDLE;
        endcase
end
*/

always @(*)
begin
	case(cstate)
		IDLE : if(r_avail && !wr_avail) nstate = RSTART;
		       else if(!r_avail && wr_avail) nstate = WSTART;
		       else if(both_avail && ratio_r[2]) nstate = WSTART;
		       else if(both_avail && !ratio_r[2]) nstate = RSTART;
		       else nstate = IDLE;

	      RSTART : if(r_avail && !wr_avail)  nstate = RWAIT;
                       else if(!r_avail && wr_avail)  nstate = WWAIT;
                       else if(both_avail && !ratio_r[2] && (ratio_r[1:0] <=2'b01))  nstate = RWAIT; 
                       else if(both_avail && !ratio_r[2] && ( cmd_cnt[1:0] == ratio_r[1:0] ))   nstate = WWAIT;	               	
		       else if(both_avail && !ratio_r[2] && ( cmd_cnt[1:0] <= ratio_r[1:0] )) nstate = RWAIT;
		       else  nstate = RWAIT;

	       RWAIT : 
                       if((rd || wr || wr_temp1 || rd_temp1))
		          begin
			      if (r_avail && !wr_avail) nstate = RSTART; 
			      else if(both_avail && ratio_r[1:0] <= 2'b01)  nstate = WWAIT;
			      else if(both_avail && ratio_r[2]) nstate = WSTART;
			      else if(both_avail && !ratio_r[2]) nstate = RSTART; 
		              else nstate = IDLE;
			  end
		       else nstate = RWAIT;
		     
	      WSTART : if(r_avail && !wr_avail)  nstate = RWAIT;
                       else if(!r_avail && wr_avail)  nstate = WWAIT;
                       else if(both_avail && ratio_r[2] && (ratio_r[1:0] <=2'b01))  nstate = WWAIT; 
                       else if(both_avail && ratio_r[2] && ( cmd_cnt[1:0] == ratio_r[1:0] ))  nstate = RWAIT;	              
		       else if(both_avail && ratio_r[2] && ( cmd_cnt[1:0] <= ratio_r[1:0] )) nstate = WWAIT;
		       else  nstate = WWAIT;

	       WWAIT : 
                       if((rd || wr || wr_temp1 || rd_temp1))
		          begin
			      if (!r_avail && wr_avail) nstate = WSTART; 
			      else if(both_avail && ratio_r[1:0] <= 2'b01)  nstate = RWAIT;
			      else if(both_avail && ratio_r[2]) nstate = WSTART;
			      else if(both_avail && !ratio_r[2]) nstate = RSTART; 
		              else nstate = IDLE;
			  end
		       else nstate = WWAIT;

		 default : nstate = IDLE;
        endcase
end



//rd
always @(*)
begin
	if(cstate == IDLE)
	   begin
		   if((ratio_r[1:0] <= 2'b01) && (!ratio_r[2] && both_avail)) begin rd_en = 1'b0; rd_temp = 1'b1; end
	      else if((r_avail && !wr_avail) || (both_avail && !ratio[2])) begin rd_en = 1'b1; rd_temp = 1'b0; end
	      else begin rd_en = 1'b0; rd_temp = 1'b0; end
           end
        else
	begin
		if(cstate == RWAIT)
		       if(rd || wr || wr_temp1 || rd_temp1) 
			       if((r_avail && !wr_avail) || (both_avail) ) begin rd_en = 1'b1; rd_temp = 1'b0; end
			       else begin rd_en = 1'b0; rd_temp = 1'b0; end
		       else begin rd_en = 1'b0; rd_temp = 1'b0; end
		else begin rd_en = 1'b0; rd_temp = 1'b0; end
	end
end

//wr
always @(*)
begin
	if(cstate == IDLE)
	   begin
	      if((ratio_r[1:0] <= 2'b01) && (ratio_r[2] && both_avail)) begin wr_en = 1'b0; wr_temp = 1'b1; end
	      else if((!r_avail && wr_avail) || (both_avail && ratio[2])) begin wr_en = 1'b1; wr_temp = 1'b0; end
	      else begin wr_en = 1'b0; wr_temp = 1'b0; end
           end
        else
	begin
		if(cstate == WWAIT) 
			if(rd || wr || wr_temp1 || rd_temp1) 
				if((!r_avail && wr_avail) || both_avail ) begin wr_en = 1'b1; wr_temp = 1'b0; end
				else begin wr_en = 1'b0; wr_temp = 1'b0; end
			else begin wr_en = 1'b0; wr_temp = 1'b0; end
		else begin wr_en = 1'b0; wr_temp = 1'b0; end
	end
end

sync_2dff #(1) u_wr_temp_sync(rstn,clk,wr_temp,wr_temp1 );
sync_2dff #(1) u_rd_temp_sync(rstn,clk,rd_temp,rd_temp1 );


endmodule

