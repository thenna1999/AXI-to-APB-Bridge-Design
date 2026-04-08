`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 01:11:30
// Design Name: 
// Module Name: apb_slave_selector
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


module apb_slave_selector #(
	parameter DW = 32,
	parameter AW = 32,
	parameter SLAVE0_BASE_ADDR = 32'h4000_0000,
	parameter SLAVE1_BASE_ADDR = 32'h4000_1000,
	parameter SLAVE2_BASE_ADDR = 32'h4000_2000,
	parameter SLAVE3_BASE_ADDR = 32'h4000_3000,
	parameter SLAVE4_BASE_ADDR = 32'h4000_4000,
	parameter SLAVE5_BASE_ADDR = 32'h4000_5000,
	parameter SLAVE6_BASE_ADDR = 32'h4000_6000,
	parameter SLAVE7_BASE_ADDR = 32'h4000_7000,
	parameter SLAVE8_BASE_ADDR = 32'h4000_8000,
	parameter SLAVE9_BASE_ADDR = 32'h4000_9000,
	parameter SLAVE10_BASE_ADDR = 32'h4000_A000,
	parameter OFFSET = 32'h0000_0FFF )

	( input PSELx,PWRITE,PENABLE,input [2:0]PPROT,input [AW-1:0]PADDR,input [DW-1:0] PWDATA,input [(DW/8)-1:0]PSTRB,output reg PSLVERR,PREADY,output reg [31:0]PRDATA, output reg [10:0] pselx,output pwrite,penable,output [2:0] pprot, output  [AW-1:0] paddr,output [DW-1:0] pwdata,output [(DW/8)-1:0] pstrb, input [10:0] pslverr,pready, output reg decode_err, input [DW-1:0] prdata_0,prdata_1,prdata_2,prdata_3,prdata_4,prdata_5,prdata_6,prdata_7,prdata_8,prdata_9,prdata_10);

	always @ (*)
	begin
		if(PSELx)
		begin
			case(PADDR & (~OFFSET))

				SLAVE0_BASE_ADDR : begin 
				                     pselx <= 11'b00000000001;
						     decode_err <= 1'b0;
					           end

		                SLAVE1_BASE_ADDR : begin 
				                     pselx <= 11'b00000000010;
						     decode_err <= 1'b0;
					           end

                                SLAVE2_BASE_ADDR : begin 
				                     pselx <= 11'b00000000100;
						     decode_err <= 1'b0;
					           end

                                SLAVE3_BASE_ADDR : begin 
				                     pselx <= 11'b00000001000;
						     decode_err <= 1'b0;
					           end

                                SLAVE4_BASE_ADDR : begin 
				                     pselx <= 11'b00000010000;
						     decode_err <= 1'b0;
					           end

                                SLAVE5_BASE_ADDR : begin 
				                     pselx <= 11'b00000100000;
						     decode_err <= 1'b0;
					           end

                                SLAVE6_BASE_ADDR : begin 
				                     pselx <= 11'b00001000000;
						     decode_err <= 1'b0;
					           end

                                SLAVE7_BASE_ADDR : begin 
				                     pselx <= 11'b00010000000;
						     decode_err <= 1'b0;
					           end

                                SLAVE8_BASE_ADDR : begin 
				                     pselx <= 11'b00100000000;
						     decode_err <= 1'b0;
					           end

                                SLAVE9_BASE_ADDR : begin 
				                     pselx <= 11'b01000000000;
						     decode_err <= 1'b0;
					           end

                                SLAVE10_BASE_ADDR : begin 
				                     pselx <= 11'b10000000000;
						     decode_err <= 1'b0;
					            end

			                 default : begin 
				                     pselx <= 11'b00000000000;
						     decode_err <= 1'b1;
					           end

			endcase
			end
			else 
				                   begin 
				                     pselx <= 11'b0;
						     decode_err <= 1'b0;
					           end
		end


		assign pwdata = (!decode_err) ? PWDATA :'b0;
		assign pstrb = (!decode_err) ? PSTRB :'b0;
		assign pprot = (!decode_err) ? PPROT :'b0;
		assign penable = (!decode_err) ? PENABLE :'b0;
		assign paddr = (!decode_err) ? PADDR :'b0;
		assign pwrite = (!decode_err) ? PWRITE :'b0;


		//PRDATA
		always @(*)
		  begin
			  if(!PWRITE)
			   begin
			    case(pselx)
				    11'b00000000001 : PRDATA = prdata_0;
				    11'b00000000010 : PRDATA = prdata_1;
				    11'b00000000100 : PRDATA = prdata_2;
				    11'b00000001000 : PRDATA = prdata_3;
				    11'b00000010000 : PRDATA = prdata_4;
				    11'b00000100000 : PRDATA = prdata_5;
				    11'b00001000000 : PRDATA = prdata_6;
				    11'b00010000000 : PRDATA = prdata_7;
				    11'b00100000000 : PRDATA = prdata_8;
				    11'b01000000000 : PRDATA = prdata_9;
				    11'b10000000000 : PRDATA = prdata_10;
				            default : PRDATA = 'b0;
			    endcase
		           end
			  else PRDATA = 'b0;
                  end

	        //PREADY
		always @(*)
		 begin
			case(pselx)
				11'b00000000000 : begin if(decode_err) PREADY = 1'b1; else  PREADY = 1'b0; end
				11'b00000000001 : PREADY = pready[0];
				11'b00000000010 : PREADY = pready[1];
				11'b00000000100 : PREADY = pready[2];
				11'b00000001000 : PREADY = pready[3];
				11'b00000010000 : PREADY = pready[4];
				11'b00000100000 : PREADY = pready[5];
				11'b00001000000 : PREADY = pready[6];
		                11'b00010000000 : PREADY = pready[7];
				11'b00100000000 : PREADY = pready[8];
				11'b01000000000 : PREADY = pready[9];
				11'b10000000000 : PREADY = pready[10];
				        default : PREADY = 1'b0;
			endcase
		 end

		 //PSLVERR
		 always @(*)
		 begin
			case(pselx)
				11'b00000000000 : begin if(decode_err) PSLVERR = 1'b1; else  PSLVERR = 1'b0; end
				11'b00000000001 : PSLVERR = pslverr[0];
				11'b00000000010 : PSLVERR = pslverr[1];
				11'b00000000100 : PSLVERR = pslverr[2];
				11'b00000001000 : PSLVERR = pslverr[3];
				11'b00000010000 : PSLVERR = pslverr[4];
				11'b00000100000 : PSLVERR = pslverr[5];
				11'b00001000000 : PSLVERR = pslverr[6];
		                11'b00010000000 : PSLVERR = pslverr[7];
				11'b00100000000 : PSLVERR = pslverr[8];
				11'b01000000000 : PSLVERR = pslverr[9];
				11'b10000000000 : PSLVERR = pslverr[10];
				        default : PSLVERR = 1'b0;
			endcase
		 end

endmodule



