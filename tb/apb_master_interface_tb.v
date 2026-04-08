`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 01:00:19
// Design Name: 
// Module Name: apb_master_interface_tb
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


module apb_master_interface_tb #(parameter AW=32,
		       parameter DW=32,
		       parameter LW=4,
		       parameter IW=4);

		       reg [AW+LW+IW+2:0] awaddr_ctrl;
		       wire waddr_ren;
		       reg waddr_fe;
		       
		       reg [(DW/8)+DW:0] wdata_strb;
		       wire data_ren;
		       reg data_fe;

		       reg [AW+LW+IW+2:0] araddr_ctrl;
		       wire raddr_ren;
		       reg raddr_fe;

		       wire [DW+IW+2:0] rdata_serr;
		       wire rdata_wen;
		       reg rdata_ff;

		       wire [1:0] wr_resp_2_axi;
		       wire [IW-1:0] wr_resp_id_2_axi;
		       wire wr_2_axi;
		       wire rd_2_axi;

		       reg [2:0] access_ratio;

		       reg PCLK,PRESETn;
		       wire PSELx,PENABLE;
		       wire [AW-1:0] PADDR;
		       wire [2:0] PPROT;
		       wire PWRITE;
		       wire [DW-1:0] PWDATA;
		       wire [3:0] PSTRB;
		       reg PREADY;
		       reg [DW-1:0] PRDATA;
		       reg PSLVERR,decode_err;

 apb_master_interface dut(awaddr_ctrl,waddr_ren,waddr_fe,wdata_strb,data_ren,data_fe,araddr_ctrl,raddr_ren,raddr_fe,rdata_serr,rdata_wen,rdata_ff,wr_resp_2_axi,wr_resp_id_2_axi,wr_2_axi,rd_2_axi,access_ratio,PCLK,PRESETn,PSELx,PENABLE,PADDR,PPROT,PWRITE,PWDATA,PSTRB,PREADY,PRDATA,PSLVERR,decode_err);


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
	   { awaddr_ctrl,wdata_strb,araddr_ctrl,access_ratio,PREADY,PRDATA,PSLVERR,decode_err } = 'b0;
	   waddr_fe = 1'b1;data_fe = 1'b1;raddr_fe = 1;rdata_ff = 1;
/*
           //ONLY WRITE
           @(negedge PCLK);
	   //awaddr_ctrl = {awprot,awlen,write_next_address,awid};
	   awaddr_ctrl = {3'd1,4'd0,32'd3456,4'd2};
           waddr_fe = 1'b0;

	   //wdata_strb = {WLAST,WSTRB,WDATA};;
	   wdata_strb = {1'b1,4'd15,32'd2345};
	   data_fe = 1'b0;
	   @(negedge PCLK);
	   @(negedge PCLK);
	   PREADY = 1;waddr_fe = 1'b1;data_fe = 1'b1;

	   //ONLY READ
	   @(negedge PCLK);
	   //awaddr_ctrl = {awprot,awlen,write_next_address,awid};
	   araddr_ctrl = {3'd1,4'd0,32'd3456,4'd3};
           raddr_fe = 1'b0;PREADY = 0;

	   PRDATA = 32'h100;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   @(negedge PCLK);
	   PREADY = 1;raddr_fe = 1'b1;rdata_ff = 1'b1;
	   @(negedge PCLK);
	   PREADY = 0;

	   @(negedge PCLK);
	   //csr 001;
	   access_ratio = 3'b001;
	   awaddr_ctrl = {3'd1,4'd0,32'd56,4'd4};
           waddr_fe = 1'b0;
	   wdata_strb = {1'b1,4'd15,32'd23};
	   data_fe = 1'b0;
	   araddr_ctrl = {3'd1,4'd0,32'd356,4'd4};
           raddr_fe = 1'b0;
	   PRDATA = 32'h23100;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   PREADY = 1;
	   @(negedge PCLK);
	   PREADY = 0;
	   @(negedge PCLK);
	   PREADY = 1;waddr_fe = 1'b1;data_fe = 1'b1;raddr_fe = 1'b1;rdata_ff = 1'b1;
	   @(negedge PCLK);
	   PREADY = 0;

	   @(negedge PCLK);
	   //csr 011;
	   access_ratio = 3'b011;
	   awaddr_ctrl = {3'd1,4'd0,32'd656,4'd1};
           waddr_fe = 1'b0;
	   wdata_strb = {1'b1,4'd15,32'd623};
	   data_fe = 1'b0;
	   araddr_ctrl = {3'd1,4'd2,32'd356,4'd1};
           raddr_fe = 1'b0;
	   PRDATA = 32'h23100;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   PREADY = 1;
	   awaddr_ctrl = {3'd1,4'd0,32'd656,4'd1};
           waddr_fe = 1'b0;
	   wdata_strb = {1'b1,4'd15,32'd23};
	   data_fe = 1'b0;
	   araddr_ctrl = {3'd1,4'd2,32'd358,4'd1};
           raddr_fe = 1'b0;
	   PRDATA = 32'h23200;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   PREADY = 0;
	   @(negedge PCLK);
	   PREADY = 1;
	   awaddr_ctrl = {3'd1,4'd0,32'd656,4'd1};
           waddr_fe = 1'b0;
	   wdata_strb = {1'b1,4'd15,32'd23};
	   data_fe = 1'b0;
	   araddr_ctrl = {3'd1,4'd2,32'd360,4'd1};
           raddr_fe = 1'b0;
	   PRDATA = 32'h23100;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   PREADY = 0;
           @(negedge PCLK);
	   PREADY = 1;
	   @(negedge PCLK);
	   PREADY = 0;
	   @(negedge PCLK);
	   PREADY = 1;waddr_fe = 1'b1;data_fe = 1'b1;raddr_fe = 1'b1;rdata_ff = 1'b1;
	   @(negedge PCLK);
	   PREADY = 0;




	   @(negedge PCLK);
	   //csr 101;
	   access_ratio = 3'b101;
	   awaddr_ctrl = {3'd1,4'd0,32'd56,4'd10};
           waddr_fe = 1'b0;
	   wdata_strb = {1'b1,4'd10,32'd6723};
	   data_fe = 1'b0;
	   araddr_ctrl = {3'd1,4'd0,32'd9356,4'd10};
           raddr_fe = 1'b0;
	   PRDATA = 32'd455;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   PREADY = 1;
	   @(negedge PCLK);
	   PREADY = 0;
	   @(negedge PCLK);
	   PREADY = 1;waddr_fe = 1'b1;data_fe = 1'b1;raddr_fe = 1'b1;rdata_ff = 1'b1;
	   @(negedge PCLK);
	   PREADY = 0;

	   @(negedge PCLK);
	   //csr 110;
	   access_ratio = 3'b110;
	   awaddr_ctrl = {3'd0,4'd1,32'd6,4'd14};
           waddr_fe = 1'b0;
	   wdata_strb = {1'b0,4'd15,32'd6203};
	   data_fe = 1'b0;
	   araddr_ctrl = {3'd1,4'd0,32'd356,4'd12};
           raddr_fe = 1'b0;
	   PRDATA = 32'h999;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   PREADY = 1;
	   awaddr_ctrl = {3'd0,4'd1,32'd8,4'd14};
           waddr_fe = 1'b0;
	   wdata_strb = {1'b1,4'd15,32'd203};
	   data_fe = 1'b0;
	   araddr_ctrl = {3'd1,4'd0,32'd356,4'd12};
           raddr_fe = 1'b0;
	   PRDATA = 32'h999;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   PREADY = 0;
	   @(negedge PCLK);
	   PREADY = 1;
	   @(negedge PCLK);
	   PREADY = 0;
	   @(negedge PCLK);
	   PREADY = 1;waddr_fe = 1'b1;data_fe = 1'b1;raddr_fe = 1'b1;rdata_ff = 1'b1;
	   @(negedge PCLK);
	   PREADY = 0;

 */
	    @(negedge PCLK);
	   //csr 100;
	   access_ratio = 3'b100;
           @(negedge PCLK);
	   awaddr_ctrl = {3'd1,4'd0,32'd56,4'd10};
           waddr_fe = 1'b0;
	   wdata_strb = {1'b1,4'd10,32'd6723};
	   data_fe = 1'b0;
	   araddr_ctrl = {3'd1,4'd0,32'd9356,4'd10};
           raddr_fe = 1'b0;
	   PRDATA = 32'd455;
	   rdata_ff = 1'b0;
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   @(negedge PCLK);
	   PREADY = 1;
	   @(negedge PCLK);
	   PREADY = 0;
	   @(negedge PCLK);
	   PREADY = 1;waddr_fe = 1'b1;data_fe = 1'b1;raddr_fe = 1'b1;rdata_ff = 1'b1;
	   @(negedge PCLK);
	   PREADY = 0;


	   #100;
	   $finish;
   end
  
endmodule

