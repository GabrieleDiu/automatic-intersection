module SevenSegmentController (
    input wire clk_i,       // Clock
    input wire rst_i,       // Reset
    input wire service_i ,  // Service signal
    input wire [7:0] counter, // Counter with maximum 2 digits
    output reg [7:0] seg1,  // Register for the first 7-segment display
    output reg [7:0] seg2   // Register for the second 7-segment display
);

always @(posedge clk_i or posedge rst_i) begin
    if (~rst_i) begin
        // Reset 
        seg1 <= 8'b11111111;
        seg2 <= 8'b11111111;
    end else begin
        // Check if service signal is active
        if (~service_i) begin
            // Service mode, set segments to display a dot
            seg1 <= 8'b00000010;
            seg2 <= 8'b00000010;
        end else begin
            // Normal operation mode, display the counter value
            // First digit
            case(counter / 10)
                4'b0000: seg1 <= 8'b11111100; // 0
                4'b0001: seg1 <= 8'b01100000; // 1
                4'b0010: seg1 <= 8'b11011010; // 2
                4'b0011: seg1 <= 8'b11110010; // 3
                4'b0100: seg1 <= 8'b01100110; // 4
                4'b0101: seg1 <= 8'b10110110; // 5
                4'b0110: seg1 <= 8'b10111110; // 6
                4'b0111: seg1 <= 8'b11100000; // 7
                4'b1000: seg1 <= 8'b11111110; // 8
                4'b1001: seg1 <= 8'b11110110; // 9
                default: seg1 <= 8'b11111111; // Default 
            endcase

            // Second digit
            case(counter % 10)
                4'b0000: seg2 <= 8'b11111100; // 0
                4'b0001: seg2 <= 8'b01100000; // 1
                4'b0010: seg2 <= 8'b11011010; // 2
                4'b0011: seg2 <= 8'b11110010; // 3
                4'b0100: seg2 <= 8'b01100110; // 4
                4'b0101: seg2 <= 8'b10110110; // 5
                4'b0110: seg2 <= 8'b10111110; // 6
                4'b0111: seg2 <= 8'b11100000; // 7
                4'b1000: seg2 <= 8'b11111110; // 8
                4'b1001: seg2 <= 8'b11110110; // 9
                default: seg2 <= 8'b11111111; // Default 
            endcase
        end
    end
end

endmodule
