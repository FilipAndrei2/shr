`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:33:31 PM
// Design Name: 
// Module Name: contor4_2
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


module contor4_2(
    input clk,
    input [7:0] di,
    input pl,
    input res,
    input inc,
    input dec,
    
    output reg [7:0] do
    );

initial begin
    do <= 8'b00000000;    
end

always@(posedge clk) begin
    if (res) begin
        do <= 8'h00;
    end else if (pl) begin
        do <= di;
    end else if (inc) begin
        do <= do + 8'h01;
    end else if (dec) begin
        do <= do - 8'h01;
    end
end

endmodule
