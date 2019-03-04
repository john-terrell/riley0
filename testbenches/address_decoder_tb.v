`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module address_decoder_tb;

	reg [15:0] address;
	wire ram_sel;
	wire rom_sel;
	wire io_sel;
	
	reg clk;
	
	// duration for each bit = 20 * timescale = 20 * 1 ns  = 20ns
	localparam period = 100;
	 
	address_decoder uut(
		.address(address),
		.ram_sel(ram_sel),
		.rom_sel(rom_sel),
		.io_sel(io_sel)
		);

	always 
	begin
		 clk = 1'b1; 
		 #50; // high for 20 * timescale = 20 ns

		 clk = 1'b0;
		 #50; // low for 20 * timescale = 20 ns
	end		
	
	integer a;
	always @(posedge clk)
	begin
		// Validate the RAM banks
		for (a = 0; a < 16'hD000; a = a + 16'h1000)
		begin
			address = a;
			$display("Testing Address Decoder for RAM bank: %h...", address);
			#period; // wait for period
			// display message if output not matched
			if(ram_sel != 0 || rom_sel != 1 || io_sel != 1)  
				$stop;
		end

		// Validate the IO bank
		address = 16'b1101000000000000;
		$display("Testing Address Decoder for IO  bank: %h...", address);
		#period; // wait for period
		// display message if output not matched
		if(ram_sel != 1 || rom_sel != 1 || io_sel != 0)  
			$stop;

		// Validate the ROM banks
		for (a = 16'hE000; a <= 16'hF000; a = a + 16'h1000)
		begin
			address = a;
			$display("Testing Address decoder for ROM bank: %h...", address);
			#period; // wait for period
			// display message if output not matched
			if(ram_sel != 1 || rom_sel != 0 || io_sel != 1)  
				$stop;
		end

		$stop;   // end of simulation
	end
endmodule
