`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:58:28
// Design Name: 
// Module Name: apb_master_interface
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


module apb_master_interface #(parameter AW=32,
		       parameter DW=32,
		       parameter LW=4,
		       parameter IW=4)

		      (input [AW+LW+IW+2:0] awaddr_ctrl,
		       output waddr_ren,
		       input waddr_fe,
		       
		       input [(DW/8)+DW:0] wdata_strb,
		       output data_ren,
		       input data_fe,

		       input [AW+LW+IW+2:0] araddr_ctrl,
		       output raddr_ren,
		       input raddr_fe,

		       output [DW+IW+2:0] rdata_serr,
		       output rdata_wen,
		       input rdata_ff,

		       output [1:0] wr_resp_2_axi,
		       output reg [IW-1:0] wr_resp_id_2_axi,
		       output reg wr_2_axi,
		       

		       input [2:0] access_ratio,

		       input PCLK,PRESETn,
		       output PSELx,PENABLE,
		       output [AW-1:0] PADDR,
		       output [2:0] PPROT,
		       output PWRITE,
		       output [DW-1:0] PWDATA,
		       output [(DW/8)-1:0] PSTRB,
		       input PREADY,
		       input [DW-1:0] PRDATA,
		       input PSLVERR,decode_err);

// FSM for cstates

parameter IDLE=3'b000;
parameter W_SETUP=3'b001; 
parameter W_ACTIVE=3'b010; 
parameter R_SETUP=3'b011;
parameter R_ACTIVE=3'b100;

reg [2:0] cstate,nstate;

//reg rd_2_axi;
wire wfifo_ren;
wire wlast;
wire RLAST;
wire apd_wr;
wire apb_rd;
wire apb_wr_complete;
//wire apb_rd_complete;
wire [(IW-1):0] RID;
reg [(2**LW) : 0] err;
reg [(2**LW) : 0] d_err;
reg [(2**LW) : 0] pslverr;
reg [(2**LW) : 0] dec_err;

reg [(LW-1):0] w_count,r_count;
wire [(LW-1):0] awlen,arlen;
wire [(IW-1):0] awid,arid;
wire wr_resp_slv_err,wr_resp_d_err;
wire [1:0] rd_resp;


assign PPROT = PWRITE ? awaddr_ctrl[(AW+IW+LW+2):(AW+IW+LW)] : araddr_ctrl[(AW+IW+LW+2):(AW+IW+LW)];
assign awlen = awaddr_ctrl[(AW+IW+LW):(AW+IW)];
assign arlen = araddr_ctrl[(AW+IW+LW):(AW+IW)];
assign awid = awaddr_ctrl[(IW-1):0];
assign arid = araddr_ctrl[(IW-1):0];

assign PADDR = PWRITE ? awaddr_ctrl[(AW+IW-1):(IW)] : araddr_ctrl[(AW+IW-1):(IW)];
assign PSTRB = PWRITE ? wdata_strb[(DW/8)+DW-1:DW] : 'b0;
assign PWDATA = wdata_strb[DW-1:0];

assign apb_rd = PSELx & PENABLE & PREADY & !PWRITE;
assign apb_wr = PSELx & PENABLE & PREADY & PWRITE;

assign apb_wr_complete = PSELx & PENABLE & PREADY & PWRITE & wlast;
//assign apb_rd_complete = PSELx & PENABLE & PREADY & PWRITE & RLAST;

assign rd_resp = (PSELx & !PWRITE) ? {PSLVERR,decode_err} :2'b00;
assign rdata_serr = {RLAST,rd_resp,PRDATA,RID};
assign rdata_wen = apb_rd;
assign wr_resp_slv_err = |(pslverr);
assign wr_resp_d_err = |(dec_err);
assign wr_resp_2_axi = {wr_resp_slv_err,wr_resp_d_err};

assign PENABLE = (cstate == W_ACTIVE) || (cstate == R_ACTIVE);
assign PWRITE = (cstate == W_ACTIVE) || (cstate == W_SETUP);
assign PSELx = (cstate != IDLE);

assign wlast = wdata_strb[(DW/8)+DW];
assign RID = arid;

//bid
always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		wr_resp_id_2_axi <= 'b0;
	else if(wlast)
		wr_resp_id_2_axi <= awid;
	else
		wr_resp_id_2_axi <= wr_resp_id_2_axi;
end

//wr_2_axi
always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		wr_2_axi <= 1'b0;
	else
		wr_2_axi <= apb_wr_complete;
end

//rd_2_axi
/*always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		rd_2_axi <= 1'b0;
	else
		rd_2_axi <= apb_rd_complete;
end
*/


//FSM
always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		cstate<=IDLE;
	else
		cstate<=nstate;
end

always@(*)
begin
	case(cstate)
		IDLE : 	begin
			if(wfifo_ren)	nstate = W_SETUP;
			else if(raddr_ren) nstate = R_SETUP;
			else		nstate = IDLE;
		        end

	    W_SETUP  :  nstate = W_ACTIVE;

	    W_ACTIVE :  begin
			if(!PREADY) nstate = W_ACTIVE;
			else if(wfifo_ren) nstate = W_SETUP;
			else if(raddr_ren) nstate = R_SETUP;
			else	nstate = IDLE;
		        end

	     R_SETUP :  nstate = R_ACTIVE;

	    R_ACTIVE :	begin
			if(!PREADY)		nstate = R_ACTIVE;
			else if(raddr_ren)	nstate = R_SETUP;
			else if(wfifo_ren)	nstate = W_SETUP;
			else	nstate = IDLE;
		        end
		default : nstate = IDLE;
	endcase
end

apb_access_arbiter u_apb_access_arb(PCLK,PRESETn,(!data_fe && !waddr_fe),apb_wr,(!raddr_fe),(!rdata_ff),apb_rd,access_ratio,wfifo_ren,raddr_ren);

assign waddr_ren = wfifo_ren;
assign data_ren = wfifo_ren;

always @(posedge PCLK or negedge PRESETn)
begin
 if(!PRESETn)
 begin
	 err <= 'b0;
	 d_err <= 'b0;
	 pslverr <= 'b0;
	 dec_err <= 'b0;
	 w_count <= 'b0;
 end
 else
 begin
	 if(w_count <= awlen)
		 begin
			 if(apb_wr)
			 begin
				 if(w_count == 'b0)
				 begin
					 err <= {15'b0,PSLVERR};
					 d_err <= {15'b0,decode_err};
				 end
				 else
				 begin
					 err[w_count] <= PSLVERR;
					 d_err[w_count] <= decode_err;
				 end
				 if(w_count == awlen)
				 begin
					 pslverr <= err;
					 dec_err <= d_err;
					 w_count <= 'b0;
				 end
				 else
				 begin
					 pslverr <= pslverr;
					 dec_err <= dec_err;
					 w_count <= w_count + 1'b1;
				 end
			 end
		         else
				 begin
					 pslverr <= pslverr;
					 err <= err;
					 d_err <= d_err;
					 w_count <= w_count;
					 dec_err <= dec_err;
				 end
	        end
		else 
		               begin
					 pslverr <= pslverr;
					 err <= 'b0;
					 d_err <= 'b0;
					 w_count <= 'b0;
					 dec_err <= dec_err;
				 end
 end
end


always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		r_count <= 'b0;
	else
	 begin
		 if(r_count <= arlen)
		 begin
			 if(apb_rd)
			 begin
				 if(r_count == arlen) r_count <= 'b0;
				 else r_count <= r_count +1'b1;
			 end
		         else r_count <= r_count;
	        end
		else r_count <= 'b0;
	end

end

assign RLAST = (r_count == arlen) ? 1'b1:1'b0;

endmodule


