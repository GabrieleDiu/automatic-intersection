module mas1(
    input clk_1hz,
    input service_i, 
    input rst_n_i,
    output w_n,
    output w_e,
    output w_v,
    output w_s,
    output w_p,
    output service_o,
    output wait_idle,
    output tranzit_n,
    output tranzit_e,
    output tranzit_v,
    output tranzit_s,
    output tranzit_w,
    output reg [7:0] counter_o 
);

// Local parameters for state times
localparam IDLE_TIME = 1; 
localparam TRANSITION_TIME = 2;
localparam WORK_N_TIME = 18; 
localparam WORK_E_TIME = 24; 
localparam WORK_V_TIME = 18;
localparam WORK_S_TIME = 15;
localparam WORK_P_TIME = 11; 
localparam FINISH_TIME = 8'd113;

// State definitions
localparam idle_s = 4'b0000; 
localparam tranzit_idle_s = 4'b0001; 
localparam work_n = 4'b0010; 
localparam tranzit_nord_s = 4'b0011; 
localparam work_e = 4'b0100; 
localparam tranzit_est_s = 4'b0101; 
localparam work_v = 4'b0110;
localparam tranzit_vest_s = 4'b0111; 
localparam work_s = 4'b1000; 
localparam tranzit_sud_s = 4'b1001; 
localparam work_p = 4'b1010; 
localparam counter_s = 4'b1011;

// Internal registers
reg [7:0] cnt_time; 
reg toggle; 
reg [3:0] curent_state;
reg [3:0] next_state;

always @(posedge clk_1hz or negedge rst_n_i) begin
    if (~rst_n_i)
        cnt_time <= 8'd0;
    else if (cnt_time == FINISH_TIME) 
        cnt_time <= 8'd0;
    else if (service_i)
        cnt_time <= cnt_time + 1;
end

always @(posedge clk_1hz or negedge rst_n_i) begin
    if (~rst_n_i)
        toggle <= 1'b0;
    else if (~service_i)
        toggle <= ~toggle;
end

always @(posedge clk_1hz or negedge rst_n_i) begin
    if (~rst_n_i)
        curent_state <= idle_s;
    else if (service_i)
        curent_state <= next_state;
end

always @(*) begin
    if (service_i) begin
        case (curent_state)
            idle_s: begin
                if (cnt_time == IDLE_TIME)
                    next_state = tranzit_idle_s;
                else
                    next_state = idle_s;
            end
            tranzit_idle_s: next_state = work_n;
            work_n: begin
                if (cnt_time == IDLE_TIME + TRANSITION_TIME + WORK_N_TIME)
                    next_state = tranzit_nord_s;
                else
                    next_state = work_n;
            end
            tranzit_nord_s: next_state = work_e;
            work_e: begin
                if (cnt_time == IDLE_TIME + (2 * TRANSITION_TIME) + WORK_N_TIME + WORK_E_TIME)
                    next_state = tranzit_est_s;
                else
                    next_state = work_e;
            end
            tranzit_est_s: next_state = work_v;
            work_v: begin
                if (cnt_time == IDLE_TIME + (3 * TRANSITION_TIME) + WORK_N_TIME + WORK_E_TIME + WORK_V_TIME)
                    next_state = tranzit_vest_s;
                else
                    next_state = work_v;
            end
            tranzit_vest_s: next_state = work_s;
            work_s: begin
                if (cnt_time == IDLE_TIME + (4 * TRANSITION_TIME) + WORK_N_TIME + WORK_E_TIME + WORK_V_TIME + WORK_S_TIME)
                    next_state = tranzit_sud_s;
                else
                    next_state = work_s;
            end
            tranzit_sud_s: next_state = work_p;
            work_p: begin
                if (cnt_time == IDLE_TIME + (5 * TRANSITION_TIME) + WORK_N_TIME + WORK_E_TIME + WORK_V_TIME + WORK_S_TIME + WORK_P_TIME)
                    next_state = counter_s;
                else
                    next_state = work_p;
            end
            counter_s: begin
                if (cnt_time == FINISH_TIME)
                    next_state = idle_s;
                else
                    next_state = counter_s;
            end
            default: next_state = idle_s;
        endcase
    end else begin
        next_state = idle_s;
    end
end

// Output the remaining time to next state transition
always @(posedge clk_1hz or negedge rst_n_i) begin
    if (~rst_n_i)
        counter_o <= 8'd0;
    else begin
        case (curent_state)
            idle_s: counter_o <= IDLE_TIME - cnt_time;
            work_n: counter_o <= IDLE_TIME + TRANSITION_TIME + WORK_N_TIME - cnt_time;
            work_e: counter_o <= IDLE_TIME + (2 * TRANSITION_TIME) + WORK_N_TIME + WORK_E_TIME - cnt_time;
            work_v: counter_o <= IDLE_TIME + (3 * TRANSITION_TIME) + WORK_N_TIME + WORK_E_TIME + WORK_V_TIME - cnt_time;
            work_s: counter_o <= IDLE_TIME + (4 * TRANSITION_TIME) + WORK_N_TIME + WORK_E_TIME + WORK_V_TIME + WORK_S_TIME - cnt_time;
            work_p: counter_o <= IDLE_TIME + (5 * TRANSITION_TIME) + WORK_N_TIME + WORK_E_TIME + WORK_V_TIME + WORK_S_TIME + WORK_P_TIME - cnt_time;
            default: counter_o <= 8'd0;
        endcase
    end
end

// Assign outputs based on the current state
assign w_n = (curent_state == work_n) && service_i;
assign w_e = (curent_state == work_e) && service_i;
assign w_v = (curent_state == work_v) && service_i;
assign w_s = (curent_state == work_s) && service_i;
assign w_p = (~service_i) ? toggle : (curent_state == work_p);
assign service_o = (curent_state != idle_s);
assign wait_idle = (curent_state == idle_s);
assign tranzit_n = (~service_i) ? toggle :(curent_state == tranzit_nord_s) && service_i;
assign tranzit_e = (~service_i) ? toggle : (curent_state == tranzit_est_s);
assign tranzit_v = (~service_i) ? toggle : (curent_state == tranzit_vest_s);
assign tranzit_s = (~service_i) ? toggle : (curent_state == tranzit_sud_s);
assign tranzit_w = (curent_state == tranzit_idle_s) && service_i;

endmodule

