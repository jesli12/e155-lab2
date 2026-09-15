// Jessica Li  |  jesli@g.hmc.edu
// 09/13/2026
// This is the top-level module, taking input from 2 sets of 4 switches, each set displaying a corresponding hex number on the two 7 segment displays.
// It contains internal clock initialization (high-speed oscillator) and the keypad-column-to-LED logic.
// The top-level module also uses another module for switch-to-7-segment display, another module for the counter, and lastly the scanner module for the keypad.


module lab2top_jl(
	input   logic  [3:0] sw1,
	input   logic  [3:0] sw2,
	input   logic  [3:0] col,
	input   logic nreset,
	input   logic enable, 
	output  logic  [1:0] pwr,
	output  logic  [6:0] seg,
	output  logic  [3:0] row,
	output  logic  [3:0] led 
);

	logic int_osc;
	logic seg_clk;
	logic [3:0] sw; // this is the single set of switches that get sent into the single seven segment module
	
	// Internal high-speed oscillator, 48 MHz clock generated in FPGA by HSOSC primitive
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	// counter for timing multiplexer (120 Hz)
	counter #(
		.WIDTH(28),
		.MAX_COUNT(200_000) // MAX_COUNT = 200_000 = a signal on/off frequency of 120 Hz
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
	
	
	assign pwr[0] = seg_clk;
	assign pwr[1] = ~seg_clk;
	assign sw = (seg_clk)? sw1 : sw2;	   // MUX: seg_clk == 0 --> sw1 + first display on, seg_clk ==1 --> sw2 + second display on (see above)
	
	// #### KEYPAD!! ####
	
	//submodule scanner: input = osc_count reset enable, output = row[3:0] to keypad | outputs: 1000 (row[0]), 0100 (row[1]), 0010 (row[2]), and 0001 (row[3])
	
	scanner scanning(
		.int_osc (int_osc), 
		.nreset (nreset), 
		.enable (enable),
		.rows (row)
	);
	
	// Note: col output is 0 when button pressed & row powered, pulled up to 1 when not pressed due to transistors
	assign led = ~(col);


endmodule