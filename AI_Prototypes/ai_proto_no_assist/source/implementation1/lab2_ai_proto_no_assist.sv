module lab2_ai_proto_no_assist #(
    parameter integer CLK_FREQ_HZ = 50_000_000, // Input clock frequency in Hz
    parameter integer REFRESH_HZ  = 200            // Desired overall refresh rate
)(
    input  logic       clk,         // System clock
    input  logic       rst,         // Active-high asynchronous reset
    input  logic [3:0] in0,         // 4-bit data for Display 0
    input  logic [3:0] in1,         // 4-bit data for Display 1
    output logic [6:0] seg0_n,      // Active-low segment outputs for Display 0 {g,f,e,d,c,b,a}
    output logic [6:0] seg1_n,      // Active-low segment outputs for Display 1 {g,f,e,d,c,b,a}
    output logic       an0,         // Anode control for Display 0 (Active HIGH)
    output logic       an1          // Anode control for Display 1 (Active HIGH)
);

    // Calculate clock division limit for digit toggle (switches at 2 * REFRESH_HZ)
    localparam integer TOGGLE_COUNT = CLK_FREQ_HZ / (REFRESH_HZ * 2);

    logic [$clog2(TOGGLE_COUNT)-1:0] clk_cnt;
    logic                            active_digit; // 0: Display 0, 1: Display 1
    logic [3:0]                      mux_data;
    logic [6:0]                      decoded_seg_n;

    // -------------------------------------------------------------------------
    // 1. Refresh Counter & Digit Select
    // -------------------------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_cnt      <= '0;
            active_digit <= 1'b0;
        end else begin
            if (clk_cnt == TOGGLE_COUNT - 1) begin
                clk_cnt      <= '0;
                active_digit <= ~active_digit;
            end else begin
                clk_cnt <= clk_cnt + 1'b1;
            end
        end
    end

    // -------------------------------------------------------------------------
    // 2. Input Data Multiplexer
    // -------------------------------------------------------------------------
    always_comb begin
        mux_data = active_digit ? in1 : in0;
    end

    // -------------------------------------------------------------------------
    // 3. Shared Hexadecimal to Active-Low 7-Segment Decoder
    // Segments layout: {g, f, e, d, c, b, a}
    // -------------------------------------------------------------------------
    always_comb begin
        case (mux_data)
            4'h0:    decoded_seg_n = 7'b100_0000; // 0
            4'h1:    decoded_seg_n = 7'b111_1001; // 1
            4'h2:    decoded_seg_n = 7'b010_0100; // 2
            4'h3:    decoded_seg_n = 7'b011_0000; // 3
            4'h4:    decoded_seg_n = 7'b001_1001; // 4
            4'h5:    decoded_seg_n = 7'b010_0010; // 5
            4'h6:    decoded_seg_n = 7'b010_0000; // 6
            4'h7:    decoded_seg_n = 7'b111_1000; // 7
            4'h8:    decoded_seg_n = 7'b000_0000; // 8
            4'h9:    decoded_seg_n = 7'b001_0000; // 9
            4'hA:    decoded_seg_n = 7'b000_1000; // A
            4'hB:    decoded_seg_n = 7'b000_0011; // b
            4'hC:    decoded_seg_n = 7'b100_0110; // C
            4'hD:    decoded_seg_n = 7'b010_0001; // d
            4'hE:    decoded_seg_n = 7'b000_0110; // E
            4'hF:    decoded_seg_n = 7'b000_1110; // F
            default: decoded_seg_n = 7'b111_1111; // All OFF
        endcase
    end

    // -------------------------------------------------------------------------
    // 4. Output Demultiplexer & Anode Driving
    // -------------------------------------------------------------------------
    always_comb begin
        if (!active_digit) begin
            // Display 0 Active
            an0     = 1'b1;
            an1     = 1'b0;
            seg0_n  = decoded_seg_n;
            seg1_n  = 7'b111_1111; // Blank Display 1 (High impedance/OFF)
        end else begin
            // Display 1 Active
            an0     = 1'b0;
            an1     = 1'b1;
            seg0_n  = 7'b111_1111; // Blank Display 0 (High impedance/OFF)
            seg1_n  = decoded_seg_n;
        end
    end

endmodule