`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2026 15:46:05
// Design Name: 
// Module Name: dual_port_fifo
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


module dp_fifo #(parameter DW = 32,AW = 5)(input wclk, wrstn, push, rclk, rrstn, pop, input [DW-1:0]wdata,output reg full,empty,output [DW-1:0]rdata);

reg [AW:0] wp_binary,rp_binary;
wire [AW:0] wp_binary_next,rp_binary_next;
reg [AW:0] wp_gray,rp_gray;
wire [AW:0] wp_gray_next,rp_gray_next;
reg [AW:0] wp_meta,wp_sync_2r;
reg [AW:0] rp_meta,rp_sync_2w;
wire[AW:0] rp_sync_2w_binary;

//dual port SRAM or MEMORY
dp_sram #(DW,AW) fifo_mem (wclk,rclk,push,pop,wp_binary[AW-1:0],rp_binary[AW-1:0],wdata,rdata);


//write pointer or wp_binary
always @(posedge wclk or negedge wrstn)
begin
	if(!wrstn) wp_binary <= 'b0;
	else if(push && (!full))  wp_binary <= wp_binary_next;
	else wp_binary <= wp_binary;
end	

assign wp_binary_next = wp_binary + 1'b1;

//write pointer gary conversion or wp_gray
always @(posedge wclk or negedge wrstn)
begin
	if(!wrstn) wp_gray <= 'b0;
	else if(push && (!full))  wp_gray <= wp_gray_next;
	else wp_gray <= wp_gray;
end	

assign wp_gray_next = wp_binary_next ^ {1'b0,wp_binary_next[AW:1]};

//gray synchronizer
always @(posedge rclk or negedge rrstn)
begin
	if(!rrstn) 
		 begin
			 wp_meta <= 'b0;
			 wp_sync_2r <= 'b0;
		  end
	else 
		begin
			wp_meta <= wp_gray; 
			wp_sync_2r <= wp_meta; 
		end
end	


// read pointer or rp_binary
always @(posedge rclk or negedge rrstn)
begin
	if(!rrstn) rp_binary <= 'b0;
	else if(pop && (!empty))  rp_binary <= rp_binary_next;
	else rp_binary <= rp_binary;
end	

assign rp_binary_next = rp_binary + 1'b1;

//read pointer gary conversion or rp_gray
always @(posedge rclk or negedge rrstn)
begin
	if(!rrstn) rp_gray <= 'b0;
	else if(pop && (!empty))  rp_gray <= rp_gray_next;
	else rp_gray <= rp_gray;
end	

assign rp_gray_next = rp_binary_next ^ {1'b0,rp_binary_next[AW:1]};


//2 stage gray synchronizer read
always @(posedge wclk or negedge wrstn)
begin
	if(!wrstn)
	        begin 
	                rp_meta <= 'b0; 
	                rp_sync_2w <= 'b0;
                end
	else 
		begin
			rp_meta <= rp_gray; 
			rp_sync_2w <= rp_meta; 
		end
end	

//gray to binary for full calculations
assign rp_sync_2w_binary = rp_sync_2w ^ {1'b0,rp_sync_2w_binary[AW:1]};

//full
always @(posedge wclk or negedge wrstn)
   begin
       	if(!wrstn) full <= 1'b0;
        else full <= ((wp_binary[AW-1:0] == rp_sync_2w_binary[AW-1:0]) & (wp_binary[AW] != rp_sync_2w_binary[AW])) | (push && (rp_sync_2w_binary[AW-1:0] == wp_binary_next[AW-1:0]) && (rp_sync_2w_binary[AW] != wp_binary_next[AW])  );
   end

//empty
always @(posedge rclk or negedge rrstn)
   begin
       	if(!rrstn) empty <= 1'b1;
        else empty <= (wp_sync_2r == rp_gray) | (pop & (rp_gray_next == wp_sync_2r)  );
   end	   
	   
endmodule

