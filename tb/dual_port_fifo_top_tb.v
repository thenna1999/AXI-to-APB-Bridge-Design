`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2026 22:39:43
// Design Name: 
// Module Name: dual_port_fifo_top_tb
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


module fifo_sub_block_tb();
parameter AW=32,DW=32,IW=4,LW=4;
//write s_clk
//read  m_clk

reg s_clk,m_clk,s_rstn,m_rstn;

//*********write address********
reg 		    wa_push,wa_pop;
reg  [AW+IW+LW+7:0] wa_wdata;
wire 		    wa_full,wa_empty;
wire [AW+IW+LW+7:0] wa_rdata;

//*********write data***********
reg 		    wd_push,wd_pop;
reg  [DW+IW:0]	    wd_wdata;
wire 		    wd_full,wd_empty;
wire [DW+IW:0]      wd_rdata;

//********read address**********
reg 		    ra_push,ra_pop;
reg  [AW+IW+LW+7:0] ra_wdata;
wire 		    ra_full,ra_empty;
wire [AW+IW+LW+7:0] ra_rdata;

//********read data**********
reg 		    rd_push,rd_pop;
reg  [DW+IW+2:0]    rd_wdata;
wire 		    rd_full,rd_empty;
wire [DW+IW+2:0]    rd_rdata;

	fifo_sub_block  DUT(s_rstn,s_clk,wa_push,wa_wdata,wa_full,wd_push,wd_wdata,wd_full,ra_push,ra_wdata,ra_full,rd_pop,rd_rdata,rd_empty,m_rstn,m_clk,wa_pop,wa_rdata,wa_empty,wd_pop,wd_rdata,wd_empty,ra_pop,ra_rdata,ra_empty,rd_push,rd_wdata,rd_full);


always #5 s_clk = ~s_clk;
always #5 m_clk = ~m_clk;

task initialize();
	begin
		{m_clk,s_rstn,s_clk,m_rstn,wa_push,wa_pop,wd_push,wd_pop,ra_push,ra_pop,rd_push,rd_pop}=12'd0;
	end
endtask


task wr_reset();
	begin
		@(negedge s_clk);
		s_rstn=1'b0;
		@(negedge s_clk);
		s_rstn=1'b1;
	end
endtask

task rd_reset();
	begin
		@(negedge m_clk);
		m_rstn=1'b0;
		@(negedge m_clk);
		m_rstn=1'b1;
	end
endtask


task wr_address(input [AW+IW+LW:0]a);//48 bit
	begin
		@(negedge s_clk);
		wa_push=1'b1;
		wa_wdata=a;
		end
endtask

task wr_data(input [36:0]b);//36 bit
	begin
		@(negedge s_clk);
		wd_push=1;
		wd_wdata=b;
		end
endtask

task rd_address(input [47:0]c);//48 bit
	begin
		@(negedge s_clk);
		ra_push=1'b1;
		ra_wdata=c;
		end
endtask

task rd_data(input [38:0]d);//39 bit
	begin
		@(negedge m_clk);
		rd_push=1'b1;
		rd_wdata=d;
	end
endtask


initial
begin
	initialize();
	wr_reset();
	rd_reset();
	
	fork
	begin
		repeat(4)
	//	begin
			wr_address($random%48);
			@(negedge m_clk);
			wa_pop=1'b1;
	//	end
	end
	begin
		repeat(64)
	//	begin
			wr_data($random%37);
			@(negedge m_clk);
			wd_pop=1'b1;
	//	end
	end
	begin
		repeat(4)
	//	begin
			rd_address($random%48);
			@(negedge m_clk);
			ra_pop=1'b1;
	//	end
	end
	begin
		repeat(64)
	//	begin
			rd_data($random%39);
			@(negedge s_clk);
			rd_pop=1'b1;
	//	end
	end
	join

	#1000 $finish;
end
endmodule





