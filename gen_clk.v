`timescale 1ns/1ps
module gen_clk(
    output reg clock_100mhz,
    output reg rst_n_o
);

initial begin
    clock_100mhz <= 0;
       forever begin
        #10  clock_100mhz <= ~clock_100mhz;
       end
   end

initial begin
    // La începutul simulării reset-ul nu este activ
    rst_n_o <= 1;
    // Așteptăm 6 unități de timp
    #6
    // Trecem semnalul rst_n_o în 0
    rst_n_o <= 0;

    // Așteptăm 2 perioade de ceas
    repeat(2) begin
        @(posedge clock_100mhz);
    end
    // Dezactivăm reset-ul

    rst_n_o <= 1;
end
endmodule