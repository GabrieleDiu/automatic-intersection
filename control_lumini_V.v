module control_lumini_V (
    input clk_i, 
    input rst_n_i, 
    input enable_i, // semnal pentru activarea semaforului
    input [1:0] w_v, 
    input tranzit_v, 
    output reg Rosu_auto_V_o, 
    output reg Galben_auto_V_o, 
    output reg Verde_auto_V_o 
);

reg [1:0] state;

always @(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
        state <= 2'b00; // Stare inițială: roșu
    end else if (enable_i) begin
        if (tranzit_v) begin
            state <= 2'b01; // Stare: galben
        end else begin
            state <= w_v; // Stare conform semnalului w_v
        end
    end
end

always @* begin
    case (state)
        2'b00: begin // Roșu
            Rosu_auto_V_o = 1'b1;
            Galben_auto_V_o = 1'b0;
            Verde_auto_V_o = 1'b0;
        end
        2'b01: begin // Galben
            Rosu_auto_V_o = 1'b0;
            Galben_auto_V_o = 1'b1;
            Verde_auto_V_o = 1'b0;
        end
        2'b10: begin // Verde
            Rosu_auto_V_o = 1'b0;
            Galben_auto_V_o = 1'b0;
            Verde_auto_V_o = 1'b1;
        end
        2'b11: begin // Roșu total (toate pe roșu)
            Rosu_auto_V_o = 1'b1;
            Galben_auto_V_o = 1'b0;
            Verde_auto_V_o = 1'b0;
        end
    endcase
end

endmodule
