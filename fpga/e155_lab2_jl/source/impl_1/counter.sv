// Jessica Li  |  jesli@g.hmc.edu
// 09/12/2026 (just name changes from lab1, no major changes)
// This is a submodule
// It contains a simple clock divider that takes the HSOSC input

module counter
	#(parameter WIDTH = 25,
		MAX_COUNT = 10_000_000) (
	input   logic   osc, nrst, en,
	output  logic   clk,
	output  logic   [WIDTH-1:0] count
);

	logic clk_state = 0;
	// logic [WIDTH-1:0] count = 0; // check this!
	
	always_ff @(posedge osc) begin
			if (~nrst) begin
				count <= 0;
				clk_state <= 0;
				end
			else if (en) begin
				if (count >= (MAX_COUNT-1)) begin //for exact timing MAX_COUNT - 1 to account for the cycle it takes to register that it hit max
					clk_state <= ~clk_state; // toggles clk state on or off once desired cycle time up
					count <= 0;
				end
				else begin
					count <= count + 1'b1;
				end
			end
	end
		
	assign clk = clk_state; 

endmodule