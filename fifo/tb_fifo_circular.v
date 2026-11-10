`timescale 1ns/1ps

module tb_fifo_circular;
    parameter M = 8;
    parameter N = 3;              // adancime 8

    reg          clk;
    reg          clear, push, pop;
    reg  [M-1:0] di;
    wire [M-1:0] data_out;        // conectat la portul "do"
    wire         full, empty, error;

    integer i;
    integer errors;

    fifo_circular #(.M(M), .N(N)) dut (
        .clk   (clk),
        .clear (clear),
        .push  (push),
        .pop   (pop),
        .di    (di),
        .do    (data_out),
        .full  (full),
        .empty (empty),
        .error (error)
    );

    // ceas: perioada 10 ns
    initial clk = 0;
    always #5 clk = ~clk;

    task check;
        input            cond;
        input [8*40-1:0] msg;
        begin
            if (!cond) begin
                errors = errors + 1;
                $display("[%0t] FAIL: %0s", $time, msg);
            end
        end
    endtask

    // push de un cuvant, pe un ciclu de ceas
    task do_push;
        input [M-1:0] d;
        begin
            @(negedge clk);
            push = 1; di = d;
            @(negedge clk);
            push = 0;
        end
    endtask

    // verifica capul FIFO-ului, apoi pop
    task do_pop_check;
        input [M-1:0] expected;
        begin
            @(negedge clk);
            check(data_out === expected, "data_out diferit de cel asteptat");
            pop = 1;
            @(negedge clk);
            pop = 0;
        end
    endtask

    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, tb_fifo_circular);

        errors = 0;
        push = 0; pop = 0; di = 0; clear = 1;
        repeat (2) @(negedge clk);
        clear = 0;
        @(negedge clk);
        check(empty === 1 && full === 0, "dupa clear trebuie EMPTY");

        // 1) umple FIFO-ul
        for (i = 1; i <= 8; i = i + 1) do_push(i);
        @(negedge clk);
        check(full === 1 && empty === 0, "trebuie FULL dupa 8 push");

        // 2) push pe FIFO plin -> ERROR
        push = 1; di = 8'hFF;
        #1 check(error === 1, "ERROR la push pe FIFO plin");
        @(negedge clk);
        push = 0;

        // 3) goleste FIFO-ul, verificand ordinea (FIFO)
        for (i = 1; i <= 8; i = i + 1) do_pop_check(i);
        @(negedge clk);
        check(empty === 1 && full === 0, "trebuie EMPTY dupa 8 pop");

        // 4) pop pe FIFO gol -> ERROR
        pop = 1;
        #1 check(error === 1, "ERROR la pop pe FIFO gol");
        @(negedge clk);
        pop = 0;

        // 5) wrap-around: pointerii fac mai multe ture
        for (i = 0; i < 20; i = i + 1) begin
            do_push(100 + i);
            do_pop_check(100 + i);
        end

        // 6) push + pop simultan (cu un element deja in FIFO)
        do_push(8'hA1);
        @(negedge clk);
        push = 1; pop = 1; di = 8'hB2;
        @(negedge clk);
        push = 0; pop = 0;
        @(negedge clk);
        check(data_out === 8'hB2 && empty === 0, "push+pop simultan");

        // 7) clear
        clear = 1;
        @(negedge clk);
        clear = 0;
        @(negedge clk);
        check(empty === 1, "EMPTY dupa clear");

        if (errors == 0) $display("TOATE TESTELE AU TRECUT");
        else             $display("%0d ERORI", errors);
        $finish;
    end
endmodule
