`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 01:06:07
// Design Name: 
// Module Name: apb_csr
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


module apb_csr #(parameter DW=32,AW=32,REGISTER_ADDR = 32'h4000A000) (input PRESETn,PCLK,PSEL,PENABLE,PWRITE,input [AW-1:0]PADDR, input [DW-1:0]PWDATA,output [DW-1:0]PRDATA,output PREADY,PSLVRR,use_mwerr_resp,output [2:0] wr_rd_ratio);


parameter IDLE = 3'B001;
parameter SETUP = 3'b010;
parameter ENABLE = 3'B100;

reg [2:0] state,next_state;
reg [DW-1:0] csr;

always @(posedge PCLK or negedge PRESETn)
  begin
	  if(!PRESETn) state <= IDLE;
	  else state <= next_state;
  end

always @(*)
begin
	case(state)
		IDLE : if(PSEL && !PENABLE) next_state <= SETUP; else next_state <= IDLE;
		SETUP : if(PSEL && PENABLE) next_state <= ENABLE; else if(PSEL && !PENABLE) next_state <= SETUP; else next_state <= IDLE;
	        ENABLE : if(PSEL) next_state <= ENABLE; else next_state <= IDLE;
	        default : next_state <= IDLE;
        endcase
end

assign PREADY = (state == ENABLE);

assign PSLVRR = (state == ENABLE && !(PADDR == REGISTER_ADDR));

assign wen = (state == ENABLE && PWRITE && (PADDR == REGISTER_ADDR));

assign ren = (state == ENABLE && !PWRITE && (PADDR == REGISTER_ADDR));

assign PRDATA = (ren == 1'b1) ? csr : 32'b0;

assign use_mwerr_resp = csr[31];

assign wr_rd_ratio = csr[2:0];

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn) csr <= 32'b0;
	else if(wen) csr <= PWDATA;
	else csr <= csr;
end

endmodule

