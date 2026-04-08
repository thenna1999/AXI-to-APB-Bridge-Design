`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 01:16:17
// Design Name: 
// Module Name: axi4_to_apb4
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


module axi4_to_apb4 #(
	parameter AW = 32,
	parameter DW = 32,
	parameter LW = 4,
	parameter IW = 4,
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

	(
//APB MASTER INTERFACE SIGNALS
output [9:0] PSELx_o,
input PCLK_i,PRESETn_i,
output PENABLE_o,
output [AW-1:0] PADDR_o,
output [2:0] PPROT_o,
output PWRITE_o,
output [DW-1:0] PWDATA_o,
output [(DW/8)-1:0] PSTRB_o,
input [9:0]PREADY_i,
input [DW-1:0] PRDATA_i_0,
input [DW-1:0] PRDATA_i_1,
input [DW-1:0] PRDATA_i_2,
input [DW-1:0] PRDATA_i_3,
input [DW-1:0] PRDATA_i_4,
input [DW-1:0] PRDATA_i_5,
input [DW-1:0] PRDATA_i_6,
input [DW-1:0] PRDATA_i_7,
input [DW-1:0] PRDATA_i_8,
input [DW-1:0] PRDATA_i_9,
input [9:0]PSLVERR_i,
		       
//AXI SLAVE SIGNALS 
input ACLK_i,
input ARESETn_i,

//Declaration of Write Address Channel Signals
input [IW-1:0] AWID_i,
input [AW-1:0] AWADDR_i,
input [LW-1:0] AWLEN_i,
input [2:0] AWSIZE_i,
input [1:0] AWBURST_i,
input [2:0] AWPROT_i,
input AWVALID_i,
output AWREADY_o,

//Declaration of Write DATA Channel Signals
//input [3:0] WID;
input [DW-1:0] WDATA_i,
input [(DW/8)-1:0] WSTRB_i,
input WVALID_i,
output WREADY_o,
input WLAST_i,

//Declaration of Write RESPONSE Channel Signals
output [IW-1:0] BID_o,
output [1:0] BRESP_o,
output BVALID_o,
input BREADY_i,

//Declaration of Read Address Channel Signals
input [IW-1:0] ARID_i,
input [AW-1:0] ARADDR_i,
input [LW-1:0] ARLEN_i,
input [2:0] ARSIZE_i,
input [1:0] ARBURST_i,
input [2:0] ARPROT_i,
input ARVALID_i,
output ARREADY_o,

//Declaration of Read DATA Channel Signals
output [IW-1:0] RID_o,
output [DW-1:0] RDATA_o,
output [1:0] RRESP_o,
output RVALID_o,
input RREADY_i,
output RLAST_o );

//signal definations
wire [AW+IW+LW+7:0] waddr_ctrl_wdata;
wire [AW+IW+LW+7:0] waddr_ctrl_rdata;
wire waddr_wen_push;
wire w_axi_addr_vld;
wire waddr_wen_pop;
wire waddr_fifo_full;
wire waddr_fifo_empty;
wire [(DW/8)+DW:0] wdata_ctrl_wdata;
wire [(DW/8)+DW:0] wdata_ctrl_rdata;
wire wdata_wen_push;
wire wdata_wen_pop;
wire wdata_fifo_full;
wire wdata_fifo_empty;
wire [AW+IW+LW+7:0] raddr_ctrl_wdata;
wire [AW+IW+LW+7:0] raddr_ctrl_rdata;
wire raddr_wen_push;
wire r_axi_addr_vld;
wire raddr_wen_pop;
wire raddr_fifo_full;
wire raddr_fifo_empty;
wire [DW + IW + 2:0] rdata_ctrl_wdata;
wire [DW + IW + 2:0] rdata_ctrl_rdata;
wire rdata_wen_push;
wire rdata_wen_pop;
wire rdata_fifo_full;
wire rdata_fifo_empty;
wire [1:0]write_resp_2_axi;
wire [IW-1:0]write_bid_2_axi;
wire apb_write;
wire use_m_err_resp;
wire [AW+IW+LW+2:0]write_calc_addr_ctrl;
wire [AW+IW+LW+2:0]read_calc_addr_ctrl;
wire aw_addr_ren;
wire ar_addr_ren;
wire w_calc_fe;
wire r_calc_fe;
wire [2:0]ratio;

wire psel_ss;
wire penable_ss;
wire [AW-1:0]paddr_ss;
wire [2:0]pprot_ss;
wire pwrite_ss;
wire [DW-1:0]pwdata_ss;
wire [(DW/8)-1:0] pstrb_ss;
wire pready_ss;
wire [DW-1:0]prdata_ss;
wire pslverr_ss;
wire dec_err;

wire PSEL_CSR;
wire [DW-1:0]PRDATA_CSR;
wire PREADY_CSR;
wire PSLVERR_CSR;


	   

axi4_slave_interface #( .AW(AW),.DW(DW),.IW(IW),.LW(LW) ) u_axi4_slave(

.ACLK(ACLK_i),
.ARESETn(ARESETn_i),

.AWID(AWID_i),
.AWADDR(AWADDR_i),
.AWLEN(AWLEN_i),
.AWSIZE(AWSIZE_i),
.AWBURST(AWBURST_i),
.AWPROT(AWPROT_i),
.AWVALID(AWVALID_i),
.AWREADY(AWREADY_o),

.WDATA(WDATA_i),
.WSTRB(WSTRB_i),
.WVALID(WVALID_i),
.WREADY(WREADY_o),
.WLAST(WLAST_i),


.BID(BID_o),
.BRESP(BRESP_o),
.BVALID(BVALID_o),
.BREADY(BREADY_i),


.ARID(ARID_i),
.ARADDR(ARADDR_i),
.ARLEN(ARLEN_i),
.ARSIZE(ARSIZE_i),
.ARBURST(ARBURST_i),
.ARPROT(ARPROT_i),
.ARVALID(ARVALID_i),
.ARREADY(ARREADY_o),


.RID(RID_o),
.RDATA(RDATA_o),
.RRESP(RRESP_o),
.RVALID(RVALID_o),
.RREADY(RREADY_i),
.RLAST(RLAST_o),

.w_addr_ctrl(waddr_ctrl_wdata),
.w_addr_wen(waddr_wen_push),
.w_addr_full(waddr_fifo_full),
.w_data_ctrl(wdata_ctrl_wdata),
.w_data_wen(wdata_wen_push),
.w_data_full(wdata_fifo_full),
.r_addr_ctrl(raddr_ctrl_wdata),
.r_addr_wen(raddr_wen_push),
.r_addr_full(raddr_fifo_full),
.r_data_ctrl(rdata_ctrl_rdata),
.r_data_ren(rdata_wen_pop),
.r_data_empty(rdata_fifo_empty),

.wr_resp_2_axi(write_resp_2_axi),
.wr_bid_2_axi(write_bid_2_axi),
.mstr_wr_2_axi(apb_write),
.use_mwerr_resp(use_m_err_resp)
);


fifos #(.AW(AW),.DW(DW),.IW(IW),.LW(LW)) u_fifos(
.s_rstn(ARESETn_i),
.sclk(ACLK_i),
.wa_push(waddr_wen_push),
.wa_wdata(waddr_ctrl_wdata),
.wd_push(wdata_wen_push),
.wd_wdata(wdata_ctrl_wdata),
.ra_push(raddr_wen_push),
.ra_wdata(raddr_ctrl_wdata),
.rd_pop(rdata_wen_pop), 
.rd_rdata(rdata_ctrl_rdata),
.wa_full(waddr_fifo_full),
.wd_full(wdata_fifo_full),
.ra_full(raddr_fifo_full),
.rd_empty(rdata_fifo_empty),
.m_rstn(PRESETn_i),
.mclk(PCLK_i),
.wa_pop(waddr_wen_pop),
.wa_rdata(waddr_ctrl_rdata),
.wd_pop(wdata_wen_pop),
.wd_rdata(wdata_ctrl_rdata),
.ra_pop(raddr_wen_pop),
.ra_rdata(raddr_ctrl_rdata),
.rd_push(rdata_wen_push),
.rd_wdata(rdata_ctrl_wdata),
.wa_empty(waddr_fifo_empty),
.wd_empty(wdata_fifo_empty),
.ra_empty(raddr_fifo_empty),
.rd_full(rdata_fifo_full));


apb_addr_calc #(.AW(AW),.IW(IW),.LW(LW)) u_apb_addr_calc(
.PCLK(PCLK_i),
.PRESETn(PRESETn_i),
.waddr_ren(aw_addr_ren),
.raddr_ren(ar_addr_ren),
.waddr_ctrl_rdata(waddr_ctrl_rdata),
.waddr_fifo_pop(waddr_wen_pop),
.waddr_fifo_empty(waddr_fifo_empty),
.raddr_ctrl_rdata(raddr_ctrl_rdata),
.raddr_fifo_pop(raddr_wen_pop),
.raddr_fifo_empty(raddr_fifo_empty),
.r_write_prot_addr_id(write_calc_addr_ctrl),
.r_read_prot_addr_id(read_calc_addr_ctrl),
.w_addr_fe(w_calc_fe),
.r_addr_fe(r_calc_fe)
);


apb_master_interface #(.AW(AW),.DW(DW),.LW(LW),.IW(IW)) u_apb_master_interface
(
.awaddr_ctrl(write_calc_addr_ctrl),
.waddr_ren(aw_addr_ren),
.waddr_fe(w_calc_fe),
		       
.wdata_strb(wdata_ctrl_rdata),
.data_ren(wdata_wen_pop),
.data_fe(wdata_fifo_empty),

.araddr_ctrl(read_calc_addr_ctrl),
.raddr_ren(ar_addr_ren),
.raddr_fe(r_calc_fe),

.rdata_serr(rdata_ctrl_wdata),
.rdata_wen(rdata_wen_push),
.rdata_ff(rdata_fifo_full),

.wr_resp_2_axi(write_resp_2_axi),
.wr_resp_id_2_axi(write_bid_2_axi),
.wr_2_axi(apb_write),

.access_ratio(ratio),

.PCLK(PCLK_i),
.PRESETn(PRESETn_i),
.PSELx(psel_ss),
.PENABLE(penable_ss),
.PADDR(paddr_ss),
.PPROT(pprot_ss),
.PWRITE(pwrite_ss),
.PWDATA(pwdata_ss),
.PSTRB(pstrb_ss),
.PREADY(pready_ss),
.PRDATA(prdata_ss),
.PSLVERR(pslverr_ss),
.decode_err(dec_err) );


apb_slave_selector #(
	.DW(DW),
	.AW(AW),
	.SLAVE0_BASE_ADDR(SLAVE0_BASE_ADDR),
	.SLAVE1_BASE_ADDR(SLAVE1_BASE_ADDR),
	.SLAVE2_BASE_ADDR(SLAVE2_BASE_ADDR),
	.SLAVE3_BASE_ADDR(SLAVE3_BASE_ADDR),
	.SLAVE4_BASE_ADDR(SLAVE4_BASE_ADDR),
	.SLAVE5_BASE_ADDR(SLAVE5_BASE_ADDR),
	.SLAVE6_BASE_ADDR(SLAVE6_BASE_ADDR),
	.SLAVE7_BASE_ADDR(SLAVE7_BASE_ADDR),
	.SLAVE8_BASE_ADDR(SLAVE8_BASE_ADDR),
	.SLAVE9_BASE_ADDR(SLAVE9_BASE_ADDR),
	.SLAVE10_BASE_ADDR(SLAVE10_BASE_ADDR),
	.OFFSET(OFFSET) ) u_apb_slave_selector
	
	( 
.PSELx(psel_ss),
.PENABLE(penable_ss),
.PADDR(paddr_ss),
.PPROT(pprot_ss),
.PWRITE(pwrite_ss),
.PWDATA(pwdata_ss),
.PSTRB(pstrb_ss),
.PREADY(pready_ss),
.PRDATA(prdata_ss),
.PSLVERR(pslverr_ss),
.decode_err(dec_err), 
.pselx({PSEL_CSR, PSELx_o}),
.pwrite(PWRITE_o),
.penable(PENABLE_o),
.pprot(PPROT_o), 
.paddr(PADDR_o),
.pwdata(PWDATA_o),
.pstrb(PSTRB_o), 
.pslverr({PSLVERR_CSR,PSLVERR_i}),
.pready({PREADY_CSR,PREADY_i}), 
.prdata_0(PRDATA_i_0),
.prdata_1(PRDATA_i_1),
.prdata_2(PRDATA_i_2),
.prdata_3(PRDATA_i_3),
.prdata_4(PRDATA_i_4),
.prdata_5(PRDATA_i_5),
.prdata_6(PRDATA_i_6),
.prdata_7(PRDATA_i_7),
.prdata_8(PRDATA_i_8),
.prdata_9(PRDATA_i_9),
.prdata_10(PRDATA_CSR)
);

apb_csr #(.DW(DW), .AW(AW),.REGISTER_ADDR(SLAVE10_BASE_ADDR)) u_apb_csr(
.PRESETn(PRESETn_i),
.PCLK(PCLK_i),
.PSEL(PSEL_CSR),
.PENABLE(PENABLE_o),
.PWRITE(PWRITE_o),
.PADDR(PADDR_o),
.PWDATA(PWDATA_o),
.PRDATA(PRDATA_CSR),
.PREADY(PREADY_CSR),
.PSLVRR(PSLVERR_CSR),
.use_mwerr_resp(use_m_err_resp),
.wr_rd_ratio(ratio)
);

endmodule

