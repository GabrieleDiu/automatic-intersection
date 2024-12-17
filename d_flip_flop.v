module d_flip_flop
(
    input clock_buton,
    input d_i,
    input rst_n_i,
    output reg q_o,
    output reg not_q_o
);

always @(posedge clock_buton or negedge rst_n_i)
begin
    if(!rst_n_i)
        q_o<='b0;
    else begin
        q_o<=d_i;
        not_q_o <= ~d_i;
    end
end
endmodule 