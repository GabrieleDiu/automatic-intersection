module control_lumini_pietoni (
    input clk_i,
    input rst_n_i,
    input enable_i,
    input w_p,
    input [4:0] counter, // Counter primit de la modulul MAS
    output reg Rosu_pietoni_o,
    output reg Verde_pietoni_o
);

localparam GREEN_TIME = 5'd11;
localparam FLASH_TIME = 5'd7;
localparam ALL_RED_TIME = 1'd1;

reg [1:0] state;

always @(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i)
        state <= 2'b00; // Initializare la starea roșu
    else if (enable_i) begin
        if (counter < GREEN_TIME)
            state <= 2'b01; // Stare verde
        else if (counter < (GREEN_TIME + FLASH_TIME))
            state <= 2'b10; // Stare intermitentă
        else if (counter < (GREEN_TIME + FLASH_TIME + ALL_RED_TIME))
            state <= 2'b11; // Stare roșu
        else
            state <= 2'b00; // Resetare la roșu
    end
end

always @* begin
    case (state)
        2'b00, 2'b11: begin
            Rosu_pietoni_o = 1'b1;
            Verde_pietoni_o = 1'b0;
        end
        2'b01: begin
            Rosu_pietoni_o = 1'b0;
            Verde_pietoni_o = 1'b1;
        end
        2'b10: begin
            Rosu_pietoni_o = 1'b0;
            Verde_pietoni_o = (counter[0]) ? 1'b1 : 1'b0; // Semnal intermitent
        end
    endcase
end

endmodule
