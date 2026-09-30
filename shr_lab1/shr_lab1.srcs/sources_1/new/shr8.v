`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:49:06 PM
// Design Name: 
// Module Name: shr8
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shr8(
    input clk,
    input pl,
    input res,
    input [7:0] di,
    input shr, shl,
    
    input sil, sir,
    
    output reg [7:0] do,
    output reg sol, sor
    );

always@(posedge clk) begin
    if (res) begin
        do <= 8'h00;
        sol <= 1'b0;
        sor <= 1'b0;
    end else if (pl) begin // incarcare de pe di
        do <= di;
        sol <= 1'b0;
        sor <= 1'b0;
    end else if (shr) begin
        // SHIFTAREA LA DREAPTA ESTE PRIORITARA IN FATA SHIFTARII LA STANGA
        sor <= do[0];
        do <= { sir, do[7:1] };
    end else if (shl && ~shr) begin
        sol <= do[7];
        do <= { do[6:0], sil };
    end
end

endmodule
