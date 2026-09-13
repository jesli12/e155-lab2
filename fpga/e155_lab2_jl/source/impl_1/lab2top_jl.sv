// Jessica Li  |  jesli@g.hmc.edu
// 09/12/2026
// This is the top-level module, taking input from 4 switches and output on 3 LEDs and a 7 segment display.
// It contains internal clock initialization (high-speed oscillator) and the switch-to-LED logic.
// The top-level module also uses another module for switch-to-7-segment display, and another module for the counter.


module lab2top_jl(
	input   logic  [3:0] sw1,
	input   logic  [3:0] sw2,
	input   logic  [3:0] col,
	input   logic nreset,
	input   logic enable,  // do i make these signals internal?
	output  logic  [1:0] pwr,
	output  logic  [6:0] seg,
	output  logic  [3:0] row,
	output  logic  [3:0] led  //
);

	logic int_osc;
	logic seg_clk;
	logic [3:0] sw; // this is the single set of switches that get sent into the single seven segment module
	
	// Internal high-speed oscillator, 48 MHz clock generated in FPGA by HSOSC primitive
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	// counter for timing multiplexer (120 Hz)
	counter #(
		.WIDTH(28),
		.MAX_COUNT(200_00_000) // MAX_COUNT = 200_000 = a signal on/off frequency of 120 Hz
	) segment_counter (
		.osc (int_osc), 
		.nrst (nreset),  
		.en (enable),
		.clk (seg_clk),
		.count () // purposely ignored, no use
	);
	
	// switch-to-7 segment display module
	sev_seg segment_decoder(
		.switch (sw), 
		.segment (seg) // this already outputs for segment display
	);
	
	assign pwr = (seg_clk == 1'b0)? 2'b10 : 2'b01; // MUX: seg_clk == 0 --> pwr = 10 powers first display, seg_clk ==1 --> pwr = 01 powers second display
	assign sw = (seg_clk == 1'b0)? sw1 : sw2;	   // MUX: seg_clk == 0 --> sw1 + first display on, seg_clk ==1 --> sw2 + second display on (see above)
	
	// #### KEYPAD!! ####
	
	// connect submodule SCAN: input = osc_count reset enable, output = row[3:0] to keypad | outputs: 1000 (row[0]), 0100 (row[1]), 0010 (row[2]), and 0001 (row[3])
	
	scanner scanning(
		.int_osc (int_osc), 
		.nreset (nreset), 
		.enable (enable),
		.rows (row)
	);
	
	
	// Note: col output is 0 when button pressed & row powered, pulled up to 1 when not pressed due to transistors
	assign led[0] = (col[0] == 0)? 1'b1 : 1'b0;
	assign led[1] = (col[1] == 0)? 1'b1 : 1'b0;
	assign led[2] = (col[2] == 0)? 1'b1 : 1'b0;
	assign led[3] = (col[3] == 0)? 1'b1 : 1'b0;
	

endmodule