// Jessica Li  |  jesli@g.hmc.edu
// 09/15/2026
// This is a test bench the top-level module of lab 2.
/* The following tests include:
	1. Exercise multiplexing functionality
	2. LED driving functionality.
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
		#20
		nrst = 1;
		// ### 1. Does the Scanner submodule exert all 4 output transitions? ###############################################################################
		// 20 ns per posedge if osc (counter increment) 20 ns * 6_000_000 = time per cycle = 120_000_000
		
		$display("### Test 1. Does the Scanner submodule exert all 4 output transitions? ");
		#500; // avoiding edge by 500 ns
		assert (row == 4'b1000)
			$display ("1a. Success Output Row 0: row = 1000. Time: %0t.", $time);
		else $error("1a. Failure Output Row 0: row does not equal 1000, but it should be the first state. Time: %0t.", $time);
		#120_000_000
		
		$stop;
	end
endmodule