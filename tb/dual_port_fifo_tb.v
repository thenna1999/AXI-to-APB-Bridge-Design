`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2026 22:11:16
// Design Name: 
// Module Name: dual_port_fifo_tb
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


module fifo_tb();

parameter AW=4,DW=8;
//location 2**4 = 16 locations
//data bits per location 8bit(0 to 2**8) so value range(0 to 255)

reg 		w_clk,r_clk;
reg 		w_rstn,r_rstn;
reg 		push,pop;
reg  [DW-1:0]   w_data;
wire [DW-1:0]   r_data;
wire 		full,empty;


dp_fifo #(AW,DW) DP_FIFO (w_clk,r_clk,w_rstn,r_rstn,push,pop,w_data,r_data,full,empty);


always #5 w_clk = ~w_clk;
always #5 r_clk = ~r_clk;

task initialize();
	begin
		{w_clk,w_rstn,push,pop,r_clk,r_rstn}=6'd0;
	end
endtask

task wr_reset();
	begin
		@(negedge w_clk);
		w_rstn=1'b0;
		@(negedge w_clk);
		w_rstn=1'b1;
	end
endtask

task rd_reset();
	begin
		@(negedge r_clk);
		r_rstn=1'b0;
		@(negedge r_clk);
		r_rstn=1'b1;
	end
endtask

task wr_data(input [DW-1:0]t_w_data,input we,input re);
	begin
		@(negedge w_clk);
		w_data=t_w_data;
		push=we;
		pop=re;
	end
endtask

task rd_data(input re,input we);
	begin
		@(negedge r_clk);
		pop=re;
		push=we;
	end
endtask

initial
begin
	initialize();
	wr_reset();
	rd_reset();
	repeat(16)
	wr_data($random%256,1'b1,1'b0);
	repeat(16)
	rd_data(1'b1,1'b0);

	#1000 $finish;
end
endmodule


/*module dp_fifo_tb #(parameter DW = 8, AW = 3) ();

//write 
reg wclk, wrstn, push;
reg [DW-1:0] wdata;
wire full;

//read
reg rclk, rrstn, pop;
wire [DW-1:0] rdata;
wire empty;

integer i;

dp_fifo  #(.DW(DW), .AW(AW)) DUV (.wclk(wclk), .wrstn(wrstn), .push(push), .wdata(wdata), .full(full), .rclk(rclk), .rrstn(rrstn), 
	.pop(pop), .rdata(rdata), .empty(empty));

initial begin
	wclk = 1'b0;
	forever #10 wclk = ~wclk;
end

initial begin
	rclk = 1'b0;
	forever #10 rclk = ~rclk;
end

task initialize;
	{push,wdata,pop} = 0;
endtask

task w_reset;
	begin
		@(negedge wclk);
		wrstn = 1'b0;
		@(negedge wclk);
		wrstn = 1'b1;
	end
endtask

task r_reset;
	begin
		@(negedge rclk);
		rrstn = 1'b0;
		@(negedge rclk );
		rrstn = 1'b1;
	end
endtask

task write;
	begin
	repeat(8)
		begin
			@(negedge wclk );
			push = 1'b1;
			wdata = $random%100;
		end
	end
endtask

task read;
	begin
	repeat(8)
		begin
			@(negedge rclk);
			@(negedge rclk);
		//	@(negedge rclk);
			push = 1'b0;
			pop = 1'b1;
		end
	end
endtask

initial begin
	initialize;
	#5;

	w_reset;
	r_reset;
	#5;

	write;
	#5;

	read;

	#1000;
	$finish;
end

endmodule*/

		





