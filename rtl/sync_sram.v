`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:35:55
// Design Name: 
// Module Name: sync_sram
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


module sync_sram #(parameter AW = 5,DW = 32,DEPTH = 2**AW)(input clk,wen,ren,input [AW-1:0]waddr,raddr,input [DW-1:0]wdata,output reg [DW-1:0]rdata);

reg [DW-1:0]mem[DEPTH-1:0];

always @(posedge clk)
begin
	if(ren) rdata <= mem[raddr];
	else    rdata <= rdata;
end

always @(posedge clk) 
begin
	if(wen) mem[waddr] <= wdata;
	else 	mem[waddr] <= mem[waddr];
end


endmodule

