//--------------------------------------------------------------
// DP-SRAM: un port de scriere (sincron), un port de citire (asincron)
//--------------------------------------------------------------
module dp_sram (
    input  wire         clk,
    input  wire         we,       // WEW
    input  wire [3:0]   addrw,    // ADDRW
    input  wire [7:0]   diw,      // DIW
    input  wire [3:0]   addrr,    // ADDRR (de la PTRR)
    output wire [7:0]   dor       // DOR
);
    reg [7:0] mem [0:15];

    always @(posedge clk)
        if (we)
            mem[addrw] <= diw;

    assign dor = mem[addrr];
endmodule

//--------------------------------------------------------------
// Pointer circular (PTRW / PTRR): numaratoare pe N biti, se
// intoarc singure la 0
//--------------------------------------------------------------
module fifo_ptr (
    input  wire         clk,
    input  wire         clear,
    input  wire         inc,
    output reg  [3:0]   ptr
);
    always @(posedge clk)
        if (clear)
            ptr <= 4'b0000;
        else if (inc)
            ptr <= ptr + 1'b1;
endmodule


// Blocul de control (cel cu "?"): contor de ocupare, FULL, EMPTY,
// ERROR si comenzile catre pointeri / memorie
module fifo_ctrl (
    input  wire clk,
    input  wire clear,
    input  wire push,
    input  wire pop,
    output wire full,
    output wire empty,
    output wire error,
    output wire [4:0] ndata,
    output wire inc_w,   // catre PTRW
    output wire inc_r,   // catre PTRR
    output wire we       // catre DP-SRAM
);
    reg [4:0] count;     // nr de cuvinte stocate

    assign full  = (count == 5'd16);
    assign empty = (count == 5'd0);
    assign ndata = count;

    // operatii
    assign inc_w = push & ~full;
    assign inc_r = pop  & ~empty;
    assign we    = inc_w;

    // eroare: push cand e plin sau pop cand e gol
    assign error = (push & full) | (pop & empty);

    always @(posedge clk)
        if (clear)
            count <= 5'b00000;
        else if (inc_w & ~inc_r)
            count <= count + 1'b1;
        else if (~inc_w & inc_r)
            count <= count - 1'b1;
endmodule

// modul top
module fifo (
    input  wire         clk,
    input  wire         clear,
    input  wire         push,
    input  wire         pop,
    input  wire [7:0]   diw,
    output wire [7:0]   dor,
    output wire         full,
    output wire         empty,
    output wire         error,
    output wire [4:0]   ndata
);
    wire         inc_w, inc_r, we;
    wire [3:0]   addrw, addrr;

    fifo_ctrl u_ctrl (
        .clk   (clk),
        .clear (clear),
        .push  (push),
        .pop   (pop),
        .full  (full),
        .empty (empty),
        .error (error),
        .ndata (ndata),
        .inc_w (inc_w),
        .inc_r (inc_r),
        .we    (we)
    );

    fifo_ptr u_ptrw (
        .clk   (clk),
        .clear (clear),
        .inc   (inc_w),
        .ptr   (addrw)
    );

    fifo_ptr u_ptrr (
        .clk   (clk),
        .clear (clear),
        .inc   (inc_r),
        .ptr   (addrr)
    );

    dp_sram u_sram (
        .clk   (clk),
        .we    (we),
        .addrw (addrw),
        .diw   (diw),
        .addrr (addrr),
        .dor   (dor)
    );
endmodule
