`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:55:44
// Design Name: 
// Module Name: sync_to_dff
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


module sync_2dff #(parameter DW = 4)( input rstn , input clk , input [DW-1:0]d , output reg [DW-1:0] q );

reg [DW-1:0] meta1;

always @(posedge clk or negedge rstn)
begin
 if(!rstn)
  begin 
   meta1 <= 1'b0;
   q <= 1'b0;
  end
 else
  begin
   meta1 <= d;
   q <= meta1;
  end
end


endmodule 
