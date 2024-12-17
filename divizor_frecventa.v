////////////////////////////////////////////////////////////////////////////////
// Nume modul: divizor_frecventa.v
// Autor: Achim Andrei
// Descriere: 
//  Acest modul are la intrare un ceas de 100 MHz si il converteste intr-un ceas de 1 Hz (1 secunda!!!!!)
////////////////////////////////////////////////////////////////////////////////

module divizor_frecventa
(
    input clk_i, // ceasul de 100MHz
    output reg clk_o_1hz, // ceasul de 1Hz
    output reg clk_o_20khz // ceasul de 20lHz
);

reg[26:0] counter1 = 27'd0;
parameter DIVISOR1 = 27'd100000000;

reg[26:0] counter2 = 27'd0;
parameter DIVISOR2 = 27'd5000;

always @(posedge clk_i)
    begin
        counter1 <= counter1 + 27'd1;
        if(counter1>=(DIVISOR1-1))
            counter1 <= 27'd0;
        clk_o_1hz <= (counter1<(DIVISOR1/2))?1'b1:1'b0;
    end

always @(posedge clk_i)
    begin
        counter2 <= counter2 + 27'd1;
        if(counter2>=(DIVISOR2-1))
            counter2 <= 27'd0;
        clk_o_20khz <= (counter2<DIVISOR2/2)?1'b1:1'b0;
    end

endmodule