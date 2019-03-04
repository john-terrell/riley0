module uart(
	input reset,
	input cpu_clock,
	input uart_clock,
	input enable,				// Active Low
	input [15:0] address,
	inout [7:0] data,
	input write_enable,		// Active Low
	output irq,
	input tx,
	output rx
	);
		
endmodule
