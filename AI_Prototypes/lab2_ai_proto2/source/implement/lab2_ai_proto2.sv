module lab2_ai_proto2 (
    input  logic       clk,
    input  logic       rst,
    input  logic       en,       // Kept in port list for compatibility
    input  logic [3:0] in0,
    input  logic [3:0] in1,
    output logic [6:0] display0,
    output logic [6:0] display1
);

    logic       select;
    logic [3:0] mux_in;
    logic [6:0] decoded_seg;
    logic       internal_en;

    // Tie enable high internally if port is left unconnected/unused
    assign internal_en = en | 1'b1; 

    // Instantiate oscillator/counter
    counter_2_4Hz osc (
        .clk(clk),
        .rst(rst),
        .en(internal_en),
        .led(select)
    );

    // Mux input selection based on counter state
    always_comb begin
        if (select) begin
            mux_in = in1;
        end else begin
            mux_in = in0;
        end
    end

    // Instantiate 7-segment decoder
    switch_to_display decoder (
        .switch(mux_in),
        .segment(decoded_seg)
    );

    // Register outputs for display time-multiplexing
    always_ff @(posedge clk) begin
        if (~rst) begin
            display0 <= 7'b1111111; // Off (Common Anode)[cite: 2]
            display1 <= 7'b1111111; // Off (Common Anode)[cite: 2]
        end else begin
            if (select) begin
                display1 <= decoded_seg;
            end else begin
                display0 <= decoded_seg;
            end
        end
    end

endmodule