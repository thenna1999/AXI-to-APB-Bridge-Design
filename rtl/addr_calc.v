`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:47:46
// Design Name: 
// Module Name: addr_calc
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


module apb_addr_calc #(
 parameter AW = 32,
 parameter IW = 4,
 parameter LW = 4
 )
 (
input PCLK,
input PRESETn,

input waddr_ren,raddr_ren,

input [AW+IW+LW+7:0] waddr_ctrl_rdata,
output waddr_fifo_pop,
input waddr_fifo_empty,

input [AW+IW+LW+7:0] raddr_ctrl_rdata,
output raddr_fifo_pop,
input raddr_fifo_empty,

output [AW+IW+LW+2:0] r_write_prot_addr_id,
output [AW+IW+LW+2:0] r_read_prot_addr_id,

output w_addr_fe,r_addr_fe

);

wire [AW-1:0] write_start_address ,read_start_address ;
reg [AW-1:0] write_next_address ,read_next_address ;
wire [IW-1:0] awid,arid;
wire [LW-1:0] awlen,arlen;
wire [2:0] awsize,arsize;
wire [1:0] awburst,arburst;
wire [2:0] awprot,arprot;

wire [8:0] w_no_of_bytes,r_no_of_bytes;

reg waddr_calc_progress,raddr_calc_progress;

reg raddr_pop, waddr_pop;
reg w_pop,r_pop;

reg w_addr_push, r_addr_push;
wire w_addr_ff, r_addr_ff;

reg [LW:0] w_count, r_count;

wire [AW+IW+LW+2:0] w_write_prot_addr_id,w_read_prot_addr_id;


//assign w_addr_ctrl = {AWPROT,AWBURST,AWSIZE,AWLEN,AWADDR,AWID};

assign awid = waddr_ctrl_rdata[IW-1:0];
assign arid = raddr_ctrl_rdata[IW-1:0];

assign write_start_address = waddr_ctrl_rdata[AW+IW-1:IW];
assign read_start_address = raddr_ctrl_rdata[AW+IW-1:IW];

assign awlen = waddr_ctrl_rdata[AW+IW+LW-1:AW+IW];
assign arlen = raddr_ctrl_rdata[AW+IW+LW-1:AW+IW];

assign awsize = waddr_ctrl_rdata[AW+IW+LW+2:AW+IW+LW];
assign arsize = raddr_ctrl_rdata[AW+IW+LW+2:AW+IW+LW];

assign awburst = waddr_ctrl_rdata[AW+IW+LW+4:AW+IW+LW+3];
assign arburst = raddr_ctrl_rdata[AW+IW+LW+4:AW+IW+LW+3];

assign awprot = waddr_ctrl_rdata[AW+IW+LW+7:AW+IW+LW+5];
assign arprot = raddr_ctrl_rdata[AW+IW+LW+7:AW+IW+LW+5];

assign w_write_prot_addr_id = {awprot,awlen,write_next_address,awid};
assign w_read_prot_addr_id = {arprot,arlen,read_next_address,arid};

assign w_no_of_bytes = 2**awsize;
assign r_no_of_bytes = 2**arsize;


//write address pop
always @(*)
begin
	if((!waddr_fifo_empty) && (!waddr_calc_progress) && (!w_addr_ff) && (!w_pop))
		waddr_pop = 1'b1;
	else    waddr_pop = 1'b0;
end

//read address pop
always @(*)
begin
	if((!raddr_fifo_empty) && (!raddr_calc_progress) && (!r_addr_ff) && (!r_pop))
		raddr_pop = 1'b1;
	else    raddr_pop = 1'b0;
end


//write address calc
always @(posedge PCLK or negedge PRESETn )
 begin
	 if(!PRESETn) 
	  begin
		  w_count <= 'b0;
		  w_pop <= 1'b0;
		  w_addr_push <= 1'b0;
		  waddr_calc_progress <= 1'b0;
	  end

	  else 
	  begin
		  if (w_count <= {1'b0,awlen})
                     begin
			  if(!w_addr_ff)
			      begin
				      w_pop <= 1'b0;
				      waddr_calc_progress <= 1'b1;
				      w_addr_push <= 1'b1;
				      w_count <= w_count +1'b1;
				      if(awburst == 2'b00) 
					      write_next_address <= write_start_address;
				      else 
					     
						      write_next_address <= write_start_address + (w_count*w_no_of_bytes);
						     
					    
		              end

			  else
			      begin
     			              w_pop <= w_pop;
				      waddr_calc_progress <= waddr_calc_progress;
				      w_addr_push <= 1'b0;
				      w_count <= w_count;
			      end
		     end
		  else
		     begin
			  if(waddr_fifo_pop) 
				  begin
					  w_pop <= 1'b1;
					  w_count <= 'b0;
				  end

			  else
			    begin
				  w_pop <= w_pop;
				  w_count <= w_count;
			    end
			              waddr_calc_progress <= 1'b0;
				      w_addr_push <= 1'b0;
		     end
	     end
 end

//read address calc
always @(posedge PCLK or negedge PRESETn )
 begin
	 if(!PRESETn) 
	  begin
		  r_count <= 'b0;
		  r_pop <= 1'b0;
		  r_addr_push <= 1'b0;
		  raddr_calc_progress <= 1'b0;
	  end

	  else 
	  begin
		  if (r_count <= {1'b0,arlen})
                     begin
			  if(!r_addr_ff)
			      begin
				      r_pop <= 1'b0;
				      raddr_calc_progress <= 1'b1;
				      r_addr_push <= 1'b1;

				      if(arburst == 2'b00) 
					      read_next_address <= read_start_address;
				      else 
					     
						      read_next_address <= read_start_address + (r_count*r_no_of_bytes);
						      r_count <= r_count +1'b1;
					     
		              end

			  else
			      begin
     			              r_pop <= r_pop;
				      raddr_calc_progress <= waddr_calc_progress;
				      r_addr_push <= 1'b0;
				      r_count <= r_count;
			      end
		     end
		  else
		     begin
			  if(raddr_fifo_pop) 
				  begin
					  r_pop <= 1'b1;
					  r_count <= 'b0;
				  end

			  else
			    begin
				  r_pop <= r_pop;
				  r_count <= r_count;
			    end
			              raddr_calc_progress <= 1'b0;
				      r_addr_push <= 1'b0;
		     end
	     end
 end


 sync_fifo #(2+LW,AW+IW+LW+3) sync_fifo_write_address (PCLK,PRESETn,w_addr_push,waddr_ren,w_write_prot_addr_id,w_addr_ff,w_addr_fe,r_write_prot_addr_id);
 sync_fifo #(2+LW,AW+IW+LW+3) sync_fifo_read_address (PCLK,PRESETn,r_addr_push,raddr_ren,w_read_prot_addr_id,r_addr_ff,r_addr_fe,r_read_prot_addr_id);
 
 pulse_sync write( PRESETn, PCLK, waddr_pop, waddr_fifo_pop);
 pulse_sync read( PRESETn, PCLK, raddr_pop, raddr_fifo_pop);

 
endmodule

