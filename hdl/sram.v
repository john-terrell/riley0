`timescale 1ns/1ps
//-----------------------------------------------------
// Design Name : ram_sp_ar_aw
// File Name   : ram_sp_ar_aw.v
// Function    : Asynchronous read write RAM
// Coder       : Deepak Kumar Tala
// Source      : http://www.asic-world.com/code/hdl_models/ram_sp_ar_aw.v
//-----------------------------------------------------

module sram (
	address, 		// Address Input
	data, 			// Data bi-directional
	chip_enable, 	// Chip Select (active low)
	write_enable, 	// Write Enable/Read Enable (write on low)
	output_enable 	// Output Enable (active low)
	);

	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 8;
	parameter RAM_DEPTH = 4096;

	//--------------Input Ports-----------------------
	input [ADDR_WIDTH-1:0] address;
	input chip_enable;
	input write_enable;
	input output_enable;

	//--------------Inout Ports-----------------------
	inout [DATA_WIDTH-1:0]  data       ;

	//--------------Internal variables----------------
	reg [DATA_WIDTH-1:0]   data_out ;
	reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

	//--------------Code Starts Here------------------

	// Tri-State Buffer control
	// output : When write_enable = 0, output_enable = 1, chip_enable = 1
	assign data = (!output_enable && write_enable) ? data_out : 8'bz;

	// Memory Write Block
	// Write Operation : When write_enable = 1, chip_enable = 1
	always @ (address or data or chip_enable or write_enable or output_enable)
	begin : MEM_WRITE
	   if ( !chip_enable && !write_enable && output_enable) begin
		   mem[address] = data;
	   end
	end

	// Memory Read Block
	// Read Operation : When write_enable = 0, output_enable = 1, chip_enable = 1
	always @ (address or chip_enable or write_enable or output_enable)
	begin : MEM_READ
		if (!chip_enable && write_enable && !output_enable)  begin
			 data_out = mem[address];
		end
	end

endmodule // End of Module ram_sp_ar_aw
