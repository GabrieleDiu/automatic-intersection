
////////////////////////////////////////////////////////////////////////////////
// Nume modul: gen_clk_rst
// Autor: Stefan Gheorghe
// Descriere: 
//   Acest modul implementează un generator parametrizabil pentru clock si reset. 
//   Reset-ul este activ în 0.  
//
// Modificari:
//   18/03/2024 | Stefan Gheorghe | Varianta initiala
//
////////////////////////////////////////////////////////////////////////////////

module gen_clk_rst#(
    parameter SEMIPERIOADA_CEAS = 10  // Parametru pentru definirea semiperioadei ceasului care va fi generat
) (
    output reg clk_o   , // Ieșirea pentru ceas, declarată ca reg          
    output reg rst_n_o   // Ieșirea pentru reset, declarată ca reg și activă în 0
);

initial begin
    clk_o <= 0;
    forever #SEMIPERIOADA_CEAS  // La fiecare semiperioadă de ceas 
        clk_o <= ~clk_o;        // valoarea semnalului clk_o va fi complementată
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
        @(posedge clk_o);
    end
    // Dezactivăm reset-ul

    rst_n_o <= 1;
end

    
endmodule