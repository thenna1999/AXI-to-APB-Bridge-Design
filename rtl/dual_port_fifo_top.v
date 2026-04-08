`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2026 22:38:34
// Design Name: 
// Module Name: dual_port_fifo_top
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


module fifos #(
 parameter AW = 32,
 parameter DW = 32,
 parameter IW = 4,
 parameter LW = 4
 )
(input s_rstn,sclk,wa_push,input [AW+IW+LW+7:0] wa_wdata,input wd_push,input [(DW/8)+DW:0] wd_wdata,input ra_push,input [AW+IW+LW+7:0] ra_wdata,input rd_pop,output [DW+IW+2:0] rd_rdata,output wa_full,wd_full,ra_full,rd_empty,input m_rstn,mclk,wa_pop,output [AW+IW+LW+7:0] wa_rdata,input wd_pop,output [(DW/8)+DW:0] wd_rdata,input ra_pop,output [AW+IW+LW+7:0] ra_rdata,input rd_push,input [DW+IW+2:0] rd_wdata,output wa_empty,wd_empty,ra_empty,rd_full);

//write addr
dp_fifo #(AW+IW+LW+8,2) wa_fifo(sclk, s_rstn, wa_push, mclk, m_rstn, wa_pop,wa_wdata,wa_full,wa_empty,wa_rdata);

//write data
dp_fifo #((DW/8)+DW+1,2+LW) wd_fifo(sclk, s_rstn, wd_push, mclk, m_rstn, wd_pop,wd_wdata,wd_full,wd_empty,wd_rdata);

//read addr
dp_fifo #(AW+IW+LW+8,2) ra_fifo(sclk, s_rstn, ra_push, mclk, m_rstn, ra_pop,ra_wdata,ra_full,ra_empty,ra_rdata);

//read data
dp_fifo #(DW+IW+3,2+LW) rd_fifo(mclk, m_rstn, rd_push, sclk, s_rstn, rd_pop,rd_wdata,rd_full,rd_empty,rd_rdata);


endmodule

