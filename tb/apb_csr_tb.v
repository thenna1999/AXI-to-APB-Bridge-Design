`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 01:06:44
// Design Name: 
// Module Name: apb_csr_tb
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


module apb_csr_tb #(parameter DW=32);

reg PRESETn,PCLK,PSEL,PENABLE,PWRITE;
reg [DW-1:0]PADDR,PWDATA;
wire [DW-1:0] PRDATA;
wire PREADY,PSLVRR,use_mwerr_resp;
wire [2:0] wr_rd_ratio;

apb_csr dut(PRESETn,PCLK,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA,PREADY,PSLVRR,use_mwerr_resp,wr_rd_ratio);

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
	   resetn; //IDLE
	   {PSEL,PENABLE,PWRITE,PADDR,PWDATA} = 67'b0;

	    @(negedge PCLK);//SETUP
	    PSEL = 1'b1; PENABLE = 1'b0; PWRITE = 1'B1; PADDR = 32'h4000A000;
            PWDATA = 32'hFFFFAAAA;

	    @(negedge PCLK);//ENABLE
	    PSEL = 1'b1; PENABLE = 1'b1;

	    @(negedge PCLK);
	    @(negedge PCLK);PSEL = 1'b0;

	    //READ
	    @(negedge PCLK);//SETUP
	    PSEL = 1'b1; PENABLE = 1'b0; PWRITE = 1'B0; PADDR = 32'h4000A000;
            PWDATA = 32'hABBABABA;

	    @(negedge PCLK);//ENABLE
	    PSEL = 1'b1; PENABLE = 1'b1;

	    @(negedge PCLK);
	    @(negedge PCLK);PSEL = 1'b0;

	    //slvrr
	    @(negedge PCLK);//SETUP
	    PSEL = 1'b1; PENABLE = 1'b0; PWRITE = 1'B1; PADDR = 32'hA000A000;
            PWDATA = 32'hFFFFAAAA;

	    @(negedge PCLK);//ENABLE
	    PSEL = 1'b1; PENABLE = 1'b1;

	    @(negedge PCLK);
	    @(negedge PCLK);PSEL = 1'b0;



	    #1000;
	    $finish;
    end

endmodule


