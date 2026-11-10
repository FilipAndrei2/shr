//==============================================================
// FIFO circular
//   M = latimea datelor (bitii lui DI / DO)
//   N = latimea adresei  -> adancime = 2^N cuvinte
//==============================================================

//--------------------------------------------------------------
// DP-SRAM: un port de scriere (sincron), un port de citire (asincron)
//--------------------------------------------------------------
module dp_sram #(
    parameter M = 8,
    parameter N = 4
)(
    input  wire         clk,
    input  wire         we,       // WEW
    input  wire [N-1:0] addrw,    // ADDRW
    input  wire [M-1:0] diw,      // DIW
    input  wire [N-1:0] addrr,    // ADDRR (de la PTRR)
    output wire [M-1:0] dor       // DOR
);
    reg [M-1:0] mem [0:(1<<N)-1];

    always @(posedge clk)
        if (we)
            mem[addrw] <= diw;

    assign dor = mem[addrr];
endmodule

//--------------------------------------------------------------
// Pointer circular (PTRW / PTRR): numaratoare pe N biti, se
// intoarc singure la 0
//--------------------------------------------------------------
module fifo_ptr #(
    parameter N = 4
)(
    input  wire         clk,
    input  wire         clear,
    input  wire         inc,
    output reg  [N-1:0] ptr
);
    always @(posedge clk)
        if (clear)
            ptr <= {N{1'b0}};
        else if (inc)
            ptr <= ptr + 1'b1;
endmodule


// Blocul de control (cel cu "?"): contor de ocupare, FULL, EMPTY,
// ERROR si comenzile catre pointeri / memorie
module fifo_ctrl #(
    parameter N = 4
)(
    input  wire clk,
    input  wire clear,
    input  wire push,
    input  wire pop,
    output wire full,
    output wire empty,
    output wire error,
    output wire inc_w,   // catre PTRW
    output wire inc_r,   // catre PTRR
    output wire we       // catre DP-SRAM
);
    reg [N:0] count;     // nr de cuvinte stocate

    assign full  = (count == (1 << N));
    assign empty = (count == 0);

    // operatii
    assign inc_w = push & ~full;
    assign inc_r = pop  & ~empty;
    assign we    = inc_w;

    // eroare: push cand e plin sau pop cand e gol
    assign error = (push & full) | (pop & empty);

    always @(posedge clk)
        if (clear)
            count <= {(N+1){1'b0}};
        else if (inc_w & ~inc_r)
            count <= count + 1'b1;
        else if (~inc_w & inc_r)
            count <= count - 1'b1;
endmodule

// modul top
module fifo_circular #(
    parameter M = 8,
    parameter N = 4
)(
    input  wire         clk,
    input  wire         clear,
    input  wire         push,
    input  wire         pop,
    input  wire [M-1:0] di,
    output wire [M-1:0] do,
    output wire         full,
    output wire         empty,
    output wire         error
);
    wire         inc_w, inc_r, we;
    wire [N-1:0] addrw, addrr;

    fifo_ctrl #(.N(N)) u_ctrl (
        .clk   (clk),
        .clear (clear),
        .push  (push),
        .pop   (pop),
        .full  (full),
        .empty (empty),
        .error (error),
        .inc_w (inc_w),
        .inc_r (inc_r),
        .we    (we)
    );

    fifo_ptr #(.N(N)) u_ptrw (
        .clk   (clk),
        .clear (clear),
        .inc   (inc_w),
        .ptr   (addrw)
    );

    fifo_ptr #(.N(N)) u_ptrr (
        .clk   (clk),
        .clear (clear),
        .inc   (inc_r),
        .ptr   (addrr)
    );

    dp_sram #(.M(M), .N(N)) u_sram (
        .clk   (clk),
        .we    (we),
        .addrw (addrw),
        .diw   (di),
        .addrr (addrr),
        .dor   (do)
    );
endmodule
