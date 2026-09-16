// Jessica Li  |  jesli@g.hmc.edu
// 09/15/2026
// This is a test bench the top-level module of lab 2.
/* The following tests include:
	1. LED driving functionality (column input to LEDs).
	2. Exercise multiplexing functionality (7-segment switches and displays)
*/

`timescale 1 ns/1 ns

module lab2top_jl_tb();
	logic  [3:0] sw1s;
	logic  [3:0] sw2s;
	logic  [3:0] cols;
	logic  nrst;
	logic  en;
	logic  [1:0] pwrs;
	logic  [6:0] segs;
	logic  [3:0] rows;
	logic  [3:0] leds;
	
	lab2top_jl dut(
		.sw1 (sw1s), 
		.sw2 (sw2s), 
		.col (cols),
		.nreset (nrst),
		.enable (en),
		.pwr (pwrs),
		.seg (segs),
		.row (rows),
		.led (leds)
	);
	
	initial begin
		nrst = 0; //nrst is active low
		en = 1;
		#20;
		nrst = 1;
		sw1s = 4'b1111;
		sw2s = 4'b0000;
		
		// ### 1. LED driving functionality (column input to LEDs)###############################################################################
		$display("### Test 1. LED Driving functionality from column input. ");
		cols = 4'b0111;
		#20;
		assert (leds == ~cols)
			$display ("1a. Success. Time: %0t.", $time);
		else $error("1a. Failure. Time: %0t.", $time);
		cols = 4'b1011;
		#20;
		assert (leds == ~cols)
			$display ("1b. Success. Time: %0t.", $time);
		else $error("1b. Failure. Time: %0t.", $time);
		cols = 4'b1101;
		#20;
		assert (leds == ~cols)
			$display ("1c. Success. Time: %0t.", $time);
		else $error("1c. Failure. Time: %0t.", $time);
		cols = 4'b1110;
		#20;
		assert (leds == ~cols)
			$display ("1d. Success. Time: %0t.", $time);
		else $error("1d. Failure. Time: %0t.", $time);
		cols = 4'b0011;
		#20;
		assert (leds == ~cols)
			$display ("1e. Success. Time: %0t.", $time);
		else $error("1e. Failure. Time: %0t.", $time);
		cols = 4'b0101;
		#20;
		assert (leds == ~cols)
			$display ("1f. Success. Time: %0t.", $time);
		else $error("1f. Failure. Time: %0t.", $time);
		cols = 4'b1111;
		#20;
		
		// ### 2. Exercise multiplexing functionality (7-segment switches and displays)#########################################################
		$display("### Test 2. Exercise multiplexing functionality (7-segment switches and displays)");
		#18_000_000;
		sw1s = 4'b1000;
		sw2s = 4'b0001;
		#500_000_000;
		#110_000_000;
		nrst = 0;
		#18_000_000;
		nrst = 1;
		en = 0;
		#150_000_000;
		en = 1;
		
		$stop;
	end
endmodule