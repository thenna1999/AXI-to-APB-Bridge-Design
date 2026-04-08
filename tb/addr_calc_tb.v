`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:49:03
// Design Name: 
// Module Name: addr_calc_tb
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


module apb_addr_calc_tb #(
 parameter AW = 32,
 parameter IW = 4,
 parameter LW = 4
 );

reg PCLK, PRESETn;
reg waddr_ren,raddr_ren;

reg [AW+IW+LW+7:0] waddr_ctrl_rdata;
wire waddr_fifo_pop;
reg waddr_fifo_empty;

reg [AW+IW+LW+7:0] raddr_ctrl_rdata;
wire raddr_fifo_pop;
reg raddr_fifo_empty;

wire [AW+IW+LW+2:0] r_write_prot_addr_id;
wire [AW+IW+LW+2:0] r_read_prot_addr_id;

wire w_addr_fe,r_addr_fe;

apb_addr_calc #(AW,IW,LW) dut(PCLK,PRESETn,waddr_ren,raddr_ren,waddr_ctrl_rdata,waddr_fifo_pop,waddr_fifo_empty,raddr_ctrl_rdata,raddr_fifo_pop,raddr_fifo_empty,r_write_prot_addr_id,r_read_prot_addr_id,w_addr_fe,r_addr_fe);

initial
 begin	
  PCLK = 1'B0;
  forever
  #5 PCLK = ~PCLK;
 end


  task resetn;
	 begin
		 @(negedge PCLK) PRESETn = 1'b0;
		 @(negedge PCLK) PRESETn = 1'b1;
          end
  endtask

  initial

    begin
	    resetn;
	    waddr_ren = 1'b0;
	    raddr_ren = 1'b0;
            waddr_fifo_empty = 0;
	    raddr_fifo_empty = 0;
	    fork
		    @(posedge PCLK);
	    waddr_ctrl_rdata = {3'b1,2'b1,3'd2,4'd7,32'd100,4'd2};
	    raddr_ctrl_rdata = {3'b0,2'b0,3'd2,4'd5,32'd234,4'd1};
            join
	    #100;
	    waddr_ctrl_rdata = {3'd2,2'b0,3'd3,4'd6,32'd22,4'd3};
	   // waddr_fifo_empty = 1;
	    @(posedge PCLK);
	    @(posedge PCLK);
	    raddr_ctrl_rdata = {3'd3,2'b1,3'd1,4'd15,32'd4532,4'd4};
	    #1000;
	    waddr_ren = 1'b1;
	    @(posedge PCLK);
	    raddr_ren = 1'b1;
	    if(waddr_fifo_empty == 1'b1) waddr_ren = 1'b0;
	    if(raddr_fifo_empty == 1'b1) raddr_ren = 1'b0;
	    #1000;
	    $finish;
    end

endmodule

