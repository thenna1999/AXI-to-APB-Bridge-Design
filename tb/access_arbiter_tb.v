`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 00:53:34
// Design Name: 
// Module Name: access_arbiter_tb
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


module apb_access_arbiter_tb;

reg clk,rstn,wr_avail,wr,ra_avail,rd_avail,rd;
reg [2:0] ratio;
wire wr_en,rd_en;

apb_access_arbiter dut(clk,rstn,wr_avail,wr,ra_avail,rd_avail,rd,ratio,wr_en,rd_en);

initial
 begin	
  clk = 1'B0;
  forever
  #5 clk = ~clk;
 end

  task resetn;
	 begin
		 @(negedge clk) rstn = 1'b0;
		 @(negedge clk) rstn = 1'b1;
          end
  endtask

  task only_read;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b011;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b01;
		  {wr_avail,ra_avail,rd_avail} = 3'b000;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
	  end
  endtask

    task only_write;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b100;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b10;
		  {wr_avail,ra_avail,rd_avail} = 3'b000;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
	  end
  endtask

   task csr_000;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b111; ratio = 3'b000;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b01;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
		  @(negedge clk);
		  {wr,rd} = 2'b10;{wr_avail,ra_avail,rd_avail} = 3'b000; ratio = 3'b001;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
	  end
  endtask

  task csr_001;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b111; ratio = 3'b001;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b01;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
		  @(negedge clk);
		  {wr,rd} = 2'b10;{wr_avail,ra_avail,rd_avail} = 3'b000; ratio = 3'b101;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
	  end
  endtask

  task csr_010;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b111; ratio = 3'b010;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b01;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
		   @(negedge clk);
		  {wr,rd} = 2'b01;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
		  @(negedge clk);
		  {wr,rd} = 2'b10;{wr_avail,ra_avail,rd_avail} = 3'b000; ratio = 3'b001;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
	  end
  endtask

  task csr_011;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b111; ratio = 3'b011;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b01;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
		  @(negedge clk);
		  {wr,rd} = 2'b01;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
		  @(negedge clk);
		  {wr,rd} = 2'b01;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
		  @(negedge clk);
		  {wr,rd} = 2'b10;{wr_avail,ra_avail,rd_avail} = 3'b000; ratio = 3'b001;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
	  end
  endtask

     task csr_100;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b111; ratio = 3'b100;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b10;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
		  @(negedge clk);
		  {wr,rd} = 2'b01;{wr_avail,ra_avail,rd_avail} = 3'b000; ratio = 3'b001;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
	  end
  endtask

  task csr_101;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b111; ratio = 3'b101;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b10;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
		  @(negedge clk);
		  {wr,rd} = 2'b01;{wr_avail,ra_avail,rd_avail} = 3'b000; ratio = 3'b001;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
	  end
  endtask

  task csr_110;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b111; ratio = 3'b110;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b10;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
		   @(negedge clk);
		  {wr,rd} = 2'b10;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
		  @(negedge clk);
		  {wr,rd} = 2'b01;{wr_avail,ra_avail,rd_avail} = 3'b000; ratio = 3'b001;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
	  end
  endtask

  task csr_111;
	  begin
		  @(negedge clk);
		  {wr_avail,ra_avail,rd_avail} = 3'b111; ratio = 3'b111;
		  @(negedge clk);
		  @(negedge clk);
		  {wr,rd} = 2'b10;
		  @(negedge clk);
		  {wr,rd} = 2'b00; 
		  @(negedge clk);
		  {wr,rd} = 2'b10;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
		  @(negedge clk);
		  {wr,rd} = 2'b10;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
		  @(negedge clk);
		  {wr,rd} = 2'b01;{wr_avail,ra_avail,rd_avail} = 3'b000; ratio = 3'b001;
		  @(negedge clk);
		  {wr,rd} = 2'b00;
	  end
  endtask


  initial
  begin
	  resetn;
	  {wr_avail,wr,ra_avail,rd_avail,rd} = 5'd0;
	  ratio = 3'd0;

	  only_read;
	  only_write;
	  @(negedge clk);
	  csr_001;
	  @(negedge clk);
	  csr_000;
	  @(negedge clk);
	  csr_010;
	  @(negedge clk);
	  csr_011;
	  @(negedge clk);
	  csr_100;
	  @(negedge clk);
	  csr_101;
	  @(negedge clk);
	  csr_110;
	  @(negedge clk);
	  csr_111;

	  #100;
	  $finish;
	  
  end

endmodule

