`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2026 22:06:21
// Design Name: 
// Module Name: dual_port_sram
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


module dp_sram #(parameter DW = 32,AW = 5)(input wclk,rclk,wen,ren,input [AW-1:0]waddr,raddr,input [DW-1:0]wdata,output reg [DW-1:0]rdata);

reg [DW-1:0]mem[(2**AW)-1:0];

//wire read , write;

//assign read = rclk && ren;
//assign write = wclk && wen;

always @(posedge rclk)
begin
	if(ren) rdata <= mem[raddr];
       else	rdata <= rdata;
end

always @(posedge wclk) 
begin
	if(wen) mem[waddr] <= wdata;
        else    mem[waddr] <= mem[waddr];
end

endmodule
