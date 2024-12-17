module driver_buton(
    input clock_100mhz,
    input   clock_buton,
    input   service_i,
    input   rst_n_i,
    output pressed_button_o
);
wire q1, not_q1, not_q2, q2;
reg delay;

d_flip_flop d1(
.clock_buton(clock_buton),
.d_i(service_i),
.rst_n_i(rst_n_i),
.q_o(q1),
.not_q_o(not_q1)
);

d_flip_flop d2(
.clock_buton(clock_buton),
.d_i(q1),
.rst_n_i(rst_n_i),
.q_o(q2),
.not_q_o(not_q2)
);


assign pressed_button_o = (q1 & not_q2);


endmodule;