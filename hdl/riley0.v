module riley0(
	input CLOCK_50_IN,
	input RESET,
	output UART_RX,
	output UART_TX
	);

///////////////////////////////////////////////////////////////////////////////
// Clocks
wire cpu_clock;	// 5 Mhz
wire uart_clock;	// 1.15220 Mhz
	
pll clocks(
	.inclk0(CLOCK_50_IN),
	.c0(cpu_clock),
	.c1(uart_clock)
	);
	
///////////////////////////////////////////////////////////////////////////////
// CPU
wire [15:0] address;	// Address bus
wire [7:0] data;		// Data bus
wire write_enable;   // write enable
wire irq;				// interrupt request
wire nmi;      		// non-maskable interrupt request
wire rdy;				// Ready signal. Pauses CPU when RDY=0 

cpu_65c02 cpu(
	.clk(cpu_clock),
	.reset(RESET),
	.AB(address),
	.DI(data),
	.DO(data),
	.WE(write_enable),
	.IRQ(irq),
	.NMI(nmi),
	.RDY(rdy)
	);

///////////////////////////////////////////////////////////////////////////////
// Address Decoder
wire ram_sel;			// RAM chip select
wire io_sel;			// IO chip select
wire rom_sel;			// ROM chip select

address_decoder address_decoder(
	.address(address),
	.ram_sel(ram_sel),
	.rom_sel(rom_sel),
	.io_sel(io_sel)
	);

///////////////////////////////////////////////////////////////////////////////
// RAM
sram ram(
	.address(address),
	.data(data),
	.chip_enable(ram_sel),
	.write_enable(write_enable),
	.output_enable(ram_sel)
	);	
	
///////////////////////////////////////////////////////////////////////////////
// UART/Console
uart console(
	.cpu_clock(cpu_clock),
	.uart_clock(uart_clock),
	.reset(reset),
	.enable(io_sel),
	.address(address),
	.data(data),
	.irq(irq),
	.tx(UART_TX),
	.rx(UART_RX)
	);
	
endmodule
