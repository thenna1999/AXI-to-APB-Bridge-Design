`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:32:49
// Design Name: 
// Module Name: sync_fifo
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


module sync_fifo #(parameter AW = 4,DW = 16) (input clk,rstn,push,pop,input [DW-1:0]write_data,output almost_full,empty,output [DW-1:0]read_data);

reg [AW-1:0] wp_ptr,rd_ptr;
reg [AW:0] fifo_ptr;
wire wr_vld,rd_vld,full;

parameter DEPTH = 2**AW;
parameter ALMOST_FULL = DEPTH -3;


sync_sram #(AW,DW,DEPTH) fifo_mem(clk,wr_vld,rd_vld,wp_ptr,rd_ptr,write_data,read_data);


assign empty = (fifo_ptr == 'b0);

assign full = (fifo_ptr == DEPTH);

assign almost_full = (fifo_ptr >= ALMOST_FULL);

assign wr_vld = push && (!full) ;

assign rd_vld = pop && (!empty) ;


//write pointer or wp_ptr
always @(posedge clk or negedge rstn)
begin
	if(!rstn) wp_ptr <= 'b0;
	else if(wr_vld)  wp_ptr <= wp_ptr + 1'b1;
	else wp_ptr <= wp_ptr;
end	


//read pointer or rd_ptr
always @(posedge clk or negedge rstn)
begin
	if(!rstn) rd_ptr <= 'b0;
	else if(rd_vld)  rd_ptr <= rd_ptr + 1'b1;
	else rd_ptr <= rd_ptr;
end	


//fifo pointer or fifo_ptr
always @(posedge clk or negedge rstn)
begin
	if(!rstn) fifo_ptr <= 'b0;
	else if(wr_vld && !rd_vld)  fifo_ptr <= fifo_ptr + 1'b1;
	else if(!wr_vld && rd_vld)  fifo_ptr <= fifo_ptr - 1'b1;
	else fifo_ptr <= fifo_ptr;
end	

endmodule


