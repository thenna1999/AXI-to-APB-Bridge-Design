`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 01:11:56
// Design Name: 
// Module Name: apb_slave_selector_tb
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


module apb_slave_selector_tb #(
	parameter DW = 32,
	parameter AW = 32);

reg PSELx,PWRITE,PENABLE;
reg [2:0]PPROT;
reg [AW-1:0]PADDR;
reg [DW-1:0] PWDATA;
reg [(DW/8)-1:0]PSTRB;
wire PSLVERR,PREADY;
wire [31:0]PRDATA; 
wire [10:0] pselx;
wire pwrite,penable;
wire [2:0] pprot; 
wire  [AW-1:0] paddr;
wire [DW-1:0] pwdata;
wire [(DW/8)-1:0] pstrb; 
reg [10:0] pslverr,pready; 
wire decode_err; 
reg [31:0] prdata_0,prdata_1,prdata_2,prdata_3,prdata_4,prdata_5,prdata_6,prdata_7,prdata_8,prdata_9,prdata_10;


 apb_slave_selector dut(PSELx,PWRITE,PENABLE,PPROT,PADDR,PWDATA,PSTRB,PSLVERR,PREADY,PRDATA,pselx,pwrite,penable,pprot,paddr,pwdata,pstrb,pslverr,pready,decode_err,prdata_0,prdata_1,prdata_2,prdata_3,prdata_4,prdata_5,prdata_6,prdata_7,prdata_8,prdata_9,prdata_10);



 task initialze;
   begin 
	  {PSELx,PWRITE,PENABLE} ='b0;
	  {pslverr,pready} = 'b0;
          PPROT = 'b0;
          PADDR = 'b0;
          PWDATA = 'b0;
          PSTRB = 'b0;
	  prdata_0 = 'b0;
          prdata_1 = 'b0;
	  prdata_2 = 'b0;
	  prdata_3 = 'b0;
	  prdata_4 = 'b0;
          prdata_5 = 'b0;
          prdata_6 = 'b0;
          prdata_7 = 'b0;
          prdata_8 = 'b0;
          prdata_9 = 'b0;
	  prdata_10 = 'b0;
   end
 endtask

 initial
   begin 
       initialze;
       #10;
       {PSELx,PWRITE,PENABLE} =3'b111;
       PPROT = 3'b1;
          PADDR = 32'h4000_00F0;
          PWDATA = 32'h10000;
          PSTRB = 4'b1111;
	  prdata_0 = 32'd10;
	  pready = 12'b1;
	  
	   #10;
       {PSELx,PWRITE,PENABLE} =3'b101;
          PPROT = 3'b1;
          PADDR = 32'h4000_00F0;
          PWDATA = 32'h10000;
          PSTRB = 4'b1111;
	  prdata_0 = 32'd230;
	  pready = 12'b1;

	  	   #10;
       {PSELx,PWRITE,PENABLE} =3'b101;
          PPROT = 3'b1;
          PADDR = 32'h4000_3200;
          PWDATA = 32'h100;
          PSTRB = 4'b111;
	  prdata_3 = 32'd103;
	  pready = 12'b1000;

	  	   #10;
       {PSELx,PWRITE,PENABLE} =3'b101;
          PPROT = 3'b1;
          PADDR = 32'h4000_651F;
          PWDATA = 32'h1000;
          PSTRB = 4'b1111;
	  prdata_6 = 4'd1230;
	  pready = 12'b1000000;
	       
	        #10;
               initialze;
	  	   #10;
       {PSELx,PWRITE,PENABLE} =3'b101;
          PPROT = 3'b1;
          PADDR = 32'h4000_9822;
          PWDATA = 32'h10000;
          PSTRB = 4'b1111;
	  prdata_9 = 4'b10;
	  pready = 12'b1;

	  	   #10;
       {PSELx,PWRITE,PENABLE} =3'b101;
          PPROT = 3'b1;
          PADDR = 32'h4000_A0F0;
          PWDATA = 32'h10000;
          PSTRB = 4'b1111;
	  prdata_10 = 4'd670;
	  pready = 12'b100000000000;

       #10;

          initialze;


	  #100
	  $finish;


  end
endmodule

