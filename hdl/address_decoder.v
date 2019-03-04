`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module address_decoder(	
	input [15:0] address,
	output ram_sel,
	output io_sel,
	output rom_sel
	);

wire [7:0] upper_nibble_enable;
	
ic_74138 u7(
	.A(address[14:12]),
	.Y(upper_nibble_enable),
	.E1(1'b0),
	.E2(1'b0),
	.E3(address[15])
	);

assign io_sel = upper_nibble_enable[5];
	
wire rom_line_and;	
	
ic_7400 u8(
	.A1(),
	.B1(),
	.Y1(),
	.A2(io_sel),
	.B2(rom_sel),
	.Y2(ram_sel),
	.A3(upper_nibble_enable[6]),  // A3/B3 and A4/B4 are used to implement an AND gate.
	.B3(upper_nibble_enable[7]),
	.Y3(rom_line_and),
	.A4(rom_line_and),
	.B4(rom_line_and),
	.Y4(rom_sel)
	);

endmodule
