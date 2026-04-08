`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 01:16:50
// Design Name: 
// Module Name: axi4_to_apb4_tb
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


module axi4_to_apb4_tb #(parameter AW=32,
		      parameter DW=32,
		      parameter IW = 4,
		      parameter LW = 4,
		      SLAVE0_BASE_ADDR = 32'h4000_0000,
		      SLAVE1_BASE_ADDR = 32'h4000_1000,
		      SLAVE2_BASE_ADDR = 32'h4000_2000,
		      SLAVE3_BASE_ADDR = 32'h4000_3000,
		      SLAVE4_BASE_ADDR = 32'h4000_4000,
		      SLAVE5_BASE_ADDR = 32'h4000_5000,
		      SLAVE6_BASE_ADDR = 32'h4000_6000,
		      SLAVE7_BASE_ADDR = 32'h4000_7000,
		      SLAVE8_BASE_ADDR = 32'h4000_8000,
		      SLAVE9_BASE_ADDR = 32'h4000_9000,
		      SLAVE10_BASE_ADDR = 32'h4000_A000,
		      OFFSET = 32'h0000_0FFF);
	

	//SLAVE SIGNALS
	reg ACLK_i;
	reg ARESETn_i;

	//WRITE ADDRESS CHANNEL
	reg [IW-1:0] AWID_i;
	reg [AW-1:0] AWADDR_i;
	reg [LW-1:0] AWLEN_i;
	reg [2:0] AWSIZE_i;
	reg [1:0] AWBURST_i;
	reg [2:0] AWPROT_i;
	reg AWVALID_i;
	wire AWREADY_o;

	//WRITE DATA CHANNEL	
	reg [DW-1:0] WDATA_i;
	reg [(DW/8)-1:0] WSTRB_i;
	reg WLAST_i;
	reg WVALID_i;
	wire WREADY_o;

	//WRITE RESPONSE CHANNEL
	wire [IW-1:0] BID_o;  //4 BIT
	wire [1:0] BRESP_o;
	wire BVALID_o;
	reg BREADY_i;

			//READ ADDRESS CHANNEL
	reg [IW-1:0] ARID_i;  //4 BIT
	reg [AW-1:0] ARADDR_i; //32 BIT
	reg [LW-1:0] ARLEN_i; //4 BIT
	reg [2:0] ARSIZE_i;
	reg [1:0] ARBURST_i;
	reg [2:0] ARPROT_i;
	reg ARVALID_i;
	wire ARREADY_o;

	//READ DATA CHANNEL
	wire [IW-1:0] RID_o; //4 BIT
	wire [DW-1:0] RDATA_o; // 32 BIT
	wire [1:0] RRESP_o;
	wire RLAST_o;
	wire RVALID_o;
	reg RREADY_i;

	//FROM APB
	reg PCLK_i,PRESETn_i;
	
	wire [9:0] PSELx_o;
	//wire decode_err_o;
	wire PWRITE_o,PENABLE_o;
	wire [2:0] PPROT_o;
	wire [AW-1:0] PADDR_o;
	wire [DW-1:0] PWDATA_o;
	wire [(DW/8)-1:0] PSTRB_o;
	reg [9:0] PSLVERR_i,PREADY_i;
	reg [DW-1:0] PRDATA_i_0,PRDATA_i_1,PRDATA_i_2,PRDATA_i_3,PRDATA_i_4,PRDATA_i_5,PRDATA_i_6,PRDATA_i_7,PRDATA_i_8,PRDATA_i_9;	

axi4_to_apb4 dut(PSELx_o,PCLK_i,PRESETn_i,PENABLE_o,PADDR_o,PPROT_o,PWRITE_o,PWDATA_o,PSTRB_o,PREADY_i,PRDATA_i_0,PRDATA_i_1,PRDATA_i_2,PRDATA_i_3,PRDATA_i_4,PRDATA_i_5,PRDATA_i_6,PRDATA_i_7,PRDATA_i_8,PRDATA_i_9,PSLVERR_i,ACLK_i,ARESETn_i,AWID_i,AWADDR_i,AWLEN_i,AWSIZE_i,AWBURST_i,AWPROT_i,AWVALID_i,AWREADY_o,WDATA_i,WSTRB_i,WVALID_i,WREADY_o,WLAST_i,BID_o,BRESP_o,BVALID_o,BREADY_i,ARID_i,ARADDR_i,ARLEN_i,ARSIZE_i,ARBURST_i,ARPROT_i,ARVALID_i,ARREADY_o,RID_o,RDATA_o,RRESP_o,RVALID_o,RREADY_i,RLAST_o );

	always #5 ACLK_i = ~ACLK_i; //AXI CLOCK
	always #10 PCLK_i = ~PCLK_i;//APB CLOCK

	task initialize;
		begin
			//SLAVE SIGNALS
			ACLK_i = 0;
			ARESETn_i = 1;

			//WRITE ADDRESS CHANNEL
			{AWID_i,AWADDR_i,AWLEN_i,AWSIZE_i,AWBURST_i,AWPROT_i,AWVALID_i} = 0;
				//output AWREADY_o,

			//WRITE DATA CHANNEL	
			{WDATA_i,WSTRB_i,WLAST_i,WVALID_i} = 0;
				//output WREADY_o,

			//WRITE RESPONSE CHANNEL
			//output [IW-1:0] BID_o,  //4 BIT
			//output [1:0] BRESP_o,
			//output BVALID_o,
			 BREADY_i = 0;

			 //READ ADDRESS CHANNEL
			{ARID_i,ARADDR_i,ARLEN_i,ARSIZE_i,ARBURST_i,ARPROT_i,ARVALID_i} =0;
				//output ARREADY_o,

			//READ DATA CHANNEL
			//output [IW-1:0] RID_o, //4 BIT
			//output [DW-1:0] RDATA_o, // 32 BIT
			//output [1:0] RRESP_o,
			//output RLAST_o,
			//output RVALID_o,
			 RREADY_i = 0;
			
			//FROM APB
			PCLK_i = 0;
			PRESETn_i = 1;

			/*output [9:0] PSELx_o,
			output decode_err_o,
			output PWRITE_o,PENABLE_o,
			output [2:0] PPROT_o,
			output [AW-1:0] PADDR_o,
			output [DW-1:0] PWDATA_o,
			output [(DW/8)-1:0] PSTRB_o,*/
			{PSLVERR_i,PREADY_i} = 0;
			{PRDATA_i_0,PRDATA_i_1,PRDATA_i_2,PRDATA_i_3,PRDATA_i_4,PRDATA_i_5,PRDATA_i_6,PRDATA_i_7,PRDATA_i_8,PRDATA_i_9} =0;

		end
	endtask

	task reset;
		begin
			#10;
			ARESETn_i = 0;
			PRESETn_i = 0;
			#40;
			ARESETn_i = 1;
			PRESETn_i = 1;

		end
	endtask


	task axi_write_address(input [IW-1:0] aw_id,input [AW-1:0] aw_addr,input [LW-1:0] aw_len, input [2:0] aw_size,input [1:0] aw_burst,input [2:0]aw_prot);
		begin
			@(negedge ACLK_i)
			AWID_i = aw_id;
			AWADDR_i = aw_addr;
			AWLEN_i = aw_len;
			AWSIZE_i = aw_size;
			AWBURST_i = aw_burst;
			AWPROT_i = aw_prot;
			AWVALID_i = 1'b1;

			wait(AWREADY_o)
			@(negedge ACLK_i)
			AWVALID_i = 1'b0;
			
		end
	endtask

	task axi_write_data(input  [LW-1:0] len);
		integer i;
		begin
			for(i=0;i<=len;i=i+1)
			begin
				@(negedge ACLK_i)
					WDATA_i=$random;
					WSTRB_i = 4'b1111;
					WVALID_i = 1'b1;
					if(i==len)
						WLAST_i = 1'b1;
					else
						WLAST_i = 1'b0;

				wait(WREADY_o)

				@(negedge ACLK_i)
					WVALID_i = 1'b0;
					WLAST_i = 1'b0;
			end
		end
	endtask

	task axi_write_response;
		begin
			@(negedge ACLK_i)
				BREADY_i = 1'b1;
			wait(BVALID_o)
			@(negedge ACLK_i)
				BREADY_i = 1'b0;
		end
	endtask


task axi_read_address(input [IW-1:0] ARID_ii,input [AW-1:0] ARADDR_ii,input [LW-1:0] ARLEN_ii,input [2:0] ARSIZE_ii,input [1:0] ARBURST_ii,input [2:0] ARPROT_ii);
	begin
		@(negedge ACLK_i);
		//@(posedge ACLK_i);
		ARID_i = ARID_ii;
		ARADDR_i = ARADDR_ii;
		ARLEN_i = ARLEN_ii;
		ARSIZE_i = ARSIZE_ii;
		ARBURST_i = ARBURST_ii;
		ARPROT_i = ARPROT_ii;
		ARVALID_i = 1'b1;
		wait(ARREADY_o)
		@(negedge ACLK_i);
		//@(posedge ACLK_i);
		ARVALID_i = 1'b0;
	end
endtask

task axi_read_data(input [LW-1:0] r_len);
	integer j;
	begin
		for(j=0; j <= r_len; j = j+1)
		  begin
		    @(negedge ACLK_i);
		    //@(posedge ACLK_i);
		    RREADY_i = 1'b1;
		    wait(RVALID_o)
		    //@(negedge ACLK_i);
		    @(posedge ACLK_i);
		    RREADY_i = 1'b0;
	          end
	  end
endtask
/*
	task axi_read_address(input [IW-1:0] ar_id,input [AW-1:0] ar_addr,input [LW-1:0] ar_len, input [2:0] ar_size,input [1:0] ar_burst,input [2:0]ar_prot);
		begin
			@(negedge ACLK_i)
			ARID_i = ar_id;
			ARADDR_i = ar_addr;
			ARLEN_i = ar_len;
			ARSIZE_i = ar_size;
			ARBURST_i = ar_burst;
			ARPROT_i = ar_prot;
			ARVALID_i = 1'b1;

			wait(ARREADY_o)
			@(negedge ACLK_i)
			ARVALID_i = 1'b0;
			
		end
	endtask

	task axi_read_data(input  [LW-1:0] r_len);
		integer i;
		begin
			for(i=0;i<=r_len;i=i+1)
			begin
				@(negedge ACLK_i)
					RREADY_i = 1'b1;

				wait(RVALID_o)

				@(posedge ACLK_i)
					RREADY_i = 1'b0;
			end
		end
	endtask
*/

	task apb_operation(input [LW-1:0] len,input resp);
		integer i;
		begin
			for(i=0;i<=len;i=i+1)
			begin
				@(negedge PCLK_i)
				wait(PSELx_o)
					begin
						if(PWRITE_o)
						  begin
							  case(PSELx_o)
								  10'b00_0000_0001: begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  		PREADY_i = 10'b00_0000_0001;
											PSLVERR_i = {9'b0,resp};
											  end
										    end
								  10'b00_0000_0010:begin
									 		 wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b00_0000_0010;
												PSLVERR_i = {8'b0,resp,1'b0};
											  end
										    end
								  10'b00_0000_0100:begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b00_0000_0100;
												PSLVERR_i = {7'b0,resp,2'b0};
											  end
										    end
								  10'b00_0000_1000:begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b00_0000_1000;
												PSLVERR_i = {6'b0,resp,3'b0};
											  end
										    end
								  10'b00_0001_0000:begin
											wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b00_0001_0000;
												PSLVERR_i = {5'b0,resp,4'b0};
											  end
										    end
								  10'b00_0010_0000:begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b00_0010_0000;
												PSLVERR_i = {4'b0,resp,5'b0};
											  end
										    end
								  10'b00_0100_0000:begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b00_0100_0000;
												PSLVERR_i = {3'b0,resp,6'b0};
											  end
										    end
								  10'b00_1000_0000:begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b00_1000_0000;
												PSLVERR_i = {2'b0,resp,7'b0};
											  end
										    end
								  10'b01_0000_0000:begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b01_0000_0000;
												PSLVERR_i = {1'b0,resp,8'b0};
											  end
										    end
								  10'b10_0000_0000:begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b10_0000_0000;
												PSLVERR_i = {resp,9'b0};
											  end
										    end
								  default         :begin
									  		wait(PENABLE_o)
											@(negedge PCLK_i)
											  begin
									  			PREADY_i = 10'b00_0000_0001;
												PSLVERR_i = 10'b0;
											  end
										    end
							  endcase
							  wait(PWRITE_o && PENABLE_o)
							  @(negedge PCLK_i)
							  PREADY_i = 10'b0;
						  end
						else
						  begin
							case(PSELx_o)
								  10'b00_0000_0001: begin
									  		PREADY_i = 10'b00_0000_0001;
											PSLVERR_i = {9'b0,resp};
											PRDATA_i_0 = $random;
										    end
								  10'b00_0000_0010:begin
									  		PREADY_i = 10'b00_0000_0010;
											PSLVERR_i = {8'b0,resp,1'b0};
											PRDATA_i_1 = $random;
										    end
								  10'b00_0000_0100:begin
									  		PREADY_i = 10'b00_0000_0100;
											PSLVERR_i = {7'b0,resp,2'b0};
											PRDATA_i_2 = $random;
										    end
								  10'b00_0000_1000:begin
									  		PREADY_i = 10'b00_0000_1000;
											PSLVERR_i = {6'b0,resp,3'b0};
											PRDATA_i_3 = $random;
										    end
								  10'b00_0001_0000:begin
									  		PREADY_i = 10'b00_0001_0000;
											PSLVERR_i = {5'b0,resp,4'b0};
											PRDATA_i_4 = $random;
										    end
								  10'b00_0010_0000:begin
									  		PREADY_i = 10'b00_0010_0000;
											PSLVERR_i = {4'b0,resp,5'b0};
											PRDATA_i_5 = $random;
										    end
								  10'b00_0100_0000:begin
									  		PREADY_i = 10'b00_0100_0000;
											PSLVERR_i = {3'b0,resp,6'b0};
											PRDATA_i_6 = $random;
										    end
								  10'b00_1000_0000:begin
									  		PREADY_i = 10'b00_1000_0000;
											PSLVERR_i = {2'b0,resp,7'b0};
											PRDATA_i_7 = $random;
										    end
								  10'b01_0000_0000:begin
									  		PREADY_i = 10'b01_0000_0000;
											PSLVERR_i = {1'b0,resp,8'b0};
											PRDATA_i_8 = $random;
										    end
								  10'b10_0000_0000:begin
									  		PREADY_i = 10'b10_0000_0000;
											PSLVERR_i = {resp,9'b0};
											PRDATA_i_9 = $random;
										    end
								  default         :begin
									  		PREADY_i = 10'b00_0000_0001;
											PSLVERR_i = 10'b0;
										    end
							endcase
							wait(!PWRITE_o && PENABLE_o)
							@(posedge PCLK_i)
								PREADY_i = 10'b0;						

						  end

					end
			end
		end
	endtask


	task axi_write_address_csr(input [IW-1:0] aw_id,input [2:0]aw_prot);
		begin
			@(negedge ACLK_i)
			AWID_i = aw_id;
			AWADDR_i = 32'h4000_A000;
			AWLEN_i = 4'h0;
			AWSIZE_i = 3'h0;
			AWBURST_i = 2'h0;
			AWPROT_i = aw_prot;
			AWVALID_i = 1'b1;

			wait(AWREADY_o)
			@(negedge ACLK_i)
			AWVALID_i = 1'b0;
			
		end
	endtask

	task axi_write_data_csr(input  [31:0] data);
		integer i;
		begin
			@(negedge ACLK_i)
				WDATA_i=data;
				WSTRB_i = 4'b1111;
				WVALID_i = 1'b1;
				WLAST_i = 1'b1;

			wait(WREADY_o)
			@(negedge ACLK_i)
				WVALID_i = 1'b0;
				WLAST_i = 1'b0;		
		end
	endtask



	initial
		begin
			//Operation: Initialize all input signals to zero
			initialize;

			//Operation: Reset the DUT
			reset;

			//Operation: write to the crsr(to set the
			//use_mwerr_resp as 0 and wr_rd_ratio as 0)
			fork
			       axi_write_address_csr(4'hA,3'h5);
			       axi_write_data_csr(32'h0000_0000);
			       axi_write_response;
			join

			//Operation: AXI Write Operation for 6th slave
			//call tasks axi_write_address, axi_write_data ,axi_write_response
			//and apb_operation in the fork join block for concurrent operation
			fork
				axi_write_address(4'hA,32'h4000_5040,4'h3,3'h2,2'h1,3'h5);
				axi_write_data(4'h3);
				axi_write_response;
				apb_operation(4'h3,1'b0); //len and resp
			join

			//Operation: AXI Write Operation for 8th slave
			fork
				axi_write_address(4'hA,32'h4000_7040,4'h3,3'h2,2'h1,3'h5);
				axi_write_data(4'h3);
				axi_write_response;
				apb_operation(4'h3,1'b0); //len and resp
			join


			//Operation: AXI write Operations to verify the
			//multiple outstanding transcations
			fork
				begin
					axi_write_address(4'hA,32'h4000_1040,4'h3,3'h2,2'h1,3'h5);
					axi_write_address(4'hA,32'h4000_4040,4'h3,3'h2,2'h1,3'h5);
					axi_write_address(4'hA,32'h4000_6040,4'h3,3'h2,2'h1,3'h5);
					axi_write_address(4'hA,32'h4000_8040,4'h3,3'h2,2'h1,3'h5);	
				end
				begin
					axi_write_data(4'h3);
					axi_write_data(4'h3);
					axi_write_data(4'h3);
					axi_write_data(4'h3);					
				end
				begin
					axi_write_response;
					axi_write_response;
					axi_write_response;
					axi_write_response;					
				end
				begin
					apb_operation(4'h3,1'b1); //len and resp
					apb_operation(4'h3,1'b1); //len and resp
					apb_operation(4'h3,1'b1); //len and resp
					apb_operation(4'h3,1'b1); //len and resp					
				end
			join

			//Operation: write to the crsr(to set the
			//use_mwerr_resp as 0 and wr_rd_ratio as 7)
			fork
			       axi_write_address_csr(4'hA,3'h5);
			       axi_write_data_csr(32'h8000_0007);
			       axi_write_response;
			join

			//operation : AXI Write Operation for 3rd slave
			fork
				   axi_write_address(4'hC,32'h4000_1040,4'h3,3'h2,2'h1,3'h5);
			           axi_write_data(4'h3);
			           axi_write_response;
				   apb_operation(4'h3,1'b1);
			join


			//Operation: read from configuration register
			fork
				axi_read_address(4'h5,32'h4000_A000,4'h3,3'h0,2'h1,3'h5);
				axi_read_data(4'h3); //len
			join	

			//Operation: AXI write operation to verify the decaode error
			//Here apb_operation task is not called because since
			//address is not of range design will not convert to
			//apb transacrtion and will return a BREsp as decode
			//error
			fork
				axi_write_address(4'hA,32'hCA45_7276,4'h7,3'h2,2'h1,3'h5);
				axi_write_data(4'h7);
				axi_write_response;
			join

			
			//#50;
			//OPERATION: AXI write opeartion FOR 5TH SLAVE
			fork
				   axi_write_address(4'hC,32'h4000_2040,4'h1,3'h2,2'h1,3'h5);
			           axi_write_data(4'h1);
			           axi_write_response;
				   apb_operation(4'h1,1'b1);
			join
			
			//Operation: AXI read operation to verify decode error
			fork
				axi_read_address(4'h5,32'hD346_F345,4'h3,3'h1,2'h0,3'h3);
				axi_read_data(4'h3); //len
			join

		        //operation: AXI read Operation for 7th slave
			fork
				axi_read_address(4'hB,32'h4000_6456,4'hB,3'h2,2'h1,3'h7);
				axi_read_data(4'hB); //len
				apb_operation(4'hB,1'b0);
			join




                         //Operation: write to the crsr(to set the
			//use_mwerr_resp as 0 and wr_rd_ratio as 6)
			fork
			       axi_write_address_csr(4'hA,3'h5);
			       axi_write_data_csr(32'h8000_0006);
			       axi_write_response;
			join
			#260;
			fork
				//operation: AXI read Operation for 10th slave
		                
				  axi_read_address(4'hB,32'h4000_9056,4'h5,3'h2,2'h1,3'h2);
				

				//OPERATION: AXI write opeartion FOR 10TH SLAVE
		   	        
				   axi_write_address(4'hC,32'h4000_9240,4'h5,3'h2,2'h1,3'h2);
			           axi_write_data(4'h5);			           			        
				
		        join

			fork
				apb_operation(4'D11,1'b0);
				axi_read_data(4'h5); //leN
				axi_write_response;
			join




			 //Operation: write to the crsr(to set the
			//use_mwerr_resp as 0 and wr_rd_ratio as 1)
			fork
			       axi_write_address_csr(4'hA,3'h5);
			       axi_write_data_csr(32'h8000_0001);
			       axi_write_response;
			join
			#260;
			fork
				//operation: AXI read Operation for 1th slave
		                
				  axi_read_address(4'hB,32'h4000_0006,4'h7,3'h2,2'h1,3'h2);
				

				//OPERATION: AXI write opeartion FOR 1TH SLAVE
		   	        
				   axi_write_address(4'hC,32'h4000_0740,4'h7,3'h2,2'h1,3'h2);
			           axi_write_data(4'h7);
			           			        				
		        join

			fork
				apb_operation(4'D15,1'b0);
				axi_read_data(4'h7); //leN
				axi_write_response;
			join




			 //Operation: write to the crsr(to set the
			//use_mwerr_resp as 0 and wr_rd_ratio as 3)
			fork
			       axi_write_address_csr(4'hA,3'h5);
			       axi_write_data_csr(32'h8000_0003);
			       axi_write_response;
			join
			#260;
			fork
				//operation: AXI read Operation for 5th slave
		                
				  axi_read_address(4'hB,32'h4000_6056,4'h6,3'h2,2'h1,3'h2);
				

				//OPERATION: AXI write opeartion FOR 5TH SLAVE
		   	        
				   axi_write_address(4'hC,32'h4000_6640,4'h6,3'h2,2'h1,3'h2);
			           axi_write_data(4'h6);
			           				
		        join

			fork
				apb_operation(4'D13,1'b0);
				axi_read_data(4'h6); //leN
				axi_write_response;
			join




			 //Operation: write to the crsr(to set the
			//use_mwerr_resp as 1 and wr_rd_ratio as 4)
			fork
			       axi_write_address_csr(4'hA,3'h5);
			       axi_write_data_csr(32'h8000_0004);
			       axi_write_response;
			join
			#260;
			fork
				//operation: AXI read Operation for 8th slave
		                
				  axi_read_address(4'hB,32'h4000_7006,4'h2,3'h2,2'h1,3'h2);
				

				//OPERATION: AXI write opeartion FOR 8TH SLAVE
		          
				   axi_write_address(4'hC,32'h4000_7740,4'h2,3'h2,2'h1,3'h2);
			           axi_write_data(4'h2);
			           			
		        join

			fork
				apb_operation(4'D5,1'b0);
				axi_read_data(4'h2); //leN
				axi_write_response;
			join

			//Operation: read from configuration register
			fork
				axi_read_address(4'h5,32'h4000_A000,4'h1,3'h0,2'h1,3'h5);
				axi_read_data(4'h1); //len
			join

			 //Operation: AXI read Operations to verify the
			//multiple outstanding transcations
			fork
				begin
					axi_read_address(4'hA,32'h4000_1040,4'h3,3'h2,2'h1,3'h5);
					axi_read_address(4'hA,32'h4000_2040,4'h3,3'h2,2'h1,3'h5);
					axi_read_address(4'hA,32'h4000_3040,4'h3,3'h2,2'h1,3'h5);
					axi_read_address(4'hA,32'h4000_4040,4'h3,3'h2,2'h1,3'h5);	
				end

				begin
					axi_read_data(4'h3);
					axi_read_data(4'h3);
					axi_read_data(4'h3);
					axi_read_data(4'h3);					
				end
				
				begin
					apb_operation(4'h3,1'b1); //len and resp
					apb_operation(4'h3,1'b1); //len and resp
					apb_operation(4'h3,1'b1); //len and resp
					apb_operation(4'h3,1'b1); //len and resp					
				end
			join

			//Operation: read from configuration register
			fork
				axi_read_address(4'h5,32'h4000_A000,4'h1,3'h0,2'h1,3'h5);
				axi_read_data(4'h1); //len
			join

		        #1000;
			//Operation: Reset the DUT
			reset;	

			#1000 $finish;
		end

	initial 
		begin
			$dumpfile("wave_top_module.vcd");
			$dumpvars(0,axi4_to_apb4_tb);
		end

endmodule
