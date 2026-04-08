`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:33:48
// Design Name: 
// Module Name: sync_fifo_tb
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


module sync_fifo_tb #(parameter AW=3, DW=8)();
	
	reg clk, rstn, push;
	reg [DW-1:0] write_data;
	wire almost_full;

	reg pop;
	wire [DW-1:0] read_data;
	wire empty;

	sync_fifo #(.AW(AW), .DW(DW)) DUT (.clk(clk), .rstn(rstn), .push(push), .write_data(write_data), .almost_full(almost_full),
	       		.pop(pop), .read_data(read_data), .empty(empty));

	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	task initialize;
		{push, pop, write_data} = 0;
	endtask

	task reset;
		begin
			@(negedge clk);
			rstn = 1'b0;
			@(negedge clk);
			rstn = 1'b1;
		end
	endtask

	task write;
		repeat(8)
		begin
			@(negedge clk);
			push = 1'b1;
			write_data = $random%256;
			pop = 1'b0;
		end
	endtask

	task read;
		repeat(8)
		begin
			@(negedge clk);
			push = 1'b0;
			pop = 1'b1;
		end
	endtask

	initial begin
		initialize;
		#5;
		reset;
		#5;
		write;
		//#10;
		read;

		#1000;
		$finish;
	end
	endmodule




